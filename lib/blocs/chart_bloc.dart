import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../utils/er_log.dart';
import '../repository/mem_db.dart';
import '../repository/memstat/memstat_graph.dart';

class ChartBloc extends BlocBase {
  // Inputs

  // Outputs
  ValueObservable<List<charts.Series<GraphItem, DateTime>>> get series =>
      _seriesController;
  ValueObservable<String> get title => _titleController;

  // private
  final _seriesController =
      BehaviorSubject<List<charts.Series<GraphItem, DateTime>>>();
  final _titleController = BehaviorSubject<String>();

  ChartBloc(int period) {
    loadData(int period) async {
      String title = '';
      if (period == 1) {
        title = "最近30天";
      } else {
        title = "最近12个月";
      }
      _titleController.sink.add(title);

      List<GraphItem> data = await MemDb.instance.memstatGraph().data(period);
      ErLog.withTs('$data');
      List<charts.Series<GraphItem, DateTime>> series = [
        new charts.Series(
          id: '复习',
          domainFn: (GraphItem clickData, _) =>
              DateTime.fromMillisecondsSinceEpoch(clickData.ts0 * 1000),
          measureFn: (GraphItem clickData, _) => clickData.reviewCount,
          colorFn: (GraphItem clickData, _) => charts.Color(
              r: Colors.blue.red,
              g: Colors.blue.green,
              b: Colors.blue.blue,
              a: Colors.blue.alpha),
          data: data,
        ),
        new charts.Series(
          id: '新添加',
          domainFn: (GraphItem clickData, _) =>
              DateTime.fromMillisecondsSinceEpoch(clickData.ts0 * 1000),
          measureFn: (GraphItem clickData, _) => clickData.newCount,
          colorFn: (GraphItem clickData, _) => charts.Color(
              r: Colors.orange.red,
              g: Colors.orange.green,
              b: Colors.orange.blue,
              a: Colors.orange.alpha),
          data: data,
        ),
      ];
      _seriesController.sink.add(series);
    }

    loadData(period);
  }

  @override
  void dispose() {
    _titleController.close();
    _seriesController.close();
    super.dispose();
  }
}
