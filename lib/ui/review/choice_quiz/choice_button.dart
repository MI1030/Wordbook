import 'dart:io';
import 'package:flutter/material.dart';

import '../../styles/screen.dart';

class ChoiceButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final bool isRight;
  final bool isWrong;
  final Function onPressed;

  const ChoiceButton(
      {this.text,
      this.textColor,
      this.isRight,
      this.isWrong,
      this.onPressed,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Screen.instance.marginMedium),
      child: Stack(
        children: <Widget>[
          Positioned(
            child: _buildButton(_buildText()),
          ),
          Positioned(
            right: 40.0 * Screen.instance.scale,
            top: 10 * Screen.instance.scale,
            child: _buildMark(),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(child) {
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: Colors.white, //Colors.blueGrey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.symmetric(vertical: Screen.instance.marginMedium),
      elevation: 2.0,
      child: child,
      onPressed: onPressed,
    );
  }

  _buildText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 30 * Screen.instance.scale),
            child: Text(
              text.replaceAll('\n', ' '),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: textColor,
                fontSize: Screen.instance.fontSizeBody,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMark() {
    if (isRight) {
      return Image.asset(
        'assets/images/correct.png',
        height: Screen.instance.iconLarge,
      );
    } else if (isWrong) {
      return Image.asset(
        'assets/images/wrong.png',
        height: Screen.instance.iconLarge,
      );
    } else {
      return Container();
    }
  }

  Widget _buildMark1() {
    if (isRight) {
      return Icon(
        Icons.check,
        color: Colors.red,
        size: Screen.instance.iconXLarge,
      );
    } else if (isWrong) {
      return Icon(
        Icons.close,
        color: Colors.red,
        size: Screen.instance.iconXLarge,
      );
    } else {
      return Container();
    }
  }
}
