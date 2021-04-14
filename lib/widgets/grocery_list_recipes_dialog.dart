import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/screens/view_recipe_screen.dart';

class GroceryListRecipesDialog extends StatelessWidget {
  final List<Recipe> recipes;

  GroceryListRecipesDialog(this.recipes);

  static Future<void> showIngredientRecipeSourceDialog({
    BuildContext context,
    List<Recipe> recipes,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return GroceryListRecipesDialog(recipes);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> recipesTexts = [];
    recipes.asMap().forEach((index, recipe) {
      recipesTexts.add(Row(
        children: [
          TextButton(
              child: Text(
                recipe.title,
                key:
                    Key(Keys.groceryListRecipesDialogRecipe + index.toString()),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  ViewRecipeScreen.id,
                  arguments: recipe,
                );
              }),
        ],
      ));
    });

    return AlertDialog(
      title: Text(AppLocalizations.of(context).grocery_list_recipes),
      content: SingleChildScrollView(
        child: ListBody(
          children: [...recipesTexts],
        ),
      ),
      actions: <Widget>[
        TextButton(
          key: Key(Keys.groceryListRecipesDialogCloseButton),
          child: Text(AppLocalizations.of(context).close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
