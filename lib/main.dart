import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';

import 'ui/home/home_page.dart';
import 'ui/dict/mydict_page.dart';
import 'ui/chart/chart_page.dart';
import 'localizations.dart';

import 'blocs/app_bloc.dart';
import 'blocs/dict_bloc.dart';
import 'colors.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => AppBloc()),
        Bloc((i) => DictBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => MemofLocalizations.of(context).title,
        localizationsDelegates: [
          MyLocalizationsDelegate(),
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: MyLanguages.map((language) => Locale(language, '')),
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: MemofColors.accent,
          scaffoldBackgroundColor: Colors.white,
          buttonColor: MemofColors.primary,
          accentColor: MemofColors.secondary,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            //TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          }),
        ),
        routes: {
          '/': (BuildContext context) => HomePage(),
          '/dict': (BuildContext context) => MyDictPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }

          final routeName = pathElements[1];
          if (routeName == 'chart') {
            final String period = pathElements[2];
            return MaterialPageRoute<bool>(builder: (BuildContext context) {
              return ChartPage(int.parse(period));
            });
          }

          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => HomePage(),
          );
        },
      ),
    );
  }
}
