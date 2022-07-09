import 'package:flutter/material.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/model/menu_planning_meal.dart';
import 'package:rtg_app/model/menu_planning_meal_input_action.dart';
import 'package:rtg_app/model/menu_planning_meal_type.dart';
import 'package:rtg_app/model/menu_planning_meal_type_preparation.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/screens/choose_recipe_screen.dart';

class MenuPlanningMealInput extends StatefulWidget {
  final MenuPlanningMeal meal;
  final String uniqueIndex;
  final void Function(MenuPlanningMealInputAction action) onActionPressed;
  final void Function(MenuPlanningMeal newMeal) onUpdate;
  final List<Recipe> lastUsedGroceryListRecipes;
  final List<Recipe> menuPlanningRecipes;
  MenuPlanningMealInput({
    this.meal,
    this.uniqueIndex,
    this.onActionPressed,
    this.onUpdate,
    this.lastUsedGroceryListRecipes,
    this.menuPlanningRecipes,
  });
  @override
  State<MenuPlanningMealInput> createState() => _MenuPlanningMealInputState();
}

class _MenuPlanningMealInputState extends State<MenuPlanningMealInput> {
  TextEditingController _detailsController;
  bool showDetailsField = false;
  Recipe choosenRecipe;

  @override
  void initState() {
    super.initState();
    _detailsController = TextEditingController();
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Widget buildMealTypeDropdown() {
    return DropdownButton<MenuPlanningMealType>(
      value: widget.meal.type,
      icon: const Icon(Icons.expand_more),
      iconSize: 24,
      elevation: 16,
      onChanged: (MenuPlanningMealType newValue) {
        setState(() {
          widget.meal.type = newValue;
          widget.onUpdate(widget.meal);
        });
      },
      items: MenuPlanningMealType.values
          .map<DropdownMenuItem<MenuPlanningMealType>>(
              (MenuPlanningMealType value) {
        return DropdownMenuItem<MenuPlanningMealType>(
          value: value,
          child: Text(value.i18n(context)),
        );
      }).toList(),
    );
  }

  Widget buildMealPreparationDropdown() {
    return DropdownButton<MenuPlanningMealPreparation>(
      value: widget.meal.preparation,
      icon: const Icon(Icons.expand_more),
      iconSize: 24,
      elevation: 16,
      onChanged: (MenuPlanningMealPreparation newValue) {
        setState(() {
          widget.meal.preparation = newValue;
          showDetailsField = false;
          if (widget.meal.preparation == MenuPlanningMealPreparation.eatOut ||
              widget.meal.preparation ==
                  MenuPlanningMealPreparation.orderFood ||
              widget.meal.preparation == MenuPlanningMealPreparation.other) {
            widget.meal.recipeId = null;
          }
          widget.onUpdate(widget.meal);
        });
      },
      items: MenuPlanningMealPreparation.values
          .map<DropdownMenuItem<MenuPlanningMealPreparation>>(
              (MenuPlanningMealPreparation value) {
        return DropdownMenuItem<MenuPlanningMealPreparation>(
          value: value,
          child: Text(value.i18n(context)),
        );
      }).toList(),
    );
  }

  List<Widget> buildDetailTextField() {
    _detailsController.text = widget.meal.description;
    return [
      Expanded(
        child: TextFormField(
          key: Key(
              '${Keys.menuPlanningWriteDetailsTextField}-${widget.uniqueIndex}'),
          controller: _detailsController,
          onChanged: (value) {
            widget.meal.description = value;
            widget.onUpdate(widget.meal);
          },
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).write_details_hint,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      )
    ];
  }

  void onChooseRecipe() async {
    final result = await Navigator.pushNamed(context, ChooseRecipeScreen.id,
        arguments: widget.lastUsedGroceryListRecipes);
    if (result != null && result is Recipe) {
      setState(() {
        widget.meal.recipeId = result.id;
        choosenRecipe = result;
      });
    }
  }

  List<Widget> buildDetailFields() {
    if (widget.meal.recipeId != null) {
      if (choosenRecipe == null) {
        if (widget.lastUsedGroceryListRecipes != null) {
          widget.lastUsedGroceryListRecipes.forEach((r) {
            if (r.id == widget.meal.recipeId) {
              choosenRecipe = r;
            }
          });
        }

        if (widget.menuPlanningRecipes != null) {
          widget.menuPlanningRecipes.forEach((r) {
            if (r.id == widget.meal.recipeId) {
              choosenRecipe = r;
            }
          });
        }
      }

      if (choosenRecipe != null) {
        return [
          Expanded(
            child: Text(
              choosenRecipe.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          IconButton(onPressed: onChooseRecipe, icon: Icon(Icons.edit)),
        ];
      }
    }

    if (showDetailsField ||
        (widget.meal.description != null && widget.meal.description != "")) {
      return buildDetailTextField();
    }
    if (widget.meal.preparation == MenuPlanningMealPreparation.cook ||
        widget.meal.preparation == MenuPlanningMealPreparation.leftovers) {
      return [
        TextButton(
          key: Key(
              '${Keys.menuPlanningDayPickRecipeTextButton}-${widget.uniqueIndex}'),
          child: Text(AppLocalizations.of(context).pick_recipe),
          onPressed: onChooseRecipe,
        ),
        Expanded(
          child: SizedBox(
            width: 16,
          ),
        ),
        TextButton(
          key: Key(
              '${Keys.menuPlanningWriteDetailsTextButton}-${widget.uniqueIndex}'),
          child: Text(AppLocalizations.of(context).write_details),
          onPressed: () {
            setState(() {
              showDetailsField = true;
            });
          },
        )
      ];
    }

    return buildDetailTextField();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      buildMealTypeDropdown(),
                      Expanded(
                        child: SizedBox(
                          width: 16,
                        ),
                      ),
                      buildMealPreparationDropdown(),
                    ],
                  ),
                  Row(
                    children: buildDetailFields(),
                  ),
                ],
              ),
            ),
          ),
        ),
        PopupMenuButton<int>(
          key: Key('${Keys.menuPlanningDayShowMenuIcon}-${widget.uniqueIndex}'),
          itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
            new PopupMenuItem<int>(
                key: Key(
                    '${Keys.menuPlanningDayMenuRemoveMeal}-${widget.uniqueIndex}'),
                value: 1,
                child: new Text(AppLocalizations.of(context).remove)),
            new PopupMenuItem<int>(
                key: Key(
                    '${Keys.menuPlanningDayMenuDuplicateMeal}-${widget.uniqueIndex}'),
                value: 2,
                child: new Text(AppLocalizations.of(context).duplicate)),
            new PopupMenuItem<int>(
                key: Key(
                    '${Keys.menuPlanningDayMenuMoveMeal}-${widget.uniqueIndex}'),
                value: 3,
                child: new Text(AppLocalizations.of(context).move)),
          ],
          onSelected: (int value) {
            widget
                .onActionPressed(MenuPlanningMealInputAction.values[value - 1]);
          },
        ),
      ],
    );
  }
}
