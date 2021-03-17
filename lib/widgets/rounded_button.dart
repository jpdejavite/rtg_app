import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  RoundButton({this.color, this.text, this.onPressed});

  final String text;
  final Color color;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: this.color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: this.onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            this.text,
          ),
        ),
      ),
    );
  }
}
