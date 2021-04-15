import 'package:flutter_driver/flutter_driver.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe_preparation_time_details.dart';

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
  static addRecipe(
      FlutterDriver driver,
      String recipeName,
      String portion,
      RecipePreparationTimeDetails preparationTimeDetails,
      List<String> ingredients,
      String instructions) async {
    final homeBottomBarRecipesIcon =
        find.byValueKey(Keys.homeBottomBarRecipesIcon);
    final floatingActionNewRecipeButton =
        find.byValueKey(Keys.homeFloatingActionNewRecipeButton);
    final saveRecipeNameField = find.byValueKey(Keys.saveRecipeNameField);
    final saveRecipePortionField = find.byValueKey(Keys.saveRecipePortionField);
    final saveRecipePreparationTimeAction =
        find.byValueKey(Keys.saveRecipePreparationTimeAction);
    final saveRecipeInstructionsField =
        find.byValueKey(Keys.saveRecipeInstructionsField);
    final saveRecipeFloatingActionSaveButton =
        find.byValueKey(Keys.saveRecipeFloatingActionSaveButton);
    final editRecipePreparationTimeDetailsPreparationField =
        find.byValueKey(Keys.editRecipePreparationTimeDetailsPreparationField);
    final editRecipePreparationTimeDetailsCookingField =
        find.byValueKey(Keys.editRecipePreparationTimeDetailsCookingField);
    final editRecipePreparationTimeDetailsOvenField =
        find.byValueKey(Keys.editRecipePreparationTimeDetailsOvenField);
    final editRecipePreparationTimeDetailsMarinateField =
        find.byValueKey(Keys.editRecipePreparationTimeDetailsMarinateField);
    final editRecipePreparationTimeDetailsFridgeField =
        find.byValueKey(Keys.editRecipePreparationTimeDetailsFridgeField);
    final editRecipePreparationTimeDetailsFreezerField =
        find.byValueKey(Keys.editRecipePreparationTimeDetailsFreezerField);
    final editRecipePreparationTimeDetailsSaveButton =
        find.byValueKey(Keys.editRecipePreparationTimeDetailsSaveButton);

    await driver.tap(homeBottomBarRecipesIcon);
    await driver.tap(floatingActionNewRecipeButton);

    await driver.tap(saveRecipeNameField);
    await driver.enterText(recipeName);

    await driver.tap(saveRecipePortionField);
    await driver.enterText(portion);

    if (preparationTimeDetails != null) {
      await driver.tap(saveRecipePreparationTimeAction);

      if (preparationTimeDetails.preparation != null) {
        await driver.tap(editRecipePreparationTimeDetailsPreparationField);
        await driver.enterText(preparationTimeDetails.preparation.toString());
      }

      if (preparationTimeDetails.cooking != null) {
        await driver.tap(editRecipePreparationTimeDetailsCookingField);
        await driver.enterText(preparationTimeDetails.cooking.toString());
      }

      if (preparationTimeDetails.oven != null) {
        await driver.tap(editRecipePreparationTimeDetailsOvenField);
        await driver.enterText(preparationTimeDetails.oven.toString());
      }

      if (preparationTimeDetails.marinate != null) {
        await driver.tap(editRecipePreparationTimeDetailsMarinateField);
        await driver.enterText(preparationTimeDetails.marinate.toString());
      }

      if (preparationTimeDetails.fridge != null) {
        await driver.tap(editRecipePreparationTimeDetailsFridgeField);
        await driver.enterText(preparationTimeDetails.fridge.toString());
      }

      if (preparationTimeDetails.freezer != null) {
        await driver.tap(editRecipePreparationTimeDetailsFreezerField);
        await driver.enterText(preparationTimeDetails.freezer.toString());
      }
      await driver.tap(editRecipePreparationTimeDetailsSaveButton);
    }

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

    await driver.scrollIntoView(saveRecipeInstructionsField);
    await driver.tap(saveRecipeInstructionsField);
    await driver.enterText(instructions);

    await driver.tap(saveRecipeFloatingActionSaveButton);
  }
}
