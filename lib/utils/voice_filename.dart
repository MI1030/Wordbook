import 'dart:convert';
import 'package:crypto/crypto.dart';

class VoiceFilename {
  static String name(String w) {
    RegExp regExp = RegExp("[ \\-,.?!:;\\'!`\\(\\)\\[\\]\\{\\}\\*\\/%\"‘’“”]+");
    String ret = w.replaceAll(regExp, '_');
    if (ret.length > 64) {
      var digest = md5.convert(utf8.encode(ret));
      ret = ret.substring(0, 64) + '_' + digest.toString();
    }
    return ret.toLowerCase();
  }
}
