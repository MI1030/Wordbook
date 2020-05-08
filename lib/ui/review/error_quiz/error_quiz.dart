import 'package:flutter/material.dart';

import '../review_const.dart';
import '../../styles/screen.dart';
import '../../widgets/filled_animated_button.dart';

class ErrorQuiz extends StatelessWidget {
  const ErrorQuiz({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Oops, data error.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: Screen.instance.fontSizeTitle3),
          ),
          SizedBox(
            height: Screen.instance.marginSmall,
          ),
          Text(
            '无法复习此条目',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: Screen.instance.fontSizeTitle3),
          ),
          SizedBox(
            height: Screen.instance.marginXLarge,
          ),
          FilledAnimatedButton.primary(
            title: '删除',
            onTap: () {
              ReviewConst.reviewBloc.ignoreIt();
            },
          )
        ],
      ),
    );
  }
}
