import 'package:flutter/material.dart';

class ProgressHUD extends StatefulWidget {
  final Color backgroundColor;
  final Color color;
  final Color containerColor;
  final double borderRadius;
  final String text;
  final bool loading;
  _ProgressHUDState state;

  ProgressHUD(
      {Key key,
      this.backgroundColor = Colors.black54,
      this.color = Colors.white,
      this.containerColor = Colors.transparent,
      this.borderRadius = 10.0,
      this.text,
      this.loading = true})
      : super(key: key);

  @override
  _ProgressHUDState createState() => _ProgressHUDState();
}

class _ProgressHUDState extends State<ProgressHUD> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.backgroundColor,
        body: Stack(
          children: <Widget>[
            _getCenterContent(),
          ],
        ));
  }

  Widget _getCenterContent() {
    return Center(
      child: new Container(
        decoration: new BoxDecoration(
          color: Color(0xfff0f0f0),
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        ),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _getCircularProgress(),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: Text(
                widget.text,
                style: TextStyle(color: widget.color),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getCircularProgress() {
    return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(widget.color));
  }
}
