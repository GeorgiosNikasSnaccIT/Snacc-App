# oauth_client_sn

A Flutter project to interact with OAuth Application in Servicenow instance.
The project was already built in platform simulator macos and ios, the others not yet.
Here is the oauth authorization code grant flow process implemented.

More Info about the process and servicenow oauth application:<br/>
https://docs.servicenow.com/bundle/tokyo-platform-security/page/administer/security/concept/c_OAuthAuthorizationCodeFlow.html<br/>
https://developer.servicenow.com/blog.do?p=/post/inbound-oauth-auth-code-grant-flow-part-1/<br/>
More Info about flutter webview plugin:<br/>
Mobile -> https://pub.dev/packages/flutter_webview_plugin<br/>
Desktop -> https://pub.dev/packages/desktop_webview_window<br/>

## Included Structure
- main
- oauth.dart: abstract class for the two oauth webviews
- webview
- - oauth_webview.dart: for ios and android
- - oauth_webviewDesktop.dart: for macos, windows, linux
- model
- - auth_request_info.dart
- - configuration.dart
- - token.dart
- core
- - check_platform.dart
- - colors.dart

*Important!!* The oauth app and instance infos in configuration.dart is empty now for security reason.

