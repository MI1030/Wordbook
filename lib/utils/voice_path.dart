import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import 'voice_filename.dart';
import '../models/kbase.dart';

enum VoiceType { word, sentence }

class VoicePath {
  final String word;
  final VoiceType voiceType;

  VoicePath(this.word, this.voiceType);

  static VoiceType kbaseToVoiceType(int kbiid) {
    VoiceType ret = VoiceType.word;
    if (kbiid == Kbase.word.iid) {
      ret = VoiceType.word;
    }
    return ret;
  }

  Future<bool> exists() async {
    final cachePath = await cachePathOfWord();
    return File(cachePath).existsSync();
  }

  String urlOfWord() {
    final filename = VoiceFilename.name(word);
    final ret = 'voices/${_catFolder()}/${filename[0]}/$filename.mp3';
    return ret;
  }

  Future<String> cachePathOfWord() async {
    final ret = Path.join((await _audiocacheFolder()), urlOfWord());
    return ret;
  }

  String _catFolder() {
    String ret = '';
    switch (voiceType) {
      case VoiceType.word:
        ret = 'words';
        break;
      case VoiceType.sentence:
        ret = 'samples';
        break;
    }
    return ret;
  }

  Future<String> _audiocacheFolder() async {
    final tempdir = (await getApplicationDocumentsDirectory()).path;
    final ret = Path.join(tempdir, 'audiocache', _catFolder());
    return ret;
  }
}
