import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import './mem_bloc.dart';
import './memstat_bloc.dart';
import './review_tile_bloc.dart';

import '../repository/mem_db.dart';

import '../biz/app_pref.dart';
import '../utils/er_log.dart';

class AppBloc extends BlocBase {
  ReviewTileBloc get reviewTileBloc => _reviewTileBloc;
  MemBloc get memBloc => _memBloc;
  MemstatBloc get memstatBloc => _memstatBloc;

  // Inputs
  updateHomePageData() => _updateMemsCountController.sink.add(null);

  // Outputs
  ValueObservable<String> get appVersion => _appVersionController;
  ValueObservable<bool> get memDbReady => _memDbReadyController;

  // private
  final _updateMemsCountController = StreamController();
  final _appVersionController = BehaviorSubject<String>();
  final _memDbReadyController = BehaviorSubject<bool>();

  ReviewTileBloc _reviewTileBloc;
  MemBloc _memBloc;
  MemstatBloc _memstatBloc;

  AppBloc() {
    _init();
  }

  _init() async {
    _initBlocs();
    await _loadAppVersion();
    await _loadDb();
    _initListeners();
  }

  void _initBlocs() {
    _reviewTileBloc = ReviewTileBloc();
    _memBloc = MemBloc();
    _memstatBloc = MemstatBloc();
  }

  _initListeners() {
    _updateMemsCountController.stream.listen((_) {
      _updateHomePageData();
    });
  }

  _updateHomePageData() {
    _memstatBloc.update();
    _reviewTileBloc.updateCount();
    _memDbReadyController.sink.add(true);
  }

  Future<void> _loadAppVersion() async {
    var ver = await AppPref.version;
    _appVersionController.sink.add(ver);
  }

  Future<void> _loadDb() async {
    await MemDb.instance.load();
    _memDbReadyController.sink.add(true);
    _updateHomePageData();
  }

  @override
  void dispose() {
    _updateMemsCountController.close();
    _appVersionController.close();
    _memDbReadyController.close();
    super.dispose();
  }
}
