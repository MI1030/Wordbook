import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

import '../biz/global_settings.dart';
import '../models/dict_item.dart';
import '../repository/dict_db.dart';
import '../biz/mem_const.dart';
import '../models/mem.dart';
import '../models/kr.dart';
import '../repository/mem_db.dart';
import '../utils/stopwatch.dart';
import './review_controller.dart';
import '../models/kbase.dart';
import '../biz/quiz_type.dart';
import '../utils/voice_path.dart';
import '../utils/word_voice_sync.dart';
import '../repository/prefs/review_count_per_turn_pref.dart';

class FamiliarityParams {
  final int kbaseId;
  final int ts;
  final bool learned;
  final double progress;
  FamiliarityParams({this.kbaseId, this.ts, this.learned, this.progress});
}

class FinishedParams {
  final bool finished;
  final bool hasMore;
  final List<Kr> savedKrs;
  FinishedParams({this.hasMore, this.finished, this.savedKrs});
}

class ReviewBloc extends BlocBase {
  // Inputs
  startLoad() => _startLoadController.sink.add(null);
  startShowAnswer() => _startShowAnswerController.sink.add(null);
  passIt() => _passItController.sink.add(null);
  failIt() => _failItController.sink.add(null);
  ignoreIt() => _ignoreItController.sink.add(null);
  refreshKr() => _refreshKrController.sink.add(null);
  next() => _nextController.sink.add(null);
  setAnswered(bool v) => _setAnsweredController.sink.add(v);
  stop() => _stop();
  setShowKrStatus(bool v) => _setShowKrStatusController.sink.add(v);
  setShowKrDetail(bool v) => _setShowKrDetailController.sink.add(v);

  // Outputs
  ValueObservable<int> get total => _totalController;
  ValueObservable<int> get index => _indexController;
  ValueObservable<Mem> get mem => _memController;
  ValueObservable<Kr> get kr => _krController;
  ValueObservable<Kr> get updateKr => _updateKrController;
  ValueObservable<bool> get isAnswerShown => _isAnswerShownController;
  ValueObservable<FamiliarityParams> get familiarity => _familiarityController;
  ValueObservable<FinishedParams> get finished => _finishedController;
  ValueObservable<QuizType> get quizType => _quizTypeController;
  ValueObservable<bool> get isAnswerRight => _isAnswerRightController;
  ValueObservable<DictItem> get dictItem => _dictItemController;
  ValueObservable<String> get answer => _answerController;
  ValueObservable<String> get myAnswer => _myAnswerController;
  ValueObservable<String> get mySamples => _mySamplesController;
  ValueObservable<bool> get showKrStatus => _showKrStatusController;
  ValueObservable<bool> get showKrDetail => _showKrDetailController;
  ValueObservable<bool> get shouldAutoSpeak => _shouldAutoSpeakController;

  // private
  final _startLoadController = StreamController();
  final _startShowAnswerController = StreamController();
  final _passItController = StreamController();
  final _failItController = StreamController();
  final _ignoreItController = StreamController();
  final _refreshKrController = StreamController();
  final _setAnsweredController = StreamController<bool>();
  final _nextController = StreamController();
  final _setShowKrStatusController = StreamController<bool>();
  final _setShowKrDetailController = StreamController<bool>();

  final _memController = BehaviorSubject<Mem>();
  final _krController = BehaviorSubject<Kr>();
  final _updateKrController = BehaviorSubject<Kr>();
  final _totalController = BehaviorSubject<int>();
  final _indexController = BehaviorSubject<int>();
  final _isAnswerShownController = BehaviorSubject<bool>();
  final _familiarityController = BehaviorSubject<FamiliarityParams>();
  final _finishedController = BehaviorSubject<FinishedParams>();
  final _quizTypeController = BehaviorSubject<QuizType>();
  final _isAnswerRightController = BehaviorSubject<bool>();
  final _dictItemController = BehaviorSubject<DictItem>();
  final _answerController = BehaviorSubject<String>();
  final _myAnswerController = BehaviorSubject<String>();
  final _mySamplesController = BehaviorSubject<String>();
  final _showKrStatusController = BehaviorSubject<bool>();
  final _showKrDetailController = BehaviorSubject<bool>();
  final _shouldAutoSpeakController = BehaviorSubject<bool>();

  ReviewController _biz = ReviewController();
  Stopwatch _stopwatch = Stopwatch();
  final int kbaseId;
  static const bits = 5;
  List<Kr> _savedKrs = [];

