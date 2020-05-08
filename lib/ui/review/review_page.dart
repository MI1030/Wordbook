import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../localizations.dart';
import '../../models/kr.dart';
import '../../blocs/review_bloc.dart';
import '../../ui/editor/editor_page.dart';
import '../styles/screen.dart';
import '../../biz/quiz_type.dart';
import '../../colors.dart';

import 'normal_quiz/normal_quiz.dart';
import 'choice_quiz/choice_quiz.dart';
import 'choice_quiz/reverse_choice_quiz.dart';
import 'error_quiz/error_quiz.dart';
import '../widgets/memof_alert.dart';
import 'finish_widget.dart';
import 'review_const.dart';

class ReviewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ReviewPageState();
  }
}

class _ReviewPageState extends State<ReviewPage> with RouteAware {
  bool _inited = false;

  @override
  Widget build(BuildContext context) {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    if (!_inited) {
      bloc.startLoad();
      _inited = true;
    }

    var padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: MemofColors.background,
      body: Container(
        child: Column(
          children: <Widget>[
            _buildAppBar(),
            Expanded(
              child: StreamBuilder(
                stream: bloc.finished,
                builder: (context, AsyncSnapshot<FinishedParams> snapshot) {
                  if (snapshot.hasData) {
                    List<Kr> krs = snapshot.data.savedKrs;
                    bool hasMore = snapshot.data.hasMore;
                    return _buildFinishPage(krs, hasMore, 0.0);
                  } else {
                    return _buildQuizPanel();
                  }
                },
              ),
            ),
            SizedBox(
              height: padding.bottom,
            ),
          ],
        ),
      ),
    );
  }

  _buildFinishPage(List<Kr> savedKrs, bool hasMore, double adHeight) {
    return FinishWidget(
      bannerHeight: adHeight,
      krs: savedKrs,
      hasMore: hasMore,
      onClose: () async {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildAppBar() {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    var padding = MediaQuery.of(context).padding;
    return Container(
      color: MemofColors.NavigationBarColor,
      child: StreamBuilder(
        stream: bloc.finished,
        builder: (context, AsyncSnapshot<FinishedParams> snapshot) {
          if (snapshot.hasData) {
            return Container();
          } else {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: padding.top,
                ),
                Row(
                  children: <Widget>[
                    _buildCloseButton(),
                    Expanded(child: _buildTitle()),
                    _buildMoreButton(),
                  ],
                )
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildMoreButton() {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    return StreamBuilder(
        stream: bloc.showKrStatus,
        builder: (context, snapshot) {
          bool showKrStatus = false;
          if (snapshot.hasData) {
            showKrStatus = snapshot.data;
          }

          return PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: _choiceAction,
            itemBuilder: (BuildContext context) {
              return _actions(showKrStatus).map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          );
        });
  }

  void _choiceAction(String choice) {
    if (choice == ActionConstants.Edit) {
      _onEdit();
    } else if (choice == ActionConstants.Delete) {
      _onIgnore();
    } else if (choice == ActionConstants.ShowStatus) {
      ReviewConst.reviewBloc.setShowKrStatus(true);
    } else if (choice == ActionConstants.HideStatus) {
      ReviewConst.reviewBloc.setShowKrStatus(false);
    }
  }

  _buildCloseButton() {
    return IconButton(
      icon: Icon(
        Icons.close,
        color: Colors.black,
      ),
      onPressed: () async {
        ReviewBloc bloc = ReviewConst.reviewBloc;
        bool ret = await bloc.stop();
        if (!ret) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget _buildQuizPanel() {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    return StreamBuilder(
      stream: bloc.quizType,
      builder: (context, AsyncSnapshot<QuizType> snapshot) {
        if (snapshot.hasData) {
          Widget quiz;
          switch (snapshot.data) {
            case QuizType.Word_Choice:
              quiz = ChoiceQuiz();
              break;
            case QuizType.Reverse_Word_Choice:
              quiz = ReverseChoiceQuiz();
              break;
            case QuizType.Normal:
              quiz = NormalQuiz();
              break;
            case QuizType.Error:
              quiz = ErrorQuiz();
              break;
          }
          return quiz;
        } else {
          return Container();
        }
      },
    );
  }

  void _onEdit() async {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    if (bloc.finished.value == null) {
      if (bloc.kr.value != null) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return EditorPage(
                mem: bloc.mem.value,
                kr: bloc.kr.value,
              );
            },
          ),
        );
        bloc.refreshKr();
      }
    }
  }

  void _onIgnore() async {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    if (bloc.finished.value == null) {
      showDialog(
        context: context,
        builder: (BuildContext acontext) {
          return MemofAlert(
            content: MemofLocalizations.of(context).removeOrNot,
            buttonTitles: ['Yes', 'No'],
            buttonActions: [
              () {
                ReviewBloc bloc = ReviewConst.reviewBloc;
                bloc.ignoreIt();
              },
            ],
          );
        },
      );
    }
  }

  Widget _buildTitle() {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    final s = Observable.combineLatest2(bloc.total, bloc.index, (total, index) {
      if (total != null && index != null) {
        return '$index/$total';
      } else {
        return '';
      }
    }).asBroadcastStream();
    return StreamBuilder(
      stream: s,
      builder: (context, snapshot) {
        return Text(
          snapshot.data ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Screen.instance.fontSizeTitle3,
            color: Colors.black,
          ),
        );
      },
    );
  }

  List<String> _actions(bool showKrStatus) {
    return <String>[
      ActionConstants.Edit,
      ActionConstants.Delete,
      showKrStatus ? ActionConstants.HideStatus : ActionConstants.ShowStatus
    ];
  }
}

class ActionConstants {
  static const String Edit = '编辑';
  static const String Delete = '删除';
  static const String ShowStatus = '显示状态';
  static const String HideStatus = '隐藏状态';
}
