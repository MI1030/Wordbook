import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../styles/screen.dart';
import '../../localizations.dart';
import '../../models/kr.dart';
import '../../blocs/editor_bloc.dart';
import '../../models/mem.dart';
import '../widgets/memof_alert.dart';

class EditorPage extends StatefulWidget {
  final int kbaseId;
  final Mem mem;
  final Kr kr;

  EditorPage({this.kbaseId, this.mem, this.kr});

  @override
  State<StatefulWidget> createState() {
    return _EditorPageState();
  }
}

class _EditorPageState extends State<EditorPage> {
  TextEditingController _questionController = new TextEditingController();
  TextEditingController _answerController = new TextEditingController();
  TextEditingController _samplesController = new TextEditingController();
  EditorBloc _bloc;
  GlobalKey _scaffoldKey = GlobalKey();

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = EditorBloc(mem: widget.mem, kr: widget.kr);
      int kbaseId;
      _questionController.text = widget.kr.question;
      _answerController.text = widget.kr.answer;
      _samplesController.text = widget.kr.samples;
      kbaseId = widget.mem.kbase;
      _bloc.setKbase(kbaseId);
    }

    return WillPopScope(
      onWillPop: _requestPop,
      child: _buildPage(),
    );
  }

  Widget _buildPage() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(Screen.instance.pageHmargin),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: Screen.instance.marginMedium,
              ),
              _buildQuestion(),
              SizedBox(
                height: Screen.instance.marginMedium,
              ),
              _buildMyInterpret(),
              SizedBox(
                height: Screen.instance.marginMedium,
              ),
              _buildMySamples(),
            ],
          ),
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      title: Text(MemofLocalizations.of(context).edit),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () {
            _onSave(context);
          },
        )
      ],
    );
  }

  _onSave(BuildContext context) async {
    var data = _data();
    if (_bloc.needSave(data)) {
      await _bloc.save(data);
      final snackBar =
          SnackBar(content: Text(MemofLocalizations.of(context).saveSucceeded));
      (_scaffoldKey.currentState as ScaffoldState).showSnackBar(snackBar);
    } else {
      String msg = '';
      if (_questionController.text.trim().length == 0) {
        msg = _bloc.kbase.value.questionTitle +
            MemofLocalizations.of(context).cannotEmpty;
      } else {
        msg = MemofLocalizations.of(context).noNeedSave;
      }
      final snackBar = SnackBar(content: Text(msg));
      (_scaffoldKey.currentState as ScaffoldState).showSnackBar(snackBar);
    }
  }

  Widget _buildQuestion() {
    return StreamBuilder(
      stream: _bloc.kbase,
      builder: (context, AsyncSnapshot<KbaseData> snapshot) {
        if (snapshot.hasData) {
          return TextField(
            controller: _questionController,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            maxLength: 500,
            maxLines: snapshot.data.questionLines,
            decoration: InputDecoration(
              labelText: snapshot.data.questionTitle,
              labelStyle: TextStyle(color: Color(0xff888888)),
              filled: true,
              fillColor: Colors.white,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildMyInterpret() {
    return StreamBuilder(
      stream: _bloc.kbase,
      builder: (context, AsyncSnapshot<KbaseData> snapshot) {
        if (snapshot.hasData) {
          return TextField(
            controller: _answerController,
            keyboardType: TextInputType.multiline,
            maxLength: 2000,
            maxLines: snapshot.data.answerLines,
            decoration: InputDecoration(
              labelText: snapshot.data.answerTitle,
              labelStyle: TextStyle(color: Color(0xff888888)),
              filled: true,
              fillColor: Colors.white,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildMySamples() {
    return StreamBuilder(
      stream: _bloc.kbase,
      builder: (context, AsyncSnapshot<KbaseData> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              TextField(
                controller: _samplesController,
                keyboardType: TextInputType.multiline,
                maxLength: 2000,
                maxLines: snapshot.data.samplesLines,
                decoration: InputDecoration(
                  labelText: snapshot.data.samplesTitle,
                  labelStyle: TextStyle(color: Color(0xff888888)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Future<bool> _requestPop() async {
    if (_bloc.needSave(_data())) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MemofAlert(
            content: MemofLocalizations.of(context).saveOrNot,
            buttonTitles: ['Yes', 'No'],
            buttonActions: [
              _onYes,
              _onNo,
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  _onYes() async {
    await _save();
    Navigator.of(context).pop();
  }

  _onNo() {
    Navigator.of(context).pop();
  }

  SaveParams _data() {
    final question = _questionController.text;
    final answer = _answerController.text;
    final samples = _samplesController.text;
    return SaveParams(question: question, answer: answer, samples: samples);
  }

  _save() async {
    var data = _data();
    if (_bloc.needSave(data)) {
      await _bloc.save(data);
      final snackBar =
          SnackBar(content: Text(MemofLocalizations.of(context).saveSucceeded));
      (_scaffoldKey.currentState as ScaffoldState).showSnackBar(snackBar);
    }
  }
}
