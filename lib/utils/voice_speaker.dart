import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import 'voice_path.dart';
import 'er_tts.dart';

class VoiceSpeaker {
  static VoiceSpeaker instance = VoiceSpeaker._();

  Future speak(String word, VoiceType voiceType) async {
    VoicePath wvp = VoicePath(word, voiceType);
    if (await wvp.exists()) {
      final filepath = await wvp.cachePathOfWord();
      _audioPlayer.play(filepath, isLocal: true);
    } else {
      ErTTS.instance.speak(word);
    }
  }

  VoiceSpeaker._();
  AudioPlayer _audioPlayer = AudioPlayer();
}
