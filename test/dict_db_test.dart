@Skip("sqflite cannot run on the machine.")

import "package:test/test.dart";
import 'package:mxxd/repository/dict_db.dart';

void main() {
  group("Dictionary db tests", () {
    setUp(() async {
      await EcDict.instance.load();
    });

    test('should return 1 result when look up "a" ', () async {
      var v = await EcDict.instance.lookup('a');
      expect(v.question, equals('a'));
      expect(v.answer.length, greaterThan(1));
    });

    test('should return 10 candidates when query word list of "b"', () async {
      var rs = await EcDict.instance.wordList('b', 10);
      expect(rs.length, equals(10));
    });
  });
}
