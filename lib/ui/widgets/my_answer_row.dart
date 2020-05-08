import 'package:flutter/material.dart';

import '../../models/kr.dart';

class MyAnswerRow extends StatelessWidget {
  final Kr kr;

  MyAnswerRow(this.kr);

  @override
  Widget build(BuildContext context) {
    final answer = kr == null ? '' : kr.answer;

    return Text(
      answer,
      style: TextStyle(
        fontSize: 18,
        color: Color(0xFF880000),
      ),
    );
  }
}