  ReviewBloc([this.kbaseId]) {
    _initPrefs();
    _initControllers();
  }

  _initPrefs() async {
    bool show = await GlobalSettings.getBool(
        GlobalSettings.KeyShowKrStatusOnReview, false);
    _showKrStatusController.sink.add(show);
  }

  _initControllers() {
    _setShowKrDetailController.stream.listen((bool v) async {
      _showKrDetailController.sink.add(v);
    });

    _setShowKrStatusController.stream.listen((bool v) async {
      await GlobalSettings.setBool(GlobalSettings.KeyShowKrStatusOnReview, v);
      _showKrStatusController.sink.add(v);
    });

    _nextController.stream.listen((_) async {
      _goNext();
    });

    _refreshKrController.stream.listen((_) async {
      _refreshKr();
    });

    _startLoadController.stream.listen((_) async {
      _startLoad();
    });

    _startShowAnswerController.stream.listen((_) {
      _isAnswerShownController.sink.add(true);
    });

    _passItController.stream.listen((_) async {
      _addSavedKr();
      await _biz.passIt(_stopwatch.stop());
    });

    _failItController.stream.listen((_) async {
      _addSavedKr();
      await _biz.failIt(_stopwatch.stop());
    });

    _ignoreItController.stream.listen((_) async {
      _addSavedKr();
      await _biz.ignoreIt(_stopwatch.stop());
      _goNext();
    });

    _setAnsweredController.stream.listen((bool v) async {
      _isAnswerRightController.sink.add(v);
    });
  }

  Future<bool> _stop() async {
    if (_isAnswerRightController.value != null) {
      if (_isAnswerRightController.value) {
        await _biz.passIt(_stopwatch.stop());
      } else {
        await _biz.failIt(_stopwatch.stop());
      }
      _addSavedKr();
    }

    if (_savedKrs.length > 0) {
      int count = await MemDb.instance.mems().reviewCount(kbaseId);
      bool hasMore = count > 0;
      _finishedController.sink.add(FinishedParams(
          finished: true, hasMore: hasMore, savedKrs: _savedKrs));
      return true;
    } else {
      return false;
    }
  }

  _addSavedKr() {
    Kr akr = _krController.value;
    if (akr != null) {
      if (_savedKrs.indexWhere((Kr tKr) => akr.mid == tKr.mid) < 0) {
        if (akr.answer.length == 0) {
          DictItem dictItem = _dictItemController.value;
          akr.answer = dictItem?.answer ?? '';
        }
        _savedKrs.add(akr);
      }
    }
  }

  _startLoad() async {
    int sessionCount = await ReviewCountPerTurnOptions.currentValue();
    int total = await MemDb.instance.mems().reviewCount(kbaseId);
    int count = sessionCount;
    if (total < sessionCount + bits) {
      count = null;
    }

    ReviewOrder order = await _reviewOrder();
    var mems = await MemDb.instance
        .mems()
        .memsOfReview(order: order, kbaseId: kbaseId, count: count);

    _biz.start(mems);
    _totalController.sink.add(_biz.total);
    _goNext();
  }

  Future<ReviewOrder> _reviewOrder() async {
    var prefs = await MemDb.instance.prefs().all();
    int index = prefs.reviewOrder;
    return ReviewOrder.values[index];
  }

  _refreshKr() async {
    Mem amem = await _biz.refreshMem();
    Kr oldKr = _krController.value;
    Kr akr = await MemDb.instance.krs().krOfObjectId(amem.krid);
    if (oldKr.question != akr.question || oldKr.kbase != akr.kbase) {
      _krController.sink.add(akr);
      _updateKrController.sink.add(akr);
      _memController.sink.add(amem);
      _fetchDictItem(akr);
      _updateQtype(amem, akr);
      _updateFamiliarity(amem);
      _showKrDetailController.sink.add(false);
      _isAnswerRightController.sink.add(null);
      _resetAnswerShown(amem);
    } else {
      if (akr.answer != oldKr.answer) {
        _krController.sink.add(akr);
        _updateAnswer(akr, _dictItemController.value);
      }
      if (akr.samples != oldKr.samples) {
        _krController.sink.add(akr);
        _updateMySamples(akr);
      }
    }
  }

  _updateAnswer(Kr akr, DictItem dictItem) {
    String answer = akr?.answer ?? '';
    _myAnswerController.sink.add(answer.trim());

    String rightAnswer = answer.trim();
    _myAnswerController.sink.add(rightAnswer);

    if (rightAnswer.length == 0) {
      rightAnswer = dictItem?.answer;
    }
    _answerController.sink.add(rightAnswer);
  }

