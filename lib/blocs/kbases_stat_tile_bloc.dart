import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../repository/mem_db.dart';
import '../models/kbase.dart';

class KbaseCountData {
  final Kbase kbase;
  final int count;
  KbaseCountData({this.kbase, this.count});
}

class KbasesStatTileBloc extends BlocBase {
  // Inputs
  updateCount() => _updateCountController.sink.add(null);

  // Outputs
  ValueObservable<List<KbaseCountData>> get totalCount => _totalCountController;

  // private
  final _updateCountController = StreamController();

  final _totalCountController = BehaviorSubject<List<KbaseCountData>>();

  KbasesStatTileBloc() {
    _updateCountController.stream.listen((_) async {
      _update();
    });
  }

  _update() async {
    List<KbaseCountData> counts = [];
    for (int i = 0; i < Kbase.all.length; i++) {
      var akbase = Kbase.all[i];
      int total = await MemDb.instance.mems().count(akbase.iid);
      if (total > 0) {
        counts.add(KbaseCountData(kbase: akbase, count: total));
      }
    }

    _totalCountController.sink.add(counts);
  }

  dispose() {
    _updateCountController.close();
    _totalCountController.close();
    super.dispose();
  }
}
