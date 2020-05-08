import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/dict_item.dart';
import '../../../models/kr.dart';
import '../../../blocs/review_bloc.dart';
import '../phonetic_widget.dart';
import '../known_or_not_widget.dart';
import '../next_widget.dart';
import '../top_tool_bar.dart';
import '../review_const.dart';
import '../../styles/screen.dart';
import '../../widgets/dict_content.dart';
import '../../widgets/sample_row.dart';

class NormalQuiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NormalQuizState();
  }
}

class _NormalQuizState extends State<NormalQuiz> {
  ScrollController _scrollController = ScrollController();
  StreamSubscription _listener;

  _init() {
    _listener = ReviewConst.reviewBloc.updateKr.listen((v) {
      if (v != null) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0.0);
        }
      }
    });
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_listener == null) {
      _init();
    }

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            TopToolBar(),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                    horizontal: Screen.instance.pageHmargin),
                children: <Widget>[
                  _buildTitle(),
                  _buildQuestion(),
                  PhoneticWidget(),
                  _buildMyAnswer(),
                  _buildMySamples(),
                  _buildDictContent(),
                  SizedBox(
                    height: ReviewConst.BottomPadding,
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          child: NextWidget(),
          bottom: 0,
        ),
        Positioned(
          child: KnownOrNotWidget(),
          bottom: 0,
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.only(
          top: Screen.instance.marginMedium,
          bottom: Screen.instance.marginMedium),
      child: Text(
        '还记得这个单词吗?',
        style: TextStyle(
            fontSize: Screen.instance.fontSizeTitle2, color: Color(0xff666666)),
      ),
    );
  }

  Widget _buildQuestion() {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    return StreamBuilder(
      stream: bloc.kr,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Kr kr = snapshot.data;
          return Text(
            kr == null ? '' : kr.question,
            style: TextStyle(
              fontSize: Screen.instance.fontSizeTitle1,
              color: Colors.black,
            ),
            textAlign: TextAlign.left,
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildMyAnswer() {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    var s = Observable.combineLatest2(bloc.isAnswerShown, bloc.myAnswer,
        (isAnswerShown, String myAnswer) {
      if (isAnswerShown != null && isAnswerShown && myAnswer != null) {
        return myAnswer;
      } else {
        return null;
      }
    }).asBroadcastStream();

    return StreamBuilder(
      stream: s,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                snapshot.data,
                style: TextStyle(
                  fontSize: Screen.instance.fontSizeTitle3,
                  color: Color(0xFF880000),
                ),
              ),
              SizedBox(
                height: Screen.instance.marginSmall,
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildMySamples() {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    var s = Observable.combineLatest2(bloc.isAnswerShown, bloc.mySamples,
        (isAnswerShown, String mySamples) {
      if (isAnswerShown != null && isAnswerShown && mySamples != null) {
        return mySamples;
      } else {
        return null;
      }
    }).asBroadcastStream();

    return StreamBuilder(
      stream: s,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          final samples = snapshot.data;
          List<Widget> children = [];

          final splitSample = samples.split('\n');
          splitSample.forEach((s) {
            final asample = s.trim();
            children.add(SampleRow(asample: asample));
          });

          children.add(SizedBox(
            height: Screen.instance.marginMedium,
          ));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
        } else {
          return Container();
        }
      },
    );
  }

  _buildDictContent() {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    var s = Observable.combineLatest2(bloc.isAnswerShown, bloc.dictItem,
        (isAnswerShown, DictItem dictItem) {
      if (isAnswerShown != null && isAnswerShown && dictItem != null) {
        return dictItem;
      } else {
        return null;
      }
    }).asBroadcastStream();

    return StreamBuilder(
      stream: s,
      builder: (context, AsyncSnapshot<DictItem> snapshot) {
        if (snapshot.hasData) {
          return DictContent(
            dictItem: snapshot.data,
            showChineseDefinition: true,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
