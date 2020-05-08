import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

import '../repository/mem_db.dart';
import '../repository/dict_db.dart';
import '../models/dict_item.dart';
import '../models/mem.dart';
import '../models/kr.dart';
import '../utils/voice_path.dart';
import '../utils/word_voice_sync.dart';

class KrData {
  final Kr kr;
  final DictItem dictItem;
  final bool dataError;
  KrData({this.kr, this.dictItem, this.dataError});
}

class MemDetailBloc extends BlocBase {
  // Inputs
  fetchMem() => _fetchMemController.sink.add(null);
  goFirst() => _goFirstController.sink.add(null);
  goPrevious() => _goPreviousController.sink.add(null);
  goNext() => _goNextController.sink.add(null);
  goLast() => _goLastController.sink.add(null);

  // Outputs
  ValueObservable<KrData> get krData => _krDataController;
  ValueObservable<Mem> get mem => _memController;
  ValueObservable<String> get indexText => _indexTextController;

  // private
  final _fetchMemController = StreamController();
  final _goFirstController = StreamController();
  final _goPreviousController = StreamController();
  final _goNextController = StreamController();
  final _goLastController = StreamController();

  final _memController = BehaviorSubject<Mem>();
  final _krDataController = BehaviorSubject<KrData>();
  final _indexTextController = BehaviorSubject<String>();

  int _currentIndex = 0;

  MemDetailBloc(List<int> memIds, int index) {
    _currentIndex = index;

    _initControllers(memIds);
  }

  _initControllers(List<int> memIds) {
    _fetchMemController.stream.listen((_) {
      _fetchCurrent(memIds);
    });

    _goFirstController.stream.listen((_) {
      if (_currentIndex != 0) {
        _currentIndex = 0;
        _fetchCurrent(memIds);
      }
    });

    _goPreviousController.stream.listen((_) {
      if (_currentIndex > 0) {
        _currentIndex--;
        _fetchCurrent(memIds);
      }
    });

    _goNextController.stream.listen((_) {
      if (_currentIndex < memIds.length - 1) {
        _currentIndex++;
        _fetchCurrent(memIds);
      }
    });

    _goLastController.stream.listen((_) {
      if (_currentIndex < memIds.length - 1) {
        _currentIndex = memIds.length - 1;
        _fetchCurrent(memIds);
      }
    });
  }

  _fetchCurrent(List<int> memIds) async {
    Mem mem = await MemDb.instance.mems().memOfId(memIds[_currentIndex]);
    Kr kr = await MemDb.instance.krs().krOfObjectId(mem.krid);
    if (kr != null) {
      DictItem r = await EcDict.instance.lookup(kr.question);

      VoiceType voiceType = VoicePath.kbaseToVoiceType(kr.kbase);
      final voiceExists = await VoicePath(kr.question, voiceType).exists();
      if (!voiceExists) {
        WordVoiceSync().download(kr.question, voiceType);
      }

      _krDataController.sink.add(KrData(kr: kr, dictItem: r, dataError: false));
    } else {
      _krDataController.sink
          .add(KrData(kr: null, dictItem: null, dataError: true));
    }

    _memController.sink.add(mem);
    _indexTextController.sink.add('${_currentIndex + 1}/${memIds.length}');
  }

  @override
  void dispose() {
    _fetchMemController.close();
    _goFirstController.close();
    _goPreviousController.close();
    _goNextController.close();
    _goLastController.close();
    _memController.close();
    _krDataController.close();
    _indexTextController.close();
    super.dispose();
  }
}
