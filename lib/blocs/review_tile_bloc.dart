import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../repository/mem_db.dart';

class ReviewTileParams {
  final int review;
  final int total;
  ReviewTileParams({this.review, this.total});
}

class ReviewTileBloc extends BlocBase {
  // Inputs
  updateCount() => _updateCountController.sink.add(null);

  // Outputs
  ValueObservable<ReviewTileParams> get counts => _countsController;

  // private
  final _updateCountController = StreamController();
  final _countsController = BehaviorSubject<ReviewTileParams>();

  ReviewTileBloc() {
    _updateCountController.stream.listen((_) async {
      _update();
    });
  }

  _update() async {
    int review = await MemDb.instance.mems().reviewCount();
    int total = await MemDb.instance.mems().count();
    _countsController.sink.add(ReviewTileParams(review: review, total: total));
  }

  dispose() {
    _countsController.close();
    _updateCountController.close();
    super.dispose();
  }
}
