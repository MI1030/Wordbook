import 'dart:async';

import 'package:flutter/material.dart';

import '../styles/layout_const.dart';
import 'review_const.dart';
import '../../localizations.dart';
import '../../blocs/review_bloc.dart';
import '../../colors.dart';
import '../styles/screen.dart';
import '../widgets/filled_animated_button.dart';

class NextWidget extends StatelessWidget {
  final Function onPressed;
  const NextWidget({this.onPressed, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    return StreamBuilder(
      stream: bloc.isAnswerRight,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                    child: _buildButton(
                      context,
                      icon: Icons.navigate_next,
                      onPressed: onPressed ?? () => _onNext(context),
                    ),
                  ),
                ],
              ));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildButton(
    BuildContext context, {
    IconData icon,
    Function onPressed,
  }) {
    return FilledAnimatedButton.secondary(
      child: _buttonChild(context),
      onTap: onPressed,
      padding: EdgeInsets.symmetric(
          vertical:
              LayoutConst.buttonTextVerticlePadding * Screen.instance.scale),
    );
  }

  _buttonChild(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          MemofLocalizations.of(context).next,
          style: TextStyle(
            color: Colors.white,
            fontSize: Screen.instance.fontSizeButton,
          ),
        ),
      ],
    );
  }

  _onNext(context) {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    if (bloc.isAnswerRight.value) {
      bloc.passIt();
    } else {
      bloc.failIt();
    }

    Timer(Duration(milliseconds: 100), () {
      bloc.next();
    });
  }
}
