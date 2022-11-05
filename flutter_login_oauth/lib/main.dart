import 'package:flutter/material.dart';
import 'package:oauth_client_sn/webview/oauth_webview.dart';
import 'package:oauth_client_sn/oauth.dart';
import 'package:oauth_client_sn/webview/oauth_webviewDesktop.dart';
import 'package:oauth_client_sn/core/check_platform.dart';
import 'package:oauth_client_sn/core/colors.dart';
import 'package:oauth_client_sn/model/configuration.dart';
import 'package:oauth_client_sn/model/token.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SN OAuth',
      theme: ThemeData(
          primarySwatch: ColorConstants.primaryBlue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  MainState createState() => MainState();
}

class MainState extends State<Main> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              children: [
                const SizedBox(height: 80),
                Center(
                  child: SizedBox(
                      width: 240,
                      height: 180,
                      child: Image.asset('assets/images/snaccit_logo.png')),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Center(
                    child: OutlinedButton(
                      child: const Text("Login with ServiceNow Instance"),
                      onPressed: () async {
                        //When the button is clicked, the OAuth authorization code grant flow beginn
                        authorizationCodeGrantFlow();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

/*
* authorizationCodeGrantFlow function makes:
* 1. A get request(https://instancename.service-now.com/oauth_auth.do) to the OAuth Application in Servicenow instance to 
* get authorization code, and first use the response to build Webview to show a servicenow login page, when the user is not yet authorized. 
* If user send correct credential(instance login credential) and confirm the interaction with OAuth Application then the user 
* will recieve the authorization code.
* 2. And then a post request(https://instancename.service-now.com/oauth_token.do) to the OAuth Application with authorization code
* we just got to request the access token.
* For more information about OAuth authorization code grant flow, 
* please see:https://docs.servicenow.com/bundle/tokyo-platform-security/page/administer/security/concept/c_OAuthAuthorizationCodeFlow.html 
*/
  authorizationCodeGrantFlow() async {
    //If the Platform is not mobile platform, we call desktop webview,
    //else then webview for android and ios
    final OAuth SNOAuth = !PlatformInfo.isAndroid() && !PlatformInfo.isIOS()
        ? OAuthWebviewDesktop(Configuration("code", headers: {
            "Accept": "*/*",
          }, parameters: {}))
        : OAuthWebview(Configuration("code", headers: {
            "Accept": "*/*",
          }, parameters: {}));

    Token? token = await SNOAuth
        .authorise(); //In this function we request authorization code and then access token

    //If we got the access token, it will show on a popup dialog
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Access Token & Refresh Token & Expires in"),
            content: Text(
                '${token!.accessToken}\n${token!.refreshToken}\n${token!.expires} sec\n'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close')),
            ],
          );
        });
  }
}
