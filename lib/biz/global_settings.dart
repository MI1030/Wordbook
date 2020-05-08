import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class GlobalSettings {
  static const KeyCurrentUserEmail = 'current-user-email';
  static const KeyCurrentUserPassword = 'current-user-password';
  static const KeyCurrentUserId = 'current-user-id';
  static const KeyServerTimeOffset = 'server-time-offset';
  static const KeyAvatarChanged = 'avatar-changed';
  static const KeyAvatarMd5 = 'avatar-md5';
  static const KeyAvatarNeedDownload = 'avatar-need-download';
  static const KeyAdmobShowBanner = 'admob-show-banner';
  static const KeyAdmobShowInterstitial = 'admob-show-interstitial';
  static const KeyFirstLoginUserId = 'first-login-user-id';
  static const KeyHasRated = 'has-rated';
  static const KeyStudyCount = 'study-count';
  static const KeyShouldPromptRating = 'should-prompt-rating';
  static const KeyPlayNightMode = 'play-night-mode';
  static const KeyReadAnswerInterval = 'read-answer-interval';
  static const KeyPlayIsReadAnswer = 'play-is-read-answer';
  static const KeyPlayInterval = 'play-interval';
  static const KeyPlayLoopMode = 'play-loop-mode';
  static const KeyPlayOrder = 'play-order';
  static const KeyDictPath = 'dictionary-path';
  static const KeyCardLayout = 'card-layout';
  static const KeyTtsVoice = 'tts-voice';
  static const KeyShowKrStatusOnReview = 'show-kr-status-on-review';

  static Future setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString(key, value);
    } catch (e) {}
  }

  static Future<String> getString(String key,
      [String defaultValue = '']) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String ret = prefs.getString(key);
      if (ret == null) {
        ret = defaultValue;
      }
      return ret;
    } catch (err) {
      return defaultValue;
    }
  }

  static Future setInt(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setInt(key, value);
    } catch (e) {}
  }

  static Future<int> getInt(String key, [int defaultValue = 0]) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      int ret = prefs.getInt(key);
      if (ret == null) {
        ret = defaultValue;
      }
      return ret;
    } catch (err) {
      return defaultValue;
    }
  }

  static Future setBool(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setBool(key, value);
    } catch (e) {}
  }

  static Future<bool> getBool(String key, [bool defaultValue = false]) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      bool ret = prefs.getBool(key);
      if (ret == null) {
        ret = defaultValue;
      }
      return ret;
    } catch (err) {
      return defaultValue;
    }
  }
}
