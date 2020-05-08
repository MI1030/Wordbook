import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import '../../styles/screen.dart';

class TitleWidget extends StatelessWidget {
  final bool reverse;
  const TitleWidget({@required this.reverse, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              top: Screen.instance.marginMedium,
              bottom: Screen.instance.marginMedium),
          child: Text(
            reverse ? '请选择正确的单词' : '请选择正确的解释',
            style: TextStyle(
                fontSize: Screen.instance.fontSizeTitle2,
                color: Color(0xff666666)),
          ),
        ),
      ],
    );
  }
}
