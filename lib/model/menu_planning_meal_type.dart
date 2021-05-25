import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'menu_planning_meal.dart';

enum MenuPlanningMealType {
  breakfast,
  morgningSnack,
  lunch,
  afternoonSnack,
  dinner,
  supper
}

extension MenuPlanningMealTypeExtension on MenuPlanningMealType {
  String i18n(BuildContext context) {
    if (context == null) {
      // unit test
      return this.index.toString();
    }

    switch (this) {
      case MenuPlanningMealType.breakfast:
        return AppLocalizations.of(context).breakfast;
      case MenuPlanningMealType.morgningSnack:
        return AppLocalizations.of(context).morgning_snack;
      case MenuPlanningMealType.lunch:
        return AppLocalizations.of(context).lunch;
      case MenuPlanningMealType.afternoonSnack:
        return AppLocalizations.of(context).afternoon_snack;
      case MenuPlanningMealType.dinner:
        return AppLocalizations.of(context).dinner;
      case MenuPlanningMealType.supper:
        return AppLocalizations.of(context).supper;
    }

    return "";
  }
}

MenuPlanningMealType defaultMenuPlanningMealTypeOption(
    List<MenuPlanningMeal> meals) {
  List<MenuPlanningMealType> typesByImportance = [
    MenuPlanningMealType.lunch,
    MenuPlanningMealType.dinner,
    MenuPlanningMealType.breakfast,
    MenuPlanningMealType.afternoonSnack,
    MenuPlanningMealType.morgningSnack,
    MenuPlanningMealType.supper
  ];
  if (meals == null) {
    return typesByImportance[0];
  }

  meals.forEach((meal) {
    typesByImportance.remove(meal.type);
  });
  if (typesByImportance.length == 0) {
    return MenuPlanningMealType.lunch;
  }
  return typesByImportance[0];
}
