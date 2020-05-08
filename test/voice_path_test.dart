import 'package:flutter_test/flutter_test.dart';
import 'package:mxxd/utils/voice_path.dart';

void main() {
  test("word length exceed 64 should add md5 hex", () {
    final s =
        'About eighty thousand spectators packed into the stadium last night.';
    final v =
        'voices/words/a/about_eighty_thousand_spectators_packed_into_the_stadium_last_ni_2ffa42b55c8b206b35fbb3e33c65a0fe.mp3';

    final r = VoicePath(s, VoiceType.word).urlOfWord();

    expect(r, equals(v));
  });
}
