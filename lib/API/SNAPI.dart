import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

final _storage = const FlutterSecureStorage();

class SNAPI {
  //Basic URL
  static const urlPrefix =
      "https://snaccdev.service-now.com/api/x_sigh_snacc_it_ap/expenses";

  static const checkLogin = urlPrefix + "/checkLogin";

  //GET Methode to login(Basic Authentication)
  static Future<int> login(username, password) async {
    var user = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final url = Uri.parse('$checkLogin');
    final headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": user
    };
    Response response = await get(url, headers: headers);
    //var data = jsonDecode(response.body);
    /*if (response.statusCode == 200) {
      await _storage.write(key: "token", value: data['data']["access_token"]);
    }*/
    print('Status code: ${response.statusCode}');
    return response.statusCode;
  }

  //GET Methode to login
  static Future<int> loginWithToken(token) async {
    final url = Uri.parse('$checkLogin');
    final headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": 'Token $token'
    };
    Response response = await get(url, headers: headers);
    print('Status code: ${response.statusCode}');
    return response.statusCode;
  }
}
