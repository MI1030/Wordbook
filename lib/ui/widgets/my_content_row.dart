import 'package:flutter/material.dart';

import '../../models/kr.dart';
import './sample_row.dart';
import '../styles/screen.dart';

class MyContentRow extends StatelessWidget {
  final Kr kr;

  MyContentRow(this.kr);

  @override
  Widget build(BuildContext context) {
    final samples = kr == null ? '' : kr.samples;
    final answer = kr == null ? '' : kr.answer;
    List<Widget> children = [];

    if (answer.length > 0) {
      children.add(Text(
        answer,
        style: TextStyle(
          fontSize: Screen.instance.fontSizeTitle3,
          color: Color(0xFF880000),
        ),
      ));
    }

    if (samples.length > 0) {
      if (answer.length > 0) {
        children.add(SizedBox(
          height: 5,
        ));
      }

      final splitSample = samples.split('\n');
      splitSample.forEach((s) {
        final asample = s.trim();
        children.add(SampleRow(asample: asample));
      });
    }

    if (children.length > 0) {
      children.add(SizedBox(
        height: Screen.instance.marginMedium,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
