import 'package:flutter/material.dart';

class MemofAlert extends StatelessWidget {
  final String title;
  final String content;
  final List<String> buttonTitles;
  final List<Function> buttonActions;

  const MemofAlert(
      {this.title,
      this.content,
      this.buttonTitles = const [],
      this.buttonActions = const [],
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    for (int i = 0; i < buttonTitles.length; i++) {
      actions.add(
        FlatButton(
          child: Text(buttonTitles[i]),
          onPressed: () {
            Navigator.of(context).pop();
            if (buttonActions.length > i) buttonActions[i]();
          },
        ),
      );
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: this.title == null ? null : Text(this.title),
      content: this.content == null ? null : Text(this.content),
      actions: actions,
    );
  }
}
