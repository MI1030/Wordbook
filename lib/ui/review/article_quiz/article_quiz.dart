import 'dart:async';

import 'package:flutter/material.dart';

import '../../../models/kr.dart';
import '../../../blocs/review_bloc.dart';
import '../../widgets/sample_row.dart';
import '../top_tool_bar.dart';
import '../next_widget.dart';
import '../known_or_not_widget.dart';
import '../review_const.dart';
import '../../styles/screen.dart';
import '../phonetic_widget.dart';

class ArticleQuiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ArticleQuizState();
  }
}

class _ArticleQuizState extends State<ArticleQuiz> {
  ScrollController _scrollController = ScrollController();
  StreamSubscription _listener;

  _initListener() {
    if (_listener == null) {
      _listener = ReviewConst.reviewBloc.updateKr.listen((v) {
        if (v != null) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(0.0);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initListener();

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            TopToolBar(),
            Expanded(child: _buildContent()),
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

  Widget _buildContent() {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    return StreamBuilder(
      stream: bloc.kr,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Kr kr = snapshot.data;

          return ListView(
            controller: _scrollController,
            padding:
                EdgeInsets.symmetric(horizontal: Screen.instance.pageHmargin),
            children: <Widget>[
              _buildTitle(),
              _buildArticleTitle(kr.question),
              PhoneticWidget(),
              _buildAnswer(),
              SizedBox(
                height: Screen.instance.marginMedium,
              ),
              _buildComment(),
              SizedBox(
                height: ReviewConst.BottomPadding,
              )
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  _buildAnswer() {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    return StreamBuilder(
      stream: bloc.myAnswer,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          String answer = snapshot.data;
          var ss = answer.split('\n');
          var svs = ss.map((s) {
            final asample = s.trim();
            return SampleRow(
              asample: asample,
              color: Color(0xFF000099),
            );
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[...svs],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.only(
          top: Screen.instance.marginMedium,
          bottom: Screen.instance.marginMedium),
      child: Text(
        '还记得这篇文章吗?',
        style: TextStyle(
            fontSize: Screen.instance.fontSizeTitle2, color: Color(0xff666666)),
      ),
    );
  }

  Widget _buildArticleTitle(String question) {
    return Text(
      question,
      style: TextStyle(
          fontSize: Screen.instance.fontSizeTitle2, color: Colors.black),
    );
  }

  Widget _buildComment() {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    return StreamBuilder(
      stream: bloc.mySamples,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data,
            style: TextStyle(
              fontSize: Screen.instance.fontSizeBody,
              color: Color(0xFF880000),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
