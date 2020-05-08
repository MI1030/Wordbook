import 'dart:async';
import 'dart:math';

import 'package:sqflite/sqflite.dart';

import '../biz/object_id.dart';
import '../biz/standart_time.dart';
import '../biz/mem_const.dart';
import '../utils/er_log.dart';
import '../models/mem.dart';
import '../biz/nrt.dart';

class Mems {
  Mems(this._db);

  final _tableName = 'mems';
  final Database _db;

  List<String> _fields = [
    "id",
    "_id",
    "krid",
    "ts",
    "level",
    "df",
    "kbase",
    "nrt",
    "failed",
    "offset_failed",
    "sync",
  ];

  Future<String> remember({String krid, int kbaseId = 1}) async {
    int now = StandardTime.instance.now;
    String mId = ObjectId.createOne();
    String sql = 'INSERT INTO $_tableName ' +
        '(_id, krid, ts, level, df, kbase, nrt, failed, offset_failed, sync) ' +
        "values ('$mId', '$krid', $now, 0, 0, $kbaseId, $now, 0, 0, 0)";
    int ret = await _db.rawInsert(sql);
    if (ret >= 0) {
      return mId;
    } else {
      return '';
    }
  }

  Future<bool> saveContent({String mId, int kbaseId}) async {
    var sql = "UPDATE $_tableName " +
        "SET ts =${StandardTime.instance.now}, " +
        "kbase=$kbaseId, " +
        "sync=0 WHERE _id = '$mId'";
    var r = await _db.rawUpdate(sql);
    return r == 1;
  }

  Future<Mem> memOfObjectId(String mId) async {
    final sql = "SELECT ${_fields.join(",")} FROM $_tableName WHERE _id = ?";
    final rs = await _db.rawQuery(sql, [mId]);
    if (rs.length > 0) {
      final row = rs[0];
      return Mem.fromMap(row);
    } else {
      return null;
    }
  }

  Future<Mem> memOfKrid(String krid) async {
    final sql = "SELECT ${_fields.join(",")} FROM $_tableName WHERE krid = ?";
    final rs = await _db.rawQuery(sql, [krid]);
    if (rs.length > 0) {
      final row = rs[0];
      return Mem.fromMap(row);
    } else {
      return null;
    }
  }

  Future<Mem> memOfId(int id) async {
    final sql = "SELECT ${_fields.join(",")} FROM $_tableName WHERE id = ?";
    final rs = await _db.rawQuery(sql, [id]);
    if (rs.length > 0) {
      final row = rs[0];
      return Mem.fromMap(row);
    } else {
      return null;
    }
  }

  Future<int> count([int kbaseId]) async {
    String sql = "SELECT count(id) as count FROM $_tableName WHERE level>-1 ";
    if (kbaseId != null) {
      sql += " AND kbase=$kbaseId";
    }

    final rs = await _db.rawQuery(sql, []);
    var ret = 0;
    if (rs.length > 0) {
      final row = rs[0];
      ret = row['count'];
    }
    return ret;
  }

  Future<int> reviewCount([int kbaseId]) async {
    String sql =
        "SELECT count(id) as count FROM $_tableName WHERE nrt < ${StandardTime.instance.now}";
    if (kbaseId != null) {
      sql += " AND kbase=$kbaseId ";
    }
    var rs = await _db.rawQuery(sql, []);
    var ret = 0;
    if (rs.length > 0) {
      var row = rs[0];
      ret = row['count'];
    }
    return ret;
  }

  Future<List<Mem>> getMems([int kbaseId]) async {
    String sql = "SELECT ${_fields.join(',')} FROM $_tableName WHERE level>-1";
    if (kbaseId != null) {
      sql += " AND kbase=$kbaseId";
    }
    final rs = await _db.rawQuery(sql, []);
    final List<Mem> mems = [];
    for (var i = 0; i < rs.length; i++) {
      final row = rs[i];
      mems.add(Mem.fromMap(row));
    }
    return mems;
  }

  Future<bool> ignore(int memId) async {
    var nextTime = Nrt.ignoreTs();
    var sql =
        "UPDATE $_tableName SET ts =${StandardTime.instance.now}, level= ${-1}, nrt=$nextTime, sync=0 WHERE id = $memId";
    var r = await _db.rawUpdate(sql);
    return r > 0;
  }

