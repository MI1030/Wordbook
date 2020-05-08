import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../../../models/kr.dart';
import '../../../utils/voice_path.dart';
import '../../../blocs/review_bloc.dart';
import '../../../blocs/choices_bloc.dart';
import '../../../utils/voice_speaker.dart';
import '../../../biz/quiz_type.dart';
import '../../styles/screen.dart';

import '../phonetic_widget.dart';
import '../top_tool_bar.dart';
import '../detail_next_widget.dart';
import '../review_const.dart';
import 'choice_button.dart';
import 'title_widget.dart';
import '../detail_panel.dart';

class ChoiceQuiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChoiceQuizState();
  }
}

class _ChoiceQuizState extends State<ChoiceQuiz> {
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
          quizType == QuizType.Word_Choice &&
          reviewBloc.kr.value != null) {
        _choicesBloc.prepareChoices(reviewBloc.kr.value);
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
              child: TitleWidget(
                reverse: false,
              ),
              padding:
                  EdgeInsets.symmetric(horizontal: Screen.instance.pageHmargin),
            ),
            Padding(
              child: _buildQuestion(),
              padding:
                  EdgeInsets.symmetric(horizontal: Screen.instance.pageHmargin),
            ),
            Padding(
              child: PhoneticWidget(),
              padding:
                  EdgeInsets.symmetric(horizontal: Screen.instance.pageHmargin),
            ),
            Flexible(
              child: Container(),
            ),
            Padding(
              child: _buildChoicePanel(),
              padding:
                  EdgeInsets.symmetric(horizontal: Screen.instance.pageHmargin),
            ),
            Flexible(
              child: Container(),
            ),
            SizedBox(
              height: ReviewConst.BottomPadding,
            ),
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
                fontSize: Screen.instance.fontSizeTitle1, color: Colors.black),
            textAlign: TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildChoicePanel() {
    ReviewBloc reviewBloc = ReviewConst.reviewBloc;
    return StreamBuilder(
      stream: _choicesBloc.choices,
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        final choices = snapshot.data;
        if (choices != null && choices.length > 1) {
          String rightAnswer = reviewBloc.answer.value;
          if (rightAnswer.length == 0) {
            rightAnswer = reviewBloc.kr.value.question;
          }

          List<Widget> rows = [];
          for (int i = 0; i < choices.length; i++) {
            if (choices[i].length == 0) {
              choices[i] = rightAnswer;
            }
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
            onPressed: () => _onChoiceSelect(index));
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
