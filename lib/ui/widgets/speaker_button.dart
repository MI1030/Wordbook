import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../styles/screen.dart';

class SpeakerButton extends StatelessWidget {
  final Function onPress;
  const SpeakerButton({@required this.onPress, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildRawButton();
  }

  _buildSpeakerIcon2() {
    return SvgPicture.asset(
      'assets/icons/speaker2.svg',
      height: this.iconSize,
      color: Color(0xFF06008E),
    );
  }

  double get iconSize => 40;

  _buildRawButton() {
    return RawMaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      padding: EdgeInsets.only(
          left: 0,
          right: Screen.instance.marginSmall,
          top: Screen.instance.marginMedium,
          bottom: Screen.instance.marginMedium),
      constraints: BoxConstraints(minHeight: 0, minWidth: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: _buildSpeakerIcon2(),
      onPressed: this.onPress,
    );
  }
}
