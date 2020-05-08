import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../repository/dict_db.dart';
import '../models/dict_item.dart';
import '../models/candidate.dart';
import '../utils/er_log.dart';
import '../utils/voice_path.dart';
import '../utils/word_voice_sync.dart';

class DictBloc extends BlocBase {
  // Inputs
  fetchCandidates(String v) => _fetchCandidatesController.sink.add(v);
  fetchKr(String v) => _krFetcherController.sink.add(v);

  // Outputs
  ValueObservable<DictItem> get kr => _krController;
  ValueObservable<List<Candidate>> get candidates => _candidatesController;
  ValueObservable<bool> get dbExists => _dbExistsController;
  ValueObservable<String> get textofSearching => _textOfSearchingController;

  // private
  final _krFetcherController = StreamController<String>();
  final _fetchCandidatesController = PublishSubject<String>();

  final _krController = BehaviorSubject<DictItem>();
  final _candidatesController = BehaviorSubject<List<Candidate>>();
  final _dbExistsController = BehaviorSubject<bool>();
  final _textOfSearchingController = BehaviorSubject<String>();

  DictBloc() {
    _tryLoadDict();

    _fetchCandidatesController.listen((String word) {
      _fetchCandidates(word);
    });

    _krFetcherController.stream.listen((String word) {
      _fetchKr(word);
    });
  }

  _fetchCandidates(String word) async {
    List<Candidate> rs = await EcDict.instance.wordList(word.trim(), 20);

    _candidatesController.sink.add(rs);
    _textOfSearchingController.sink.add(word);
  }

  _fetchKr(String word) async {
    if (word == null) {
      _krController.sink.add(null);
    } else {
      DictItem r = await EcDict.instance.lookup(word);
      if (r != null) {
        final voiceExists = await VoicePath(word, VoiceType.word).exists();
        if (!voiceExists) {
          WordVoiceSync().download(word, VoiceType.word);
        }
      }

      _krController.sink.add(r);
    }
  }

  _tryLoadDict() async {
    var exists = await EcDict.instance.exists();
    ErLog.withTs('dictionary db exists: $exists');
    if (!exists) {
      //_dbExistsController.sink.add(false);
      await EcDict.instance.prepare();
      //_dbExistsController.sink.add(true);
      EcDict.instance.load();
    } else {
      EcDict.instance.load();
    }
  }

  dispose() {
    _krController.close();
    _candidatesController.close();
    _krFetcherController.close();
    _fetchCandidatesController.close();
    _dbExistsController.close();
    _textOfSearchingController.close();
    super.dispose();
  }
}
