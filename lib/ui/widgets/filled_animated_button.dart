import 'package:flutter/material.dart';
import '../../colors.dart';
import '../styles/layout_const.dart';
import '../styles/screen.dart';

class FilledAnimatedButton extends StatelessWidget {
  final Function onTap;
  final String title;
  final Color fillColor;
  final Widget child;
  final EdgeInsets padding;

  FilledAnimatedButton.primary(
      {this.title, this.onTap, this.child, this.padding})
      : fillColor = MemofColors.primary;

  FilledAnimatedButton.secondary(
      {this.title, this.onTap, this.child, this.padding})
      : fillColor = MemofColors.secondary;

  FilledAnimatedButton.accent(
      {this.title, this.onTap, this.child, this.padding})
      : fillColor = MemofColors.accent;

  static const textColor = Color(0xff000000);
  static Color primaryColor = MemofColors.primary;
  static Color secondaryColor = MemofColors.secondary;
  static Color disableColor = Color(0xffcccccc);
  static Color disableFillColor = Color(0xffeeeeee);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints(minHeight: 0, minWidth: 0),
      padding: this.padding ??
          EdgeInsets.symmetric(
              horizontal: 60 * Screen.instance.scale,
              vertical: LayoutConst.buttonTextVerticlePadding),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: this.onTap == null
          ? FilledAnimatedButton.disableFillColor
          : this.fillColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 2.0,
      child: this.child == null ? _buildTitle() : this.child,
      onPressed: this.onTap,
    );
  }

  Widget _buildTitle() {
    return Text(
      this.title,
      style: TextStyle(
        fontSize: Screen.instance.fontSizeButton,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
