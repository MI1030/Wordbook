import 'package:flutter/material.dart';

import '../../models/kr.dart';
import './sample_row.dart';

class MySampleRow extends StatelessWidget {
  final Kr kr;

  MySampleRow(this.kr);

  @override
  Widget build(BuildContext context) {
    final samples = kr == null ? '' : kr.samples;
    List<Widget> children = [];

    if (samples.length > 0) {
      final splitSample = samples.split('\n');
      splitSample.forEach((s) {
        final asample = s.trim();
        children.add(SampleRow(asample: asample));
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