  _updateMySamples(Kr akr) {
    var samples = akr?.samples ?? '';
    _mySamplesController.sink.add(samples.trim());
  }

  _fetchDictItem(Kr akr) async {
    DictItem dictItem;
    if (akr != null) {
      if (akr.kbase == Kbase.word.iid) {
        dictItem = await EcDict.instance.lookup(akr.question);
      }
    }
    _dictItemController.sink.add(dictItem);

    _updateMySamples(akr);
    _updateAnswer(akr, dictItem);
  }

  _goNext() async {
    if (_biz.hasMore()) {
      _showKrDetailController.sink.add(false);

      Mem amem = _biz.next();
      _memController.sink.add(amem);

      Kr akr = await MemDb.instance.krs().krOfObjectId(amem.krid);
      _updateQtype(amem, akr);
      _prepareVoice(akr);
      _fetchDictItem(akr);
      _krController.sink.add(akr);
      _updateKrController.sink.add(akr);
      _indexController.sink.add(_biz.index + 1);
      _isAnswerRightController.sink.add(null);
      _resetAnswerShown(amem);
      _updateFamiliarity(amem);
      _stopwatch.start();

      if (_biz.isLastOne()) {
        _tryLoadMore(amem);
      }
    } else {
      int count = await MemDb.instance.mems().reviewCount(kbaseId);
      bool hasMore = count > 0;
      _finishedController.sink.add(FinishedParams(
          finished: true, hasMore: hasMore, savedKrs: _savedKrs));
    }
  }

  _resetAnswerShown(Mem amem) {
    _isAnswerShownController.sink.add(false);
  }

  _prepareVoice(Kr akr) async {
    if (akr != null) {
      VoiceType voiceType = VoicePath.kbaseToVoiceType(akr.kbase);
      final voiceExists = await VoicePath(akr.question, voiceType).exists();
      if (!voiceExists) {
        WordVoiceSync().download(akr.question, voiceType);
      }
    }
  }

  _tryLoadMore(Mem theMem) async {
    int total = await MemDb.instance.mems().reviewCount(kbaseId);
    if (total < bits) {
      ReviewOrder order = await _reviewOrder();
      var mems = await MemDb.instance
          .mems()
          .memsOfReview(order: order, kbaseId: kbaseId);
      mems.removeWhere((Mem amem) {
        return amem.mid == theMem.mid;
      });
      _biz.addMems(mems);
      _totalController.sink.add(_biz.total);
    }
  }

  _updateFamiliarity(Mem amem) {
    _familiarityController.sink.add(FamiliarityParams(
      kbaseId: amem.kbase,
      ts: amem.ts,
      learned: _biz.itemLearned(0),
      progress: amem.level / MemConst.MAX_STUDY_LEVEL,
    ));
  }

  _updateQtype(Mem amem, Kr kr) async {
    bool autospeak = false;
    QuizType qtype = QuizType.Normal;
    if (kr == null) {
      autospeak = false;
      qtype = QuizType.Error;
    } else {
      if (amem.kbase == Kbase.word.iid) {
        qtype = Kbase.qtype(level: amem.level, kbiid: amem.kbase);
        autospeak = true;
      } else {
        qtype = QuizType.Error;
      }
    }

    var prefs = await MemDb.instance.prefs().all();
    if (autospeak) {
      autospeak = prefs.autoSpeak;
    }

    _quizTypeController.sink.add(qtype);
    _shouldAutoSpeakController.sink.add(autospeak);
  }

  @override
  void dispose() {
    _nextController.close();
    _refreshKrController.close();
    _startLoadController.close();
    _startShowAnswerController.close();
    _passItController.close();
    _failItController.close();
    _ignoreItController.close();
    _setAnsweredController.close();

    _memController.close();
    _totalController.close();
    _indexController.close();
    _isAnswerShownController.close();
    _familiarityController.close();
    _finishedController.close();
    _quizTypeController.close();
    _isAnswerRightController.close();
    _krController.close();
    _updateKrController.close();
    _dictItemController.close();
    _answerController.close();
    _myAnswerController.close();
    _mySamplesController.close();
    _showKrStatusController.close();
    _setShowKrStatusController.close();
    _setShowKrDetailController.close();
    _showKrDetailController.close();
    _shouldAutoSpeakController.close();
    super.dispose();
  }
}
