import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/grocery_list_item.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/screens/view_recipe_screen.dart';
import 'package:rtg_app/widgets/view_recipe_label.dart';

class IngredientRecipeSourceDialog extends StatelessWidget {
  final GroceryListItem groceryListItem;
  final List<Recipe> recipes;

  IngredientRecipeSourceDialog({
    this.groceryListItem,
    this.recipes,
  });

  static Future<void> showIngredientRecipeSourceDialog({
    BuildContext context,
    GroceryListItem groceryListItem,
    List<Recipe> recipes,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return IngredientRecipeSourceDialog(
          groceryListItem: groceryListItem,
          recipes: recipes,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> recipesTexts = [];
    if (recipes != null) {
      recipes.forEach((recipe) {
        recipesTexts.add(Row(
          children: [
            TextButton(
                child: Text(
                  recipe.title,
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
    }

    return AlertDialog(
      title: Text(AppLocalizations.of(context).item_recipes),
      content: SingleChildScrollView(
        child: ListBody(
          key: Key(Keys.ingredientRecipeSourceDialogIngredientName),
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                groceryListItem.name,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            ViewRecipeLabel(
              label: AppLocalizations.of(context).recipes,
            ),
            ...recipesTexts
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          key: Key(Keys.ingredientRecipeSourceDialogCloseButton),
          child: Text(AppLocalizations.of(context).close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
