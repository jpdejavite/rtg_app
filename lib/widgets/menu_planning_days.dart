import 'package:flutter/material.dart';
import 'package:rtg_app/helper/date_formatter.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/menu_planning_meal.dart';
import 'package:rtg_app/model/menu_planning_meal_type.dart';
import 'package:rtg_app/model/menu_planning_meal_type_preparation.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/screens/view_recipe_screen.dart';
import 'package:rtg_app/theme/custom_colors.dart';
import 'package:rtg_app/widgets/view_recipe_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuPlannningDays extends StatelessWidget {
  final Map<String, List<MenuPlanningMeal>> days;
  final List<Recipe> menuPlanningRecipes;

  MenuPlannningDays(this.days, this.menuPlanningRecipes);

  Widget buildDayField(BuildContext context, String day, int daysCount) {
    DateTime dayTime = DateTime.parse(day);
    return ViewRecipeText(
      keyString: Keys.menuPlanningDaysDayLabelText + daysCount.toString(),
      text: DateFormatter.getMenuPlanningDayString(dayTime, context),
      hasLabel: false,
      fontWeight: FontWeight.bold,
      hasBullet: false,
      hasPaddingTop: true,
    );
  }

  Widget buildMealPreparationAndTypeField(BuildContext context, int daysCount,
      MenuPlanningMeal meal, int mealIndex) {
    return Container(
        width: 100,
        child: Card(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ListTile(
              title: Text(
                meal.type.i18n(context),
                key: Key(
                    '${Keys.menuPlanningDaysMealTypeText}-$daysCount-$mealIndex'),
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                meal.preparation.i18n(context),
                key: Key(
                    '${Keys.menuPlanningDaysMealPreparationText}-$daysCount-$mealIndex'),
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: CustomColors.primaryColor),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ]),
        ));
  }

  Widget buildMealSideDishText(
      BuildContext context, int daysCount, int mealIndex, int itemIndex) {
    return Text(
      itemIndex == 1
          ? AppLocalizations.of(context).main_course
          : AppLocalizations.of(context).side_dish,
      style: Theme.of(context).textTheme.caption,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      key: Key(
          '${Keys.menuPlanningDaysMealSideDishText}-$daysCount-${mealIndex.toString()}-${itemIndex.toString()}'),
    );
  }

  Widget buildMealRecipeCard(BuildContext context, int daysCount, int mealIndex,
      int itemIndex, String recipeId) {
    Function onTap;
    String recipeTitle;
    menuPlanningRecipes.asMap().forEach((recipeIndex, recipe) {
      if (recipe.id == recipeId) {
        onTap = () async {
          await Navigator.pushNamed(
            context,
            ViewRecipeScreen.id,
            arguments: recipe,
          );
        };
        recipeTitle = recipe.title;
      }
    });
    return InkWell(
        onTap: onTap,
        child: Card(
          key: Key(
              '${Keys.menuPlanningDaysMealCard}-$daysCount-${mealIndex.toString()}-${itemIndex.toString()}'),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  recipeTitle,
                  key: Key(
                      '${Keys.menuPlanningDaysMealRecipeText}-$daysCount-${mealIndex.toString()}-${itemIndex.toString()}'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: CustomColors.primaryColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              buildMealSideDishText(context, daysCount, mealIndex, itemIndex),
            ]),
          ),
        ));
  }

  Widget buildMealDescriptionCard(BuildContext context, int daysCount,
      int mealIndex, int itemIndex, String description) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              description,
              key: Key(
                  '${Keys.menuPlanningDaysMealDescriptionText}-$daysCount-${mealIndex.toString()}-${itemIndex.toString()}'),
              style: Theme.of(context).textTheme.bodyText2,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          buildMealSideDishText(context, daysCount, mealIndex, itemIndex),
        ]),
      ),
    );
  }

  Widget buildMealRecipeOrDescriptionField(BuildContext context, int daysCount,
      int mealIndex, int itemIndex, String recipeId, String description) {
    return Container(
        width: calculateCardCointanerWidth(recipeId, description),
        child: (recipeId != null && recipeId != '')
            ? buildMealRecipeCard(
                context, daysCount, mealIndex, itemIndex, recipeId)
            : buildMealDescriptionCard(
                context, daysCount, mealIndex, itemIndex, description));
  }

  double calculateCardCointanerWidth(String recipeId, String description) {
    if (recipeId != null && recipeId != '') {
      return 150;
    }
    double size = 10 + (description.length / 2 * 10);
    return size < 140 ? 140 : size;
  }

  Widget buildMealField(BuildContext context, int daysCount,
      MenuPlanningMeal meal, int mealIndex) {
    return Container(
      height: 80,
      child: ListView.builder(
        key: Key('${Keys.menuPlanningDaysMealList}-$daysCount-$mealIndex'),
        scrollDirection: Axis.horizontal,
        itemCount: meal.sideDishesCount() + 2,
        itemBuilder: (_, index) {
          if (index == 0) {
            return buildMealPreparationAndTypeField(
                context, daysCount, meal, mealIndex);
          }
          if (index == 1) {
            return buildMealRecipeOrDescriptionField(context, daysCount,
                mealIndex, index, meal.recipeId, meal.description);
          }
          return buildMealRecipeOrDescriptionField(
              context,
              daysCount,
              mealIndex,
              index,
              meal.sideDishes[index - 2].recipeId,
              meal.sideDishes[index - 2].description);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    int daysCount = 0;

    days.forEach((day, meals) {
      children.add(buildDayField(context, day, daysCount));

      meals.asMap().forEach((index, meal) {
        children.add(buildMealField(context, daysCount, meal, index));
      });

      daysCount++;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
