import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../biz/standart_time.dart';
import '../../models/memstat_period.dart';
import './memstat_base.dart';
import '../../biz/object_id.dart';
import '../../biz/mem_const.dart';

class MemStatItem {
  MemstatPeriod period;
  int ts0 = 0;
  int time = 0;
  int newCount = 0;
  int reviewCount = 0;
  int finishCount = 0;
  int score = 0;
}

class MemStatStudy {
  MemStatStudy(this._db);

  Database _db;

  Future saveMemstats(
      int lastLevel, int level, int modifiedTs, int elapsed) async {
    final values = MemstatPeriod.values;

    for (int i = 0; i < values.length; i++) {
      final stat = values[i];
      final sa = new MemStatItem();
      sa.period = stat;
      sa.ts0 = MemstatBase.createdTimeFromTs(stat, modifiedTs);
      sa.newCount = _newCount(lastLevel, level);
      sa.finishCount = _finishCount(lastLevel, level);
      sa.reviewCount = _reviewCount(lastLevel, level);
      sa.time = _elapsedTime(elapsed);
      sa.score = _score(sa);
      await _writeToDb(sa);
    }
  }

  Future<bool> _writeToDb(MemStatItem statInfo) async {
    final selectSql = _selectSqlForUpdate(statInfo.period, statInfo.ts0);
    final rs = await _db.rawQuery(selectSql);
    if (rs.length > 0) {
      final row = rs[0];
      final recordId = row['id'];
      return await _updateOne(statInfo, recordId);
    } else {
      return await _insertOne(statInfo);
    } //endi
  }

  Future<bool> _updateOne(MemStatItem statInfo, int recordId) async {
    final updateSql = _updateSql(statInfo, recordId);
    final r = await _db.rawUpdate(updateSql);
    final ret = r > 0;
    if (!ret) {
      //ErLog.withTs("update memstat record error. sql: " + updateSql);
    }
    return ret;
  }

  Future<bool> _insertOne(MemStatItem statInfo) async {
    var sql = _insertSql(statInfo);
    var r = await _db.rawInsert(sql);
    var ret = r > 0;
    if (!ret) {
      //ErLog.withTs("update memstat record error. sql: " + sql);
    }
    return ret;
  }

  String _updateSql(MemStatItem statInfo, int recordId) {
    var tableName = MemstatBase.tableName(statInfo.period);
    var setStr =
        "time = time + ${statInfo.time}, offset_time = offset_time + ${statInfo.time}";
    setStr +=
        ", new = new + ${statInfo.newCount}, offset_new = offset_new + ${statInfo.newCount}";
    setStr +=
        ", rvw = rvw + ${statInfo.reviewCount}, offset_rvw = offset_rvw + ${statInfo.reviewCount}";
    setStr +=
        ", fin = fin + ${statInfo.finishCount}, offset_fin = offset_fin + ${statInfo.finishCount}";
    setStr +=
        ", score = score + ${statInfo.score}, offset_score = offset_score + ${statInfo.score}";
    if (statInfo.period == MemstatPeriod.ALL) {
      setStr += ", ts = ${StandardTime.instance.now}";
    }
    final ret = "UPDATE $tableName SET $setStr, sync = 0 WHERE id = $recordId";

    return ret;
  }

  String _insertSql(MemStatItem statInfo) {
    final tableName = MemstatBase.tableName(statInfo.period);
    var columnStr =
        "_id, uid, ts0, time, score, new, rvw, fin, offset_time, offset_score, offset_new, offset_rvw, offset_fin";
    var selectStr = "'${ObjectId.createOne()}', '', ${statInfo.ts0}, " +
        "${statInfo.time}, ${statInfo.score}, ${statInfo.newCount}, ${statInfo.reviewCount}, " +
        "${statInfo.finishCount}, ${statInfo.time}, ${statInfo.score}, ${statInfo.newCount}, " +
        "${statInfo.reviewCount}, ${statInfo.finishCount}";

    if (statInfo.period == MemstatPeriod.ALL) {
      columnStr += ", ts";
      selectStr += ", ${StandardTime.instance.now}";
    }
    final ret = "INSERT INTO $tableName ($columnStr) VALUES ($selectStr)";

    return ret;
  }

  int _newCount(int lastLevel, int level) {
    var ret = 0;
    if (lastLevel == 0 && level > 0) {
      ret = 1;
    }
    return ret;
  }

  int _finishCount(int lastLevel, int level) {
    var ret = 0;
    if (level >= MemConst.MAX_STUDY_LEVEL &&
        lastLevel < MemConst.MAX_STUDY_LEVEL) {
      ret = 1;
    }
    return ret;
  }

  int _reviewCount(int lastLevel, int level) {
    var ret = 0;
    if (lastLevel != 0 && level > 0 && level <= MemConst.MAX_STUDY_LEVEL) {
      ret = 1;
    }
    return ret;
  }

  int _elapsedTime(int elapsed) {
    return (elapsed > 600) ? 30 : elapsed;
  }

  int _score(MemStatItem sa) {
    const new_weight = 10;
    const review_weight = 5;
    const finish_weight = 20;
    return sa.time +
        sa.newCount * new_weight +
        sa.reviewCount * review_weight +
        sa.finishCount * finish_weight;
  }

  String _selectSqlForUpdate(MemstatPeriod stat, int created) {
    final tableName = MemstatBase.tableName(stat);
    var sqlStr = "SELECT id FROM $tableName";

    if (stat != MemstatPeriod.ALL) {
      sqlStr += " WHERE ts0 = $created";
    } else {
      sqlStr += " ORDER BY time DESC";
    }

    return sqlStr;
  }
}
