import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../repository/mem_db.dart';

class MemstatBloc extends BlocBase {
  // Inputs
  update() => _updateController.sink.add(null);

  // Outputs
  ValueObservable<int> get todayStudyCount => _todayStudyCountController;
  ValueObservable<int> get todayStudyTime => _todayStudyTimeController;
  ValueObservable<int> get totalStudyTime => _totalStudyTimeController;
  ValueObservable<int> get totalCount => _totalCountController;
  ValueObservable<int> get totalStudyCount => _totalStudyCountController;

  // private
  final _totalCountController = BehaviorSubject<int>();
  final _todayStudyCountController = BehaviorSubject<int>();
  final _todayStudyTimeController = BehaviorSubject<int>();
  final _totalStudyCountController = BehaviorSubject<int>();
  final _totalStudyTimeController = BehaviorSubject<int>();

  final _updateController = StreamController();

  MemstatBloc() {
    _updateController.stream.listen((_) async {
      int totalTime = await MemDb.instance.memstatRead().totalStudyTime();
      _totalStudyTimeController.sink.add(totalTime);

      int totalStudyCount =
          await MemDb.instance.memstatRead().totalStudyCount();
      _totalStudyCountController.sink.add(totalStudyCount);

      int todayCount = await MemDb.instance.memstatRead().todayStudyCount();
      _todayStudyCountController.sink.add(todayCount);

      int todayTime = await MemDb.instance.memstatRead().todayStudyTime();
      _todayStudyTimeController.sink.add(todayTime);

      int total = await MemDb.instance.mems().count();
      _totalCountController.sink.add(total);
    });
  }

  dispose() {
    _updateController.close();
    _todayStudyCountController.close();
    _todayStudyTimeController.close();
    _totalStudyTimeController.close();
    _totalCountController.close();
    _totalStudyCountController.close();
    super.dispose();
  }
}
