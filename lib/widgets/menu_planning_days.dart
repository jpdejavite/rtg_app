import 'package:flutter/material.dart';
import 'package:rtg_app/helper/date_formatter.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/menu_planning_meal.dart';
import 'package:rtg_app/model/menu_planning_meal_type.dart';
import 'package:rtg_app/model/menu_planning_meal_type_preparation.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/screens/view_recipe_screen.dart';
import 'package:rtg_app/widgets/view_recipe_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuPlannningDays extends StatelessWidget {
  final Map<String, List<MenuPlanningMeal>> days;
  final List<Recipe> menuPlanningRecipes;

  MenuPlannningDays(this.days, this.menuPlanningRecipes);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    int daysCount = 0;

    days.forEach((day, meals) {
      DateTime dayTime = DateTime.parse(day);

      children.add(ViewRecipeText(
        keyString: Keys.menuPlanningDaysDayLabelText + daysCount.toString(),
        text: DateFormatter.getMenuPlanningDayString(dayTime, context),
        hasLabel: false,
        fontWeight: FontWeight.bold,
        hasBullet: false,
        hasPaddingTop: true,
      ));

      meals.asMap().forEach((index, meal) {
        MenuPlanningMealType type = meal.type;
        MenuPlanningMealPreparation preparation = meal.preparation;
        String mealText = '${type.i18n(context)}: ${preparation.i18n(context)}';
        Widget subtitle =
            buildSubtitle(meal.description, daysCount, index, context);
        Widget seeRecipeButton;
        if (meal.recipeId != null && meal.recipeId != '') {
          menuPlanningRecipes.asMap().forEach((recipeIndex, recipe) {
            if (recipe.id == meal.recipeId) {
              subtitle = buildSubtitle(recipe.title, daysCount, index, context);
              seeRecipeButton = TextButton(
                  key: Key(
                      '${Keys.menuPlanningDaysMealTextButton}-$daysCount-${index.toString()}'),
                  onPressed: () async {
                    await Navigator.pushNamed(
                      context,
                      ViewRecipeScreen.id,
                      arguments: recipe,
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context).see_recipe,
                    key: Key(
                        '${Keys.menuPlanningDaysMealRecipeText}-$daysCount-${index.toString()}'),
                  ));
            }
          });
        }
        children.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mealText,
                        key: Key(
                            '${Keys.menuPlanningDaysMealText}-$daysCount-${index.toString()}'),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: subtitle,
                      )
                    ],
                  ),
                ),
                seeRecipeButton == null ? SizedBox() : seeRecipeButton
              ],
            ),
          ),
        );
      });

      daysCount++;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget buildSubtitle(
      String text, int daysCount, int index, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.caption,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      key: Key(
          '${Keys.menuPlanningDaysMealDescriptionText}-$daysCount-${index.toString()}'),
    );
  }
}
