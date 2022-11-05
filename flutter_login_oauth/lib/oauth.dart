import 'dart:convert';
import 'package:oauth_client_sn/model/auth_request_info.dart';
import 'package:oauth_client_sn/model/configuration.dart';
import 'package:oauth_client_sn/model/token.dart';
import 'package:http/http.dart';

/*
* This class is the abstract class for the two webview classes OAuthWebview and OAuthWebviewDesktop 
* because of the common things to be used in classes
*/

abstract class OAuth {
  final Configuration configuration;
  final AuthorizationRequest authCodeRequest;
  String? code;
  Map<String, dynamic>? token;

  OAuth(this.configuration, this.authCodeRequest);

  bool shouldRequestCode() => code == null;

  /*
  * Help function 1. for constructing authorization code request url 
  * Call the map function with data pairs stored in AuthorizationRequest.
  * This help function will be used in requestCode() function in two webview classes.
  */
  String constructUrlParams() => mapToQueryParams(authCodeRequest.parameters);

  /*
  * Help function 2. for constructing authorization code request url 
  * Map the key value pairs for the query parameter for request url
  * The finished url will look like this: 
  * https://myinstance.servicenow.com/oauth_auth.do?response_type=code&redirect_uri={the_redirect_url}&client_id={the_client_identifier}
  */
  String mapToQueryParams(Map<String, String> params) {
    final queryParams = <String>[];
    params
        .forEach((String key, String value) => queryParams.add("$key=$value"));
    return queryParams.join("&");
  }

  /*
  * The HTTP Post Request function to ask for an access token and refresh token
  */
  Future<Map<String, dynamic>?> getToken() async {
    if (token == null) {
      var headers = {'Content-Type': configuration.contentType};
      var request = Request('POST', Uri.parse(configuration.tokenUrl));
      request.bodyFields = {
        'grant_type': configuration.grantTypeWithCode,
        'code': code!,
        'redirect_uri': configuration.redirectUri,
        'client_id': configuration.clientId,
        'client_secret': configuration.clientSecret
      };
      request.headers.addAll(headers);
      StreamedResponse response = await request.send();
      var responsePost = await Response.fromStream(response);
      print(responsePost.statusCode);
      print(responsePost.body);
      token = jsonDecode(responsePost.body) as Map<String, dynamic>;
    }
    return token;
  }

  /*
  * The function call two requests:
  * 1.Request function for authorization code
  * 2.Request function for access token
  */
  Future<Token?> authorise() async {
    String? resultCode = await requestCode();
    print('authorization code: ' + resultCode!);
    if (resultCode != null) {
      return Token.fromJson(await getToken() as Map<String, dynamic>);
    }
    return null;
  }

  /*
  * This function is implemented in two webview classes OAuthWebviewDesktop and OAuthWebview
  */
  Future<String?> requestCode();
}
