import 'package:flutter/material.dart';
import 'package:rtg_app/keys/keys.dart';

class ViewRecipeTitle extends StatelessWidget {
  final String text;

  ViewRecipeTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Text(
        text,
        key: Key(Keys.viewRecipeTitle),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }
}
