import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../models/kbase.dart';
import '../models/kr.dart';
import '../repository/mem_db.dart';
import '../models/mem.dart';

class KbaseCounts {
  final String code;
  final int total;
  final int review;
  KbaseCounts({
    @required this.code,
    @required this.total,
    @required this.review,
  });
}

class MemBloc extends BlocBase {
  // Inputs
  remember(String v) => _rememberController.sink.add(v);
  fetchMem(String v) => _fetchMemController.sink.add(v);

  // Outputs
  ValueObservable<Mem> get mem => _memController;
  ValueObservable<Kr> get kr => _krController;

  // private
  final _rememberController = StreamController<String>();
  final _fetchMemController = StreamController<String>();

  final _memController = BehaviorSubject<Mem>();
  final _krController = BehaviorSubject<Kr>();

  MemBloc() {
    _rememberController.stream.listen((String question) async {
      String krid = await MemDb.instance.krs().remember(question);
      await MemDb.instance.mems().remember(krid: krid, kbaseId: Kbase.word.iid);
      _fetchMemController.sink.add(question);
    });

    _fetchMemController.stream.listen((String question) async {
      if (question == null) {
        _memController.sink.add(null);
      } else {
        Mem mem;
        Kr kr;
        var krs = await MemDb.instance.krs().krsOfQuestion(question);
        for (int i = 0; i < krs.length; i++) {
          Kr akr = krs[i];
          mem = await MemDb.instance.mems().memOfKrid(akr.mid);
          if (mem != null) {
            kr = akr;
            break;
          }
        }

        _memController.sink.add(mem);
        _krController.sink.add(kr);
      }
    });
  }

  dispose() {
    _rememberController.close();
    _fetchMemController.close();
    _memController.close();
    _krController.close();
    super.dispose();
  }
}
