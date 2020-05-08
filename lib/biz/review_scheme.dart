import './mem_const.dart';

class ReviewScheme {
  static int upgradeScheme(int level) {
    var ret = 1;
    if (level < MemConst.MAX_STUDY_LEVEL) {
      ret = 1;
    } else {
      ret = 0;
    }
    return ret;
  }

  static int downgradeScheme(int level) {
    var ret = 1;
    var downLevels = [0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 5, 6];
    if (level >= 0 && level < downLevels.length) {
      ret = downLevels[level];
    }
    //else cont.

    return ret;
  }

  static int nextLevel(int level, int failedCount) {
    if (failedCount == 0) {
      if (level < MemConst.MAX_STUDY_LEVEL) {
        level += upgradeScheme(level);
      }
      //else cont.
    } else {
      level -= downgradeScheme(level);
      if (level < 1) {
        level = 1;
      }
      //else cont.
    }

    return level;
  }
}
