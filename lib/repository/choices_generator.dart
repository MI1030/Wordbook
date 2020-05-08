import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;

import './dict_db.dart';
import '../models/dict_item.dart';

class ChoicesGenerator {
  static ChoicesGenerator instance = ChoicesGenerator._();

  ChoicesGenerator._();
  List<String> _words = [];

  Future loadWords() async {
    if (_words.length == 0) {
      final String texts =
          await rootBundle.loadString(Path.join("assets", "common-words"));

      texts.split("\n").forEach((w) {
        final s = w.trim();
        if (s.length > 0) {
          _words.add(s);
        }
      });
    }
  }

  Future<List<String>> choices({@required String word, int count = 3}) async {
    List<String> cws = [];
    Random random = Random();
    while (cws.length < count * 3) {
      int r = random.nextInt(_words.length);
      String aword = _words[r];
      if (aword != word && cws.indexOf(aword) < 0) {
        cws.add(aword);
      }
    }

    List<String> ret = [];

    for (int i = 0; i < cws.length && ret.length < count; i++) {
      String aword = cws[i];
      DictItem r = await EcDict.instance.lookup(aword);
      if (r != null) {
        List<String> answers = r.answer.split("\n");
        answers = answers.where((String s) => s.length > 0).toList();
        if (answers.length > 0) {
          String a = answers[random.nextInt(answers.length)];
          ret.add(a);
        }
        //else cont.
      }
    }

    return ret;
  }

  Future<List<String>> reverseChoices(
      {@required String word, int count = 3}) async {
    List<String> cws = [];
    Random random = Random();
    while (cws.length < count) {
      int r = random.nextInt(_words.length);
      String aword = _words[r];
      if (aword != word && cws.indexOf(aword) < 0) {
        cws.add(aword);
      }
    }
    return cws;
  }
}
