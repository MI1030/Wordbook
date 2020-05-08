import 'package:flutter/material.dart';

import '../../localizations.dart';
import '../../models/dict_item.dart';
import 'sample_row.dart';
import '../styles/screen.dart';

class DictContent extends StatelessWidget {
  final DictItem dictItem;
  final bool showChineseDefinition;

  DictContent({this.dictItem, this.showChineseDefinition});

  @override
  Widget build(BuildContext context) {
    if (dictItem.answer.length > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (showChineseDefinition == null || showChineseDefinition)
            buildChineseDefinition(dictItem, context),
          //buildTense(dictItem, context),
          SizedBox(
            height: Screen.instance.marginMedium,
          ),
          buildSamples(dictItem, context),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildChineseDefinition(DictItem item, BuildContext context) {
    if (item.answer.length > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            MemofLocalizations.of(context).chineseDefinition,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Screen.instance.fontSizeBody),
          ),
          SizedBox(
            height: Screen.instance.marginSmall,
          ),
          Text(
            item.answer.trim(),
            style: TextStyle(fontSize: Screen.instance.fontSizeBody),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildTense(DictItem item, BuildContext context) {
    if (item.exchange.length > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            MemofLocalizations.of(context).tense,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Screen.instance.fontSizeBody),
          ),
          Text(
            item.exchange,
            style: TextStyle(fontSize: Screen.instance.fontSizeBody),
          ),
          SizedBox(
            height: 10 * Screen.instance.scale,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildSamples(DictItem item, BuildContext context) {
    if (item.samples.length > 0) {
      List<Widget> sv = [];
      sv.add(Text(
        MemofLocalizations.of(context).exampleSentences,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Screen.instance.fontSizeBody),
      ));

      sv.add(SizedBox(
        height: Screen.instance.marginSmall,
      ));

      sv.addAll(item.samples.map((asample) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SampleRow(
              asample: asample.x,
              fontSize: Screen.instance.fontSizeBody,
              color: Colors.black,
            ),
            SizedBox(
              height: 4 * Screen.instance.scale,
            ),
            Text(
              asample.trans,
              style: TextStyle(
                  fontSize: Screen.instance.fontSizeCaption,
                  color: Color(0xff888888)),
            ),
            SizedBox(
              height: Screen.instance.marginSmall,
            ),
          ],
        );
      }));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sv,
      );
    } else {
      return Container();
    }
  }
}
