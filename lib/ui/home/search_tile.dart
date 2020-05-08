import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../../localizations.dart';
import '../../blocs/app_bloc.dart';
import 'panel_shadow.dart';
import '../styles/screen.dart';

class SearchTile extends StatelessWidget {
  SearchTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(Screen.instance.pageHmargin),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color(0xffeeeeee),
        borderRadius: BorderRadius.circular(10),
        boxShadow: PanelShadow.box,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: Screen.instance.marginMedium),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildDictButton(context),
        ],
      ),
    );
  }

  _buildDictButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffaaaaaa)),
          shape: BoxShape.rectangle,
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.search,
              size: Screen.instance.iconMedium,
              color: Color(0xff666666),
            ),
            SizedBox(
              width: Screen.instance.marginSmall,
            ),
            Text(
              MemofLocalizations.of(context).searchDictAddToVocab,
              style: TextStyle(
                  fontSize: Screen.instance.fontSizeBody,
                  color: Color(0xff666666)),
            ),
          ],
        ),
      ),
      onTap: () async {
        await Navigator.pushNamed(context, '/dict');
        await Future.delayed(Duration(milliseconds: 1));
        BlocProvider.getBloc<AppBloc>().updateHomePageData();
      },
    );
  }
}
