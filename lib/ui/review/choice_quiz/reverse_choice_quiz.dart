import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../../../utils/voice_path.dart';
import '../../../blocs/review_bloc.dart';
import '../../../blocs/choices_bloc.dart';
import '../../../utils/voice_speaker.dart';
import '../../../biz/quiz_type.dart';
import '../../../models/kr.dart';
import '../../styles/screen.dart';

import '../phonetic_widget.dart';
import '../top_tool_bar.dart';
import '../detail_next_widget.dart';
import '../review_const.dart';
import 'choice_button.dart';
import 'title_widget.dart';
import '../detail_panel.dart';

class ReverseChoiceQuiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ReverseChoiceQuizState();
  }
}

class _ReverseChoiceQuizState extends State<ReverseChoiceQuiz> {
  StreamSubscription _choiceMadeListener;
  StreamSubscription _quizTypeListener;
  ChoicesBloc _choicesBloc;
  ScrollController _scrollController = ScrollController();
  StreamSubscription _listener;

  @override
  void dispose() {
    _listener.cancel();
    _choiceMadeListener.cancel();
    _quizTypeListener.cancel();
    super.dispose();
  }

  _init() {
    ReviewBloc reviewBloc = ReviewConst.reviewBloc;
    _choicesBloc = ChoicesBloc();

    _choiceMadeListener =
        _choicesBloc.choiceMade.listen((ChoiceMadeParams params) {
      if (params != null) {
        reviewBloc.setAnswered(params.right == params.selected);
        reviewBloc.startShowAnswer();
      }
    });

    _quizTypeListener = reviewBloc.quizType.listen((quizType) {
      if (quizType != null &&
          quizType == QuizType.Reverse_Word_Choice &&
          reviewBloc.kr.value != null) {
        _choicesBloc.prepareReverseChoices(reviewBloc.kr.value);
      }
    });

    _listener = ReviewConst.reviewBloc.updateKr.listen((v) {
      if (v != null) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0.0);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_choicesBloc == null) {
      _init();
    }

    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TopToolBar(),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Screen.instance.pageHmargin),
              child: TitleWidget(
                reverse: true,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Screen.instance.pageHmargin),
              child: _buildAnswer(),
            ),
            _buildPhonetic(),
            Flexible(
              child: Container(),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Screen.instance.pageHmargin),
              child: _buildChoicePanel(),
            ),
            Flexible(
              child: Container(),
            ),
            SizedBox(
              height: ReviewConst.BottomPadding,
            )
          ],
        ),
        Positioned(
          child: Column(
            children: <Widget>[
              Flexible(
                child: DetailPanel(),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(
                    horizontal: Screen.instance.pageHmargin),
                child: DetailNextWidget(
                  onShowDetail: () {
                    ReviewBloc bloc = ReviewConst.reviewBloc;
                    if (bloc.showKrDetail.value) {
                      bloc.setShowKrDetail(false);
                    } else {
                      bloc.setShowKrDetail(true);
                    }
                  },
                  onPressed: _onNext,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhonetic() {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    return StreamBuilder(
      stream: bloc.isAnswerShown,
      builder: (context, snapshot) {
        bool showText = snapshot.data ?? false;
        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: Screen.instance.pageHmargin),
          child: PhoneticWidget(
            showText: showText,
          ),
        );
      },
    );
  }

  Widget _buildAnswer() {
    ReviewBloc bloc = ReviewConst.reviewBloc;

    return StreamBuilder(
      stream: bloc.answer,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          String text = snapshot.data;
          return Container(
            child: Text(
              text.replaceAll('\n', ' '),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: Screen.instance.fontSizeTitle2),
              textAlign: TextAlign.left,
              maxLines: 2,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildChoicePanel() {
    return StreamBuilder(
      stream: _choicesBloc.choices,
      builder: (context, snapshot) {
        final choices = snapshot.data;
        if (choices != null && choices.length > 1) {
          List<Widget> rows = [];
          for (int i = 0; i < choices.length; i++) {
            rows.add(_buildChoiceRow(choices[i], i));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rows,
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildChoiceRow(String text, int index) {
    return StreamBuilder(
      stream: _choicesBloc.choiceMade,
      builder: (context, snapshot) {
        ChoiceMadeParams params = snapshot.data;
        Color textColor = Colors.black;
        bool isRight = false;
        bool isWrong = false;
        if (params != null) {
          if (params.right == index) {
            textColor = Color(0xff00b400);
            if (params.selected == index) {
              isRight = true;
            }
          } else if (params.selected == index) {
            isWrong = true;
          }
        }

        return ChoiceButton(
          text: text,
          textColor: textColor,
          isRight: isRight,
          isWrong: isWrong,
          onPressed: () => _onChoiceSelect(index),
        );
      },
    );
  }

  _onChoiceSelect(int index) {
    if (_choicesBloc.choiceMade.value == null) {
      ReviewBloc reviewBloc = ReviewConst.reviewBloc;
      _choicesBloc.selectChoice(index);
      if (reviewBloc.shouldAutoSpeak.value) {
        Kr kr = reviewBloc.kr.value;
        VoiceSpeaker.instance
            .speak(kr.question, VoicePath.kbaseToVoiceType(kr.kbase));
      }
    }
  }

  _onNext() {
    ReviewBloc reviewBloc = ReviewConst.reviewBloc;
    ChoiceMadeParams params = _choicesBloc.choiceMade.value;
    if (params.selected == params.right) {
      reviewBloc.passIt();
    } else {
      reviewBloc.failIt();
    }

    Timer(Duration(milliseconds: 100), () {
      reviewBloc.next();
    });
  }
}
