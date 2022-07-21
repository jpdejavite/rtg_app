import 'package:flutter/material.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/model/menu_planning_meal.dart';
import 'package:rtg_app/model/menu_planning_meal_input_action.dart';
import 'package:rtg_app/model/menu_planning_meal_type.dart';
import 'package:rtg_app/model/menu_planning_meal_type_preparation.dart';
import 'package:rtg_app/model/menu_planning_side_dish.dart';
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

class InputControls {
  TextEditingController detailsController;
  bool showDetailsField = false;
  Recipe choosenRecipe;

  InputControls(
      this.detailsController, this.showDetailsField, this.choosenRecipe);
}

class _MenuPlanningMealInputState extends State<MenuPlanningMealInput> {
  InputControls _mainCourseInputControls;
  List<InputControls> _sideDishesInputControls = [];

  @override
  void initState() {
    super.initState();
    _mainCourseInputControls =
        InputControls(TextEditingController(), false, null);
    if (widget.meal.sideDishes != null) {
      widget.meal.sideDishes.forEach((_) {
        _sideDishesInputControls
            .add(InputControls(TextEditingController(), false, null));
      });
    }
  }

  @override
  void dispose() {
    _mainCourseInputControls.detailsController.dispose();
    _sideDishesInputControls.forEach((inputControl) {
      inputControl.detailsController.dispose();
    });
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
          _mainCourseInputControls.showDetailsField = false;
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

  String buildDetailTextFieldKey(int sideDishIndex) {
    return sideDishIndex == null
        ? '${Keys.menuPlanningWriteDetailsTextField}-${widget.uniqueIndex}'
        : '${Keys.menuPlanningWriteDetailsTextField}-${widget.uniqueIndex}-$sideDishIndex';
  }

  List<Widget> buildDetailTextField(int sideDishIndex) {
    bool isMainCourse = sideDishIndex == null;
    TextEditingController _detailsController = isMainCourse
        ? _mainCourseInputControls.detailsController
        : _sideDishesInputControls[sideDishIndex].detailsController;
    _detailsController.text = isMainCourse
        ? widget.meal.description
        : widget.meal.sideDishes[sideDishIndex].description;
    return [
      Expanded(
        child: TextFormField(
          key: Key(buildDetailTextFieldKey(sideDishIndex)),
          controller: _detailsController,
          onChanged: (value) {
            if (isMainCourse) {
              widget.meal.description = value;
            } else {
              widget.meal.sideDishes[sideDishIndex].description = value;
            }
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

  void onChooseRecipe(int sideDishIndex) async {
    final result = await Navigator.pushNamed(context, ChooseRecipeScreen.id,
        arguments: widget.lastUsedGroceryListRecipes);
    if (result != null && result is Recipe) {
      setState(() {
        if (sideDishIndex == null) {
          widget.meal.recipeId = result.id;
          _mainCourseInputControls.choosenRecipe = result;
        } else {
          widget.meal.sideDishes[sideDishIndex].recipeId = result.id;
          _sideDishesInputControls[sideDishIndex].choosenRecipe = result;
        }
      });
    }
  }

  List<Widget> buildDetailFields() {
    if (widget.meal.recipeId != null) {
      if (_mainCourseInputControls.choosenRecipe == null) {
        if (widget.lastUsedGroceryListRecipes != null) {
          widget.lastUsedGroceryListRecipes.forEach((r) {
            if (r.id == widget.meal.recipeId) {
              _mainCourseInputControls.choosenRecipe = r;
            }
          });
        }

        if (widget.menuPlanningRecipes != null) {
          widget.menuPlanningRecipes.forEach((r) {
            if (r.id == widget.meal.recipeId) {
              _mainCourseInputControls.choosenRecipe = r;
            }
          });
        }
      }

      if (_mainCourseInputControls.choosenRecipe != null) {
        return [
          Expanded(
            child: Text(
              _mainCourseInputControls.choosenRecipe.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          IconButton(
              onPressed: () => onChooseRecipe(null), icon: Icon(Icons.edit)),
        ];
      }
    }

    if (_mainCourseInputControls.showDetailsField ||
        (widget.meal.description != null && widget.meal.description != "")) {
      return buildDetailTextField(null);
    }
    if (widget.meal.preparation == MenuPlanningMealPreparation.cook ||
        widget.meal.preparation == MenuPlanningMealPreparation.leftovers) {
      return [
        TextButton(
          key: Key(
              '${Keys.menuPlanningDayPickRecipeTextButton}-${widget.uniqueIndex}'),
          child: Text(AppLocalizations.of(context).pick_recipe),
          onPressed: () => onChooseRecipe(null),
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
              _mainCourseInputControls.showDetailsField = true;
            });
          },
        )
      ];
    }

    return buildDetailTextField(null);
  }

  List<Widget> buildSideDishesFields() {
    if (widget.meal.sideDishes == null) {
      return [];
    }

    return widget.meal.sideDishes.asMap().entries.map<Widget>((entry) {
      int sideDishIndex = entry.key;
      MenuPlanningSideDish sideDish = entry.value;
      return Row(
        children: buildSideDishFields(sideDish, sideDishIndex),
      );
    }).toList();
  }

  List<Widget> buildSideDishFields(
      MenuPlanningSideDish sideDish, int sideDishIndex) {
    if (sideDish.recipeId != null) {
      if (_sideDishesInputControls[sideDishIndex].choosenRecipe == null) {
        if (widget.lastUsedGroceryListRecipes != null) {
          widget.lastUsedGroceryListRecipes.forEach((r) {
            if (r.id == sideDish.recipeId) {
              _sideDishesInputControls[sideDishIndex].choosenRecipe = r;
            }
          });
        }

        if (widget.menuPlanningRecipes != null) {
          widget.menuPlanningRecipes.forEach((r) {
            if (r.id == sideDish.recipeId) {
              _sideDishesInputControls[sideDishIndex].choosenRecipe = r;
            }
          });
        }
      }

      if (_sideDishesInputControls[sideDishIndex].choosenRecipe != null) {
        return [
          Expanded(
            child: Text(
              _sideDishesInputControls[sideDishIndex].choosenRecipe.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          IconButton(
              onPressed: () => onChooseRecipe(sideDishIndex),
              icon: Icon(Icons.edit)),
        ];
      }
    }

    if (_sideDishesInputControls[sideDishIndex].showDetailsField ||
        (sideDish.description != null && sideDish.description != "")) {
      return buildDetailTextField(sideDishIndex);
    }
    return [
      TextButton(
        key: Key(
            '${Keys.menuPlanningDayPickRecipeTextButton}-${widget.uniqueIndex}-$sideDishIndex'),
        child: Text(AppLocalizations.of(context).pick_recipe),
        onPressed: () => onChooseRecipe(sideDishIndex),
      ),
      Expanded(
        child: SizedBox(
          width: 16,
        ),
      ),
      TextButton(
        key: Key(
            '${Keys.menuPlanningWriteDetailsTextButton}-${widget.uniqueIndex}-$sideDishIndex'),
        child: Text(AppLocalizations.of(context).write_details),
        onPressed: () {
          setState(() {
            _sideDishesInputControls[sideDishIndex].showDetailsField = true;
          });
        },
      )
    ];
  }

  Widget buildPopupMenu() {
    return PopupMenuButton<int>(
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
        new PopupMenuItem<int>(
            key: Key(
                '${Keys.menuPlanningDayMenuAddSideDish}-${widget.uniqueIndex}'),
            value: 4,
            child: new Text(AppLocalizations.of(context).add_side_dish)),
      ],
      onSelected: (int value) {
        if (MenuPlanningMealInputAction.addSideDish.index == value - 1) {
          addSideDish();
          return;
        }
        widget.onActionPressed(MenuPlanningMealInputAction.values[value - 1]);
      },
    );
  }

  void addSideDish() {
    setState(() {
      if (widget.meal.sideDishes == null) {
        widget.meal.sideDishes = [];
      }
      widget.meal.sideDishes.add(MenuPlanningSideDish());
      _sideDishesInputControls
          .add(InputControls(TextEditingController(), false, null));
    });
  }

  Widget buildCard() {
    return Card(
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
            ...buildSideDishesFields(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: buildCard(),
        ),
        buildPopupMenu(),
      ],
    );
  }
}
