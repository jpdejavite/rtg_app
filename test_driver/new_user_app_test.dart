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
    final saveRecipeNameField = find.byValueKey(Keys.saveRecipeNameField);
    final saveRecipeFloatingActionSaveButton =
        find.byValueKey(Keys.saveRecipeFloatingActionSaveButton);
    final recipeListRowTitleText0 =
        find.byValueKey(Keys.recipeListRowTitleText + "0");
    final recipeListRowTitleText1 =
        find.byValueKey(Keys.recipeListRowTitleText + "1");
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
    final viewRecipeAddToGroceryListAction =
        find.byValueKey(Keys.viewRecipeAddToGroceryListAction);
    final viewRecipeGroceryListToSelect0 =
        find.byValueKey(Keys.viewRecipeGroceryListToSelect + '0');
    final viewRecipeCreateNewGroceryListAction =
        find.byValueKey(Keys.viewRecipeCreateNewGroceryListAction);
    final addRecipeToGroceryListDialogPortionTextField =
        find.byValueKey(Keys.addRecipeToGroceryListDialogPortionTextField);
    final addRecipeToGroceryListDialogConfirmButton =
        find.byValueKey(Keys.addRecipeToGroceryListDialogConfirmButton);

    final String recipeName1 = 'Minha primeira receita!';
    final String portion1 = '1';
    final String ingredient10 = '1 chuchu';
    final String ingredient11 = '1 colher de chá de sal';
    final String instructions1 = 'Vamos preparar minha primeira receita\n\\o/';

    final String recipeName2 = 'Minha segunda receita';
    final String portion2 = '19';
    final String ingredient20 = '1 beterraba';
    final String ingredient21 = '1 colher de chá de sal';
    final String ingredient22 = '1 colher de chá de açucar';
    final String instructions2 = 'Vamos preparar minha segunda receita\n\\o/';

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
      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.homeActionSettingsIcon), driver),
          true);
      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.homeActionSettingsNotification), driver),
          false);
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

    test('insert first recipe', () async {
      await Helper.addRecipe(driver, recipeName1, portion1,
          [ingredient10, ingredient11], instructions1);

      expect(await driver.getText(recipeListRowTitleText0), recipeName1);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.homeActionSettingsNotification), driver),
          true);
    });

    test('insert second recipe', () async {
      await Helper.addRecipe(driver, recipeName2, portion2,
          [ingredient20, ingredient21, ingredient22], instructions2);

      expect(await driver.getText(recipeListRowTitleText1), recipeName2);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.homeActionSettingsNotification), driver),
          true);
    });

    test('view recipe', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      await driver.tap(recipeListRowTitleText0);

      expect(await driver.getText(viewRecipeTitle), recipeName1);
      expect(
          await driver.getText(viewRecipeIngredientText0), "• " + ingredient10);
      expect(
          await driver.getText(viewRecipeIngredientText1), "• " + ingredient11);

      expect(await driver.getText(viewRecipeInstructionText), instructions1);

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);
    });

    test('edit recipe', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      await driver.tap(recipeListRowTitleText0);

      await driver.tap(viewRecipeFloatingActionEditButton);

      await driver.tap(saveRecipeNameField);
      await driver.enterText(recipeName1 + " editado");

      await driver.tap(saveRecipeFloatingActionSaveButton);

      expect(await driver.getText(viewRecipeTitle), recipeName1 + " editado");

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);
    });

    test('add first recipe to new grocery list', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      await driver.tap(recipeListRowTitleText0);

      await driver.tap(viewRecipeAddToGroceryListAction);

      await driver.tap(addRecipeToGroceryListDialogPortionTextField);
      await driver.enterText("123");

      await driver.tap(addRecipeToGroceryListDialogConfirmButton);

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);
    });

    test('add second recipe to same grocery list', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      await driver.tap(recipeListRowTitleText1);

      await driver.tap(viewRecipeAddToGroceryListAction);

      await driver.tap(addRecipeToGroceryListDialogPortionTextField);
      await driver.enterText("123");

      await driver.tap(addRecipeToGroceryListDialogConfirmButton);

      await driver.tap(viewRecipeGroceryListToSelect0);

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);
    });

    test('add second recipe to new grocery list', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      await driver.tap(recipeListRowTitleText1);

      await driver.tap(viewRecipeAddToGroceryListAction);

      await driver.tap(addRecipeToGroceryListDialogPortionTextField);
      await driver.enterText("123");

      await driver.tap(addRecipeToGroceryListDialogConfirmButton);

      await driver.tap(viewRecipeCreateNewGroceryListAction);

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);
    });

    // TODO: implement backup
    // test('do backup', () async {
    //   await driver.tap(homeActionSettingsIcon);

    //   await driver.tap(settingsGoogleDriveButtton);

    //   await driver.tap(find.text(newUserGoogleAccountEmail));
    // });
  });
}
