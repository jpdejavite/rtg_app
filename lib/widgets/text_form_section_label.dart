import 'package:flutter/material.dart';

class TextFormSectionLabelFields extends StatefulWidget {
  final String text;

  TextFormSectionLabelFields(this.text);
  @override
  _TextFormSectionLabelFieldsState createState() =>
      _TextFormSectionLabelFieldsState();
}

class _TextFormSectionLabelFieldsState
    extends State<TextFormSectionLabelFields> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        widget.text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Theme.of(context).textTheme.caption.color,
        ),
      ),
    );
  }
}
