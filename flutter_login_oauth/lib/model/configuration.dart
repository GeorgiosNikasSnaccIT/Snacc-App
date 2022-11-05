/*
* This class stores the configuration of the request to OAuth Application in instance
* Important: the instance/oauth application information should not be uploaded !
*/

class Configuration {
  final String authorizationUrl =
      ""; //https://instancename.service-now.com/oauth_auth.do
  final String tokenUrl =
      ""; //https://instancename.service-now.com/oauth_token.do
  final String clientId = ""; //client id from OAuth Application in SN instance.
  final String clientSecret =
      ""; //client secrect from OAuth Application in SN instance.
  final String redirectUri =
      "http://localhost:3000"; //This value should also be in OAuth Application in SN instance.
  final String responseType; //for authoriation code request -> code
  final String grantTypeWithCode = 'authorization_code';
  final String contentType = "application/x-www-form-urlencoded";
  final Map<String, String> parameters;
  final Map<String, String> headers;

  Configuration(this.responseType,
      {required this.parameters, required this.headers});
}
