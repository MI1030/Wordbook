import 'dart:io';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;
import 'package:large_file_copy/large_file_copy.dart';

import '../biz/global_settings.dart';
import '../models/candidate.dart';
import '../models/dict_item.dart';
import '../utils/er_log.dart';

class EcDict {
  EcDict._();
  static final EcDict instance = EcDict._();

  Database _db;

  Future prepare() async {
    ErLog.withTs('prepare dictionary db');
    try {
      String fullPathName = await LargeFileCopy(_dictFileName).copyLargeFile;

      await GlobalSettings.setString(
          GlobalSettings.KeyDictPath, Path.dirname(fullPathName));
      ErLog.withTs(fullPathName);
    } on PlatformException {
      ErLog.withTs('Failed to copy the Large File.');
      return;
    }
    ErLog.withTs('prepare dictionary db end');
  }

  Future<bool> exists() async {
    var databasesPath =
        await GlobalSettings.getString(GlobalSettings.KeyDictPath);
    databasesPath = Path.join(databasesPath, _dictFileName);
    ErLog.withTs(databasesPath);
    if (File(databasesPath).existsSync()) {
      return true;
    } else {
      return false;
    }
  }

  load() async {
    var databasesPath =
        await GlobalSettings.getString(GlobalSettings.KeyDictPath);
    var path = Path.join(databasesPath, _dictFileName);
    var db = await openDatabase(path, readOnly: true);
    _db = db;
  }

  String get _dictFileName => 'dict.db';

  String get tableName {
    return 'stardict';
  }

  Future<DictItem> lookup(String word) async {
    var ret = new DictItem();
    var select =
        'SELECT word,phonetic,translation, samples FROM ${this.tableName} WHERE word=? COLLATE NOCASE';

    List<Map> rs = await _db.rawQuery(select, [word]);
    if (rs.length > 0) {
      var same;
      for (var i = 0; i < rs.length; i++) {
        var row = rs[i];
        if (row['word'] == word) {
          same = row;
          break;
        }
      }

      if (same == null) {
        same = rs[0];
      }

      ret.question = same['word'];
      ret.phonetic = same['phonetic'];
      //ret.definition = same['definition'];
      ret.answer =
          same['translation'] == null ? '' : same['translation'].trim();
      //ret.exchange = same['exchange'];
      ret.setSamples(same['samples']);
    } else {
      ret.question = word;
    }

    return ret;
  }

  Future<List<Candidate>> wordList(String word, int total) async {
    List<Candidate> ret = [];
    String plainWord = word.replaceAll(RegExp(r"'"), "''");
    var select = 'SELECT word,translation FROM ${this.tableName} ' +
        "WHERE word LIKE '$plainWord%' " +
        "ORDER BY word COLLATE NOCASE LIMIT $total";
    List<Map> rs = await _db.rawQuery(select);
    for (var i = 0; i < rs.length; i++) {
      var row = rs[i];
      var acan = Candidate(row['word'], row['translation']);
      ret.add(acan);
    }
    return ret;
  }
}
