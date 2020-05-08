import 'dart:async';
import 'package:flutter/material.dart';

import 'drawer.dart';
import 'review_tile.dart';
import 'flat_search_tile.dart';

import '../../localizations.dart';
import '../../utils/er_log.dart';
import 'landing_bottom_bar.dart';
import 'prepare_dict_progress.dart';
import '../styles/screen.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with RouteAware {
  @override
  Widget build(BuildContext context) {
    Screen.buildInstance(context);

    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomPadding: false,
          drawer: MainDrawer(),
          appBar: _buildAppBar(),
          body: SafeArea(
            child: _buildContent2(),
          ),
          bottomNavigationBar: LandingBottomBar(),
        ),
        PrepareDictProgress(),
      ],
    );
  }

  Widget _buildContent2() {
    return Column(
      children: <Widget>[
        Flexible(flex: 2, child: FlatSearchTile()),
        Flexible(flex: 7, child: ReviewTile()),
      ],
    );
  }

  _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(MemofLocalizations.of(context).title),
      actions: <Widget>[],
      elevation: 0.0,
    );
  }

  @override
  void didPush() {
    ErLog.withTs('didPush');
  }

  @override
  void didPopNext() {
    ErLog.withTs('didPopNext');
  }
}
