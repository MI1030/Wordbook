import 'package:flutter/material.dart';

import '../../models/kr.dart';
import '../../utils/voice_path.dart';
import '../../utils/voice_speaker.dart';
import 'speaker_button.dart';

class NoTextSpeaker extends StatelessWidget {
  final Kr kr;
  NoTextSpeaker(this.kr);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SpeakerButton(
          onPress: () {
            VoiceSpeaker.instance
                .speak(kr.question, VoicePath.kbaseToVoiceType(kr.kbase));
          },
        ),
      ],
    );
  }
}
