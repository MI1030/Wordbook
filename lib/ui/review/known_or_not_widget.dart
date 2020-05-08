import 'dart:async';
import 'package:flutter/material.dart';

import '../styles/layout_const.dart';
import 'review_const.dart';
import '../../localizations.dart';
import '../../models/kr.dart';
import '../../utils/voice_path.dart';
import '../../utils/voice_speaker.dart';
import '../../blocs/review_bloc.dart';
import '../styles/screen.dart';
import '../../colors.dart';
import '../widgets/filled_animated_button.dart';

class KnownOrNotWidget extends StatelessWidget {
  const KnownOrNotWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReviewBloc reviewBloc = ReviewConst.reviewBloc;
    return StreamBuilder(
      stream: reviewBloc.isAnswerRight,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: MemofColors.background,
            padding: EdgeInsets.only(
                left: Screen.instance.pageHmargin,
                right: Screen.instance.pageHmargin,
                bottom: 30 * Screen.instance.scale,
                top: Screen.instance.marginMedium),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: _buildKnownButton(context),
                ),
                SizedBox(
                  width: Screen.instance.pageHmargin,
                ),
                Flexible(
                  flex: 1,
                  child: _buildUnknownButton(context),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  _buildKnownButton(context) {
    return FilledAnimatedButton.secondary(
      child:
          _knowButtonChild(MemofLocalizations.of(context).know, Colors.white),
      onTap: () => _onKnow(),
      padding: EdgeInsets.symmetric(
          vertical:
              LayoutConst.buttonTextVerticlePadding * Screen.instance.scale),
    );
  }

  _buildUnknownButton(context) {
    return FilledAnimatedButton.primary(
      child:
          _knowButtonChild(MemofLocalizations.of(context).forgot, Colors.white),
      onTap: () => _onUnknow(),
      padding: EdgeInsets.symmetric(
          vertical:
              LayoutConst.buttonTextVerticlePadding * Screen.instance.scale),
    );
  }

  _knowButtonChild(String title, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: Screen.instance.fontSizeButton,
          ),
        ),
      ],
    );
  }

  _onKnow() {
    ReviewBloc reviewBloc = ReviewConst.reviewBloc;
    if (reviewBloc.isAnswerShown.value) {
      reviewBloc.passIt();
      Timer(Duration(milliseconds: 100), () {
        reviewBloc.next();
      });
    } else {
      reviewBloc.setAnswered(true);
      reviewBloc.startShowAnswer();
      if (reviewBloc.shouldAutoSpeak.value) {
        Kr kr = reviewBloc.kr.value;
        if (kr != null) {
          VoiceSpeaker.instance
              .speak(kr.question, VoicePath.kbaseToVoiceType(kr.kbase));
        }
      }
    }
  }

  _onUnknow() {
    ReviewBloc reviewBloc = ReviewConst.reviewBloc;
    if (reviewBloc.isAnswerShown.value) {
      reviewBloc.failIt();
      Timer(Duration(milliseconds: 100), () {
        reviewBloc.next();
      });
    } else {
      reviewBloc.setAnswered(false);
      reviewBloc.startShowAnswer();
      if (reviewBloc.shouldAutoSpeak.value) {
        Kr kr = reviewBloc.kr.value;
        if (kr != null) {
          VoiceSpeaker.instance
              .speak(kr.question, VoicePath.kbaseToVoiceType(kr.kbase));
        }
      }
    }
  }
}
