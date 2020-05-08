import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../repository/search_history_db.dart';
import '../models/search_history_item.dart';

enum DictContentType { History, Candidate, Result }

class HistoryScope {
  final int start;
  final int count;
  HistoryScope(this.start, this.count);
}

class HistoryAddItem {
  final String question;
  final String answer;
  HistoryAddItem(this.question, this.answer);
}

class DictPageBloc extends BlocBase {
  // Inputs
  setContentType(DictContentType v) => _contentTypeController.sink.add(v);
  fetchHistory() => _fetchHistoryController.sink.add(null);
  fetchMore() => _fetchMoreController.sink.add(null);
  addHistory(HistoryAddItem v) => _addHistoryController.sink.add(v);
  clearHistory() => _clearHistoryController.sink.add(null);

  // Outputs
  ValueObservable<DictContentType> get contentType => _contentTypeController;
  Stream<List<SearchHistoryItem>> get historyItems =>
      _historyItemsController.stream;

  // private
  final _historyItemsController = BehaviorSubject<List<SearchHistoryItem>>();
  final _fetchHistoryController = StreamController<HistoryScope>();
  final _fetchMoreController = StreamController<dynamic>();
  final _addHistoryController = StreamController<HistoryAddItem>();
  final _clearHistoryController = StreamController<dynamic>();
  final _contentTypeController = BehaviorSubject<DictContentType>();

  SearchHistoryDb _sdb = SearchHistoryDb();
  List<SearchHistoryItem> _items = [];

  DictPageBloc() {
    _sdb.load().then((_) {
      _fetchHistoryController.sink.add(null);
    });

    _addHistoryController.stream.listen((HistoryAddItem item) async {
      await _sdb.addWord(item.question, item.answer);
    });

    _clearHistoryController.stream.listen((_) async {
      await _sdb.clearWords();
      _fetchHistoryController.sink.add(null);
    });

    _fetchHistoryController.stream.listen((_) async {
      List<SearchHistoryItem> r = await _sdb.recentWords(0, 30);
      _items.clear();
      _items.addAll(r);
      _historyItemsController.sink.add(r);
    });

    _fetchMoreController.stream.listen((_) async {
      List<SearchHistoryItem> r = await _sdb.recentWords(_items.length, 30);
      _items.addAll(r);
      _historyItemsController.sink.add(_items);
    });
  }

  dispose() {
    _contentTypeController.close();
    _sdb.close();
    _historyItemsController.close();
    _fetchHistoryController.close();
    _fetchMoreController.close();
    _addHistoryController.close();
    _clearHistoryController.close();
    super.dispose();
  }
}
