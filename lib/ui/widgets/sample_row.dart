import 'package:flutter/material.dart';

import '../../utils/er_tts.dart';
import '../../utils/string_has_chinese.dart';
import '../../utils/voice_path.dart';
import '../../utils/voice_speaker.dart';
import '../../utils/word_voice_sync.dart';
import '../styles/screen.dart';

class SampleRow extends StatelessWidget {
  final String asample;
  final Color color;
  final double fontSize;

  SampleRow({
    this.asample,
    this.fontSize,
    this.color = const Color(0xFF000099),
  });

  @override
  Widget build(BuildContext context) {
    String trimmed = asample.trim();
    int chineseIndex = trimmed.indexOf(StringHasChinese.chineseRegExp);
    String english;
    String chinese;
    if (trimmed.length > 0) {
      if (chineseIndex == -1) {
        english = trimmed;
      } else if (chineseIndex < 2) {
        chinese = trimmed;
      } else {
        english = trimmed.substring(0, chineseIndex);
        if (chineseIndex < trimmed.length - 1) {
          chinese = trimmed.substring(chineseIndex);
        }
      }
    }

    return RawMaterialButton(
      constraints: BoxConstraints(minWidth: 0, minHeight: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text.rich(
        TextSpan(
          text: '',
          children: [
            if (english != null)
              TextSpan(
                text: english,
                style: TextStyle(
                    fontSize: fontSize ?? Screen.instance.fontSizeTitle3,
                    color: color),
              ),
            if (chinese != null)
              TextSpan(
                text: chinese,
                style: TextStyle(
                    fontSize: Screen.instance.fontSizeBody,
                    color: Color(0xFF666666)),
              ),
            if (english != null)
              WidgetSpan(
                child: Image.asset(
                  'assets/icons/speaker.png',
                  //width: Screen.instance.iconSmall,
                  height: Screen.instance.iconSmall,
                ),
              ),
          ],
        ),
        textAlign: TextAlign.left,
      ),
      onPressed: () async {
        if (english != null) {
          final voiceExists =
              await VoicePath(english, VoiceType.sentence).exists();
          if (!voiceExists) {
            bool downloadSuccess =
                await WordVoiceSync().download(english, VoiceType.sentence);
            if (!downloadSuccess) {
              ErTTS.instance.speak(english);
            } else {
              VoiceSpeaker.instance.speak(english, VoiceType.sentence);
            }
          } else {
            VoiceSpeaker.instance.speak(english, VoiceType.sentence);
          }
        }
      },
    );
  }
}
