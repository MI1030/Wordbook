import 'package:flutter/material.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

import '../../models/kbase.dart';
import '../../models/kr.dart';
import '../../blocs/dict_bloc.dart';
import '../../blocs/mem_bloc.dart';
import '../../blocs/app_bloc.dart';

import '../../models/dict_item.dart';
import '../widgets/phonetic_row.dart';
import '../widgets/dict_content.dart';
import '../widgets/my_content_row.dart';

class ItemDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ItemDetailState();
  }
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DictBloc dictBloc = BlocProvider.getBloc<DictBloc>();
    return Expanded(
      child: StreamBuilder(
        stream: dictBloc.kr,
        builder: (context, snapshot) {
          DictItem item = snapshot.data;
          if (item == null) {
            return Container();
          } else {
            return Padding(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  _buildQuestion(item),
                  PhoneticRow(item.phonetic,
                      Kr(question: item.question, kbase: Kbase.word.iid)),
                  _buildMyContentRow(item),
                  DictContent(dictItem: item),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildMyContentRow(DictItem item) {
    MemBloc memBloc = BlocProvider.getBloc<AppBloc>().memBloc;
    return StreamBuilder(
      stream: memBloc.kr,
      builder: (BuildContext context, AsyncSnapshot<Kr> snapshot) {
        var kr = snapshot.data;
        if (kr != null) {
          return MyContentRow(kr);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildQuestion(DictItem item) {
    return Text(
      item.question,
      style: TextStyle(fontSize: 20),
    );
  }
}