  Future<List<Mem>> memsOfReview(
      {ReviewOrder order, int kbaseId, int count}) async {
    final fields = _fields.join(',');
    final ts = StandardTime.instance.now;
    final rorder = _reviewOrder(order);
    String sql;
    if (kbaseId == null) {
      sql = "SELECT $fields FROM $_tableName WHERE nrt < $ts $rorder";
    } else {
      sql =
          "SELECT $fields FROM $_tableName WHERE kbase=$kbaseId AND nrt < $ts $rorder";
    }

    if (count != null && order != ReviewOrder.Random) {
      sql += " limit 0, $count";
    }

    final rs = await _db.rawQuery(sql, []);
    final List<Mem> ret = [];
    for (var i = 0; i < rs.length; i++) {
      final row = rs[i];
      ret.add(Mem.fromMap(row));
    }

    if (order == ReviewOrder.Random) {
      ret.shuffle();
      return ret.sublist(0, count);
    } else {
      return ret;
    }
  }

  Future<bool> save(
      int id, int ts, int level, int df, int nrt, int failedCount) async {
    var setStr =
        "ts =$ts, level= $level, df = $df, nrt=$nrt, failed=failed+$failedCount, offset_failed=offset_failed+$failedCount, sync=0";
    var sql = "UPDATE mems SET $setStr WHERE id = $id";
    var r = await _db.rawUpdate(sql);
    return r > 0;
  }

  Future<Map<int, int>> levelCount([int kbaseId]) async {
    var sql = "SELECT level, count(level) AS count FROM mems ";
    if (kbaseId != null) {
      sql += " WHERE kbase=$kbaseId ";
    }
    sql += " GROUP BY level ORDER BY level DESC";
    var rs = await _db.rawQuery(sql, []);
    if (rs.length > 0) {
      Map<int, int> ret = {};
      for (var i = 0; i < rs.length; i++) {
        var row = rs[i];
        var level = row['level'];
        var count = row['count'];
        ret[level] = count;
      }
      return ret;
    } else {
      return {};
    }
  }

  Future<int> difficultyCount([int kbaseId]) async {
    String sql =
        "SELECT COUNT(*) as count FROM $_tableName WHERE df>=${MemConst.DIFFICULTY_THRESHOLD_VALUE} "
        " AND level<>-1 AND level<${MemConst.MAX_STUDY_LEVEL}";
    if (kbaseId != null) {
      sql += " AND kbase=$kbaseId ";
    }
    final rs = await _db.rawQuery(sql, []);
    if (rs.length > 0) {
      final row = rs[0];
      return row['count'];
    } else {
      return 0;
    }
  }

  Future<List<Mem>> emphasisMems(
      [int kbaseId, int start = 0, int count = 0]) async {
    String sql = "SELECT ${_fields.join(',')} FROM $_tableName";
    sql +=
        " WHERE df>=${MemConst.DIFFICULTY_THRESHOLD_VALUE} AND level<>-1 AND level<${MemConst.MAX_STUDY_LEVEL} ";
    if (kbaseId != null) {
      sql += " AND kbase=$kbaseId";
    }
    sql += " ORDER BY ts DESC";
    if (start != null && count != null && count > 0) {
      sql += " limit $start, $count";
    }
    ErLog.withTs('emphasisMems sql: $sql');
    final rs = await _db.rawQuery(sql, []);
    return rs.map((row) => Mem.fromMap(row)).toList();
  }

  Future<int> getMemsCountOfLevel(int level) async {
    final sql = "SELECT count(*) as count FROM $_tableName WHERE level=$level";
    final rs = await _db.rawQuery(sql, []);
    if (rs.length > 0) {
      final row = rs[0];
      return row['count'];
    } else {
      return 0;
    }
  }

  Future<List<Mem>> getMemsOfLevel(int startLevel, int endLevel,
      [int kbaseId, int start = 0, int count = 0]) async {
    String sql = "SELECT ${_fields.join(',')} FROM $_tableName ";
    sql += " WHERE level>=$startLevel AND level<=$endLevel ";
    if (kbaseId != null) {
      sql += " AND kbase=$kbaseId";
    }
    sql += " ORDER BY ts DESC";
    if (start != null && count != null && count > 0) {
      sql += " LIMIT $start, $count";
    }

    var rs = await _db.rawQuery(sql, []);
    List<Mem> mems = [];
    rs.forEach((row) {
      mems.add(Mem.fromMap(row));
    });

    return mems;
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

  String _reviewOrder(ReviewOrder order) {
    var ret = "";
    final random = Random();
    final r = random.nextInt(1);
    switch (order) {
      case ReviewOrder.EasyFirst:
        if (r > 0) {
          ret = "ORDER BY ts DESC, df, level DESC";
        } else {
          ret = "ORDER BY level DESC, df, ts DESC";
        }
        break;
      case ReviewOrder.HardFirst:
        if (r > 0) {
          ret = "ORDER BY df DESC, level, ts";
        } else {
          ret = "ORDER BY df DESC, ts, level";
        }
        break;
      default:
        break;
    }
    return ret;
  }
}
