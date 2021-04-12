import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/grocery_list.dart';

class ChooseGroceryListToRecipeDialog extends StatefulWidget {
  final List<GroceryList> groceryLists;
  final void Function(GroceryList groceryList) onSelectGroceryList;

  ChooseGroceryListToRecipeDialog({
    this.groceryLists,
    this.onSelectGroceryList,
  });
  @override
  _AddRecipeToGroceryListDialogState createState() =>
      _AddRecipeToGroceryListDialogState();

  static Future<void> showChooseGroceryListToRecipeDialog({
    BuildContext context,
    List<GroceryList> groceryLists,
    Function(GroceryList groceryList) onSelectGroceryList,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ChooseGroceryListToRecipeDialog(
          onSelectGroceryList: onSelectGroceryList,
          groceryLists: groceryLists,
        );
      },
    );
  }
}

class _AddRecipeToGroceryListDialogState
    extends State<ChooseGroceryListToRecipeDialog> {
  @override
  Widget build(BuildContext context) {
    List<Widget> groceriesWidgets = [];
    widget.groceryLists.asMap().forEach((i, groceryList) {
      groceriesWidgets.add(TextButton(
          key: Key(Keys.viewRecipeGroceryListToSelect + i.toString()),
          child: Text(groceryList.title),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onSelectGroceryList(groceryList);
          }));
    });

    return AlertDialog(
      title: Text(AppLocalizations.of(context).choose_a_grocery_list),
      content: SingleChildScrollView(
        child: ListBody(
          children: groceriesWidgets,
        ),
      ),
      actions: <Widget>[
        TextButton(
          key: Key(Keys.viewRecipeCreateNewGroceryListAction),
          child: Text(AppLocalizations.of(context).create_a_new_grocery_list),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onSelectGroceryList(null);
          },
        ),
      ],
    );
  }
}
