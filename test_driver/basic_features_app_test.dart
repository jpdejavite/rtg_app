import 'package:flutter_driver/flutter_driver.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe_preparation_time_details.dart';
import 'package:test/test.dart';

import 'constants.dart';
import 'helper.dart';

void main() {
  group('basic fetures app test', () {
    final String recipeName1 = 'Minha primeira receita!';
    final String portion1 = '1.00';
    final String ingredient10 = '1 chuchu';
    final String ingredient11 = '1 colher de chá de sal';
    final RecipePreparationTimeDetails preparationTimeDetails1 =
        RecipePreparationTimeDetails(preparation: 10, cooking: 120);
    final String instructions1 = 'Vamos preparar minha primeira receita\n\\o/';

    final String recipeName2 = 'Minha segunda receita';
    final String portion2 = '3,00';
    final String label2 = 'carne';
    final String ingredient20 = '1 beterraba';
    final String ingredient21 = '1 colher de chá de sal';
    final String ingredient22 = '1 1/2 colher de chá de açucar';
    final String instructions2 = 'Vamos preparar minha segunda receita\n\\o/';

    final String recipeName3 = 'Minha terceira receita';
    final String portion3 = '4,00';
    final String label3 = 'frango';
    final Map<int, String> labels3 = const {
      0: 'molho',
      3: 'macarrao',
      4: 'servir'
    };
    final String ingredient30 = '1 kg tomate';
    final String ingredient31 = '1 cebola';
    final String ingredient32 = '1 pitada de sal';
    final String ingredient33 = '500 g penne';
    final String ingredient34 = '100 g queijo parmessao';
    final String ingredient35 = 'algumas folhas de manjericão';
    final String instructions3 = 'Vamos preparar minha terceira receita\n\\o/';

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver.tap(Constants.actionDeleteAllIcon);
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('home inital screen', () async {
      await driver.tap(Constants.homeBottomBarHomeIcon);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.homeCardRecipeTutorial), driver),
          true);

      expect(await Helper.isPresent(Constants.homeActionSettingsIcon, driver),
          true);
      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.homeActionSettingsNotification), driver),
          false);
    });

    test('recipes initial screen', () async {
      await driver.tap(Constants.homeBottomBarRecipesIcon);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.recipesListEmptyText), driver,
              timeout: Duration(seconds: 10)),
          true);
    });

    test('lists initial screen', () async {
      await driver.tap(Constants.homeBottomBarListsIcon);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.groceryListsEmptyText), driver),
          true);
    });

    test('dimiss recipe tutorial', () async {
      await driver.tap(Constants.homeBottomBarHomeIcon);

      await driver.tap(Constants.homeCardRecipeTutorialDismiss);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.homeBottomBarHomeText), driver),
          true);

      expect(await Helper.isPresent(Constants.homeActionSettingsIcon, driver),
          true);
    });

    test('insert first recipe', () async {
      await Helper.addRecipe(
          driver,
          recipeName1,
          portion1,
          null,
          preparationTimeDetails1,
          null,
          [ingredient10, ingredient11],
          instructions1);

      expect(
          await driver.getText(Constants.recipeListRowTitleText0), recipeName1);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.homeActionSettingsNotification), driver),
          true);
    });

    test('check configure backup home action', () async {
      await driver.tap(Constants.homeBottomBarHomeIcon);

      expect(await Helper.isPresent(Constants.homeCardConfigureBackup, driver),
          true);

      await driver.tap(Constants.homeCardConfigureBackupAction);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('insert second recipe', () async {
      await Helper.addRecipe(driver, recipeName2, portion2, label2, null, null,
          [ingredient20, ingredient21, ingredient22], instructions2);

      expect(
          await driver.getText(Constants.recipeListRowTitleText1), recipeName2);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.homeActionSettingsNotification), driver),
          true);
    });

    test('insert third recipe', () async {
      await Helper.addRecipe(
          driver,
          recipeName3,
          portion3,
          label3,
          null,
          labels3,
          [
            ingredient30,
            ingredient31,
            ingredient32,
            ingredient33,
            ingredient34,
            ingredient35
          ],
          instructions3);

      expect(
          await driver.getText(Constants.recipeListRowTitleText2), recipeName3);
    });

    test('view third recipe', () async {
      await driver.tap(Constants.homeBottomBarRecipesIcon);

      await driver.tap(Constants.recipeListRowTitleText2);

      expect(await driver.getText(Constants.viewRecipeTitle), recipeName3);
      expect(await driver.getText(Constants.viewRecipeIngredientLabelText0),
          labels3[0]);
      expect(await driver.getText(Constants.viewRecipeIngredientText0),
          "    • " + ingredient30);
      expect(await driver.getText(Constants.viewRecipeIngredientText1),
          "    • " + ingredient31);
      expect(await driver.getText(Constants.viewRecipeIngredientText2),
          "    • " + ingredient32);
      expect(await driver.getText(Constants.viewRecipeIngredientLabelText1),
          labels3[3]);
      expect(await driver.getText(Constants.viewRecipeIngredientText3),
          "    • " + ingredient33);
      expect(await driver.getText(Constants.viewRecipeIngredientLabelText2),
          labels3[4]);
      expect(await driver.getText(Constants.viewRecipeIngredientText4),
          "    • " + ingredient34);
      expect(await driver.getText(Constants.viewRecipeIngredientText5),
          "    • " + ingredient35);

      expect(await driver.getText(Constants.viewRecipeInstructionText),
          instructions3);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('remove label third recipe', () async {
      await driver.tap(Constants.homeBottomBarRecipesIcon);

      await driver.tap(Constants.recipeListRowTitleText2);

      await driver.tap(Constants.viewRecipeFloatingActionEditButton);

      await driver.scrollIntoView(Constants.saveRecipeLabelRemoveIcon1);

      await driver.tap(Constants.saveRecipeLabelRemoveIcon1);
      await Future.delayed(Duration(seconds: 1));

      await driver.tap(Constants.saveRecipeFloatingActionSaveButton);

      expect(await driver.getText(Constants.viewRecipeIngredientLabelText0),
          labels3[0]);
      expect(await driver.getText(Constants.viewRecipeIngredientText0),
          "    • " + ingredient30);
      expect(await driver.getText(Constants.viewRecipeIngredientText1),
          "    • " + ingredient31);
      expect(await driver.getText(Constants.viewRecipeIngredientText2),
          "    • " + ingredient32);
      expect(await driver.getText(Constants.viewRecipeIngredientText3),
          "    • " + ingredient33);
      expect(await driver.getText(Constants.viewRecipeIngredientLabelText1),
          labels3[4]);
      expect(await driver.getText(Constants.viewRecipeIngredientText4),
          "    • " + ingredient34);
      expect(await driver.getText(Constants.viewRecipeIngredientText5),
          "    • " + ingredient35);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('edit label third recipe', () async {
      await driver.tap(Constants.homeBottomBarRecipesIcon);

      await driver.tap(Constants.recipeListRowTitleText2);

      await driver.tap(Constants.viewRecipeFloatingActionEditButton);

      await driver.scrollIntoView(Constants.saveRecipeLabelField0);

      await driver.tap(Constants.saveRecipeLabelField0);
      await driver.enterText(labels3[0] + " editado");

      await driver.tap(Constants.saveRecipeFloatingActionSaveButton);

      expect(await driver.getText(Constants.viewRecipeIngredientLabelText0),
          labels3[0] + " editado");
      expect(await driver.getText(Constants.viewRecipeIngredientText0),
          "    • " + ingredient30);
      expect(await driver.getText(Constants.viewRecipeIngredientText1),
          "    • " + ingredient31);
      expect(await driver.getText(Constants.viewRecipeIngredientText2),
          "    • " + ingredient32);
      expect(await driver.getText(Constants.viewRecipeIngredientText3),
          "    • " + ingredient33);
      expect(await driver.getText(Constants.viewRecipeIngredientLabelText1),
          labels3[4]);
      expect(await driver.getText(Constants.viewRecipeIngredientText4),
          "    • " + ingredient34);
      expect(await driver.getText(Constants.viewRecipeIngredientText5),
          "    • " + ingredient35);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('edit ingredient third recipe', () async {
      await driver.tap(Constants.homeBottomBarRecipesIcon);

      await driver.tap(Constants.recipeListRowTitleText2);

      await driver.tap(Constants.viewRecipeFloatingActionEditButton);

      await driver.scrollIntoView(Constants.saveRecipeIngredientField2);

      await driver.tap(Constants.saveRecipeIngredientField2);
      await driver.enterText(ingredient32 + " editado");

      await driver.tap(Constants.saveRecipeFloatingActionSaveButton);

      expect(await driver.getText(Constants.viewRecipeIngredientLabelText0),
          labels3[0] + " editado");
      expect(await driver.getText(Constants.viewRecipeIngredientText0),
          "    • " + ingredient30);
      expect(await driver.getText(Constants.viewRecipeIngredientText1),
          "    • " + ingredient31);
      expect(await driver.getText(Constants.viewRecipeIngredientText2),
          "    • " + ingredient32 + " editado");
      expect(await driver.getText(Constants.viewRecipeIngredientText3),
          "    • " + ingredient33);
      expect(await driver.getText(Constants.viewRecipeIngredientLabelText1),
          labels3[4]);
      expect(await driver.getText(Constants.viewRecipeIngredientText4),
          "    • " + ingredient34);
      expect(await driver.getText(Constants.viewRecipeIngredientText5),
          "    • " + ingredient35);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('remove ingredient third recipe', () async {
      await driver.tap(Constants.homeBottomBarRecipesIcon);

      await driver.tap(Constants.recipeListRowTitleText2);

      await driver.tap(Constants.viewRecipeFloatingActionEditButton);

      await driver.scrollIntoView(Constants.saveRecipeIngredientRemoveIcon3);

      await driver.tap(Constants.saveRecipeIngredientRemoveIcon3);

      await driver.tap(Constants.saveRecipeFloatingActionSaveButton);

      expect(await driver.getText(Constants.viewRecipeIngredientLabelText0),
          labels3[0] + " editado");
      expect(await driver.getText(Constants.viewRecipeIngredientText0),
          "    • " + ingredient30);
      expect(await driver.getText(Constants.viewRecipeIngredientText1),
          "    • " + ingredient31);
      expect(await driver.getText(Constants.viewRecipeIngredientText2),
          "    • " + ingredient32 + " editado");
      expect(await driver.getText(Constants.viewRecipeIngredientLabelText1),
          labels3[4]);
      expect(await driver.getText(Constants.viewRecipeIngredientText3),
          "    • " + ingredient34);
      expect(await driver.getText(Constants.viewRecipeIngredientText4),
          "    • " + ingredient35);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('view recipe', () async {
      await driver.tap(Constants.homeBottomBarRecipesIcon);

      await driver.tap(Constants.recipeListRowTitleText0);

      expect(await driver.getText(Constants.viewRecipeTitle), recipeName1);
      expect(await driver.getText(Constants.viewRecipeIngredientText0),
          "• " + ingredient10);
      expect(await driver.getText(Constants.viewRecipeIngredientText1),
          "• " + ingredient11);
      expect(
          await driver.getText(Constants.viewRecipePreparationTimeDetailsText),
          '10 m preparo + 2 h cozimento');

      expect(await driver.getText(Constants.viewRecipeInstructionText),
          instructions1);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('edit recipe', () async {
      await driver.tap(Constants.homeBottomBarRecipesIcon);

      await driver.tap(Constants.recipeListRowTitleText0);

      await driver.tap(Constants.viewRecipeFloatingActionEditButton);

      await driver.tap(Constants.saveRecipeNameField);
      await driver.enterText(recipeName1 + " editado");

      await driver.tap(Constants.saveRecipeFloatingActionSaveButton);

      expect(await driver.getText(Constants.viewRecipeTitle),
          recipeName1 + " editado");

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('edit label recipe with auto complete', () async {
      await driver.tap(Constants.homeBottomBarRecipesIcon);

      await driver.tap(Constants.recipeListRowTitleText0);

      await driver.tap(Constants.viewRecipeFloatingActionEditButton);

      await driver.tap(Constants.saveRecipeLabelField);
      await driver.enterText(label2.substring(0, 3));
      await driver.tap(find.text(label2));

      await driver.tap(Constants.saveRecipeFloatingActionSaveButton);

      expect(
          (await driver.getText(Constants.viewRecipeLabelLabelText))
              .contains(label2),
          true);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('share recipe', () async {
      await driver.tap(Constants.homeBottomBarRecipesIcon);

      await driver.tap(Constants.recipeListRowTitleText0);

      await driver.tap(Constants.viewRecipeShareRecipeAction);

      await driver.tap(Constants.viewRecipeCopyContentToClipboardAction);

      await driver.tap(Constants.viewRecipeShareRecipeAction);

      await driver.tap(Constants.viewRecipeShareAsImagesAction);

      await driver.tap(Constants.viewRecipeShareRecipeAction);

      await driver.tap(Constants.viewRecipeShareAsPdfAction);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('add first recipe to new grocery list', () async {
      await driver.tap(Constants.homeBottomBarRecipesIcon);

      await driver.tap(Constants.recipeListRowTitleText0);

      await driver.tap(Constants.viewRecipeAddToGroceryListAction);

      await driver.tap(Constants.addRecipeToGroceryListDialogPortionTextField);
      await driver.enterText("2");

      await driver.tap(Constants.addRecipeToGroceryListDialogConfirmButton);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);

      await driver.tap(Constants.homeBottomBarListsIcon);

      expect(await Helper.isPresent(Constants.groceryListRowTitleText0, driver),
          true);

      await driver.tap(Constants.groceryListRowTitleText0);

      expect(await driver.getText(Constants.groceryItemTextField0), "2 chuchu");

      expect(await driver.getText(Constants.groceryItemTextField1),
          "2 colheres de chá sal");

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('check last used recipe on home', () async {
      await driver.tap(Constants.homeBottomBarHomeIcon);

      expect(
          await Helper.isPresent(Constants.homeCardLastGroceryListUsed, driver),
          true);

      await driver.tap(Constants.homeCardLastGroceryListUsedAction);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);

      await driver.tap(Constants.homeCardRecipeButton0);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('add second recipe to same grocery list', () async {
      await driver.tap(Constants.homeBottomBarRecipesIcon);

      await driver.tap(Constants.viewRecipeAddToGroceryListAction1);

      await driver.tap(Constants.addRecipeToGroceryListDialogPortionTextField);
      await driver.enterText("9");

      await driver.tap(Constants.addRecipeToGroceryListDialogConfirmButton);

      await driver.tap(Constants.viewRecipeGroceryListToSelect0);

      await driver.tap(Constants.homeBottomBarListsIcon);

      await driver.tap(Constants.groceryListRowTitleText0);

      expect(await driver.getText(Constants.groceryItemTextField0), "2 chuchu");

      expect(await driver.getText(Constants.groceryItemTextField1),
          "5 colheres de chá sal");

      expect(
          await driver.getText(Constants.groceryItemTextField2), "3 beterraba");

      expect(await driver.getText(Constants.groceryItemTextField3),
          "4 1/2 colheres de chá açucar");

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('add second recipe to new grocery list', () async {
      await driver.tap(Constants.homeBottomBarRecipesIcon);

      await driver.tap(Constants.recipeListRowTitleText1);

      await driver.tap(Constants.viewRecipeAddToGroceryListAction);

      await driver.tap(Constants.addRecipeToGroceryListDialogPortionTextField);
      await driver.enterText("2");

      await driver.tap(Constants.addRecipeToGroceryListDialogConfirmButton);

      await driver.tap(Constants.viewRecipeCreateNewGroceryListAction);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);

      await driver.tap(Constants.homeBottomBarListsIcon);

      expect(await Helper.isPresent(Constants.groceryListRowTitleText1, driver),
          true);
    });

    test('edit grocery list item name', () async {
      await driver.tap(Constants.homeBottomBarListsIcon);

      await driver.tap(Constants.groceryListRowTitleText0);

      await driver.tap(Constants.groceryItemTextField0);
      await driver.enterText("1 chuchu grande");

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);

      await driver.tap(Constants.groceryListRowTitleText0);

      expect(await driver.getText(Constants.groceryItemTextField0),
          "1 chuchu grande");

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('edit grocery list drag item', () async {
      await driver.tap(Constants.homeBottomBarListsIcon);

      await driver.tap(Constants.groceryListRowTitleText0);

      await driver.scroll(Constants.groceryItemActionIcon2, 0, -75,
          Duration(milliseconds: 3000));

      await Future.delayed(Duration(seconds: 2));

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('edit grocery list check item', () async {
      await driver.tap(Constants.homeBottomBarListsIcon);

      await driver.tap(Constants.groceryListRowTitleText0);

      await driver.tap(Constants.groceryItemCheckBox1);

      expect(
          await Helper.isPresent(Constants.saveGroceryListShowChecked, driver),
          true);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('edit grocery list show recipes', () async {
      await driver.tap(Constants.homeBottomBarListsIcon);

      await driver.tap(Constants.groceryListRowTitleText0);

      await driver.tap(Constants.saveGroceryListBottomActionIcon);

      await driver.tap(Constants.groceryItemActionIcon1);

      expect(
          await driver.getText(Constants.ingredientRecipeSourceDialogRecipe0),
          recipeName2);
      expect(
          await driver.getText(
              Constants.ingredientRecipeSourceDialogRecipeIngredientQuantity0),
          "1 1/2 colheres de chá");

      await driver.tap(Constants.ingredientRecipeSourceDialogCloseButton);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('edit grocery list archive recipes', () async {
      await driver.tap(Constants.homeBottomBarListsIcon);

      await driver.tap(Constants.groceryListRowTitleText0);

      await driver.tap(Constants.saveGroceryListArchiveAction);

      await driver.tap(Constants.saveGroceryListArchiveConfirm);

      expect(await Helper.isPresent(Constants.groceryListRowTitleText0, driver),
          true);

      expect(await Helper.isPresent(Constants.groceryListRowTitleText1, driver),
          false);
    });

    test('show grocery list recipes', () async {
      await driver.tap(Constants.homeBottomBarListsIcon);

      await driver.tap(Constants.groceryListRowShowRecipes0);

      expect(await driver.getText(Constants.groceryListRecipesDialogRecipe0),
          recipeName1 + " editado");

      expect(await driver.getText(Constants.groceryListRecipesDialogRecipe1),
          recipeName2);

      await driver.tap(Constants.groceryListRecipesDialogCloseButton);
    });

    test('new grocery list', () async {
      await driver.tap(Constants.homeBottomBarListsIcon);

      await driver.tap(Constants.homeFloatingActionNewGroceryListButton);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('add items to new grocery list', () async {
      await driver.tap(Constants.homeBottomBarListsIcon);

      await driver.tap(Constants.groceryListRowTitleText0);

      String groceryItem0 = 'sabão em pó';
      await driver.tap(Constants.groceryItemTextField0);
      await driver.enterText(groceryItem0);
      await driver.enterText("\n");

      String groceryItem1 = '1 colher de sopa de azeite';
      await driver.tap(Constants.groceryItemTextField1);
      await driver.enterText(groceryItem1);
      await driver.enterText("\n");

      String groceryItem2 = '1 coca';
      await driver.tap(Constants.groceryItemTextField2);
      await driver.enterText(groceryItem2);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);

      await driver.tap(Constants.groceryListRowTitleText0);

      expect(
          await driver.getText(Constants.groceryItemTextField0), groceryItem0);
      expect(await driver.getText(Constants.groceryItemTextField1),
          '1 colher de sopa azeite');
      expect(
          await driver.getText(Constants.groceryItemTextField2), groceryItem2);

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('configure local backup', () async {
      await driver.tap(Constants.homeBottomBarHomeIcon);

      expect(await Helper.isPresent(Constants.homeCardConfigureBackup, driver),
          true);

      await driver.tap(Constants.homeCardConfigureBackupAction);

      await driver.tap(Constants.settingsLocalButtton);

      expect(await driver.getText(Constants.settingsConfiguredAtText),
          'Configurado em: Local');

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('do local backup again', () async {
      await driver.tap(Constants.homeBottomBarHomeIcon);

      await driver.tap(Constants.homeActionSettingsIcon);

      await driver.tap(Constants.settingsDoBackupButton);

      expect(await driver.getText(Constants.settingsConfiguredAtText),
          'Configurado em: Local');

      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('do first menu planning', () async {
      await driver.tap(Constants.homeBottomBarHomeIcon);

      await driver.tap(Constants.homeCardDoMenuPlanning);

      await driver.tap(Constants.menuPlanningDayAddMealButton0);

      await driver.tap(Constants.menuPlanningDayPickRecipeTextButton00);

      await driver.tap(Constants.recipesListFilter);
      await driver.enterText(recipeName1);

      await driver.tap(Constants.recipeListRowTitleText0);

      await driver.tap(Constants.menuPlanningDayAddMealButton0);

      await driver.tap(Constants.menuPlanningWriteDetailsTextButton01);

      await driver.tap(Constants.menuPlanningWriteDetailsTextField01);
      await driver.enterText("segredo");

      await driver.tap(Constants.menuPlanningDayAddMealButton1);

      await driver.tap(Constants.menuPlanningDayPickRecipeTextButton10);

      await driver.tap(Constants.recipesListFilter);
      await driver.enterText(recipeName2);

      await driver.tap(Constants.recipeListRowTitleText0);

      await driver.tap(Constants.saveMenuPlanningFloatingActionSaveButton);

      expect(await driver.getText(Constants.menuPlanningDaysMealText00),
          "almoço: cozinhar");
      await driver.tap(Constants.menuPlanningDaysMealTextButton00);
      expect(await driver.getText(Constants.viewRecipeTitle),
          recipeName1 + " editado");
      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);

      expect(await driver.getText(Constants.menuPlanningDaysMealText01),
          "jantar: cozinhar");
      expect(
          await driver.getText(Constants.menuPlanningDaysMealDescriptionText01),
          "segredo");

      expect(await driver.getText(Constants.menuPlanningDaysMealText10),
          "almoço: cozinhar");
      await driver.tap(Constants.menuPlanningDaysMealTextButton10);
      expect(await driver.getText(Constants.viewRecipeTitle), recipeName2);
      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });

    test('edit menu planning', () async {
      await driver.tap(Constants.homeBottomBarHomeIcon);

      await driver.tap(Constants.homeCardSeeMenuPlanning);

      await driver.tap(Constants.viewMenuPlanningFloatingActionEditButton);

      await driver.tap(Constants.menuPlanningWriteDetailsTextField01);
      await driver.enterText("segredo editado");

      await driver.tap(Constants.menuPlanningDayAddMealButton00);

      await driver.tap(Constants.saveMenuPlanningStartAtIcon);

      await driver.tap(find.text(DateTime.now().day.toString()));
      await driver.tap(find.text('OK'));

      await driver.tap(Constants.saveMenuPlanningFloatingActionSaveButton);

      expect(await driver.getText(Constants.menuPlanningDaysMealText00),
          "jantar: cozinhar");
      expect(
          await driver.getText(Constants.menuPlanningDaysMealDescriptionText00),
          "segredo editado");

      expect(await driver.getText(Constants.menuPlanningDaysMealText10),
          "almoço: cozinhar");
      await driver.tap(Constants.menuPlanningDaysMealTextButton10);
      expect(await driver.getText(Constants.viewRecipeTitle), recipeName2);
      await driver.waitFor(Constants.backButtonFinder);
      await driver.tap(Constants.backButtonFinder);
    });
  });
}
