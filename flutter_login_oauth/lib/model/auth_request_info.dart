import 'package:oauth_client_sn/model/configuration.dart';

/*
* This is a help-class for a request to construct, and some information for 
* authorization request(Servicenow login) webview to store
*/

class AuthorizationRequest {
  late String url;
  late Map<String, String> parameters;
  late Map<String, String> headers;
  late bool fullScreen;
  late bool clearCookies;

  AuthorizationRequest(Configuration config,
      {bool fullScreen: true, bool clearCookies: true}) {
    this.url = config.authorizationUrl;
    this.parameters = {
      "client_id": config.clientId,
      "response_type": config.responseType,
      "redirect_uri": config.redirectUri,
    };
    if (config.parameters != null) {
      this.parameters.addAll(config.parameters);
    }
    this.fullScreen = fullScreen;
    this.clearCookies = clearCookies;
    this.headers = config.headers;
  }
}
