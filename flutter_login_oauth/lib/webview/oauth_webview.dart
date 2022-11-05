import 'dart:async';
import 'dart:io';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:oauth_client_sn/model/auth_request_info.dart';
import 'package:oauth_client_sn/model/configuration.dart';
import 'package:oauth_client_sn/oauth.dart';

/*
* For Mobile App: This Class build the webview from the url(https://instancename.service-now.com/oauth_auth.do)
* And create a server with localhost:3000 as redirectUrl for OAuth Application to send authorization code back
*/

class OAuthWebview extends OAuth {
  final StreamController<String> onCodeListener = StreamController();
  var isBrowserOpen = false;
  var server;
  var onCodeStream;

  final FlutterWebviewPlugin webView = FlutterWebviewPlugin();

  Stream<String> get onCode =>
      onCodeStream ??= onCodeListener.stream.asBroadcastStream();

  OAuthWebview(Configuration configuration)
      : super(configuration, AuthorizationRequest(configuration));

  @override
  Future<String?> requestCode() async {
    if (shouldRequestCode() && !isBrowserOpen) {
      await webView.close();
      isBrowserOpen = true;

      server = await createServer();
      listenForServerResponse(server);

      final String urlParams = constructUrlParams();
      webView.onDestroy.first.then((_) {
        close();
      });

      webView.launch(
        "${authCodeRequest.url}?$urlParams",
        clearCookies: authCodeRequest.clearCookies,
      );

      code = await onCode.first;
      close();
    }
    return code;
  }

  void close() {
    if (isBrowserOpen) {
      server.close(force: true);
      webView.close();
    }
    isBrowserOpen = false;
  }

  /*
  * This is the server with http://localhost:3000 we create for redirectUrl 
  * to listen to the authorization code from response from Servicenow OAuth App.
  * In request parameter redirect_url and redirectURL field in Servicenow OAuth App 
  * should have the same url.
  */
  Future<HttpServer> createServer() async {
    final server =
        await HttpServer.bind(InternetAddress.loopbackIPv4, 3000, shared: true);
    return server;
  }

  /*
  * We wait to listen the authrization code from the response
  */
  listenForServerResponse(HttpServer server) {
    server.listen((HttpRequest request) async {
      final uri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.set("Content-Type", ContentType.html.mimeType);

      final code = uri.queryParameters["code"];
      final error = uri.queryParameters["error"];
      await request.response.close();

      if (code != null && error == null) {
        onCodeListener.add(code);
      } else if (error != null) {
        onCodeListener.add('');
        onCodeListener.addError(error);
      }
    });
  }
}
