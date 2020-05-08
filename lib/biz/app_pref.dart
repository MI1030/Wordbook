import 'dart:async';
import 'dart:io';

import 'package:package_info/package_info.dart';
import 'package:get_version/get_version.dart';

class AppPref {
  static int get appId {
    return 1;
  }

  static Future<String> get productCode async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int lastDot = packageInfo.packageName.lastIndexOf('.');
    String ret = packageInfo.packageName.substring(lastDot + 1);
    return ret;
  }

  static String get os {
    return Platform.isIOS ? 'iOS' : 'Android';
  }

  static Future<String> get version async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> get appName async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  static Future<String> get systemVersion async {
    return await GetVersion.platformVersion;
  }

  static Future<String> get appStoreId async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }
}
