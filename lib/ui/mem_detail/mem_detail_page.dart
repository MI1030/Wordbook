import 'package:flutter/material.dart';

import '../styles/screen.dart';
import '../../localizations.dart';
import '../../models/kr.dart';
import '../../models/dict_item.dart';
import '../../blocs/mem_detail_bloc.dart';
import '../../models/mem.dart';
import '../widgets/phonetic_row.dart';
import '../widgets/dict_content.dart';
import '../widgets/my_content_row.dart';
import '../editor/editor_page.dart';

class MemDetailPage extends StatefulWidget {
  final List<int> memIds;
  final int index;

  MemDetailPage(this.memIds, this.index);

  @override
  State<StatefulWidget> createState() {
    return _MemDetailPageState();
  }
}

class _MemDetailPageState extends State<MemDetailPage> {
  MemDetailBloc _memDetailBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_memDetailBloc == null) {
      _memDetailBloc = MemDetailBloc(widget.memIds, widget.index);
      _memDetailBloc.fetchMem();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: _buildTitle(),
        actions: <Widget>[_buildActions()],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: _buildContent(),
            ),
            _buildToolbar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return StreamBuilder(
      stream: _memDetailBloc.indexText,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        } else {
          return Text(snapshot.data);
        }
      },
    );
  }

  _buildActions() {
    return StreamBuilder(
      stream: _memDetailBloc.mem,
      builder: (BuildContext context, AsyncSnapshot<Mem> snapshot) {
        var mem = snapshot.data;
        return FlatButton(
          child: Text(
            MemofLocalizations.of(context).edit,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            if (!_memDetailBloc.krData.value.dataError) {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return EditorPage(
                      mem: mem,
                      kr: _memDetailBloc.krData.value.kr,
                    );
                  },
                ),
              );
              _memDetailBloc.fetchMem();
            }
          },
        );
      },
    );
  }

  Widget _buildToolbar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xffcccccc), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.first_page,
              size: 32,
            ),
            onPressed: () {
              _memDetailBloc.goFirst();
            },
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            icon: Icon(
              Icons.navigate_before,
              size: 32,
            ),
            onPressed: () {
              _memDetailBloc.goPrevious();
            },
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            icon: Icon(
              Icons.navigate_next,
              size: 32,
            ),
            onPressed: () {
              _memDetailBloc.goNext();
            },
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            icon: Icon(
              Icons.last_page,
              size: 32,
            ),
            onPressed: () {
              _memDetailBloc.goLast();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return StreamBuilder(
      stream: _memDetailBloc.krData,
      builder: (context, AsyncSnapshot<KrData> snapshot) {
        if (snapshot.hasData) {
          KrData krData = snapshot.data;
          if (krData.dataError) {
            return Container(
              padding: EdgeInsets.all(Screen.instance.pageHmargin),
              child: Text(
                '数据错误',
                style: TextStyle(fontSize: Screen.instance.fontSizeTitle3),
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  buildQuestion(krData.kr),
                  _buildPhonetic(),
                  MyContentRow(krData.kr),
                  _buildDictContent(),
                ],
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildPhonetic() {
    return StreamBuilder(
      stream: _memDetailBloc.krData,
      builder: (context, AsyncSnapshot<KrData> snapshot) {
        final phonetic = '';
        if (snapshot.hasData) {
          KrData krData = snapshot.data;
          if (krData.dataError) {
            return Container();
          } else {
            return PhoneticRow(phonetic, krData.kr);
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildDictContent() {
    return StreamBuilder(
      stream: _memDetailBloc.krData,
      builder: (context, AsyncSnapshot<KrData> snapshot) {
        if (snapshot.hasData && snapshot.data.dictItem != null) {
          DictItem item = snapshot.data.dictItem;
          return DictContent(dictItem: item);
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildQuestion(Kr kr) {
    return Text(
      kr.question,
      style: TextStyle(fontSize: 20),
    );
  }
}
