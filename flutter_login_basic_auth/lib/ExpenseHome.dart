import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snaccit_login/SnaccITLoginForm.dart';

class ExpenseHome extends StatelessWidget {
  const ExpenseHome({super.key});
  final _storage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Would you like to log out ?',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              ElevatedButton(
                onPressed: () {
                  // Logout action: delete the data from secure storage
                  _storage.deleteAll();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SnaccITLoginForm()),
                  );
                },
                child: const Text('Logout'),
              ),
            ]),
      ),
    );
  }
}
