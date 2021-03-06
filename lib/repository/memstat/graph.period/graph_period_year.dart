import 'package:intl/intl.dart';

import './graph_period.dart';
import '../../../models/memstat_period.dart';
import '../../../biz/standart_time.dart';

class GraphPeriodYear implements GraphPeriod {
  String get name {
    return "一年";
  }

  MemstatPeriod get tableType {
    return MemstatPeriod.MONTHLY;
  }

  int get step {
    return -1;
  }

  int get beginTime {
    DateTime ret =
        DateTime.fromMillisecondsSinceEpoch(StandardTime.instance.now);
    int year = ret.year;
    int month = ret.month - 11;
    if (month <= 0) {
      year -= 1;
      month += 12;
    }
    ret = DateTime(year, month);

    return (ret.millisecondsSinceEpoch / 1000).floor();
  }

  int get realCount {
    return 12;
  }

  int pos(int ts0) {
    DateTime start = DateTime.fromMillisecondsSinceEpoch(this.beginTime * 1000);
    DateTime ts = DateTime.fromMillisecondsSinceEpoch(ts0);
    return (ts.year * 12 + ts.month) - (start.year * 12 + start.month);
  }

  String tsTag(int ts0, int index) {
    DateTime ts =
        DateTime.fromMillisecondsSinceEpoch(this.ts0(ts0, index) * 1000);
    return DateFormat("YY-M").format(ts);
  }

  int ts0(int ts0, int index) {
    var ret = ts0;
    if (ts0 == 0) {
      DateTime ts = DateTime.fromMillisecondsSinceEpoch(this.beginTime * 1000);
      int month = ts.month + index;
      if (month > 12) {
        ts = DateTime(ts.year + 1, month % 12);
      } else {
        ts = DateTime(ts.year, month);
      }
      ret = (ts.millisecondsSinceEpoch / 1000).floor();
    }
    return ret;
  }
}
