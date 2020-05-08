import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../styles/layout_const.dart';
import '../../localizations.dart';
import '../../blocs/dict_page_bloc.dart';
import '../../blocs/dict_bloc.dart';
import '../../blocs/mem_bloc.dart';
import '../../blocs/app_bloc.dart';
import '../editor/editor_page.dart';
import '../../models/mem.dart';
import '../widgets/filled_animated_button.dart';
import '../styles/screen.dart';

import './search_bar.dart';
import './candidate_list.dart';
import './history_list.dart';
import './item_detail.dart';

class MyDictPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyDictPageState();
  }
}

class _MyDictPageState extends State<MyDictPage> {
  DictBloc _dictBloc;
  MemBloc _memBloc;
  DictPageBloc _dictPageBloc;

  @override
  void initState() {
    super.initState();
    _dictPageBloc = DictPageBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _dictBloc = BlocProvider.getBloc<DictBloc>();
    _memBloc = BlocProvider.getBloc<AppBloc>().memBloc;
  }

  @override
  void dispose() {
    _dictBloc.fetchKr(null);
    _memBloc.fetchMem(null);
    _dictPageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SearchBar(_dictPageBloc),
            Divider(
              height: 2,
            ),
            _buildContent(),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: Screen.instance.marginMedium,
                horizontal: Screen.instance.pageHmargin,
              ),
              child: _buildButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return StreamBuilder(
      stream: _dictPageBloc.contentType,
      builder: (BuildContext context, AsyncSnapshot<DictContentType> snapshot) {
        if (snapshot.hasData && snapshot.data == DictContentType.Result) {
          return StreamBuilder(
            stream: _memBloc.mem,
            builder: (context, AsyncSnapshot<Mem> snapshot) {
              if (snapshot.hasData) {
                return _buildEditButton(snapshot.data);
              } else {
                return _buildAddButton();
              }
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  _buildAddButton() {
    return FilledAnimatedButton.primary(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            MemofLocalizations.of(context).addToNotes,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(
          vertical:
              LayoutConst.buttonTextVerticlePadding * Screen.instance.scale),
      onTap: () {
        DictBloc dictBloc = BlocProvider.getBloc<DictBloc>();
        var kr = dictBloc.kr.value;
        _memBloc.remember(kr.question);
      },
    );
  }

  _buildEditButton(Mem mem) {
    return FilledAnimatedButton.secondary(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            MemofLocalizations.of(context).edit,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(
          vertical:
              LayoutConst.buttonTextVerticlePadding * Screen.instance.scale),
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return EditorPage(
                mem: mem,
                kr: _memBloc.kr.value,
              );
            },
          ),
        );

        _memBloc.fetchMem(_memBloc.kr.value.question);
      },
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      title: Text(MemofLocalizations.of(context).dictionary),
      actions: <Widget>[
        FlatButton(
          child: Text(
            MemofLocalizations.of(context).clearHistory,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            _dictPageBloc.clearHistory();
          },
        )
      ],
    );
  }

  Widget _buildContent() {
    return StreamBuilder(
      stream: _dictPageBloc.contentType,
      builder: (BuildContext context, AsyncSnapshot<DictContentType> snapshot) {
        var content = snapshot.data;
        if (content == DictContentType.History) {
          return HistoryList(_dictPageBloc);
        } else if (content == DictContentType.Candidate) {
          return CandidateList(_dictPageBloc);
        } else {
          return ItemDetail();
        }
      },
    );
  }
}
