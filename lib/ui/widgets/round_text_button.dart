import 'dart:io' show Platform;
import 'package:flutter/material.dart';

class RoundTextButton extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Color bgColor;
  final double size;
  final VoidCallback onPressed;

  RoundTextButton.large({
    this.title,
    this.titleColor,
    this.bgColor,
    this.onPressed,
  }) : size = 80.0;

  RoundTextButton.small({
    this.title,
    this.titleColor,
    this.bgColor,
    this.onPressed,
  }) : size = 60.0;

  RoundTextButton({
    this.title,
    this.titleColor,
    this.bgColor,
    this.size,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor ?? Color(0xffbbbbbb),
          boxShadow: [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 10.0,
              offset: Offset(0.0, 3.0),
            ),
          ]),
      child: RawMaterialButton(
        shape: CircleBorder(),
        elevation: 0.0,
        child: Text(
          title,
          style: TextStyle(
            color: titleColor ?? Colors.white,
            fontSize: 12,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
