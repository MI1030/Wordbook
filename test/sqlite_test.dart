// test/sqlite_test.dart
@Skip("sqflite cannot run on the machine.")

import "package:test/test.dart";
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;

final testDB = "demo.db";
Database database;
String dbpath;

void main() {
  group("SQLiteDao tests", () {
    setUp(() async {
      var databasesPath = await getDatabasesPath();
      dbpath = Path.join(databasesPath, testDB);
      print(dbpath);

      // Delete the database
      await deleteDatabase(dbpath);

      database = await openDatabase(dbpath, version: 1,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
      });
    });

    // Delete the database so every test run starts with a fresh database
    tearDownAll(() async {
      await deleteDatabase(dbpath);
    });

    test("should insert and query path by id", () async {
      // Insert some records in a transaction
      await database.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
        print('inserted1: $id1');
        int id2 = await txn.rawInsert(
            'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
            ['another name', 12345678, 3.1416]);
        print('inserted2: $id2');
      });

      var count = Sqflite.firstIntValue(
          await database.rawQuery('SELECT COUNT(*) FROM Test'));

      expect(count, equals(2));
    });
  });
}
