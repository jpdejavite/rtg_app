import 'package:flutter_driver/flutter_driver.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:test/test.dart';

import 'helper.dart';

void main() {
  group('New User RTG App', () {
    final homeBottomBarHomeIcon = find.byValueKey(Keys.homeBottomBarHomeIcon);
    final homeBottomBarRecipesIcon =
        find.byValueKey(Keys.homeBottomBarRecipesIcon);
    final homeBottomBarListsIcon = find.byValueKey(Keys.homeBottomBarListsIcon);
    final actionDeleteAllIcon = find.byValueKey(Keys.actionDeleteAllIcon);
    final floatingActionNewRecipeButton =
        find.byValueKey(Keys.homeFloatingActionNewRecipeButton);
    final saveRecipeNameField = find.byValueKey(Keys.saveRecipeNameField);
    final saveRecipePortionField = find.byValueKey(Keys.saveRecipePortionField);
    final saveRecipeIngredientField0 =
        find.byValueKey(Keys.saveRecipeIngredientField + "0");
    final saveRecipeIngredientField1 =
        find.byValueKey(Keys.saveRecipeIngredientField + "1");
    final saveRecipeInstructionsField =
        find.byValueKey(Keys.saveRecipeInstructionsField);
    final saveRecipeFloatingActionSaveButton =
        find.byValueKey(Keys.saveRecipeFloatingActionSaveButton);
    final recipeListRowTitleText0 =
        find.byValueKey(Keys.recipeListRowTitleText + "0");
    final viewRecipeTitle = find.byValueKey(Keys.viewRecipeTitle);
    final viewRecipeIngredientText0 =
        find.byValueKey(Keys.viewRecipeIngredientText + "0");
    final viewRecipeIngredientText1 =
        find.byValueKey(Keys.viewRecipeIngredientText + "1");
    final viewRecipeInstructionText =
        find.byValueKey(Keys.viewRecipeInstructionText);
    SerializableFinder backButtonFinder = find.byTooltip("Voltar");
    final viewRecipeFloatingActionEditButton =
        find.byValueKey(Keys.viewRecipeFloatingActionEditButton);

    final String recipeName = 'Minha primeira receita!';
    final String portion = '1';
    final String ingredient0 = '1 chuchu';
    final String ingredient1 = '1 colher de chá de sal';
    final String instructions = 'Vamos preparar minha primeira receita\n\\o/';

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      // await DatbaseHelper.initDB(Users.newUser);
      await driver.tap(actionDeleteAllIcon);
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('tap home', () async {
      await driver.tap(homeBottomBarHomeIcon);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.homeBottomBarHomeText), driver),
          true);
    });

    test('tap recipes', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.recipesListEmptyText), driver,
              timeout: Duration(seconds: 10)),
          true);
    });

    test('tap lists', () async {
      await driver.tap(homeBottomBarListsIcon);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.homeBottomBarListsText), driver),
          true);
    });

    test('new recipe', () async {
      await driver.tap(homeBottomBarRecipesIcon);
      await driver.tap(floatingActionNewRecipeButton);

      await driver.tap(saveRecipeNameField);
      await driver.enterText(recipeName);

      await driver.tap(saveRecipePortionField);
      await driver.enterText(portion);

      await driver.tap(saveRecipeIngredientField0);
      await driver.enterText(ingredient0);
      await driver.enterText("\n");

      await driver.tap(saveRecipeIngredientField1);
      await driver.enterText(ingredient1);

      await driver.tap(saveRecipeInstructionsField);
      await driver.enterText(instructions);

      await driver.tap(saveRecipeFloatingActionSaveButton);

      expect(await driver.getText(recipeListRowTitleText0), recipeName);
    });

    test('view recipe', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      await driver.tap(recipeListRowTitleText0);

      expect(await driver.getText(viewRecipeTitle), recipeName);
      expect(
          await driver.getText(viewRecipeIngredientText0), "• " + ingredient0);
      expect(
          await driver.getText(viewRecipeIngredientText1), "• " + ingredient1);

      expect(await driver.getText(viewRecipeInstructionText), instructions);

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);
    });

    test('edit recipe', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      await driver.tap(recipeListRowTitleText0);

      await driver.tap(viewRecipeFloatingActionEditButton);

      await driver.tap(saveRecipeNameField);
      await driver.enterText(recipeName + " editado");

      await driver.tap(saveRecipeFloatingActionSaveButton);

      expect(await driver.getText(viewRecipeTitle), recipeName + " editado");

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);
    });
  });
}
