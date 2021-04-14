import 'package:flutter_driver/flutter_driver.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:test/test.dart';

import 'helper.dart';

void main() {
  group('basic fetures app test', () {
    final homeBottomBarHomeIcon = find.byValueKey(Keys.homeBottomBarHomeIcon);
    final homeBottomBarRecipesIcon =
        find.byValueKey(Keys.homeBottomBarRecipesIcon);
    final homeBottomBarListsIcon = find.byValueKey(Keys.homeBottomBarListsIcon);
    final homeCardRecipeTutorialDismiss =
        find.byValueKey(Keys.homeCardRecipeTutorialDismiss);
    final homeCardConfigureBackup =
        find.byValueKey(Keys.homeCardConfigureBackup);
    final homeCardConfigureBackupAction =
        find.byValueKey(Keys.homeCardConfigureBackupAction);
    final homeCardLastGroceryListUsed =
        find.byValueKey(Keys.homeCardLastGroceryListUsed);
    final homeCardLastGroceryListUsedAction =
        find.byValueKey(Keys.homeCardLastGroceryListUsedAction);
    final homeCardRecipeButton0 =
        find.byValueKey('${Keys.homeCardRecipeButton}-0');
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
    final viewRecipeAddToGroceryListAction1 =
        find.byValueKey(Keys.viewRecipeAddToGroceryListAction + "1");
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
    final groceryListRowTitleText0 =
        find.byValueKey(Keys.groceryListRowTitleText + "0");
    final groceryListRowShowRecipes0 =
        find.byValueKey(Keys.groceryListRowShowRecipes + "0");
    final groceryListRowTitleText1 =
        find.byValueKey(Keys.groceryListRowTitleText + "1");
    final groceryListRecipesDialogRecipe0 =
        find.byValueKey(Keys.groceryListRecipesDialogRecipe + "0");
    final groceryListRecipesDialogRecipe1 =
        find.byValueKey(Keys.groceryListRecipesDialogRecipe + "1");
    final groceryListRecipesDialogCloseButton =
        find.byValueKey(Keys.groceryListRecipesDialogCloseButton);
    final groceryItemTextField0 =
        find.byValueKey(Keys.groceryItemTextField + "0");
    final groceryItemTextField1 =
        find.byValueKey(Keys.groceryItemTextField + "1");
    final groceryItemTextField2 =
        find.byValueKey(Keys.groceryItemTextField + "2");
    final groceryItemTextField3 =
        find.byValueKey(Keys.groceryItemTextField + "3");
    final groceryItemCheckBox1 =
        find.byValueKey(Keys.groceryItemCheckBox + "1");
    final saveGroceryListShowChecked =
        find.byValueKey(Keys.saveGroceryListShowChecked);
    final groceryItemActionIcon2 =
        find.byValueKey(Keys.groceryItemActionIcon + "2");
    final saveGroceryListBottomActionIcon =
        find.byValueKey(Keys.saveGroceryListBottomActionIcon);
    final ingredientRecipeSourceDialogRecipe0 =
        find.byValueKey(Keys.ingredientRecipeSourceDialogRecipe + "0");
    final ingredientRecipeSourceDialogCloseButton =
        find.byValueKey(Keys.ingredientRecipeSourceDialogCloseButton);
    final saveGroceryListArchiveAction =
        find.byValueKey(Keys.saveGroceryListArchiveAction);
    final saveGroceryListArchiveConfirm =
        find.byValueKey(Keys.saveGroceryListArchiveConfirm);

    final String recipeName1 = 'Minha primeira receita!';
    final String portion1 = '1.00';
    final String ingredient10 = '1 chuchu';
    final String ingredient11 = '1 colher de chá de sal';
    final String instructions1 = 'Vamos preparar minha primeira receita\n\\o/';

    final String recipeName2 = 'Minha segunda receita';
    final String portion2 = '3,00';
    final String ingredient20 = '1 beterraba';
    final String ingredient21 = '1 colher de chá de sal';
    final String ingredient22 = '1 1/2 colher de chá de açucar';
    final String instructions2 = 'Vamos preparar minha segunda receita\n\\o/';

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver.tap(actionDeleteAllIcon);
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('home inital screen', () async {
      await driver.tap(homeBottomBarHomeIcon);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.homeCardRecipeTutorial), driver),
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

    test('recipes initial screen', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.recipesListEmptyText), driver,
              timeout: Duration(seconds: 10)),
          true);
    });

    test('lists initial screen', () async {
      await driver.tap(homeBottomBarListsIcon);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.groceryListsEmptyText), driver),
          true);
    });

    test('dimiss recipe tutorial', () async {
      await driver.tap(homeBottomBarHomeIcon);

      await driver.tap(homeCardRecipeTutorialDismiss);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.homeBottomBarHomeText), driver),
          true);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.homeActionSettingsIcon), driver),
          true);
    });

    test('insert first recipe', () async {
      await Helper.addRecipe(driver, recipeName1, portion1, null,
          [ingredient10, ingredient11], instructions1);

      expect(await driver.getText(recipeListRowTitleText0), recipeName1);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.homeActionSettingsNotification), driver),
          true);
    });

    test('check configure backup home action', () async {
      await driver.tap(homeBottomBarHomeIcon);

      expect(await Helper.isPresent(homeCardConfigureBackup, driver), true);

      await driver.tap(homeCardConfigureBackupAction);

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);
    });

    test('insert second recipe', () async {
      await Helper.addRecipe(driver, recipeName2, portion2, null,
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
      await driver.enterText("2");

      await driver.tap(addRecipeToGroceryListDialogConfirmButton);

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);

      await driver.tap(homeBottomBarListsIcon);

      expect(await Helper.isPresent(groceryListRowTitleText0, driver), true);

      await driver.tap(groceryListRowTitleText0);

      expect(await driver.getText(groceryItemTextField0), "2 chuchu");

      expect(
          await driver.getText(groceryItemTextField1), "2 colheres de chá sal");

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);
    });

    test('check last used recipe on home', () async {
      await driver.tap(homeBottomBarHomeIcon);

      expect(await Helper.isPresent(homeCardLastGroceryListUsed, driver), true);

      await driver.tap(homeCardLastGroceryListUsedAction);

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);

      await driver.tap(homeCardRecipeButton0);

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);
    });

    test('add second recipe to same grocery list', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      await driver.tap(viewRecipeAddToGroceryListAction1);

      await driver.tap(addRecipeToGroceryListDialogPortionTextField);
      await driver.enterText("9");

      await driver.tap(addRecipeToGroceryListDialogConfirmButton);

      await driver.tap(viewRecipeGroceryListToSelect0);

      await driver.tap(homeBottomBarListsIcon);

      await driver.tap(groceryListRowTitleText0);

      expect(await driver.getText(groceryItemTextField0), "2 chuchu");

      expect(
          await driver.getText(groceryItemTextField1), "5 colheres de chá sal");

      expect(await driver.getText(groceryItemTextField2), "3 beterraba");

      expect(await driver.getText(groceryItemTextField3),
          "4 1/2 colheres de chá açucar");

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);
    });

    test('add second recipe to new grocery list', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      await driver.tap(recipeListRowTitleText1);

      await driver.tap(viewRecipeAddToGroceryListAction);

      await driver.tap(addRecipeToGroceryListDialogPortionTextField);
      await driver.enterText("2");

      await driver.tap(addRecipeToGroceryListDialogConfirmButton);

      await driver.tap(viewRecipeCreateNewGroceryListAction);

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);

      await driver.tap(homeBottomBarListsIcon);

      expect(await Helper.isPresent(groceryListRowTitleText1, driver), true);
    });

    test('edit grocery list item name', () async {
      await driver.tap(homeBottomBarListsIcon);

      await driver.tap(groceryListRowTitleText0);

      await driver.tap(groceryItemTextField0);
      await driver.enterText("1 chuchu grande");

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);

      await driver.tap(groceryListRowTitleText0);

      expect(await driver.getText(groceryItemTextField0), "1 chuchu grande");

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);
    });

    test('edit grocery list check item', () async {
      await driver.tap(homeBottomBarListsIcon);

      await driver.tap(groceryListRowTitleText0);

      await driver.tap(groceryItemCheckBox1);

      expect(await Helper.isPresent(saveGroceryListShowChecked, driver), true);

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);
    });

    test('edit grocery list drag item', () async {
      await driver.tap(homeBottomBarListsIcon);

      await driver.tap(groceryListRowTitleText0);

      await driver.scroll(
          groceryItemActionIcon2, 0, -75, Duration(milliseconds: 3000));

      await Future.delayed(Duration(seconds: 2));

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);
    });

    test('edit grocery list show recipes', () async {
      await driver.tap(homeBottomBarListsIcon);

      await driver.tap(groceryListRowTitleText0);

      await driver.tap(saveGroceryListBottomActionIcon);

      await driver.tap(groceryItemActionIcon2);

      expect(await driver.getText(ingredientRecipeSourceDialogRecipe0),
          recipeName2);

      await driver.tap(ingredientRecipeSourceDialogCloseButton);

      await driver.waitFor(backButtonFinder);
      await driver.tap(backButtonFinder);
    });

    test('edit grocery list archive recipes', () async {
      await driver.tap(homeBottomBarListsIcon);

      await driver.tap(groceryListRowTitleText0);

      await driver.tap(saveGroceryListArchiveAction);

      await driver.tap(saveGroceryListArchiveConfirm);

      expect(await Helper.isPresent(groceryListRowTitleText0, driver), true);

      expect(await Helper.isPresent(groceryListRowTitleText1, driver), false);
    });

    test('show grocery list recipes', () async {
      await driver.tap(homeBottomBarListsIcon);

      await driver.tap(groceryListRowShowRecipes0);

      expect(
          await driver.getText(groceryListRecipesDialogRecipe0), recipeName1);

      expect(
          await driver.getText(groceryListRecipesDialogRecipe1), recipeName2);

      await driver.tap(groceryListRecipesDialogCloseButton);
    });

    // TODO: implement backup
    // test('do backup', () async {
    //   await driver.tap(homeActionSettingsIcon);

    //   await driver.tap(settingsGoogleDriveButtton);

    //   await driver.tap(find.text(newUserGoogleAccountEmail));
    // });
  });
}
