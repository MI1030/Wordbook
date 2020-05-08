import 'dart:async';
import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';

class ErTTS {
  static final ErTTS instance = ErTTS._();

  ErTTS._() {
    _flutterTts.setSpeechRate(Platform.isIOS ? 0.5 : 0.9);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }

  Future voices() async {
    return await _flutterTts.getVoices;
  }

  Future speak(String text, [String lang = "en-US"]) async {
    await _flutterTts.setLanguage(lang);
    await _flutterTts.speak(text);
  }

  Future stop() async {
    await _flutterTts.stop();
  }

  FlutterTts _flutterTts = FlutterTts();
}
