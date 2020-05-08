import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../repository/mem_db.dart';
import '../models/pref_item.dart';
import '../repository/prefs/review_count_per_turn_pref.dart';
import '../repository/prefs/review_order_pref.dart';

class SaveData {
  final OptionItem current;
  final int index;
  SaveData({this.current, this.index});
}

class PrefsPageBloc extends BlocBase {
  // Inputs
  save(SaveData v) => _saveController.sink.add(v);
  saveSwitch(PrefItemSwitch v) => _saveSwitchController.sink.add(v);

  // Outputs
  ValueObservable<List<PrefItem>> get items => _itemsController;

  // private properties
  final _itemsController = BehaviorSubject<List<PrefItem>>();
  final _saveController = StreamController<SaveData>();
  final _saveSwitchController = StreamController<PrefItemSwitch>();

  int _autoSpeakIndex;

  // constructor
  PrefsPageBloc() {
    _initListeners();
    _load();
  }

  // private methods
  _load() async {
    List<PrefItem> items = [];
    int switchIndex = 0;

    items.add(PrefItemHeader());

    var allPrefs = await MemDb.instance.prefs().all();
    items.add(_autoSpeakPref(switchIndex, allPrefs.autoSpeak));
    switchIndex++;

    items.add(PrefItemHeader());
    items.add(ReviewCountPerTurnOptions.prefItem(allPrefs.reviewCountPerTurn));
    items.add(ReviewOrderOptions.prefItem(allPrefs.reviewOrder));
    items.add(PrefItemHeader());
    _itemsController.sink.add(items);
  }

  PrefItem _autoSpeakPref(int index, bool isAutoSpeak) {
    _autoSpeakIndex = index;
    return PrefItemSwitch(index: index, title: '自动朗读', isOn: isAutoSpeak);
  }

  _initListeners() {
    _saveSwitchController.stream.listen((PrefItemSwitch v) async {
      if (v.index == _autoSpeakIndex) {
        await MemDb.instance.prefs().setAutoSpeak(v.isOn);
      }
    });

    _saveController.stream.listen((SaveData v) {
      PrefItemWithOptions item = items.value[v.index];
      item.current = v.current;
      _itemsController.sink.add(items.value);
      if (item.type == ReviewCountPerTurnOptions) {
        ReviewCountPerTurnOptions.save(v.current.value);
      } else if (item.type == ReviewOrderOptions) {
        ReviewOrderOptions.save(v.current.value);
      }
    });
  }

  // dispose
  @override
  void dispose() {
    _itemsController.close();
    _saveController.close();
    _saveSwitchController.close();
    super.dispose();
  }
}
