import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:oauth_client_sn/core/check_platform.dart';
import 'package:oauth_client_sn/oauth.dart';
import 'package:path/path.dart' as p;
import 'package:oauth_client_sn/model/auth_request_info.dart';
import 'package:oauth_client_sn/model/configuration.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:path_provider/path_provider.dart';

/*
* For Desktop App: This Class build the webview from the url(https://instancename.service-now.com/oauth_auth.do)
* And create a server with localhost:3000 as redirectUrl for OAuth Application to send authorization code back
* The build for this desktop webview is from this example: 
* https://pub.dev/packages/desktop_webview_window/example
*/

class OAuthWebviewDesktop extends OAuth {
  final StreamController<String> onCodeListener = StreamController();
  var isBrowserOpen = false;
  var server;
  var onCodeStream;

  Stream<String> get onCode =>
      onCodeStream ??= onCodeListener.stream.asBroadcastStream();

  OAuthWebviewDesktop(Configuration configuration)
      : super(configuration, AuthorizationRequest(configuration));

  Future<String> _getWebViewPath() async {
    final document = await getApplicationDocumentsDirectory();
    return p.join(
      document.path,
      'desktop_webview_window',
    );
  }

  @override
  Future<String?> requestCode() async {
    final webView = await WebviewWindow.create(
      configuration: CreateConfiguration(
        windowHeight: 720,
        windowWidth: 720,
        title: "ExampleTestWindow",
        titleBarTopPadding: PlatformInfo.isMacOS() ? 10 : 0,
        userDataFolderWindows: await _getWebViewPath(),
      ),
    );
    webView
      ..registerJavaScriptMessageHandler("test", (name, body) {
        debugPrint('on javaScipt message: $name $body');
      })
      ..setApplicationNameForUserAgent(" ServicenowLogin/1.0.0")
      ..setPromptHandler((prompt, defaultText) {
        if (prompt == "test") {
          return "Hello World!";
        } else if (prompt == "init") {
          return "initial prompt";
        }
        return "";
      })
      ..addScriptToExecuteOnDocumentCreated("""
        const mixinContext = {
        platform: 'Desktop',
        conversation_id: 'conversationId',
        immersive: false,
        app_version: '1.0.0',
        appearance: 'dark',
      }
      window.MixinContext = {
        getContext: function() {
        return JSON.stringify(mixinContext)
      }
      }
      """);

    if (shouldRequestCode() && !isBrowserOpen) {
      //webView.close();
      isBrowserOpen = true;

      server = await createServer();
      listenForServerResponse(server);

      final String urlParams = constructUrlParams();

      webView.launch("${authCodeRequest.url}?$urlParams");

      code = await onCode.first;

      close();
      webView.close();
    }
    return code;
  }

  void close() {
    if (isBrowserOpen) {
      server.close(force: true);
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
