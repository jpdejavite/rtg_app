import 'package:flutter_driver/flutter_driver.dart';
import 'package:rtg_app/keys/keys.dart';

class Helper {
  static isPresent(SerializableFinder byValueKey, FlutterDriver driver,
      {Duration timeout = const Duration(seconds: 1)}) async {
    try {
      await driver.waitFor(byValueKey, timeout: timeout);
      return true;
    } catch (exception) {
      return false;
    }
  }

  /// add a recipe, must be called from home
  static addRecipe(FlutterDriver driver, String recipeName, String portion,
      List<String> ingredients, String instructions) async {
    final homeBottomBarRecipesIcon =
        find.byValueKey(Keys.homeBottomBarRecipesIcon);
    final floatingActionNewRecipeButton =
        find.byValueKey(Keys.homeFloatingActionNewRecipeButton);
    final saveRecipeNameField = find.byValueKey(Keys.saveRecipeNameField);
    final saveRecipePortionField = find.byValueKey(Keys.saveRecipePortionField);
    final saveRecipeInstructionsField =
        find.byValueKey(Keys.saveRecipeInstructionsField);
    final saveRecipeFloatingActionSaveButton =
        find.byValueKey(Keys.saveRecipeFloatingActionSaveButton);

    await driver.tap(homeBottomBarRecipesIcon);
    await driver.tap(floatingActionNewRecipeButton);

    await driver.tap(saveRecipeNameField);
    await driver.enterText(recipeName);

    await driver.tap(saveRecipePortionField);
    await driver.enterText(portion);

    final ingredientsMap = ingredients.asMap();
    for (int i = 0; i < ingredientsMap.length; i++) {
      final saveRecipeIngredientField =
          find.byValueKey(Keys.saveRecipeIngredientField + i.toString());

      await driver.tap(saveRecipeIngredientField);
      await driver.enterText(ingredientsMap[i]);
      if (i != ingredients.length - 1) {
        await driver.enterText("\n");
      }
    }

    await driver.tap(saveRecipeInstructionsField);
    await driver.enterText(instructions);

    await driver.tap(saveRecipeFloatingActionSaveButton);
  }
}
