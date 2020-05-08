import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

export 'package:dio/dio.dart';

class MyDio {
  static Future<Dio> createDio() async {
    var dio = Dio(BaseOptions(connectTimeout: 10000));
    dio.interceptors.add(CookieManager(
        PersistCookieJar(dir: (await getTemporaryDirectory()).path)));
    return dio;
  }
}
