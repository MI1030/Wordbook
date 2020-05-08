import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../colors.dart';
import '../../utils/er_log.dart';
import '../../blocs/review_tile_bloc.dart';
import '../../blocs/app_bloc.dart';
import '../../blocs/review_bloc.dart';
import '../../localizations.dart';
import '../review/review_page.dart';
import '../widgets/memof_alert.dart';
import '../styles/screen.dart';

class ReviewTile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ReviewTileState();
  }
}

class _ReviewTileState extends State<ReviewTile> {
  ReviewTileBloc _bloc;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      resumeCallBack: () {
        AppBloc bloc = BlocProvider.getBloc<AppBloc>();
        if (bloc.memDbReady.value != null && bloc.memDbReady.value) {
          _bloc.updateCount();
        }
      },
      suspendingCallBack: () {},
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = BlocProvider.getBloc<AppBloc>().reviewTileBloc;

      AppBloc appBloc = BlocProvider.getBloc<AppBloc>();
      appBloc.memDbReady.listen((v) {
        if (v != null && v) {
          _bloc.updateCount();
        }
      });
    }

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            flex: 10,
            child: Container(),
          ),
          Flexible(
            flex: 100,
            child: _buildArc(),
          ),
          Flexible(
            flex: 6,
            child: Container(),
          ),
          _buildBigReviewButton(),
          Flexible(
            flex: 10,
            child: Container(),
          ),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xffeeeeee),
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _buildTodayBlock(),
                      flex: 1,
                    ),
                    Expanded(
                      child: _buildTotalBlock(),
                      flex: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayBlock() {
    return Container(
      decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Color(0xffeeeeee)))),
      child: RawMaterialButton(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: _vPadding(),
            ),
            Text(
              MemofLocalizations.of(context).todayLearn,
              style: TextStyle(fontSize: 12, color: Color(0xff666666)),
            ),
            SizedBox(
              height: 5,
            ),
            _buildTodayCount(),
            SizedBox(
              height: _vPadding(),
            ),
          ],
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/chart/1');
        },
      ),
    );
  }

  Widget _buildTodayCount() {
    return StreamBuilder(
        stream: BlocProvider.getBloc<AppBloc>().memstatBloc.todayStudyCount,
        builder: (context, AsyncSnapshot<int> snapshot) {
          String text = snapshot.data == null ? '0' : '${snapshot.data}';
          return Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Screen.instance.fontSizeBody,
              color: Color(0xff666666),
            ),
          );
        });
  }

  double _vPadding() {
    double ret =
        (Screen.instance.isSmallScreen() ? 16 : 24) * Screen.instance.scale;
    return ret;
  }

  Widget _buildTotalBlock() {
    return RawMaterialButton(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: _vPadding(),
          ),
          Text(
            MemofLocalizations.of(context).totalLearn,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xff666666)),
          ),
          SizedBox(
            height: 5,
          ),
          _buildTotalCount(),
          //_buildTotalTime(),
          SizedBox(
            height: _vPadding(),
          ),
        ],
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/chart/2');
      },
    );
  }

  Widget _buildTotalCount() {
    return StreamBuilder(
        stream: BlocProvider.getBloc<AppBloc>().memstatBloc.totalStudyCount,
        builder: (context, AsyncSnapshot<int> snapshot) {
          String text = snapshot.data == null ? '0' : '${snapshot.data}';
          return Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Screen.instance.fontSizeBody,
              color: Color(0xff666666),
            ),
          );
        });
  }

  Widget _buildArc() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: _bloc.counts,
        builder: (context, AsyncSnapshot<ReviewTileParams> snapshot) {
          int count = 0;
          if (snapshot.hasData) {
            ReviewTileParams params = snapshot.data;
            count = params.review;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Container(),
              ),
              SvgPicture.asset(
                'assets/icons/lightning.svg',
                color: count > 0 ? MemofColors.primary : Color(0xffaaaaaa),
                height: 40 * Screen.instance.scale,
              ),
              SizedBox(
                height: Screen.instance.marginSmall,
              ),
              Container(
                //color: Colors.blue,
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: count > 0 ? Colors.black : Color(0xff666666),
                    fontSize: 70 * Screen.instance.scale,
                    fontFamily: 'Fjalla One',
                  ),
                ),
              ),
              SizedBox(
                height: Screen.instance.marginMedium,
              ),
              Text(
                '复习任务',
                style: TextStyle(
                  color: Color(0xff888888),
                  fontSize: Screen.instance.fontSizeBody,
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBigReviewButton() {
    return RawMaterialButton(
      constraints: BoxConstraints(minHeight: 0, minWidth: 0),
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 4,
          vertical: Screen.instance.marginMedium),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: MemofColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      elevation: 2.0,
      child: Text(
        MemofLocalizations.of(context).start,
        style: TextStyle(
          color: Colors.white,
          fontSize: Screen.instance.fontSizeTitle3,
        ),
      ),
      onPressed: _onReview,
    );
  }

  _onReview() async {
    if (_bloc.counts.value.review > 0) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            tagText: 'ReviewModule',
            blocs: [Bloc((i) => ReviewBloc())],
            child: ReviewPage(),
          ),
        ),
      );
      await Future.delayed(Duration(milliseconds: 1));
      BlocProvider.getBloc<AppBloc>().updateHomePageData();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return MemofAlert(
              content: MemofLocalizations.of(context).noReviewTask,
              buttonTitles: ['Ok'],
            );
          });
    }
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({this.resumeCallBack, this.suspendingCallBack});

  final Function resumeCallBack;
  final Function suspendingCallBack;

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      await suspendingCallBack();
    } else if (state == AppLifecycleState.resumed) {
      await resumeCallBack();
    }
  }
}
