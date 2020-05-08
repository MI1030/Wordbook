import 'dart:async';

import 'package:sqflite/sqflite.dart';

class MemofPrefs {
  int reviewCountPerTurn = MemofPrefs.defaultReviewCountPerTurn;
  bool autoSpeak = true;
  int reviewOrder = 0;

  static const int defaultReviewCountPerTurn = 20;
}

class Prefs {
  Prefs(this._db);

  static const String reviewCountPerTurnKey = 'reviewCountPerTurn';
  static const String autoSpeakKey = 'autoSpeak';
  static const String reviewOrderKey = 'reviewOrder';

  Future<MemofPrefs> all() async {
    final select = "SELECT key, val FROM $_tableName";
    final rs = await _db.rawQuery(select);
    MemofPrefs ret = MemofPrefs();
    for (int i = 0; i < rs.length; i++) {
      final row = rs[i];

      String key = row['key'];
      String val = row['val'];
      if (key == reviewCountPerTurnKey) {
        int v = int.tryParse(val);
        if (v != null) {
          ret.reviewCountPerTurn = v;
        }
      } else if (key == autoSpeakKey) {
        int v = int.tryParse(val);
        if (v != null) {
          ret.autoSpeak = v > 0;
        }
      } else if (key == reviewOrderKey) {
        int v = int.tryParse(val);
        if (v != null) {
          ret.reviewOrder = v;
        }
      }
    }
    return ret;
  }

  Future<bool> setReviewCountPerTurn(int count) async {
    return await _save(reviewCountPerTurnKey, count.toString());
  }

  Future<bool> setAutoSpeak(bool isAuto) async {
    int v = isAuto ? 1 : 0;
    return await _save(autoSpeakKey, v.toString());
  }

  Future<bool> setReviewOrder(int order) async {
    return await _save(reviewOrderKey, order.toString());
  }

  Future<bool> _save(String key, String val) async {
    final String select = 'SELECT val FROM $_tableName WHERE key = ?';
    final rs = await _db.rawQuery(select, [key]);
    if (rs.length > 0) {
      String sql = 'UPDATE $_tableName SET val = ?, sync = 0 WHERE key = ?';
      var r = await _db.rawUpdate(sql, [val, key]);
      return r > 0;
    } else {
      String sql = 'INSERT INTO $_tableName (key, val, sync) VALUES (?, ?, 0)';
      var r = await _db.rawInsert(sql, [key, val]);
      return r >= 0;
    }
  }

  final _tableName = 'prefs';
  final Database _db;
}
