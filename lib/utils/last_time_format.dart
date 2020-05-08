import 'dart:math';

import '../biz/standart_time.dart';

class LastTimeFormat {
  static String lastLearnTime(int ts, bool learned) {
    var ret = '';
    if (learned) {
      ret += '刚学过';
    } else if (ts > 0) {
      final t = (max(StandardTime.instance.now - ts, 0) / 1000).floor();
      if (t == 0) {
        ret += '刚学过';
      } else {
        final days = (t / (24 * 3600)).floor();
        final hours = ((t / 3600) % 24).floor();
        final mins = ((t / 60) % 60).floor();
        final secs = t % 60;
        if (days > 0) {
          ret += '$days天';
        } else {
          if (hours > 0) {
            ret += '$hours小时';
          } else if (mins > 0) {
            ret += '$mins分钟';
          } else {
            ret += '$secs秒';
          }
        }
        ret += '前';
      }
    }
    return ret;
  }
}
