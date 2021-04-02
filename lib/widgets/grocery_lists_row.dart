import 'package:flutter/material.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/grocery_list.dart';

class GroceryListListRow extends StatelessWidget {
  final GroceryList groceryList;
  final int index;
  final void Function(int index) onTap;
  GroceryListListRow({this.onTap, this.groceryList, this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.onTap(index);
      },
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              groceryList.title,
              key: Key(Keys.groceryListRowTitleText + index.toString()),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
