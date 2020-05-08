import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;

import '../biz/standart_time.dart';
import '../models/search_history_item.dart';
import '../models/candidate.dart';

class SearchHistoryDb {
  Database _db;
  SearchHistoryDb();

  Future<String> dbpath() async {
    var databasesPath = await getDatabasesPath();
    var path = Path.join(databasesPath, "search_history.rdb");

    return path;
  }

  Future<void> load() async {
    if (_db == null) {
      String path = await dbpath();
      if (!File.fromUri(Uri.file(path)).existsSync()) {
        ByteData data =
            await rootBundle.load(Path.join("assets", "search_history.rdb"));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await new File(path).writeAsBytes(bytes);
      }

      _db = await openDatabase(path);
    }
  }

  close() async {
    await _db.close();
    _db = null;
  }

  String get _tableName {
    return 'krecords';
  }

  Future<bool> addWord(String theword, String answer) async {
    if (_db == null) return false;

    String sql = "SELECT id FROM $_tableName WHERE question = ? limit 1";
    List<Map> rs = await _db.rawQuery(sql, [theword]);

    int ret = 0;
    if (rs.length > 0) {
      var row = rs[0];
      int theId = row['id'];
      String updateSql =
          'update $_tableName set ts = ${StandardTime.instance.now} where id = $theId';
      ret = await this._db.rawUpdate(updateSql);
    } else {
      String question = theword.replaceAll("'", "''");
      String updateSql =
          "INSERT INTO $_tableName (question, answer, ts) VALUES ('$question', '$answer', ${StandardTime.instance.now})";
      ret = await this._db.rawInsert(updateSql);
    }

    return ret > 0;
  }

  Future<bool> removeWord(String theword) async {
    if (_db == null) return false;

    String w = theword.replaceAll("'", "''");
    String sql = "DELETE FROM $_tableName WHERE question='$w'";
    int r = await _db.rawDelete(sql);
    return r > 0;
  }

  Future<void> clearWords() async {
    if (_db == null) return false;

    String sql = "DELETE FROM $_tableName";
    await _db.rawDelete(sql);
  }

  Future<List<SearchHistoryItem>> recentWords(int start, int count) async {
    if (_db == null) return [];

    String sql =
        "SELECT question, answer FROM $_tableName ORDER BY ts DESC LIMIT $start, $count";
    List<Map> rs = await _db.rawQuery(sql, []);
    List<SearchHistoryItem> ret = [];
    for (int i = 0; i < rs.length; i++) {
      var row = rs[i];
      var a = new SearchHistoryItem();
      a.question = row['question'];
      a.answer = row['answer'];
      a.index = i + start;
      ret.add(a);
    }
    return ret;
  }

  Future<Candidate> recentWordOfIndex(int index) async {
    if (_db == null) return null;

    String sql =
        "SELECT question, answer FROM $_tableName ORDER BY ts DESC LIMIT $index,1";
    List<Map> rs = await _db.rawQuery(sql, []);
    var row = rs[0];
    var ret = Candidate(row['question'], row['answer']);
    return ret;
  }

  Future<int> total() async {
    if (_db == null) return 0;

    String sql = "SELECT count(*) as count FROM $_tableName";
    List<Map> rs = await _db.rawQuery(sql, []);
    int ret = 0;
    if (rs.length > 0) {
      var row = rs[0];
      ret = row['count'];
    }
    return ret;
  }
}
