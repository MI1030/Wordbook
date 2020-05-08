import 'dart:math';

import 'package:flutter/material.dart';

import '../styles/layout_const.dart';
import '../styles/screen.dart';
import '../../localizations.dart';
import '../widgets/filled_animated_button.dart';
import '../../models/kr.dart';

class FinishWidget extends StatefulWidget {
  final List<Kr> krs;
  final bool hasMore;
  final double bannerHeight;
  final Function onClose;
  FinishWidget(
      {this.krs, this.hasMore, this.bannerHeight, this.onClose, Key key})
      : super(key: key);

  _FinishWidgetState createState() => _FinishWidgetState();
}

class _FinishWidgetState extends State<FinishWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          _buildTitle(widget.krs.length),
          SizedBox(
            height: Screen.instance.marginSmall,
          ),
          Divider(
            indent: Screen.instance.pageHmargin,
            endIndent: Screen.instance.pageHmargin,
            color: Color(0xff888888),
          ),
          Expanded(
            child: _buildKrList(widget.krs),
          ),
          Divider(
            indent: Screen.instance.pageHmargin,
            endIndent: Screen.instance.pageHmargin,
            color: Color(0xff888888),
          ),
          SizedBox(
            height: Screen.instance.marginMedium,
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Screen.instance.pageHmargin),
            child: _buildFinishCloseButton(),
          ),
          SizedBox(
            height: widget.bannerHeight + Screen.instance.pageHmargin,
          ),
        ],
      ),
    );
  }

  _buildTitle(int count) {
    final int imageIndex = Random().nextInt(8);
    double imageHeight =
        (Screen.instance.isSmallScreen() ? 80 : 120.0) * Screen.instance.scale;
    imageHeight *= count > 5 ? 0.5 : 1;
    return Column(
      children: <Widget>[
        SizedBox(
          height: Screen.instance.marginLarge,
        ),
        Image.asset(
          'assets/images/finish$imageIndex.png',
          height: imageHeight,
          fit: BoxFit.scaleDown,
        ),
        SizedBox(
          height: Screen.instance.marginLarge,
        ),
        Text(
          '本次学习$count个',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Screen.instance.fontSizeTitle1,
            color: Color(0xff666666),
          ),
        ),
      ],
    );
  }

  _buildFinishCloseButton() {
    return FilledAnimatedButton.primary(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            MemofLocalizations.of(context).close,
            style: TextStyle(
              color: Colors.white,
              fontSize: Screen.instance.fontSizeButton,
            ),
          )
        ],
      ),
      padding:
          EdgeInsets.symmetric(vertical: LayoutConst.buttonTextVerticlePadding),
      onTap: _onFinished,
    );
  }

  _onFinished() {
    widget.onClose();
  }

  _buildKrList(List<Kr> krs) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemBuilder: (BuildContext context, int index) {
        Kr akr = krs[index];
        return ListTile(
          key: Key(akr.mid),
          contentPadding: EdgeInsets.symmetric(
              vertical: Screen.instance.marginSmall,
              horizontal: Screen.instance.pageHmargin),
          title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        akr.question,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Screen.instance.fontSizeTitle3,
                          color: Color(0xff444444),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        akr.answer,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Screen.instance.fontSizeCaption,
                          color: Color(0xff888888),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        );
      },
      itemCount: krs.length,
    );
  }
}
