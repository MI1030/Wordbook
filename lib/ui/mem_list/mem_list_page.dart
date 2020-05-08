import 'package:flutter/material.dart';

import '../../utils/er_log.dart';
import '../../blocs/mem_list_bloc.dart';
import '../mem_detail/mem_detail_page.dart';
import '../../models/mem.dart';

class MemListPage extends StatefulWidget {
  final int kbaseId;
  final int rank;

  MemListPage({this.kbaseId, this.rank});

  @override
  State<StatefulWidget> createState() {
    return _MemListPageState();
  }
}

class _MemListPageState extends State<MemListPage> {
  MemListBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = MemListBloc(kbaseId: widget.kbaseId, rank: widget.rank);
      _bloc.startLoad();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: _buildTitle(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.popUntil(
                context, ModalRoute.withName(Navigator.defaultRouteName)),
          )
        ],
      ),
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            ErLog.withTs(
                "${scrollInfo.metrics.pixels} | ${scrollInfo.metrics.maxScrollExtent}");
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200) {
              _loadMore();
            }
          },
          child: _buildList(),
        ),
      ),
    );
  }

  _loadMore() {
    ErLog.withTs('_loadMore()');
    _bloc.loadMore();
  }

  Widget _buildTitle() {
    return StreamBuilder(
      stream: _bloc.title,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        } else {
          return Text(snapshot.data);
        }
      },
    );
  }

  Widget _buildList() {
    return StreamBuilder(
      stream: _bloc.memListItems,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        } else {
          final List<MemListItem> mems = snapshot.data;

          return ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, int index) {
              MemListItem amem = mems[index];
              return ListTile(
                key: Key(amem.key),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${index + 1}.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff888888),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(child: Text('${amem.title}')),
                    ]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemDetailPage(
                        _bloc.mems.value.map((Mem amem) => amem.id).toList(),
                        index,
                      ),
                    ),
                  );
                },
              );
            },
            itemCount: mems.length,
          );
        }
      },
    );
  }
}
