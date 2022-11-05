import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

/*
* This simple class offers the boolean value of wether the platform is a specific platform,
* because the flutter webview plugin/class for Desktop and Mobile App are different.
*/

class PlatformInfo {
  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static bool isIOS() {
    return Platform.isIOS;
  }

  static bool isLinux() {
    return Platform.isLinux;
  }

  static bool isWindows() {
    return Platform.isWindows;
  }

  static bool isMacOS() {
    return Platform.isMacOS;
  }

  static bool isWeb() {
    return kIsWeb;
  }
}
