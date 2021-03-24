import 'package:flutter/material.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe.dart';

class RecipeListRow extends StatelessWidget {
  final Recipe recipe;
  final int index;
  RecipeListRow({this.recipe, this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe.title,
            key: Key(Keys.recipeListRowTitleText + index.toString()),
          ),
          Divider(),
        ],
      ),
    );
  }
}
