import 'dart:async';

import 'package:flutter/material.dart';

import 'review_const.dart';
import '../styles/layout_const.dart';
import '../../localizations.dart';
import '../../blocs/review_bloc.dart';
import '../styles/screen.dart';
import '../widgets/filled_animated_button.dart';

class DetailNextWidget extends StatefulWidget {
  final Function onShowDetail;
  final Function onPressed;
  const DetailNextWidget({this.onPressed, this.onShowDetail, Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DetailNextWidgetState();
  }
}

class _DetailNextWidgetState extends State<DetailNextWidget> {
  @override
  Widget build(BuildContext context) {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    return StreamBuilder(
      stream: bloc.isAnswerRight,
      builder: (context, snapshot) {
        bool disable = !snapshot.hasData;
        return Container(
          padding: EdgeInsets.only(
              bottom: 30 * Screen.instance.scale,
              top: Screen.instance.marginMedium),
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: _buildNextButton(disable),
              ),
              SizedBox(
                width: Screen.instance.pageHmargin,
              ),
              Flexible(
                flex: 1,
                child: _buildShowDetailButton(disable),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShowDetailButton(bool disable) {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    return StreamBuilder(
      stream: bloc.showKrDetail,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        String title = MemofLocalizations.of(context).showMore;
        if (snapshot.hasData && snapshot.data) {
          title = '隐藏';
        }

        return FilledAnimatedButton.primary(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: disable
                      ? FilledAnimatedButton.disableColor
                      : Colors.white,
                  fontSize: Screen.instance.fontSizeButton,
                ),
              )
            ],
          ),
          onTap: disable ? null : widget.onShowDetail,
          padding: EdgeInsets.symmetric(
              vertical: LayoutConst.buttonTextVerticlePadding *
                  Screen.instance.scale),
        );
      },
    );
  }

  Widget _buildNextButton(bool disable) {
    return FilledAnimatedButton.secondary(
      child: _buttonChild(disable),
      onTap: disable ? null : (widget.onPressed ?? () => _onNext()),
      padding: EdgeInsets.symmetric(
          vertical:
              LayoutConst.buttonTextVerticlePadding * Screen.instance.scale),
    );
  }

  _buttonChild(bool disable) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          MemofLocalizations.of(context).next,
          style: TextStyle(
            color: disable ? FilledAnimatedButton.disableColor : Colors.white,
            fontSize: Screen.instance.fontSizeButton,
          ),
        ),
      ],
    );
  }

  _onNext() {
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
