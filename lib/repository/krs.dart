import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../biz/object_id.dart';
import '../biz/standart_time.dart';
import '../models/kr.dart';

class Krs {
  Krs(this._db);

  final _tableName = 'krs';
  final Database _db;

  List<String> _fields = [
    "id",
    "_id",
    "kbase",
    "sync",
    "question",
    "answer",
    "samples",
    "image"
  ];

  Future<String> remember(String question, [int kbaseId = 1]) async {
    int now = StandardTime.instance.now;
    String q = question.replaceAll("'", "''");
    String mId = ObjectId.createOne();
    String sql = 'INSERT INTO $_tableName ' +
        '(_id, question, answer, samples, image, ts, kbase, sync) ' +
        "values ('$mId', '$q', '', '', '', $now, $kbaseId, 0)";
    int ret = await _db.rawInsert(sql);
    if (ret >= 0) {
      return mId;
    } else {
      return '';
    }
  }

  Future<String> add(
      {String question, int kbaseId, String answer, String samples}) async {
    question = question.replaceAll("'", "''");
    answer = answer.replaceAll("'", "''");
    samples = samples.replaceAll("'", "''");
    int now = StandardTime.instance.now;
    String mId = ObjectId.createOne();
    String sql = 'INSERT INTO $_tableName ' +
        '(_id, question, answer, samples, image, ts, kbase, sync) ' +
        "values ('$mId', '$question', '$answer', '$samples', '', $now, $kbaseId, 0)";
    int ret = await _db.rawInsert(sql);
    if (ret >= 0) {
      return mId;
    } else {
      return '';
    }
  }

  Future<bool> saveContent(
      {String mId,
      String question,
      int kbaseId,
      String answer,
      String samples}) async {
    question = question.replaceAll("'", "''");
    answer = answer.replaceAll("'", "''");
    samples = samples.replaceAll("'", "''");
    var sql = "UPDATE $_tableName " +
        "SET ts =${StandardTime.instance.now}, " +
        "question='$question', " +
        "kbase=$kbaseId, " +
        "answer='$answer', " +
        "samples='$samples', " +
        "sync=0 WHERE _id = '$mId'";
    var r = await _db.rawUpdate(sql);
    return r == 1;
  }

  Future<bool> saveMyContents(Kr akr) async {
    var answer = akr.answer.replaceAll("'", "''");
    var samples = akr.samples.replaceAll("'", "''");
    var sql = "UPDATE $_tableName " +
        "SET ts =${StandardTime.instance.now}, " +
        "kbase=${akr.kbase}, " +
        "answer='$answer', " +
        "samples='$samples', " +
        "sync=0 WHERE id = ${akr.id}";
    var r = await _db.rawUpdate(sql);
    return r == 1;
  }

  Future<List<Kr>> krsOfQuestion(String question) async {
    final fields = _fields.join(",");
    final sql = "SELECT $fields FROM $_tableName WHERE question = ?";
    final rs = await _db.rawQuery(sql, [question]);
    List<Kr> ret = [];
    for (int i = 0; i < rs.length; i++) {
      final row = rs[i];
      ret.add(Kr.fromMap(row));
    }

    return ret;
  }

  Future<Kr> krOfObjectId(String mId) async {
    final sql = "SELECT ${_fields.join(",")} FROM $_tableName WHERE _id = ?";
    final rs = await _db.rawQuery(sql, [mId]);
    if (rs.length > 0) {
      final row = rs[0];
      return Kr.fromMap(row);
    } else {
      return null;
    }
  }

  Future<List<Kr>> krOfObjectIds(List<String> mIds) async {
    final sql =
        "SELECT ${_fields.join(",")} FROM $_tableName WHERE _id IN ('${mIds.join("','")}') ";
    final rs = await _db.rawQuery(sql, []);
    List<Kr> ret = [];
    for (int i = 0; i < rs.length; i++) {
      final row = rs[i];
      ret.add(Kr.fromMap(row));
    }
    return ret;
  }

  Future<Kr> krOfId(int id) async {
    final sql = "SELECT ${_fields.join(",")} FROM $_tableName WHERE id = ?";
    final rs = await _db.rawQuery(sql, [id]);
    if (rs.length > 0) {
      final row = rs[0];
      return Kr.fromMap(row);
    } else {
      return null;
    }
  }

  Future<bool> needSync() async {
    final sql = "SELECT id FROM $_tableName WHERE sync=0";
    final rs = await _db.rawQuery(sql, []);
    if (rs.length > 0) {
      return true;
    } else {
      return false;
    }
  }
}
