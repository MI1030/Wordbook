import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as Path;

import '../biz/server_config.dart';
import '../utils/er_log.dart';
import '../utils/my_dio.dart';
import '../utils/voice_path.dart';

class WordVoiceSync {
  Future<bool> download(String word, VoiceType voiceType) async {
    VoicePath vp = VoicePath(word, voiceType);
    final cachePath = await vp.cachePathOfWord();
    final saveDir = Directory(Path.dirname(cachePath));
    if (!saveDir.existsSync()) {
      await saveDir.create(recursive: true);
    }

    final url = "${ServerConfig.apiUrl}" + vp.urlOfWord();
    ErLog.withTs('word voice url: $url');

    try {
      Dio dio = await MyDio.createDio();
      Response response = await dio.download(url, cachePath);
      //ErLog.withTs('voice download response: $response');

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}
