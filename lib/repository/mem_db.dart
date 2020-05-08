import 'dart:io';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;

import 'memstat/memstat_read.dart';
import 'memstat/memstat_study.dart';
import 'mems.dart';
import 'krs.dart';
import 'prefs.dart';
import '../utils/er_log.dart';
import './memstat/memstat_graph.dart';

class MemDb {
  static final MemDb instance = MemDb._();

  MemstatGraph memstatGraph() {
    return MemstatGraph(_db);
  }

  Prefs prefs() {
    return Prefs(_db);
  }

  MemstatRead memstatRead() {
    return MemstatRead(_db);
  }

  MemStatStudy memstatStudy() {
    return MemStatStudy(_db);
  }

  Mems mems() {
    return Mems(_db);
  }

  Krs krs() {
    return Krs(_db);
  }

  Future<String> dbpath() async {
    var databasesPath = await getDatabasesPath();
    var filename = 'mems.rdb';
    var path = Path.join(databasesPath, filename);
    ErLog.withTs('mems db path: $path');
    return path;
  }

  Future<void> load() async {
    if (_db == null) {
      String path = await dbpath();
      if (!File.fromUri(Uri.file(path)).existsSync()) {
        ByteData data = await rootBundle.load(Path.join("assets", "mems.rdb"));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes);
      }

      _db = await openDatabase(path);
    }
  }

  Future<void> close() async {
    await _db.close();
    _db = null;
  }

  MemDb._();
  Database _db;
}
