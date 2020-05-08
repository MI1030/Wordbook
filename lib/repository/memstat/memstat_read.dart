import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../biz/standart_time.dart';
import '../../models/memstat_period.dart';
import './memstat_base.dart';

class MemstatRead {
  MemstatRead(this._db);

  final Database _db;

  Future<int> todayStudyTime() async {
    return await this
        .studyTimeOfPeriod(MemstatPeriod.DAILY, StandardTime.instance.now);
  }

  Future<int> totalStudyTime() async {
    var sql = "SELECT time FROM allmemstats ORDER BY time DESC LIMIT 1";
    var rs = await _db.rawQuery(sql);

    if (rs.length > 0) {
      var row = rs[0];
      return row['time'];
    } else {
      return 0;
    }
  }

  Future<int> totalStudyCount() async {
    var sql = "SELECT new,rvw FROM allmemstats ORDER BY time DESC LIMIT 1";
    var rs = await _db.rawQuery(sql);
    if (rs.length > 0) {
      var row = rs[0];
      return row['new'] + row['rvw'];
    } else {
      return 0;
    }
  }

  Future<int> todayStudyCount() async {
    return await this
        .studyCountOfPeriod(MemstatPeriod.DAILY, StandardTime.instance.now);
  }

  Future<int> score() async {
    var sql = "select score from allmemstats order by time DESC";
    var rs = await _db.rawQuery(sql);
    if (rs.length > 0) {
      var row = rs[0];
      return row['score'];
    } else {
      return 0;
    }
  }

  Future<int> studyCountOfPeriod(MemstatPeriod periodType, int time) async {
    var tableName = MemstatBase.tableName(periodType);
    var atime = MemstatBase.createdTimeFromTs(periodType, time);
    var sql = "SELECT new,rvw FROM $tableName WHERE ts0 = $atime LIMIT 0, 1";
    var rs = await _db.rawQuery(sql);
    if (rs.length > 0) {
      var row = rs[0];
      return row['new'] + row['rvw'];
    } else {
      return 0;
    }
  }

  Future<int> studyTimeOfPeriod(MemstatPeriod periodType, int time) async {
    var tableName = MemstatBase.tableName(periodType);
    var atime = MemstatBase.createdTimeFromTs(periodType, time);
    var sql = "SELECT time FROM $tableName WHERE ts0 = $atime LIMIT 0, 1";
    var rs = await _db.rawQuery(sql);

    if (rs.length > 0) {
      var row = rs[0];
      return row['time'];
    } else {
      return 0;
    }
  }
}
