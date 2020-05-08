import 'dart:async';

import '../biz/nrt.dart';
import '../biz/standart_time.dart';
import '../models/mem.dart';
import '../repository/mem_db.dart';

class ReviewItem {
  Mem mem;
  int failedCount = 0;
  int repeatTimes = 0;
  int elapsed = 0;

  ReviewItem(this.mem);
}

class FailRecord {
  int nextTime = 0;
  int failedCount = 0;
  int failedSchedule = 0;
  int elapsed = 0;
}

class ReviewController {
  List<ReviewItem> _reviewMems;
  int _total = 0;
  static const int _MaxSchedule = 2;

  Mem start(List<Mem> mems) {
    _reviewMems = mems.map((Mem mem) => ReviewItem(mem)).toList();
    _total = mems.length;
    return _reviewMems.first.mem;
  }

  addMems(List<Mem> mems) {
    _reviewMems.addAll(mems.map((Mem mem) => ReviewItem(mem)).toList());
    _total += mems.length;
  }

  int get total {
    return _total;
  }

  int get index {
    return _total - _reviewMems.length;
  }

  bool isLastOne() {
    return _reviewMems.length == 1;
  }

  bool hasMore() {
    return _reviewMems.length > 0;
  }

  Mem next() {
    return _reviewMems.first.mem;
  }

  Mem next2() {
    Mem ret;
    if (_reviewMems.length > 1) {
      ret = _reviewMems[1].mem;
    } else {
      ret = null;
    }
    return ret;
  }

  Future<Mem> refreshMem() async {
    Mem currentMem = _reviewMems.first.mem;
    Mem newMem = await MemDb.instance.mems().memOfId(currentMem.id);
    _reviewMems[0].mem = newMem;
    return newMem;
  }

  bool itemLearned(int index) {
    if (index < _reviewMems.length) {
      return _reviewMems[index].failedCount > 0;
    } else {
      return false;
    }
  }

  Future<bool> passIt(int elapsed) async {
    ReviewItem currentMem = _reviewMems.removeAt(0);
    var saved = false;
    if (currentMem.failedCount == 0) {
      await _saveOneMem(currentMem.mem, 0, elapsed);
      saved = true;
    } else {
      currentMem.repeatTimes += 1;

      if (currentMem.repeatTimes < _MaxSchedule && _reviewMems.length > 0) {
        currentMem.elapsed += elapsed;
        _insertFailedItem(currentMem);
      } else {
        await _saveOneMem(
          currentMem.mem,
          currentMem.failedCount,
          currentMem.elapsed + elapsed,
        );
        saved = true;
      }
    }
    return saved;
  }

  failIt(int elapsed) async {
    ReviewItem currentMem = _reviewMems.removeAt(0);
    currentMem.failedCount += 1;
    currentMem.repeatTimes = 0;
    currentMem.elapsed += elapsed;
    if (_reviewMems.length > 0 || currentMem.repeatTimes == 0) {
      _insertFailedItem(currentMem);
    } else {
      await _saveOneMem(
        currentMem.mem,
        currentMem.failedCount,
        currentMem.elapsed + elapsed,
      );
    }
  }

  Future ignoreIt(int elapsed) async {
    ReviewItem currentMem = _reviewMems.removeAt(0);
    return await MemDb.instance.mems().ignore(currentMem.mem.id);
  }

  Future<List<Mem>> stop() async {
    List<Mem> ret = [];
    for (int i = 0; i < _reviewMems.length; i++) {
      ReviewItem item = _reviewMems[i];
      var failedCount = item.failedCount;
      if (failedCount > 0) {
        var elapsed = item.elapsed;
        await _saveOneMem(item.mem, failedCount, elapsed);
        ret.add(item.mem);
      }
    }
    return ret;
  }

  _insertFailedItem(ReviewItem item) {
    int index = item.repeatTimes + 1;
    if (_reviewMems.length > index) {
      _reviewMems.insert(index, item);
    } else {
      _reviewMems.add(item);
    }
  }

  _saveOneMem(Mem mem, int failedCount, int elapsed) async {
    var ret = true;
    ret = ret && await _saveMem(mem, failedCount);
    ret = ret && await _saveMemstat(mem, failedCount, elapsed);
    return ret;
  }

  Future<bool> _saveMem(Mem mem, int failedCount) async {
    var level = Nrt.nextLevel(mem.level, failedCount);
    var df = Nrt.newDifficulty(mem.df, failedCount);
    var nrt = Nrt.nextReviewTimeOf(level, failedCount);
    return await MemDb.instance
        .mems()
        .save(mem.id, StandardTime.instance.now, level, df, nrt, failedCount);
  }

  Future<bool> _saveMemstat(Mem mem, int failedCount, int elapsed) async {
    var level = Nrt.nextLevel(mem.level, failedCount);
    return await MemDb.instance
        .memstatStudy()
        .saveMemstats(mem.level, level, StandardTime.instance.now, elapsed);
  }
}
