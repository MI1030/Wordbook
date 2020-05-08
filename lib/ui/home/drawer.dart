import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:app_review/app_review.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../blocs/app_bloc.dart';
import '../../localizations.dart';
import '../../biz/server_config.dart';
import '../../biz/app_pref.dart';
import '../styles/screen.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainDrawer();
}

class _MainDrawer extends State<MainDrawer> {
  String _appID;

  @override
  void initState() {
    super.initState();
    AppReview.getAppID.then((onValue) {
      setState(() {
        _appID = onValue;
      });
      print("App ID" + _appID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          _buildUserTile(),
          _buildFeedbackTile(),

          if (Platform.isIOS)
            _buildRatingTile(),

          //_buildPrefsTile(),
          _buildAppVersionTile(),
        ],
      ),
    );
  }

  _buildUserTile() {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.all(Screen.instance.pageHmargin),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Text(
                '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Screen.instance.fontSizeBody,
                ),
              ),
              SizedBox(
                height: Screen.instance.pageHmargin,
              ),
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + Screen.instance.pageHmargin,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: Screen.instance.pageHmargin,
              ),
              Text(
                _username(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Screen.instance.fontSizeTitle3,
                ),
              ),
              SizedBox(
                width: Screen.instance.pageHmargin,
              ),
            ],
          ),
        )
      ],
    );
  }

  _username() {
    String ret = MemofLocalizations.of(context).guest;
    return ret;
  }

  _buildFeedbackTile() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.mail),
          title: Text(
            MemofLocalizations.of(context).feedback,
            style: TextStyle(fontSize: Screen.instance.fontSizeBody),
          ),
          onTap: () {
            Navigator.pop(context);
            _onFeedback();
          },
        ),
        Divider(),
      ],
    );
  }

  _buildRatingTile() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.star_half),
          title: Text(
            MemofLocalizations.of(context).rating,
            style: TextStyle(fontSize: Screen.instance.fontSizeBody),
          ),
          onTap: () {
            Navigator.pop(context);
            _onRating();
          },
        ),
        Divider(),
      ],
    );
  }

  _buildAppVersionTile() {
    return StreamBuilder(
      stream: BlocProvider.getBloc<AppBloc>().appVersion,
      builder: (context, snapshot) {
        return ListTile(
          title: Text(
            snapshot.data == null
                ? ''
                : MemofLocalizations.of(context).version + ': ' + snapshot.data,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: Screen.instance.fontSizeCaption),
          ),
        );
      },
    );
  }

  _onFeedback() async {
    String appName = await AppPref.appName;
    String title = MemofLocalizations.of(context).feedback;
    String body = MemofLocalizations.of(context).feedbackBody(appName);
    List<String> receivers = [ServerConfig.feedbackMail];
    final MailOptions mailOptions = MailOptions(
      body: body,
      subject: title,
      recipients: receivers,
      isHTML: true,
    );

    await FlutterMailer.send(mailOptions);
  }

  _onRating() async {
    var sysVersion = await AppPref.systemVersion;
    print('sysVersion: $sysVersion');
    if (Platform.isIOS) {
      AppReview.requestReview.then((onValue) {
        print(onValue);
      });
    } else {
      AppReview.writeReview.then((onValue) {
        print(onValue);
      });
    }
  }

  _onHelp() async {
    const url = 'http://www.easyrote.jp/help.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) {
    //       return HtmlViewPage();
    //     },
    //   ),
    // );
  }
}
