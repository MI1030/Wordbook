@Skip("package info cannot run on the machine.")

import "package:test/test.dart";
import 'package:mxxd/biz/app_pref.dart';

void main() {
  group("App pref tests", () {
    test('should return com.lilyreading.mxxd when get appStoreId ', () async {
      var v = await AppPref.appStoreId;
      expect(v, equals('com.lilyreading.mxxd'));
    });

    test('should return mxxd when get productCode', () async {
      String v = await AppPref.productCode;
      expect(v, equals('mxxd'));
    });

    test('should return 1.0.1 when get version', () async {
      String v = await AppPref.version;
      expect(v, equals('1.0.1'));
    });

    test('should return 单词本 when get appName', () async {
      String v = await AppPref.appName;
      expect(v, equals('单词本'));
    });
  });
}
