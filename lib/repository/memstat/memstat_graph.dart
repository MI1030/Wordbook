import 'dart:async';

import 'package:sqflite/sqflite.dart';

import './memstat_base.dart';
import '../../utils/er_log.dart';
import './graph.period/graph_period.dart';
import './graph.period/graph_period_day.dart';
import './graph.period/graph_period_month.dart';
import './graph.period/graph_period_year.dart';
import './graph.period/graph_period_two_year.dart';

class GraphItem {
  int newCount = 0;
  int reviewCount = 0;
  int finishedCount = 0;
  int reviewTime = 0;
  String tsTag = '';
  int ts0 = 0;

  GraphItem();

  GraphItem.fromData(this.tsTag, this.reviewCount);

  @override
  String toString() {
    return '{new: $newCount, review: $reviewCount, finish: $finishedCount, time: $reviewTime, tsTag: $tsTag, ts0: $ts0}\n';
  }
}

enum GRAPH_PERIOD {
  DAY,
  MONTH,
  YEAR,
  TWOYEAR,
}

class MemstatGraph {
  List<GraphPeriod> graphPeriods = [];

  Database _db;
  MemstatGraph(this._db) {
    this.graphPeriods.add(this.createGraphPeriod(GRAPH_PERIOD.DAY));
    this.graphPeriods.add(this.createGraphPeriod(GRAPH_PERIOD.MONTH));
    this.graphPeriods.add(this.createGraphPeriod(GRAPH_PERIOD.YEAR));
    this.graphPeriods.add(this.createGraphPeriod(GRAPH_PERIOD.TWOYEAR));
  }

  List<String> tabs() {
    return this.graphPeriods.map((v) => v.name).toList();
  }

  Future<List<GraphItem>> data(int tab) async {
    final period = this.graphPeriods[tab];
    final List<GraphItem> items = [];
    final realCount = period.realCount;
    for (int i = 0; i < realCount; i++) {
      final aitem = new GraphItem();
      aitem.tsTag = period.tsTag(0, i);
      aitem.ts0 = period.ts0(0, i);
      items.add(aitem);
    } //endf

    final tableName = MemstatBase.tableName(period.tableType);
    final beginTime = period.beginTime * 1000;
    final sql =
        "SELECT ts0, time, new,rvw,fin FROM $tableName WHERE ts0>=$beginTime ORDER BY ts0";
    ErLog.withTs('sql: $sql');
    final rs = await _db.rawQuery(sql);
    for (int i = 0; i < rs.length; i++) {
      final ele = rs[i];
      final ts0 = ele['ts0'];
      final pos = period.pos(ts0);
      final aitem = items[pos];
      aitem.reviewTime += ele['time'];
      aitem.newCount += ele['new'];
      aitem.reviewCount += ele['rvw'];
      aitem.finishedCount += ele['fin'];
    }
    return items;
  }

  GraphPeriod createGraphPeriod(GRAPH_PERIOD timeType) {
    GraphPeriod ret = GraphPeriodDay();
    switch (timeType) {
      case GRAPH_PERIOD.DAY:
        ret = new GraphPeriodDay();
        break;
      case GRAPH_PERIOD.MONTH:
        ret = new GraphPeriodMonth();
        break;
      case GRAPH_PERIOD.YEAR:
        ret = new GraphPeriodYear();
        break;
      case GRAPH_PERIOD.TWOYEAR:
        ret = new GraphPeriodTwoYear();
        break;
    }
    return ret;
  }
}
