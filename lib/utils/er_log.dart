import 'package:flutter/foundation.dart';

class ErLog {
  static withTs(String msg) {
    if (kReleaseMode) {
    } else {
      print("${DateTime.now()} $msg");
    }
  }
}
