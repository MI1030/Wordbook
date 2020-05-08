import 'package:flutter/material.dart';

class Stopwatch with WidgetsBindingObserver {
  void start() {
    WidgetsBinding.instance.addObserver(this);
    _time = DateTime.now();
    _sleep = 0;
  }

  int stop() {
    WidgetsBinding.instance.removeObserver(this);
    var elapsed = this.elapsed();
    this._duration += elapsed;
    return elapsed;
  }

  int elapsed() {
    if (_time != null) {
      return ((DateTime.now().millisecondsSinceEpoch -
                      _time.millisecondsSinceEpoch) /
                  1000)
              .ceil() -
          _sleep;
    } else {
      return 0;
    }
  }

  int duration() {
    return _duration + elapsed();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _onSuspend();
    } else if (state == AppLifecycleState.resumed) {
      _onResume();
    }
  }

  _onResume() {
    var suspendTime = _suspendTime;
    if (suspendTime != null) {
      _sleep += ((DateTime.now().millisecondsSinceEpoch -
                  suspendTime.millisecondsSinceEpoch) /
              1000)
          .ceil();
      _suspendTime = null;
    }
    //else cont.
  }

  _onSuspend() {
    _suspendTime = DateTime.now();
  }

  DateTime _time;
  int _sleep = 0;
  DateTime _suspendTime;
  int _duration = 0;
}
