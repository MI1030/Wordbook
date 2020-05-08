import 'dart:async';
import 'dart:math';

import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../models/mem.dart';
import '../models/kr.dart';
import '../repository/mem_db.dart';
import '../utils/er_log.dart';
import '../biz/mem_const.dart';
import '../models/kbase.dart';

class MemListBloc extends BlocBase {
  // Inputs
  startLoad() => _startLoadController.sink.add(null);
  loadMore() => _loadMoreController.sink.add(null);

  // Outputs
  ValueObservable<List<MemListItem>> get memListItems =>
      _memListItemsController;
  ValueObservable<List<Mem>> get mems => _memsController;
  ValueObservable<String> get title => _titleController;

  // private
  final _startLoadController = StreamController();
  final _loadMoreController = ReplaySubject();

  final _memListItemsController = BehaviorSubject<List<MemListItem>>();
  final _memsController = BehaviorSubject<List<Mem>>();
  final _titleController = BehaviorSubject<String>();

  int _kbaseId;
  int _rank;
  List<Mem> _mems;

  MemListBloc({int rank, int kbaseId}) {
    _kbaseId = kbaseId;
    _rank = rank;

    _startLoadController.stream.listen((_) {
      _load();
    });

    _loadMoreController.stream
        .throttle((_) => TimerStream(true, const Duration(seconds: 2)))
        .listen((_) {
      if (_memListItemsController.value.length < _mems.length) {
        ErLog.withTs('did load krs');
        _loadKrs();
      }
    });
  }

  _loadKrs() async {
    int start = _memListItemsController.value == null
        ? 0
        : _memListItemsController.value.length;
    int count = min(_mems.length - start, 50);
    List<String> krids =
        _mems.getRange(start, start + count).map((amem) => amem.krid).toList();
    List<Kr> krs = await MemDb.instance.krs().krOfObjectIds(krids);

    List<MemListItem> memlist = [];
    for (int i = 0; i < krids.length; i++) {
      Mem amem = _mems[start + i];
      Kr akr = krs.firstWhere(
        (tkr) => tkr.mid == amem.krid,
        orElse: () => null,
      );
      if (akr != null) {
        memlist.add(MemListItem(amem.id, akr.question, akr.answer, amem.mid));
      }
    }

    if (_memListItemsController.value != null) {
      List<MemListItem> oldlist = _memListItemsController.value;
      oldlist.addAll(memlist);
      _memListItemsController.sink.add(oldlist);
    } else {
      _memListItemsController.sink.add(memlist);
    }
  }

  _load() async {
    String title = '';
    if (_kbaseId != null) {
      title += Kbase.nameOfIid(_kbaseId) + '-';
    }

    if (_rank == null) {
      _mems = await ReviewLoader(_kbaseId).load();
      title = "复习列表 (${_mems.length})";
    } else {
      _mems = await RankLoader(_kbaseId, _rank).load();
      title = MemConst.rankName(_rank) + ' (${_mems.length})';
    }

    _memsController.sink.add(_mems);

    _loadKrs();
    _titleController.sink.add(title);
  }

  @override
  void dispose() {
    _startLoadController.close();
    _memListItemsController.close();
    _memsController.close();
    _titleController.close();
    _loadMoreController.close();
    super.dispose();
  }
}

class MemListItem {
  final int memId;
  final String title;
  final String subtitle;
  final String key;
  MemListItem(this.memId, this.title, this.subtitle, this.key);
}

abstract class MemsLoader {
  Future<List<Mem>> load();
}

class ReviewLoader implements MemsLoader {
  final int kbaseId;

  ReviewLoader(this.kbaseId);

  Future<List<Mem>> load() async {
    final timerName = 'ReviewLoader';
    ErLog.withTs(timerName);
    final mems = await MemDb.instance
        .mems()
        .memsOfReview(order: ReviewOrder.EasyFirst, kbaseId: kbaseId);
    ErLog.withTs(timerName);
    return mems;
  }
}

class RankLoader implements MemsLoader {
  final int _rank;
  final int kbaseId;

  RankLoader(this.kbaseId, this._rank);

  Future<List<Mem>> load() async {
    final timerName = 'RankReviewLoader';
    ErLog.withTs(timerName);
    var mems;

    if (this._rank == MemConst.LEARN_RANK_EMPHASIS) {
      mems = await MemDb.instance.mems().emphasisMems(kbaseId);
    } else if (this._rank == MemConst.LEARN_RANK_ALL) {
      mems = await MemDb.instance
          .mems()
          .getMemsOfLevel(0, MemConst.MAX_STUDY_LEVEL, kbaseId);
    } else {
      final levelP = MemConst.levelOfRank(this._rank);
      mems = await MemDb.instance
          .mems()
          .getMemsOfLevel(levelP.start, levelP.end, kbaseId);
    }

    ErLog.withTs(timerName);
    return mems;
  }
}
