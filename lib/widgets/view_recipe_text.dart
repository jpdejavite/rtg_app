import 'package:flutter/material.dart';

class ViewRecipeText extends StatelessWidget {
  final String text;
  final bool hasBullet;
  final hasPaddingTop;

  ViewRecipeText({this.text, this.hasBullet, this.hasPaddingTop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: hasPaddingTop ? 5 : 0),
      child: Text(
        hasBullet ? "• " + text : text,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}
