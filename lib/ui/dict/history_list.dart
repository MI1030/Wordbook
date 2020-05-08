import 'package:flutter/material.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

import '../../blocs/app_bloc.dart';
import '../../blocs/dict_bloc.dart';
import '../../blocs/dict_page_bloc.dart';
import '../../blocs/mem_bloc.dart';
import '../../models/search_history_item.dart';

class HistoryList extends StatefulWidget {
  final DictPageBloc dictPageBloc;

  HistoryList(this.dictPageBloc);

  @override
  State<StatefulWidget> createState() {
    return _HistoryListState();
  }
}

class _HistoryListState extends State<HistoryList> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget.dictPageBloc.fetchHistory();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 200) {
      widget.dictPageBloc.fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
          stream: widget.dictPageBloc.historyItems,
          builder: (BuildContext context,
              AsyncSnapshot<List<SearchHistoryItem>> snapshot) {
            if (snapshot.hasData) {
              return buildResult(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            return Container();
          }),
    );
  }

  Widget buildResult(AsyncSnapshot<List<SearchHistoryItem>> snapshot) {
    return ListView.separated(
      controller: _scrollController,
      itemCount: snapshot.data.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (BuildContext context, int index) {
        SearchHistoryItem item = snapshot.data[index];
        return ListTile(
          title: Text(item.question),
          subtitle: Text(
            item.answer,
            maxLines: 1,
          ),
          onTap: () {
            DictBloc dictBloc = BlocProvider.getBloc<DictBloc>();
            dictBloc.fetchKr(item.question);

            MemBloc memBloc = BlocProvider.getBloc<AppBloc>().memBloc;
            memBloc.fetchMem(item.question);

            widget.dictPageBloc.setContentType(DictContentType.Result);
          },
        );
      },
    );
  }
}
