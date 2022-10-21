import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:snaccit_login/ExpenseHome.dart';
import 'package:snaccit_login/Model/User.dart' as user;
import 'package:snaccit_login/API/SNAPI.dart';

class SnaccITLoginForm extends StatefulWidget {
  _SnaccITLoginFormState createState() => _SnaccITLoginFormState();
}

class _SnaccITLoginFormState extends State<SnaccITLoginForm> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  var UserModel = user.User();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.disabled,
          key: formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,
                      child: Image.asset('assets/images/snaccit_logo.png')),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 87, 73, 75)),
                      ),
                      labelText: 'Emailaddress',
                      hintText: 'Please enter your emailaddress'),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "* Required"),
                    EmailValidator(
                        errorText: "Please enter a valid email address"),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                  controller: pwdController,
                  obscureText: true,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 87, 73, 75)),
                      ),
                      labelText: 'Password',
                      hintText: 'Please enter your password'),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "* Required"),
                    MinLengthValidator(8,
                        errorText: "Password should be at least 8 characters"),
                  ]),
                ),
              ),
              TextButton(
                onPressed: () {
                  //Forget Password action
                },
                child: Text(
                  'Forgot Password ?',
                  style: TextStyle(
                      color: Color.fromARGB(255, 228, 76, 84), fontSize: 12),
                ),
              ),
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 33, 32, 75),
                    borderRadius: BorderRadius.circular(8)),
                child: TextButton(
                  onPressed: () async {
                    var status = 0;
                    if (formkey.currentState!.validate()) {
                      UserModel.email = emailController.text.toString();
                      UserModel.password = pwdController.text.toString();
                      //var token = await _storage.read(key: "token") ?? '';
                      //status = await SNAPI.loginWithToken(token);
                      //print('login with stored token.');
                      status = await SNAPI.login(
                          UserModel.email, UserModel.password);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(status.toString())));

                      if (status == 200) {
                        //Authorization success then store data in secure storage and go to home page
                        await _storage.write(
                            key: "KEY_EMAIL", value: UserModel.email);
                        await _storage.write(
                            key: "KEY_PASSWORD", value: UserModel.password);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ExpenseHome()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Wrong Email or Password.Please check your input value again !')));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Please fill the login form with valid data !')));
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
