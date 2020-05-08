import 'dart:async';
import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

import '../repository/mem_db.dart';
import '../biz/mem_const.dart';

class AchieveBloc extends BlocBase {
  // Inputs
  startLoad() => _startLoadController.sink.add(null);

  // Outputs
  ValueObservable<List<AchieveItem>> get achieves => _achievesContorller;

  // private
  final _startLoadController = StreamController();
  final _achievesContorller = BehaviorSubject<List<AchieveItem>>();

  AchieveBloc(int kbase) {
    _startLoadController.stream.listen((_) async {
      final r = await AchieveLoader().load(kbase);

      _achievesContorller.sink.add(AchieveItem.getAchieves(r));
    });
  }

  @override
  void dispose() {
    _startLoadController.close();
    _achievesContorller.close();
    super.dispose();
  }
}

class AchieveLoader {
  Future<Map<int, int>> load([int kbaseId, bool includeEmphasis = true]) async {
    final Map<int, int> levelCounts =
        await MemDb.instance.mems().levelCount(kbaseId);
    var difficultCount;
    if (includeEmphasis) {
      difficultCount = await MemDb.instance.mems().difficultyCount(kbaseId);
    }

    var ret = {
      MemConst.LEARN_RANK_UNKNOWN: 0,
      MemConst.LEARN_RANK_0: 0,
      MemConst.LEARN_RANK_1: 0,
      MemConst.LEARN_RANK_2: 0,
      MemConst.LEARN_RANK_3: 0,
      MemConst.LEARN_RANK_4: 0,
    };

    var total = 0;
    levelCounts.forEach((int level, int value) {
      if (level >= 0 && level <= MemConst.MAX_STUDY_LEVEL) {
        final rank = MemConst.rankOfLevel(level);
        ret[rank] += value;
      } else if (level == MemConst.IGNORE_LEVEL) {
        ret[MemConst.IGNORE_LEVEL] = value;
      } else {
        ret[MemConst.LEARN_RANK_UNKNOWN] += value;
      }

      if (level >= 0) {
        total += value;
      }
    });

    ret[MemConst.LEARN_RANK_EMPHASIS] = difficultCount > 0 ? difficultCount : 0;
    ret[MemConst.LEARN_RANK_ALL] = total;
    return ret;
  }
}

class AchieveItem {
  String key = '';
  int rank;
  String title = '';
  int count;
  double progress = 0;
  int color;

  AchieveItem._(int rank, int count, double progress) {
    this.rank = rank;
    this.title = MemConst.rankName(rank);
    this.count = count;
    this.progress = progress;
    this.key = 'rank_$rank';
    this.color = MemConst.color(rank);
  }

  static AchieveItem emptyHeaderItem() {
    Random random = Random();
    final ret = AchieveItem._(MemConst.LEARN_RANK_UNKNOWN, 0, 0);
    ret.key = "empty-header-" + random.nextInt(9999).toString();
    return ret;
  }

  static List<AchieveItem> getAchieves(Map<int, int> rankCounts) {
    final List<AchieveItem> ret = [];
    ret.add(AchieveItem.emptyHeaderItem());
    ret.add(createItem(MemConst.LEARN_RANK_ALL, rankCounts));
    ret.add(AchieveItem.emptyHeaderItem());
    ret.add(createItem(MemConst.LEARN_RANK_4, rankCounts));
    ret.add(createItem(MemConst.LEARN_RANK_3, rankCounts));
    ret.add(createItem(MemConst.LEARN_RANK_2, rankCounts));
    ret.add(createItem(MemConst.LEARN_RANK_1, rankCounts));
    ret.add(createItem(MemConst.LEARN_RANK_0, rankCounts));
    ret.add(AchieveItem.emptyHeaderItem());
    ret.add(createItem(MemConst.LEARN_RANK_EMPHASIS, rankCounts));
    ret.add(createItem(MemConst.LEARN_RANK_IGNORE, rankCounts));
    ret.add(AchieveItem.emptyHeaderItem());
    return ret;
  }

  static createItem(int rank, Map<int, int> rankCounts) {
    final total = rankCounts[MemConst.LEARN_RANK_ALL];
    final count = rankCounts[rank] == null ? 0 : rankCounts[rank];
    final ret = new AchieveItem._(rank, count, calcProgress(total, count));
    return ret;
  }

  static double calcProgress(int total, int count) {
    return total > 0 ? min(count / total, 1) : 0;
  }
}
