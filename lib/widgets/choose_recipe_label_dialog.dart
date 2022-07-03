import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe_label.dart';

class ChooseRecipeLabelDialog extends StatefulWidget {
  final RecipeLabel current;
  final List<RecipeLabel> labels;
  final void Function(RecipeLabel selected) onSelectSort;

  ChooseRecipeLabelDialog({
    this.current,
    this.labels,
    this.onSelectSort,
  });
  @override
  _ChooseRecipeLabelDialogState createState() =>
      _ChooseRecipeLabelDialogState();

  static Future<void> showChooseRecipeSortDialog({
    BuildContext context,
    RecipeLabel current,
    List<RecipeLabel> labels,
    Function(RecipeLabel selected) onSelectSort,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ChooseRecipeLabelDialog(
          current: current,
          labels: labels,
          onSelectSort: onSelectSort,
        );
      },
    );
  }
}

class _ChooseRecipeLabelDialogState extends State<ChooseRecipeLabelDialog> {
  void selectOption(RecipeLabel selected) {
    Navigator.of(context).pop();
    widget.onSelectSort(selected);
  }

  Widget buildLabelOption(RecipeLabel label, int index) {
    return ListTile(
      title: Text(label.title),
      leading: Radio<RecipeLabel>(
        key: Key('${Keys.chooseRecipeLabelDialogOption}-$index'),
        value: label,
        groupValue: widget.current,
        onChanged: selectOption,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).filter_by_label),
      content: SingleChildScrollView(
        child: ListBody(
          children:
              widget.labels
                  .asMap()
                  .entries
                  .map<Widget>(
                    (entry) => buildLabelOption(entry.value, entry.key),
                  )
                  .toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          key: Key(Keys.chooseRecipeLabelDialogClear),
          child: Text(AppLocalizations.of(context).clean),
          onPressed: () {
            selectOption(null);
          },
        ),
      ],
    );
  }
}
