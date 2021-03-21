import 'package:flutter/material.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/widgets/txt.dart';

class ListRow extends StatelessWidget {
  //
  final Recipe recipe;
  ListRow({this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Txt(text: recipe.id + ": " +recipe.title),
          Divider(),
        ],
      ),
    );
  }
}
