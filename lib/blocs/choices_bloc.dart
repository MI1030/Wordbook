import 'dart:async';
import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

import '../ui/styles/screen.dart';
import '../repository/choices_generator.dart';
import '../models/kr.dart';

class ChoiceMadeParams {
  final int right;
  final int selected;
  ChoiceMadeParams(this.right, this.selected);
}

class ChoicesBloc extends BlocBase {
  // Inputs
  selectChoice(int v) => _selectChoiceController.sink.add(v);
  prepareChoices(Kr v) => _prepareChoicesController.sink.add(v);
  prepareReverseChoices(Kr v) => _prepareReverseChoicesController.sink.add(v);

  // Outputs
  ValueObservable<List<String>> get choices => _choicesController;
  ValueObservable<ChoiceMadeParams> get choiceMade => _choiceMadeController;

  // private
  final _prepareChoicesController = StreamController<Kr>();
  final _prepareReverseChoicesController = StreamController<Kr>();
  final _selectChoiceController = StreamController<int>();
  final _choicesController = BehaviorSubject<List<String>>();
  final _choiceMadeController = BehaviorSubject<ChoiceMadeParams>();

  int _rightChoiceIndex = -1;
  int _choiceCount;

  ChoicesBloc() {
    _choiceCount = Screen.instance.isSmallScreen() ? 3 : 4;

    _prepareChoicesController.stream.listen((Kr akr) async {
      _prepareChoices(akr);
    });

    _prepareReverseChoicesController.stream.listen((Kr akr) async {
      _prepareReverseChoices(akr);
    });

    _selectChoiceController.stream.listen((v) async {
      _choiceMadeController.sink.add(ChoiceMadeParams(_rightChoiceIndex, v));
    });
  }

  _prepareChoices(Kr akr) async {
    await ChoicesGenerator.instance.loadWords();
    final choices = await ChoicesGenerator.instance
        .choices(word: akr.question, count: _choiceCount - 1);

    _rightChoiceIndex = Random().nextInt(_choiceCount);
    if (_rightChoiceIndex >= choices.length) {
      choices.add(akr.answer);
    } else {
      choices.insert(_rightChoiceIndex, akr.answer);
    }
    _choiceMadeController.sink.add(null);
    _choicesController.sink.add(choices);
  }

  _prepareReverseChoices(Kr akr) async {
    await ChoicesGenerator.instance.loadWords();
    final choices = await ChoicesGenerator.instance
        .reverseChoices(word: akr.question, count: _choiceCount - 1);

    _rightChoiceIndex = Random().nextInt(_choiceCount);
    if (_rightChoiceIndex >= choices.length) {
      choices.add(akr.question);
    } else {
      choices.insert(_rightChoiceIndex, akr.question);
    }
    _choiceMadeController.sink.add(null);
    _choicesController.sink.add(choices);
  }

  @override
  void dispose() {
    _prepareChoicesController.close();
    _prepareReverseChoicesController.close();
    _selectChoiceController.close();
    _choicesController.close();
    _choiceMadeController.close();
    super.dispose();
  }
}
