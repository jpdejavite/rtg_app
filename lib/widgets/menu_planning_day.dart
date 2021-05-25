import 'package:flutter/material.dart';
import 'package:rtg_app/helper/date_formatter.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuPlanningDay extends StatelessWidget {
  final DateTime day;
  final int index;
  final void Function() onAddMeal;
  MenuPlanningDay({
    this.index,
    this.day,
    this.onAddMeal,
  });

  @override
  Widget build(BuildContext context) {
    return  Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              DateFormatter.getMenuPlanningDayString(day, context),
              key: Key('${Keys.menuPlanningDayText}-$index'),
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          TextButton(
            key: Key('${Keys.menuPlanningDayAddMealButton}-$index'),
            child: Text(AppLocalizations.of(context).add_meal),
            onPressed: onAddMeal,
          ),
        ],
      );
  }
}
