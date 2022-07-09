import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';

import '../helper/date_formatter.dart';

class ChooseMenuPlanningDayDialog extends StatefulWidget {
  final String title;
  final List<DateTime> days;
  final void Function(int selected) onSelectDay;

  ChooseMenuPlanningDayDialog({
    this.title,
    this.days,
    this.onSelectDay,
  });
  @override
  _ChooseMenuPlanningDayDialogState createState() =>
      _ChooseMenuPlanningDayDialogState();

  static Future<void> showChooseMenuPlanningDayDialog({
    String title,
    BuildContext context,
    List<DateTime> days,
    void Function(int selected) onSelectDay,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ChooseMenuPlanningDayDialog(
          title: title,
          days: days,
          onSelectDay: onSelectDay,
        );
      },
    );
  }
}

class _ChooseMenuPlanningDayDialogState
    extends State<ChooseMenuPlanningDayDialog> {
  void selectOption(int selected) {
    Navigator.of(context).pop();
    widget.onSelectDay(selected);
  }

  Widget buildDayOption(DateTime day, int index) {
    return ListTile(
      key: Key('${Keys.chooseMenuPlanningDayDialogOption}-$index'),
      onTap: () => {selectOption(index)},
      title: Text(DateFormatter.getMenuPlanningDayString(day, context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            ...widget.days.asMap().entries.map<Widget>((entry) {
              int index = entry.key;
              DateTime day = entry.value;
              return buildDayOption(day, index);
            }).toList()
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          key: Key(Keys.chooseMenuPlanningDayDialogCancel),
          child: Text(AppLocalizations.of(context).cancel),
          onPressed: () {
            selectOption(null);
          },
        ),
      ],
    );
  }
}
