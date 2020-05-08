import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../styles/screen.dart';
import '../achieve/achieve_page.dart';
import '../../blocs/app_bloc.dart';
import '../../localizations.dart';
import '../editor/editor_page.dart';
import '../../blocs/prefs_page_bloc.dart';
import '../prefs/prefs_page.dart';

class LandingBottomBar extends StatelessWidget {
  const LandingBottomBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 0.0,
      elevation: 0.0,
      child: Container(
        height: max(54, 60.0 * Screen.instance.scale),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildSvgBottomBarItem(
              title: MemofLocalizations.of(context).statistics,
              svg: 'assets/icons/Chart-Bars_48.svg',
              onPressed: () {
                Navigator.pushNamed(context, '/chart/1');
              },
            ),
            _buildSvgBottomBarItem(
              title: MemofLocalizations.of(context).list,
              svg: 'assets/icons/List_48.svg',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AchievePage()));
              },
            ),
            _buildSvgBottomBarItem(
              title: MemofLocalizations.of(context).settings,
              svg: 'assets/icons/Settings_48.svg',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return BlocProvider(
                      tagText: 'PrefsModule',
                      blocs: [Bloc((i) => PrefsPageBloc())],
                      child: PrefsPage(),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBarItem(
      {String title, IconData icon, Function onPressed, Color iconColor}) {
    return RawMaterialButton(
      constraints:
          BoxConstraints(minHeight: 0, minWidth: 70 * Screen.instance.scale),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: Screen.instance.iconMedium,
              color: iconColor ?? Color(0xff555555),
            ),
            SizedBox(
              height: Screen.instance.marginxSmall,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Color(0xff666666),
                  fontSize: Screen.instance.fontSizeFootnote),
            ),
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildSvgBottomBarItem(
      {String title, String svg, Function onPressed, Color iconColor}) {
    return RawMaterialButton(
      constraints:
          BoxConstraints(minHeight: 0, minWidth: 70 * Screen.instance.scale),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: Screen.instance.marginxSmall,
            ),
            SvgPicture.asset(
              svg,
              width: Screen.instance.iconSmall,
              height: Screen.instance.iconSmall,
              color: iconColor ?? Color(0xff555555),
            ),
            SizedBox(
              height: Screen.instance.marginxSmall,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Color(0xff666666),
                  fontSize: Screen.instance.fontSizeFootnote),
            ),
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }

  _onAdd(context) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EditorPage();
    }));
    await Future.delayed(Duration(milliseconds: 1));
    BlocProvider.getBloc<AppBloc>().updateHomePageData();
  }
}
