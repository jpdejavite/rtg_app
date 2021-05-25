import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum MenuPlanningMealPreparation { cook, leftovers, eatOut, orderFood, other }

extension MenuPlanningMealPreparationExtension on MenuPlanningMealPreparation {
  String i18n(BuildContext context) {
    if (context == null) {
      // unit test
      return this.index.toString();
    }

    switch (this) {
      case MenuPlanningMealPreparation.cook:
        return AppLocalizations.of(context).cook;
      case MenuPlanningMealPreparation.leftovers:
        return AppLocalizations.of(context).leftovers;
      case MenuPlanningMealPreparation.eatOut:
        return AppLocalizations.of(context).eat_out;
      case MenuPlanningMealPreparation.orderFood:
        return AppLocalizations.of(context).order_food;
      case MenuPlanningMealPreparation.other:
        return AppLocalizations.of(context).other;
    }

    return "";
  }
}
