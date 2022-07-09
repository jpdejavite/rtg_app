import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe_preparation_time_details.dart';

import 'driver_helper.dart';

class Helper {
  /// add a recipe, must be called from home
  static addRecipe(
      DriverHelper driver,
      String recipeName,
      String portion,
      String label,
      RecipePreparationTimeDetails preparationTimeDetails,
      Map<int, String> labels,
      List<String> ingredients,
      String instructions) async {
    await driver.tap(Keys.homeBottomBarRecipesIcon);
    await driver.tap(Keys.homeFloatingActionNewRecipeButton);

    await driver.scrollIntoView(Keys.saveRecipeNameField);
    await driver.tap(Keys.saveRecipeNameField);
    await driver.enterText(recipeName);

    await driver.scrollIntoView(Keys.saveRecipeNameField);
    await driver.tap(Keys.saveRecipePortionField);
    await driver.enterText(portion);

    if (label != null) {
      await driver.scrollIntoView(Keys.saveRecipeLabelField);
      await driver.tap(Keys.saveRecipeLabelField);
      await driver.enterText(label);
    }

    if (preparationTimeDetails != null) {
      await driver.tap(Keys.saveRecipePreparationTimeAction);

      if (preparationTimeDetails.preparation != null) {
        await fillPreparationTime(
            driver,
            Keys.editRecipePreparationTimeDetailsPreparationField,
            preparationTimeDetails.preparation);
      }

      if (preparationTimeDetails.cooking != null) {
        await fillPreparationTime(
            driver,
            Keys.editRecipePreparationTimeDetailsCookingField,
            preparationTimeDetails.cooking);
      }

      if (preparationTimeDetails.oven != null) {
        await fillPreparationTime(
            driver,
            Keys.editRecipePreparationTimeDetailsOvenField,
            preparationTimeDetails.oven);
      }

      if (preparationTimeDetails.marinate != null) {
        await fillPreparationTime(
            driver,
            Keys.editRecipePreparationTimeDetailsMarinateField,
            preparationTimeDetails.marinate);
      }

      if (preparationTimeDetails.fridge != null) {
        await fillPreparationTime(
            driver,
            Keys.editRecipePreparationTimeDetailsFridgeField,
            preparationTimeDetails.fridge);
      }

      if (preparationTimeDetails.freezer != null) {
        await fillPreparationTime(
            driver,
            Keys.editRecipePreparationTimeDetailsFreezerField,
            preparationTimeDetails.freezer);
      }
      await driver.tap(Keys.editRecipePreparationTimeDetailsSaveButton);
    }

    final ingredientsMap = ingredients.asMap();
    int labelCount = 0;
    for (int i = 0; i < ingredientsMap.length; i++) {
      if (labels != null && labels[i] != null) {
        await driver.scrollIntoView(Keys.saveRecipeNewLabelAction);
        await driver.tap(Keys.saveRecipeNewLabelAction);
        await driver
            .scrollIntoView(Keys.saveRecipeLabelField + labelCount.toString());
        await driver.enterText(labels[i]);
        labelCount++;
      }
      await driver
          .scrollIntoView(Keys.saveRecipeIngredientField + i.toString());
      await driver.tap(Keys.saveRecipeIngredientField + i.toString());
      await driver.enterText(ingredientsMap[i]);
      if (i != ingredients.length - 1 &&
          !(labels != null && labels[i + 1] != null)) {
        await driver.enterText("\n");
      }
    }

    await driver.scrollIntoView(Keys.saveRecipeInstructionsField);
    await driver.tap(Keys.saveRecipeInstructionsField);
    await driver.enterText(instructions);

    await driver.tap(Keys.saveRecipeFloatingActionSaveButton);
  }

  static fillPreparationTime(
      DriverHelper driver, String fieldKey, int value) async {
    if (value > 60) {
      await driver.scrollIntoView(
          Keys.editRecipePreparationTimeDetailsDurationDropdown);
      await driver.tap(Keys.editRecipePreparationTimeDetailsDurationDropdown);
      await driver.tapInText('horas');

      await driver.scrollIntoView(fieldKey);
      await driver.tap(fieldKey);
      await driver.enterText((value / Duration.minutesPerHour).toString());

      await driver.scrollIntoView(
          Keys.editRecipePreparationTimeDetailsDurationDropdown);
      await driver.tap(Keys.editRecipePreparationTimeDetailsDurationDropdown);
      await driver.tapInText('minutos');
    } else {
      await driver.scrollIntoView(fieldKey);
      await driver.tap(fieldKey);
      await driver.enterText(value.toString());
    }
  }
}
