@Skip("sqflite cannot run on the machine.")

import "package:test/test.dart";
import 'package:sqflite/sqflite.dart';

import 'package:mxxd/repository/search_history_db.dart';

void main() {
  SearchHistoryDb sdb = SearchHistoryDb();

  group("Search history db tests", () {
    setUp(() async {
      await sdb.load();
    });

    tearDown(() async {
      await sdb.close();
      String dbpath = await sdb.dbpath();
      await deleteDatabase(dbpath);
    });

    test('should get correct count when add word', () async {
      bool r = await sdb.addWord('a', 'answer');
      expect(r, equals(true));

      r = await sdb.addWord('a', 'answer new');
      expect(r, equals(true));

      int v = await sdb.total();
      expect(v, equals(1));

      r = await sdb.addWord('b', 'b answer');
      expect(r, equals(true));

      v = await sdb.total();
      expect(v, equals(2));
    });

    test('should get 0 after clear words', () async {
      await sdb.addWord('a', 'answer');

      int v = await sdb.total();
      expect(v, equals(1));

      await sdb.clearWords();
      v = await sdb.total();
      expect(v, equals(0));
    });

    test('should get 0 after remove word', () async {
      await sdb.addWord('a', 'answer');

      int v = await sdb.total();
      expect(v, equals(1));

      await sdb.removeWord('a');

      v = await sdb.total();
      expect(v, equals(0));
    });

    test('should return proper recent words', () async {
      await sdb.addWord('a', 'a answer');
      await sdb.addWord('b', 'b answer');

      var items = await sdb.recentWords(0, 10);
      expect(items.length, equals(2));
      expect(items[1].question, equals('a'));
      expect(items[1].answer, equals('a answer'));
      expect(items[0].question, equals('b'));
    });

    test('should return proper recent words', () async {
      await sdb.addWord('a', 'a answer');
      await sdb.addWord('b', 'b answer');

      var item = await sdb.recentWordOfIndex(1);
      expect(item.question, equals('a'));
      expect(item.answer, equals('a answer'));
    });
  });
}
