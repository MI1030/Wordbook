import 'package:intl/intl.dart';

import './graph_period.dart';
import '../../../models/memstat_period.dart';
import '../../../biz/standart_time.dart';

class GraphPeriodMonth implements GraphPeriod {
  String get name {
    return "月";
  }

  MemstatPeriod get tableType {
    return MemstatPeriod.DAILY;
  }

  int get step {
    return 86400;
  }

  int get beginTime {
    DateTime ret =
        DateTime.fromMillisecondsSinceEpoch(StandardTime.instance.now);
    ret = ret.subtract(Duration(days: 30));
    ret = DateTime(ret.year, ret.month, ret.day);
    ret = ret.add(Duration(days: 1));
    return (ret.millisecondsSinceEpoch / 1000).floor();
  }

  int get realCount {
    final delta = StandardTime.instance.now / 1000 - this.beginTime;
    return (delta / this.step).ceil();
  }

  int pos(int ts0) {
    final pos = (ts0 / 1000 - this.beginTime) / this.step;
    return pos.floor();
  }

  String tsTag(int ts0, int index) {
    DateTime ts =
        DateTime.fromMillisecondsSinceEpoch(this.ts0(ts0, index) * 1000);
    final ret = DateFormat("M-d").format(ts);
    return ret;
  }

  int ts0(int ts0, int index) {
    var ret = ts0;
    if (ts0 == 0) {
      ret = this.beginTime + this.step * index;
    }
    return ret;
  }
}
