import 'package:flutter/material.dart';

class TextFormSectionLabelFields extends StatelessWidget {
  final String text;

  TextFormSectionLabelFields(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Theme.of(context).textTheme.caption.color,
        ),
      ),
    );
  }
}
