import 'package:flutter/material.dart';

import 'package:rtg_app/model/recipe.dart';

import '../../helper/date_formatter.dart';
import '../../model/menu_planning.dart';
import '../../model/menu_planning_meal.dart';
import '../menu_planning_days.dart';
import 'home_card.dart';

class HomeMenuPlanningCard extends HomeCard {
  final MenuPlanning currentMenuPlanning;
  final List<Recipe> currentMenuPlanningRecipes;

  HomeMenuPlanningCard({
    cardKey,
    actionKey,
    title,
    action,
    onAction,
    secundaryActionKey,
    secundaryAction,
    onSecundaryAction,
    this.currentMenuPlanning,
    this.currentMenuPlanningRecipes,
  }) : super(
          cardKey: cardKey,
          actionKey: actionKey,
          title: title,
          action: action,
          onAction: onAction,
          secundaryActionKey: secundaryActionKey,
          secundaryAction: secundaryAction,
          onSecundaryAction: onSecundaryAction,
        );

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }

  Widget buildExtraWidget(BuildContext context) {
    return Padding(
      child: buildCurrentMenuPlanningWidgets(context),
      padding: EdgeInsets.only(left: 16),
    );
  }

  Widget buildCurrentMenuPlanningWidgets(BuildContext context) {
    final Map<String, List<MenuPlanningMeal>> days = Map();
    String now =
        DateFormatter.formatDate(DateTime.now(), MenuPlanning.dateFormat);
    currentMenuPlanning.days.forEach((day, meals) {
      if (days.length < 2 && day.compareTo(now) >= 0) {
        days[day] = meals;
      }
    });

    return MenuPlannningDays(days, currentMenuPlanningRecipes);
  }
}
