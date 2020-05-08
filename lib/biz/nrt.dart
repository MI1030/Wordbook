import 'dart:math';

import './mem_const.dart';
import './standart_time.dart';
import './review_scheme.dart';

class Nrt {
  static int nextLevel(int level, int failedCount) {
    if (failedCount == 0) {
      if (level < MemConst.MAX_STUDY_LEVEL) {
        level += ReviewScheme.upgradeScheme(level);
      }
      //else cont.
    } else {
      level -= ReviewScheme.downgradeScheme(level);
      if (level < 1) {
        level = 1;
      }
      //else cont.
    }

    return level;
  }

  static int ignoreTs() {
    return 2147483647 * 1000;
  }

  static int nextReviewTimeOf(int level, int failedCount) {
    var ret = 0;
    if (level < 0 || level >= MemConst.MAX_STUDY_LEVEL) {
      ret = ignoreTs(); //2^31 - 1 (2038-01-19 11:14:07)
    } else {
      final now = StandardTime.instance.now;
      if (failedCount == 0) {
        final int interval = reviewScheme(level);
        const oneDay = 3600 * 24;
        int days = (interval / oneDay).floor();
        int seconds = interval % oneDay;
        if (days > 0 && seconds == 0) {
          var date = DateTime.fromMillisecondsSinceEpoch(now + interval * 1000);
          var newDate = DateTime(
            date.year,
            date.month,
            date.day,
            3,
          ); // 当天的凌晨3点，这样的话，每天的复习任务在上午就能都看到了
          ret = newDate.millisecondsSinceEpoch;
        } else {
          ret = offset20Percent(seconds) * 1000 + now;
        }
      } else {
        if (0 == level) {
          ret = now;
        } else {
          if (level < 7) {
            ret = now + offset20Percent(2 * 3600) * 1000;
          } else {
            ret = now + offset20Percent(24 * 3600) * 1000;
          }
        }
      }
    } //endi

    return ret;
  }

  static int newDifficulty(int old, int failedCount) {
    var ret = old;
    if (failedCount > 0) {
      //增加难度
      ret = max(0, ret);
      ret += (failedCount / 3).floor() + 1;
    } else if (failedCount == 0) {
      //降低难度
      if (old > 1) {
        //int theNew = (old * 2 / 3).floor();
        int theNew = old - 1;
        ret = max(MemConst.DIFFICULTY_THRESHOLD_VALUE - 1, theNew);
      }
      //else cont.
    }
    //else cont.

    return ret;
  }

  static int reviewScheme(int level) {
    var ret = 0;
    //[0,300,900,2700,39600,46800,86400,345600,345600,432000,1296000,2592000,7776000,15552000,15552000]
    final intervals = [
      0,
      3600,
      86400, // 1天
      86400, // 1天
      86400, // 1天
      259200, // 3天
      345600, // 4天
      432000, // 5天
      432000, // 5天
      864000, // 10天
      1296000, // 15天
      2592000, // 30天
      7776000, // 90天
      15552000, // 180天
      15552000 // 180天
    ];
    if (level >= 0 && level < intervals.length) {
      ret = intervals[level];
    }
    return ret;
  }

  static int offset20Percent(int val) {
    var ret = val;
    if (ret > 0) {
      var random = Random();
      var r = random.nextInt(100);

      final offset = r % 40;
      ret += (ret * (offset - 20) / 100).floor();
    }
    return ret;
  }
}
