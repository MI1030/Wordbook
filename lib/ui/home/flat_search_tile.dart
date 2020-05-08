import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../colors.dart';
import '../../localizations.dart';
import '../../blocs/app_bloc.dart';
import '../styles/screen.dart';

class FlatSearchTile extends StatelessWidget {
  FlatSearchTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MemofColors.accent,
      padding: EdgeInsets.symmetric(
        horizontal: Screen.instance.scale * 10,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: Screen.instance.marginMedium,
          ),
          Flexible(
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color(0x44aacccc),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _buildDictButton(context),
              ),
              onTap: () async {
                await Navigator.pushNamed(context, '/dict');
                await Future.delayed(Duration(milliseconds: 1));
                BlocProvider.getBloc<AppBloc>().updateHomePageData();
              },
            ),
          ),
          SizedBox(
            height: Screen.instance.marginLarge,
          ),
        ],
      ),
    );
  }

  _buildDictButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildSearchIcon(),
        SizedBox(
          width: Screen.instance.marginSmall,
        ),
        Text(
          MemofLocalizations.of(context).searchDictAddToVocab,
          style: TextStyle(
            fontSize: Screen.instance.fontSizeBody,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  _buildSearchIcon() {
    return SvgPicture.asset(
      'assets/icons/Search_48_s.svg',
      width: Screen.instance.iconMedium,
      height: Screen.instance.iconMedium,
      color: Colors.white,
    );
  }

  _buildSearchIcon1() {
    return Icon(Icons.search,
        size: Screen.instance.iconXLarge, color: Colors.white);
  }
}
