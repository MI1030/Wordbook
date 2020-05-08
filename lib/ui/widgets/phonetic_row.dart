import 'package:flutter/material.dart';

import '../../models/kr.dart';
import '../../utils/voice_path.dart';
import '../../utils/voice_speaker.dart';
import '../styles/screen.dart';
import 'speaker_button.dart';

class PhoneticRow extends StatelessWidget {
  final String phonetic;
  final Kr kr;

  PhoneticRow(this.phonetic, this.kr);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SpeakerButton(
          onPress: () {
            VoiceSpeaker.instance
                .speak(kr.question, VoicePath.kbaseToVoiceType(kr.kbase));
          },
        ),
        Expanded(
          child: Text(
            (phonetic == null || phonetic.length == 0) ? '' : '[ $phonetic ]',
            style: TextStyle(
              fontSize: Screen.instance.fontSizeCaption,
              color: Color(0xff888888),
            ),
          ),
        ),
      ],
    );
  }
}
