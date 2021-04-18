import 'package:flutter/material.dart';

class ViewRecipeText extends StatelessWidget {
  final String text;
  final bool hasBullet;
  final hasPaddingTop;
  final hasLabel;
  final fontWeight;
  final String keyString;

  ViewRecipeText(
      {this.keyString,
      this.text,
      this.hasBullet,
      this.hasPaddingTop,
      this.fontWeight,
      this.hasLabel = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: hasPaddingTop ? 5 : 0),
      child: Text(
        (hasBullet ? (hasLabel ? '    • ' : '• ') : '') + text,
        key: Key(keyString),
        style: Theme.of(context).textTheme.bodyText2.copyWith(
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
