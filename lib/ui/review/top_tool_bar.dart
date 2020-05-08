import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../localizations.dart';
import '../../ui/styles/screen.dart';
import '../../blocs/review_bloc.dart';
import '../../utils/last_time_format.dart';
import '../../models/kbase.dart';
import 'review_const.dart';

class TopToolBar extends StatefulWidget {
  TopToolBar({Key key}) : super(key: key);

  _TopToolBarState createState() => _TopToolBarState();
}

class _TopToolBarState extends State<TopToolBar> {
  @override
  Widget build(BuildContext context) {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    return StreamBuilder(
      stream: bloc.showKrStatus,
      builder: (context, snapshot) {
        bool showKrStatus = false;
        if (snapshot.hasData) {
          showKrStatus = snapshot.data;
        }
        if (showKrStatus) {
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  _buildFamiliarity(),
                ],
              ),
              Divider(),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildFamiliarity() {
    ReviewBloc bloc = ReviewConst.reviewBloc;
    return StreamBuilder(
      stream: bloc.familiarity,
      builder: (context, AsyncSnapshot<FamiliarityParams> snapshot) {
        if (snapshot.hasData) {
          FamiliarityParams params = snapshot.data;
          double progress = 0;
          String lastLearn = '';
          if (params != null) {
            progress = params.progress.clamp(0.0, 1.0);
            lastLearn = LastTimeFormat.lastLearnTime(params.ts, params.learned);
          }
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: Screen.instance.pageHmargin,
                left: Screen.instance.pageHmargin,
                right: Screen.instance.pageHmargin),
            child: Row(
              children: <Widget>[
                Text(
                  MemofLocalizations.of(context).familarity + ': ',
                  style: TextStyle(
                      fontSize: Screen.instance.fontSizeFootnote,
                      color: Color(0xff888888)),
                ),
                CircularPercentIndicator(
                  radius: 14.0,
                  lineWidth: 2.0,
                  percent: progress,
                  backgroundColor: Color(0xffcccccc),
                  progressColor: Color(0xff888888),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  MemofLocalizations.of(context).lastTime + ': ' + lastLearn,
                  style: TextStyle(
                      fontSize: Screen.instance.fontSizeFootnote,
                      color: Color(0xff888888)),
                ),
                Expanded(
                  child: Container(),
                ),
                Text(
                  Kbase.kbaseOfIid(params.kbaseId).name,
                  style: TextStyle(
                      fontSize: Screen.instance.fontSizeFootnote,
                      color: Color(0xff888888)),
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
}
