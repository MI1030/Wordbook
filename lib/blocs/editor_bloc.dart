import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../utils/er_log.dart';
import '../repository/mem_db.dart';
import '../models/mem.dart';
import '../models/kr.dart';
import '../models/kbase.dart';

class SaveParams {
  final String question;
  final String answer;
  final String samples;
  final int kbase;

  SaveParams({this.question, this.answer, this.samples, this.kbase});
}

class KbaseData {
  final int kbaseId;
  final String questionTitle;
  final String answerTitle;
  final String samplesTitle;
  final int questionLines;
  final int answerLines;
  final int samplesLines;
  KbaseData(
      {this.kbaseId,
      this.questionLines,
      this.answerLines,
      this.answerTitle,
      this.questionTitle,
      this.samplesLines,
      this.samplesTitle});
}

class EditorBloc extends BlocBase {
  // Inputs
  save(SaveParams v) async {
    await _save(v);
  }

  createNew() => _createNewController.sink.add(null);
  setKbase(int kbaseId) => _kbaseController.sink.add(kbaseId);

  // Outputs
  ValueObservable<bool> get saved => _savedController;
  ValueObservable<KbaseData> get kbase => _kbaseDataController;

  // private
  final _createNewController = StreamController();
  final _savedController = BehaviorSubject<bool>();
  final _questionTitleController = BehaviorSubject<String>();
  final _answerTitleController = BehaviorSubject<String>();
  final _samplesTitleController = BehaviorSubject<String>();
  final _kbaseController = BehaviorSubject<int>();
  final _kbaseDataController = BehaviorSubject<KbaseData>();

  Kr _kr;
  Mem _mem;

  EditorBloc({Mem mem, Kr kr}) {
    _mem = mem;
    _kr = kr;

    _createNewController.stream.listen((_) {
      _kr = null;
    });

    _kbaseController.stream.listen((int kbaseId) {
      Kbase kb = Kbase.kbaseOfIid(kbaseId);
      var data = KbaseData(
          kbaseId: kbaseId,
          questionTitle: kb.questionTitle,
          answerTitle: kb.answerTitle,
          samplesTitle: kb.samplesTitle,
          questionLines: kb.questionLines,
          answerLines: kb.answerLines,
          samplesLines: kb.samplesLines);
      _kbaseDataController.sink.add(data);
    });
  }

  _save(SaveParams data) async {
    String question = data.question.trim();
    String answer = data.answer.trim();
    String samples = data.samples.trim();
    int kbaseId = _kbaseController.value;
    ErLog.withTs('kbaseId: $kbaseId');
    String krid;
    if (_kr != null) {
      krid = _kr.mid;
      await MemDb.instance.krs().saveContent(
            mId: krid,
            question: question,
            answer: answer,
            samples: samples,
            kbaseId: kbaseId,
          );
      if (kbaseId != _kr.kbase) {
        await MemDb.instance
            .mems()
            .saveContent(kbaseId: kbaseId, mId: _mem.mid);
      }
    } else {
      krid = await MemDb.instance.krs().add(
            question: question,
            answer: answer,
            kbaseId: kbaseId,
            samples: samples,
          );
      String memId =
          await MemDb.instance.mems().remember(krid: krid, kbaseId: kbaseId);
      _mem = await MemDb.instance.mems().memOfObjectId(memId);
    }
    _kr = await MemDb.instance.krs().krOfObjectId(krid);
    _savedController.sink.add(true);
  }

  needSave(SaveParams data) {
    String question = data.question.trim();
    String answer = data.answer.trim();
    String samples = data.samples.trim();
    if (question.length > 0) {
      if (_kr != null) {
        return _kr.question != question ||
            _kr.answer != answer ||
            _kr.samples != samples ||
            _kr.kbase != _kbaseController.value;
      }
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _savedController.close();

    _createNewController.close();
    _questionTitleController.close();
    _answerTitleController.close();
    _samplesTitleController.close();
    _kbaseController.close();
    _kbaseDataController.close();
    super.dispose();
  }
}
