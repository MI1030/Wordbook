import 'package:flutter/material.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

import '../../localizations.dart';
import '../../blocs/dict_bloc.dart';
import '../../blocs/dict_page_bloc.dart';
import '../../models/dict_item.dart';
import '../../blocs/mem_bloc.dart';
import '../../blocs/app_bloc.dart';

class SearchBar extends StatefulWidget {
  final DictPageBloc dictPageBloc;

  SearchBar(this.dictPageBloc);

  @override
  State<StatefulWidget> createState() {
    return _SearchBarState();
  }
}

class _SearchBarState extends State<SearchBar> {
  FocusNode _focusNode;
  var _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        DictPageBloc contentBloc = widget.dictPageBloc;

        if (_textController.text.length > 0) {
          contentBloc.setContentType(DictContentType.Candidate);
        } else {
          contentBloc.setContentType(DictContentType.History);
        }

        DictBloc dictBloc = BlocProvider.getBloc<DictBloc>();
        dictBloc.fetchKr(null);

        MemBloc memBloc = BlocProvider.getBloc<AppBloc>().memBloc;
        memBloc.fetchMem(null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          _buildSearchIcon(),
          _buildTextField(context),
          _buildClearIcon(),
          _buildTextDetector(),
        ],
      ),
    );
  }

  Widget _buildSearchIcon() {
    return Icon(
      Icons.search,
      color: Colors.grey,
    );
  }

  Widget _buildTextField(BuildContext context) {
    DictBloc dictBloc = BlocProvider.getBloc<DictBloc>();

    return Flexible(
      child: TextField(
        focusNode: _focusNode,
        autofocus: true,
        onSubmitted: (v) {
          String word = v.trim();
          if (word.length > 0) {
            dictBloc.fetchKr(word);
            widget.dictPageBloc.setContentType(DictContentType.Result);

            MemBloc memBloc = BlocProvider.getBloc<AppBloc>().memBloc;
            memBloc.fetchMem(word);
          }
        },
        decoration: InputDecoration.collapsed(
            hintText: MemofLocalizations.of(context).inputWordHere),
        onChanged: (String v) {
          String word = v.trim();
          if (word.length > 0) {
            widget.dictPageBloc.setContentType(DictContentType.Candidate);
            dictBloc.fetchCandidates(word);
          } else {
            widget.dictPageBloc.setContentType(DictContentType.History);
          }
        },
        controller: _textController,
      ),
    );
  }

  Widget _buildTextDetector() {
    DictBloc dictBloc = BlocProvider.getBloc<DictBloc>();

    return StreamBuilder(
      stream: dictBloc.kr,
      builder: (BuildContext context, AsyncSnapshot<DictItem> snapshot) {
        if ((snapshot.hasData)) {
          if (snapshot.data != null) {
            _focusNode.unfocus();
            widget.dictPageBloc.addHistory(
                HistoryAddItem(snapshot.data.question, snapshot.data.answer));
          }
        }

        return Container(
          width: 0,
          height: 0,
        );
      },
    );
  }

  Widget _buildClearIcon() {
    return IconButton(
      icon: Icon(
        Icons.clear,
        color: Colors.grey,
      ),
      onPressed: () {
        _textController.text = '';
        widget.dictPageBloc.setContentType(DictContentType.History);
        FocusScope.of(context).requestFocus(_focusNode);
      },
    );
  }
}
