import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

abstract class PrefItem {}

class PrefItemHeader implements PrefItem {}

class PrefItemSwitch implements PrefItem {
  final int index;
  final bool isOn;
  final String title;
  PrefItemSwitch(
      {@required this.index, @required this.title, @required this.isOn});
}

enum PrefCmd { rating, feedback }

class PrefItemCmd implements PrefItem {
  final PrefCmd cmd;
  final String title;
  PrefItemCmd({@required this.cmd, @required this.title});
}

class PrefItemInfo implements PrefItem {
  final String title;
  final String info;
  PrefItemInfo({@required this.title, @required this.info});
}

class PrefItemWithOptions implements PrefItem {
  final Type type;
  final String title;
  final List<OptionItem> options;
  OptionItem current;

  PrefItemWithOptions(
      {@required this.type, @required this.title, @required this.options});
}

class OptionItem {
  final String text;
  final int value;
  OptionItem({@required this.text, @required this.value});
}
