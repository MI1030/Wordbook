import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../repository/mem_db.dart';
import '../models/kbase.dart';

class KbaseTileBloc extends BlocBase {
  // Inputs
  updateCount() => _updateCountController.sink.add(null);

  // Outputs
  ValueObservable<int> get reviewCount => _reviewCountController;
  ValueObservable<int> get totalCount => _totalCountController;

  // private
  final _updateCountController = StreamController();

  final _reviewCountController = BehaviorSubject<int>();
  final _totalCountController = BehaviorSubject<int>();

  KbaseTileBloc(Kbase kbase) {
    _updateCountController.stream.listen((_) async {
      _update(kbase.iid);
    });
  }

  _update(int kbaseId) async {
    int review = await MemDb.instance.mems().reviewCount(kbaseId);
    int total = await MemDb.instance.mems().count(kbaseId);
    _reviewCountController.sink.add(review);
    _totalCountController.sink.add(total);
  }

  dispose() {
    _reviewCountController.close();
    _updateCountController.close();
    _totalCountController.close();
    super.dispose();
  }
}
