import 'package:flutter/material.dart';

import '../../blocs/achieve_bloc.dart';
import '../mem_list/mem_list_page.dart';
import '../../models/kbase.dart';
import '../../localizations.dart';
import 'kbases_stat_tile.dart';

class AchievePage extends StatefulWidget {
  final int kbaseId;

  AchievePage({this.kbaseId});

  @override
  State<StatefulWidget> createState() {
    return _AchievePage();
  }
}

class _AchievePage extends State<AchievePage> {
  AchieveBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AchieveBloc(widget.kbaseId);
    _bloc.startLoad();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.kbaseId != null
        ? Kbase.nameOfIid(widget.kbaseId)
        : MemofLocalizations.of(context).achievements;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.popUntil(
                context, ModalRoute.withName(Navigator.defaultRouteName)),
          )
        ],
      ),
      body: SafeArea(
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    return StreamBuilder(
      stream: _bloc.achieves,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        } else {
          final List<Widget> children = [];
          if (widget.kbaseId == null) {
            children.add(KbasesStatTile());
          }

          final List<AchieveItem> items = snapshot.data;
          items.forEach((AchieveItem aitem) {
            if (aitem.key.startsWith("empty-header")) {
              children.add(
                Container(
                  height: 10,
                  color: Color(0xfff0f0f0),
                ),
              );
            } else {
              var tile = ListTile(
                leading: Container(
                  width: 80,
                  child: Text(
                    aitem.title,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                title: LinearProgressIndicator(
                  value: aitem.progress,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(aitem.color)),
                  backgroundColor: Color(0xfff0f0f0),
                ),
                trailing: Container(
                  width: 80,
                  child: Row(children: <Widget>[
                    Expanded(
                      child: Text(aitem.count.toString()),
                    ),
                    aitem.count > 0
                        ? Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Color(0xffc0c0c0),
                          )
                        : Container(),
                  ]),
                ),
                onTap: () {
                  if (aitem.count > 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MemListPage(
                                  kbaseId: widget.kbaseId,
                                  rank: aitem.rank,
                                )));
                  }
                },
              );
              children.add(tile);
            }
          });

          return ListView(
            children: children,
          );
        }
      },
    );
  }
}
