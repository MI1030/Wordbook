import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:app_review/app_review.dart';
import 'package:flutter/cupertino.dart';

import '../styles/screen.dart';
import '../../localizations.dart';
import '../../models/pref_item.dart';
import '../../blocs/prefs_page_bloc.dart';
import 'pref_options_page.dart';

class PrefsPage extends StatefulWidget {
  PrefsPage({Key key}) : super(key: key);

  _PrefsPageState createState() => _PrefsPageState();
}

class _PrefsPageState extends State<PrefsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(MemofLocalizations.of(context).settings),
      ),
      body: SafeArea(
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    PrefsPageBloc bloc =
        BlocProvider.tag('PrefsModule').getBloc<PrefsPageBloc>();
    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<List<PrefItem>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              PrefItem item = snapshot.data[index];
              if (item is PrefItemWithOptions) {
                return ListTile(
                  title: Text(item.title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(item.current.text),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PrefOptionsPage(
                            item: item,
                          );
                        },
                      ),
                    );
                    bloc.save(SaveData(current: item.current, index: index));
                  },
                );
              } else if (item is PrefItemHeader) {
                return Container(
                  color: Color(0xffeeeeee),
                  height: Screen.instance.marginLarge,
                );
              } else if (item is PrefItemSwitch) {
                return ListTile(
                  title: Text(item.title),
                  trailing: _buildSwitch(item),
                );
              } else if (item is PrefItemInfo) {
                return ListTile(
                  title: Text(item.title),
                  trailing: Text(item.info),
                );
              } else if (item is PrefItemCmd) {
                return ListTile(
                  title: Text(item.title),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    if (item.cmd == PrefCmd.rating) {
                      _onRating();
                    } else if (item.cmd == PrefCmd.feedback) {
                      _onFeedback();
                    }
                  },
                );
              } else {
                return Container();
              }
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  _onRating() async {
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

  _onFeedback() async {}

  Widget _buildSwitch(PrefItemSwitch item) {
    PrefsPageBloc bloc =
        BlocProvider.tag('PrefsModule').getBloc<PrefsPageBloc>();
    if (Platform.isIOS) {
      return CupertinoSwitch(
        value: item.isOn,
        onChanged: (bool v) {
          var newpref =
              PrefItemSwitch(index: item.index, isOn: v, title: item.title);
          bloc.saveSwitch(newpref);
        },
      );
    } else {
      return Switch(
        value: item.isOn,
        onChanged: (bool v) {
          var newpref =
              PrefItemSwitch(index: item.index, isOn: v, title: item.title);
          bloc.saveSwitch(newpref);
        },
      );
    }
  }
}
