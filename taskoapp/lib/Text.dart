import 'package:flutter/material.dart';

class AppBoldText extends StatefulWidget{
  const AppBoldText({
    Key key,
    this.text,
  }) : super(key: key);
  final String text;
  _AppBoldTextState createState() => _AppBoldTextState();

}

class _AppBoldTextState extends State<AppBoldText> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(widget.text, style: TextStyle(
        fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'OpenSans'),);
  }
}