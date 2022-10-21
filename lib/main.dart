import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snaccit_login/API/SNAPI.dart';
import 'package:snaccit_login/ExpenseHome.dart';
import 'package:snaccit_login/SnaccITLoginForm.dart';
import 'package:snaccit_login/Others/colors.dart';

final _storage = const FlutterSecureStorage();
/*
  Because secure storage doesn't be automatically deleted when uninstall,
  this function check if this is the first run of the application,
  if yes, delete all secure storage data.
   */
Future<void> _checkFirstRun() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  if (sharedPreferences.getBool('first_run') ?? true) {
    await _storage.deleteAll();
    sharedPreferences.setBool('first_run', false);
  }
}

void main() {
  runApp(SnaccITApp());
  //_checkFirstRun();
}

class SnaccITApp extends StatelessWidget {
  /*
  This function reads email/password which were stored in secure storage,
  and do the login request automatically.
   */
  Future<bool> _hasAuthData() async {
    var hasLogin = false;
    var email = await _storage.read(key: "KEY_EMAIL") ?? '';
    var password = await _storage.read(key: "KEY_PASSWORD") ?? '';
    //var token = await _storage.read(key: "token") ?? '';

    if (email != '' && password != '') {
      hasLogin = true;
    }

    return hasLogin;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnaccIT',
      theme: ThemeData(
          primarySwatch: ColorConstants.primaryBlue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: FutureBuilder<bool>(
          future: _hasAuthData(),
          builder: (context, snapshot) {
            print(snapshot.data);
            if (snapshot.hasData && snapshot.data == true) {
              return const ExpenseHome();
            } else {
              return SnaccITLoginForm();
            }
          }),
    );
  }
}
