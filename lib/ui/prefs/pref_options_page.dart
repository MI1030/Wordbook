import 'package:flutter/material.dart';

import '../../models/pref_item.dart';

class PrefOptionsPage extends StatefulWidget {
  final PrefItem item;

  PrefOptionsPage({this.item, Key key}) : super(key: key);

  _PrefOptionsPageState createState() => _PrefOptionsPageState();
}

class _PrefOptionsPageState extends State<PrefOptionsPage> {
  PrefItemWithOptions _item;

  @override
  void initState() {
    super.initState();

    _item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(_item.title),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _item.options.length,
          itemBuilder: (context, int index) {
            int value = _item.options[index].value;
            bool isCheck = value == _item.current.value;
            return ListTile(
              title: Text(_item.options[index].text),
              trailing: isCheck ? Icon(Icons.check) : null,
              onTap: () {
                if (!isCheck) {
                  _item.current = _item.options[index];
                  setState(() {});
                }
              },
            );
          },
        ),
      ),
    );
  }
}
