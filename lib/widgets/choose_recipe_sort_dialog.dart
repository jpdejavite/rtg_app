import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe_sort.dart';

class ChooseRecipeSortDialog extends StatefulWidget {
  final RecipeSort current;
  final void Function(RecipeSort selected) onSelectSort;

  ChooseRecipeSortDialog({
    this.current,
    this.onSelectSort,
  });
  @override
  _ChooseRecipeSortDialogState createState() => _ChooseRecipeSortDialogState();

  static Future<void> showChooseRecipeSortDialog({
    BuildContext context,
    RecipeSort current,
    Function(RecipeSort selected) onSelectSort,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ChooseRecipeSortDialog(
          current: current,
          onSelectSort: onSelectSort,
        );
      },
    );
  }
}

class _ChooseRecipeSortDialogState extends State<ChooseRecipeSortDialog> {
  void selectOption(RecipeSort selected) {
    Navigator.of(context).pop();
    widget.onSelectSort(selected);
  }

  Widget buildSortOption(RecipeSort sort, String radioKey) {
    return ListTile(
      onTap: () => {selectOption(sort)},
      title: Text(sort.description(context)),
      leading: Radio<RecipeSort>(
        key: Key(radioKey),
        value: sort,
        groupValue: widget.current,
        onChanged: selectOption,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).sort_by),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            buildSortOption(
                RecipeSort.newest, Keys.chooseRecipeSortDialogNewestRadio),
            buildSortOption(
                RecipeSort.oldest, Keys.chooseRecipeSortDialogOldesRadio),
            buildSortOption(RecipeSort.recentlyUsed,
                Keys.chooseRecipeSortDialogRecentlyUsedRadio),
            buildSortOption(RecipeSort.usedALongTime,
                Keys.chooseRecipeSortDialogUsedALongTimeRadio),
            buildSortOption(
                RecipeSort.faster, Keys.chooseRecipeSortDialogFasterRadio),
            buildSortOption(
                RecipeSort.slower, Keys.chooseRecipeSortDialogSlowerRadio),
            buildSortOption(
                RecipeSort.titleAz, Keys.chooseRecipeSortDialogTitleAzRadio),
            buildSortOption(
                RecipeSort.titleZa, Keys.chooseRecipeSortDialogTitleZaRadio),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          key: Key(Keys.chooseRecipeSortDialogClear),
          child: Text(AppLocalizations.of(context).clean),
          onPressed: () {
            selectOption(null);
          },
        ),
      ],
    );
  }
}
