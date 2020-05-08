import '../../models/memstat_period.dart';

const table_prefix = ["all", "hourly", "daily", "weekly", "monthly"];

class MemstatBase {
  static String tableName(MemstatPeriod prefix) {
    var ret = table_prefix[prefix.index] + "memstats";
    return ret;
  }

  static int createdTimeFromTs(MemstatPeriod statType, int time) {
    int rtv = 0;

    time = (time / 1000).floor();
    if (statType == MemstatPeriod.HOURLY) {
      rtv = 3600 * (time / 3600).round();
    } else if (statType == MemstatPeriod.DAILY) {
      rtv = startOfDayTs(time);
    } else if (statType == MemstatPeriod.WEEKLY) {
      rtv = startOfWeekTs(time);
    } else if (statType == MemstatPeriod.MONTHLY) {
      rtv = startOfMonthTs(time);
    } else {
      rtv = time;
    }
    return rtv * 1000;
  }

  static int startOfDayTs(int timeinterval) {
    // 今天0点
    var localDateTime =
        DateTime.fromMillisecondsSinceEpoch(timeinterval * 1000);
    var rtv =
        DateTime(localDateTime.year, localDateTime.month, localDateTime.day);
    return (rtv.millisecondsSinceEpoch / 1000).round();
  }

  static int startOfWeekTs(int timeinterval) {
    //本周一
    var localDateTime =
        DateTime.fromMillisecondsSinceEpoch(timeinterval * 1000);
    var weekday = localDateTime.weekday;
    var t =
        DateTime(localDateTime.year, localDateTime.month, localDateTime.day);
    var ts = (t.millisecondsSinceEpoch / 1000).round() +
        ((weekday - 1) * 3600 * 24 * -1);
    var rtv = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
    return (rtv.millisecondsSinceEpoch / 1000).round();
  }

  static int startOfMonthTs(int timeinterval) {
    // 本月1日
    var localDateTime =
        DateTime.fromMillisecondsSinceEpoch(timeinterval * 1000);
    var rtv = DateTime(localDateTime.year, localDateTime.month);
    return (rtv.millisecondsSinceEpoch / 1000).round();
  }
}
