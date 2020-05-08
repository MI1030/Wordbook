import 'dart:math';
import 'package:flutter/material.dart';

import '../../utils/er_log.dart';

class Screen {
  final double screenWidth;
  final double screenHeight;
  final double contentHeight;
  final double scale;
  static Screen instance;

  Screen({this.screenWidth, this.screenHeight, this.contentHeight, this.scale});

  double get fontSizeTitle1 => (28 * scale).floor().toDouble();
  double get fontSizeTitle2 => (24 * scale).floor().toDouble();
  double get fontSizeTitle3 => (20 * scale).floor().toDouble();
  double get fontSizeBody => (18 * scale).floor().toDouble();
  double get fontSizeButton => (18 * scale).floor().toDouble();
  double get fontSizeCaption => (16 * scale).floor().toDouble();
  double get fontSizeFootnote => max(11, (12 * scale).floor().toDouble());

  double get iconSmall => 16;
  double get iconMedium => (24 * scale).floor().toDouble();
  double get iconLarge => (32 * scale).floor().toDouble();
  double get iconXLarge => (48 * scale).floor().toDouble();
  double get iconXXLarge => (64 * scale).floor().toDouble();

  double get pageHmargin => (16 * scale).floor().toDouble();

  double get marginxSmall => (4 * scale).ceil().toDouble();
  double get marginSmall => (8 * scale).floor().toDouble();
  double get marginMedium => (16 * scale).floor().toDouble();
  double get marginLarge => (24 * scale).floor().toDouble();
  double get marginXLarge => (32 * scale).floor().toDouble();

  static buildInstance(BuildContext context) {
    if (Screen.instance == null) {
      Size screenSize = MediaQuery.of(context).size;
      double contentHeight = screenSize.height - topBarHeight(context);
      Screen.instance = Screen(
          screenWidth: screenSize.width,
          screenHeight: screenSize.height,
          contentHeight: contentHeight,
          scale: calcScale(screenSize));
      ErLog.withTs('screen: $screenSize, content height: $contentHeight');
    }
  }

  bool isSmallScreen() {
    return screenWidth < 341 || contentHeight < 540;
  }

  bool isBigScreen() {
    return screenWidth > 600;
  }

  static double topBarHeight(BuildContext context) {
    EdgeInsets edge = MediaQuery.of(context).padding;
    double paddingTop = edge.top;
    AppBar appBar = AppBar(
      elevation: 0.0,
      title: Text('Demo'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.access_alarm),
          onPressed: () {},
        )
      ],
    );
    double height = appBar.preferredSize.height + paddingTop;
    return height;
  }

  static double calcScale(Size screenSize) {
    double width = screenSize.width;
    double ret;
    if (width < 346) {
      ret = 0.8;
    } else if (width < 376) {
      ret = 0.9;
    } else if (width < 415) {
      ret = 1.0;
    } else {
      ret = 1.2;
    }
    return ret;
  }
}
