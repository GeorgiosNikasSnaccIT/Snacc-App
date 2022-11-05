/*
* Datamodel class for the access token
*/

class Token {
  late String accessToken;
  late String tokenType;
  late String refreshToken;
  late int expires;
  late String scope;

  Token();

  factory Token.fromJson(Map<String, dynamic> json) =>
      Token.fromMap(json) as Token;

  Map toMap() => Token.toJsonMap(this);

  @override
  String toString() => Token.toJsonMap(this).toString();

  static Map toJsonMap(Token model) {
    Map map = {};
    if (model != null) {
      if (model.accessToken != null) {
        map["access_token"] = model.accessToken;
      }
      if (model.tokenType != null) {
        map["refresh_token"] = model.refreshToken;
      }
      if (model.accessToken != null) {
        map["expires_in"] = model.expires;
      }
      if (model.tokenType != null) {
        map["token_type"] = model.tokenType;
      }
      if (model.accessToken != null) {
        map["scope"] = model.scope;
      }
    }
    return map;
  }

  static Token? fromMap(Map map) {
    Token model = Token();
    model.accessToken = map["access_token"];
    model.refreshToken = map["refresh_token"];
    model.expires = map["expires_in"];
    model.tokenType = map["token_type"];
    model.scope = map["scope"];
    return model;
  }
}
