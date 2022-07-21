import 'package:flutter_driver/flutter_driver.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe_preparation_time_details.dart';
import 'package:test/test.dart';

import '../utils/driver_helper.dart';
import '../utils/helper.dart';

class RecipeInput {
  final String name;
  final String portion;
  final String label;
  final RecipePreparationTimeDetails preparationTime;
  final List<String> ingredients;
  final String instructions;

  RecipeInput(this.name, this.portion, this.label, this.preparationTime,
      this.ingredients, this.instructions);
}

void main() {
  group('recipe list app test', () {
    final List<RecipeInput> recipeInputs = [
      RecipeInput(
          'Minha primeira receita!',
          '1.00',
          'label1',
          RecipePreparationTimeDetails(cooking: 90, preparation: 10),
          ['1 chuchu', '1 colher de chá de sal'],
          'Vamos preparar minha primeira receita\n\\o/'),
      RecipeInput(
          'Minha segunda receita!',
          '2.00',
          null,
          RecipePreparationTimeDetails(preparation: 45),
          [
            '1 beterraba',
            '1 colher de chá de sal',
            '1 1/2 colher de chá de açucar demerara'
          ],
          'Vamos preparar minha primeira receita\n\\o/'),
      RecipeInput(
          'Terceira receita!',
          '3.00',
          'label2',
          RecipePreparationTimeDetails(oven: 50, preparation: 4),
          ['1 colher de chá de sal', '1 1/2 colher de chá de açucar'],
          'Vamos preparar minha terceira receita\n\\o/'),
      RecipeInput(
          'Quarta receita lol!',
          '3.00',
          'label4',
          RecipePreparationTimeDetails(preparation: 22),
          ['1 colher de chá de sal', '1 1/2 colher de chá de açucar'],
          'Vamos preparar minha receita\n\\o/'),
      RecipeInput(
          'Quinta receita lol!',
          '3.00',
          'label3',
          RecipePreparationTimeDetails(cooking: 100, preparation: 9, oven: 60),
          [
            '1 petiti gatewau pronto',
          ],
          'Vamos preparar minha receita\n\\o/'),
      RecipeInput(
          'Sexta receita!',
          '3.00',
          'label2',
          RecipePreparationTimeDetails(
              cooking: 100, preparation: 100, oven: 100, freezer: 100),
          [
            '1 kilo sal',
          ],
          'Vamos preparar minha sexta receita, eu nao acredito\n\\o/'),
    ];

    DriverHelper driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = new DriverHelper(await FlutterDriver.connect());
      await driver.tap(Keys.actionDeleteAllIcon);
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      await driver.close();
    });

    clearSearch() async {
      await driver.tap(Keys.recipesListSort);

      await driver.tap(Keys.chooseRecipeSortDialogClear);

      await driver.tap(Keys.recipesListLabelIcon);

      await driver.tap(Keys.chooseRecipeLabelDialogClear);

      await driver.tap(Keys.recipesListFilter);
      await driver.enterText('');
    }

    expectNotifications(bool shouldSortNoficitaionBePresent,
        bool shouldLabelNoficitaionBePresent) async {
      expect(await driver.isPresent(Keys.recipesListSortNotification),
          shouldSortNoficitaionBePresent);

      expect(await driver.isPresent(Keys.recipesListLabelNotification),
          shouldLabelNoficitaionBePresent);
    }

    Future<void> checkItemName(int listIndex, int inputIndex) async {
      await driver.scrollUntilVisible(
          Keys.recipesList, Keys.recipeListRowTitleText + listIndex.toString(),
          dyScroll: -300.0);
      expect(
          await driver
              .getText(Keys.recipeListRowTitleText + listIndex.toString()),
          recipeInputs[inputIndex].name);
    }

    test('recipes initial screen', () async {
      await driver.tap(Keys.homeBottomBarRecipesIcon);

      expect(await driver.isPresent(Keys.recipesListEmptyText), true);
    });

    test(
      'insert recipes',
      () async {
        await driver.tap(Keys.homeBottomBarRecipesIcon);

        for (int i = 0; i < recipeInputs.length; i++) {
          RecipeInput input = recipeInputs[i];
          await Helper.addRecipe(
              driver,
              input.name,
              input.portion,
              input.label,
              input.preparationTime,
              null,
              input.ingredients,
              input.instructions);
        }
      },
      timeout: Timeout(Duration(minutes: 1)),
    );

    test('newest recipes sorting', () async {
      await driver.tap(Keys.homeBottomBarRecipesIcon);

      await driver.tap(Keys.recipesListSort);

      await driver.tap(Keys.chooseRecipeSortDialogNewestRadio);

      await driver.scrollUntilVisible(
        Keys.recipesList,
        Keys.recipeListRowTitleText + '0',
        dyScroll: 300.0,
      );

      for (int i = 0; i < recipeInputs.length; i++) {
        final itemKey = Keys.recipeListRowTitleText + i.toString();
        RecipeInput input = recipeInputs[recipeInputs.length - i - 1];
        await driver.scrollUntilVisible(Keys.recipesList, itemKey,
            dyScroll: -300.0);
        expect(await driver.getText(itemKey), input.name);
      }

      await expectNotifications(true, false);
    });

    test('oldest recipes sorting', () async {
      await driver.tap(Keys.homeBottomBarRecipesIcon);

      await driver.tap(Keys.recipesListSort);

      await driver.tap(Keys.chooseRecipeSortDialogOldesRadio);

      await driver.scrollUntilVisible(
        Keys.recipesList,
        Keys.recipeListRowTitleText + '0',
        dyScroll: 300.0,
      );

      for (int i = 0; i < recipeInputs.length; i++) {
        final itemKey = Keys.recipeListRowTitleText + i.toString();
        RecipeInput input = recipeInputs[i];
        await driver.scrollUntilVisible(Keys.recipesList, itemKey,
            dyScroll: -300.0);
        expect(await driver.getText(itemKey), input.name);
      }

      await expectNotifications(true, false);
    });

    test('faster recipes sorting', () async {
      await driver.tap(Keys.homeBottomBarRecipesIcon);

      await driver.tap(Keys.recipesListSort);

      await driver.tap(Keys.chooseRecipeSortDialogFasterRadio);

      await driver.scrollUntilVisible(
        Keys.recipesList,
        Keys.recipeListRowTitleText + '0',
        dyScroll: 300.0,
      );

      await checkItemName(0, 3);
      await checkItemName(1, 1);
      await checkItemName(2, 2);
      await checkItemName(3, 0);
      await checkItemName(4, 4);
      await checkItemName(5, 5);

      await expectNotifications(true, false);
    });

    test('slower recipes sorting', () async {
      await driver.tap(Keys.homeBottomBarRecipesIcon);

      await driver.tap(Keys.recipesListSort);

      await driver.tap(Keys.chooseRecipeSortDialogSlowerRadio);

      await driver.scrollUntilVisible(
        Keys.recipesList,
        Keys.recipeListRowTitleText + '0',
        dyScroll: 300.0,
      );

      await checkItemName(0, 5);
      await checkItemName(1, 4);
      await checkItemName(2, 0);
      await checkItemName(3, 2);
      await checkItemName(4, 1);
      await checkItemName(5, 3);

      await expectNotifications(true, false);
    });

    test('titleAz recipes sorting', () async {
      await driver.tap(Keys.homeBottomBarRecipesIcon);

      await driver.tap(Keys.recipesListSort);

      await driver.tap(Keys.chooseRecipeSortDialogTitleAzRadio);

      await driver.scrollUntilVisible(
        Keys.recipesList,
        Keys.recipeListRowTitleText + '0',
        dyScroll: 300.0,
      );

      await checkItemName(0, 0);
      await checkItemName(1, 1);
      await checkItemName(2, 3);
      await checkItemName(3, 4);
      await checkItemName(4, 5);
      await checkItemName(5, 2);

      await expectNotifications(true, false);
    });

    test('titleZa recipes sorting', () async {
      await driver.tap(Keys.homeBottomBarRecipesIcon);

      await driver.tap(Keys.recipesListSort);

      await driver.tap(Keys.chooseRecipeSortDialogTitleZaRadio);

      await driver.scrollUntilVisible(
        Keys.recipesList,
        Keys.recipeListRowTitleText + '0',
        dyScroll: 300.0,
      );

      await checkItemName(0, 2);
      await checkItemName(1, 5);
      await checkItemName(2, 4);
      await checkItemName(3, 3);
      await checkItemName(4, 1);
      await checkItemName(5, 0);

      await expectNotifications(true, false);
    });

    test('filter recipe name', () async {
      await driver.tap(Keys.homeBottomBarRecipesIcon);

      await clearSearch();

      await driver.tap(Keys.recipesListFilter);
      await driver.enterText('lol');

      await driver.scrollUntilVisible(
        Keys.recipesList,
        Keys.recipeListRowTitleText + '0',
        dyScroll: 300.0,
      );

      await checkItemName(0, 3);
      await checkItemName(1, 4);

      await expectNotifications(false, false);
    });

    test('filter ingredient name', () async {
      await driver.tap(Keys.homeBottomBarRecipesIcon);

      await clearSearch();

      await driver.tap(Keys.recipesListFilter);
      await driver.enterText('açucar demerara');

      await driver.scrollUntilVisible(
        Keys.recipesList,
        Keys.recipeListRowTitleText + '0',
        dyScroll: 300.0,
      );

      await checkItemName(0, 1);

      await expectNotifications(false, false);
    });

    test('filter instructions name', () async {
      await driver.tap(Keys.homeBottomBarRecipesIcon);

      await clearSearch();

      await driver.tap(Keys.recipesListFilter);
      await driver.enterText('nao acredito');

      await driver.scrollUntilVisible(
        Keys.recipesList,
        Keys.recipeListRowTitleText + '0',
        dyScroll: 300.0,
      );

      await checkItemName(0, 5);

      await expectNotifications(false, false);
    });

    test('filter by label', () async {
      await driver.tap(Keys.homeBottomBarRecipesIcon);

      await clearSearch();

      await driver.tap(Keys.recipesListLabelIcon);

      await driver.tap('${Keys.chooseRecipeLabelDialogOption}-1');

      await driver.scrollUntilVisible(
        Keys.recipesList,
        Keys.recipeListRowTitleText + '0',
        dyScroll: 300.0,
      );

      await checkItemName(0, 5);
      await checkItemName(1, 2);

      await expectNotifications(false, true);
    });

    test('filter by label and recipe name', () async {
      await driver.tap(Keys.homeBottomBarRecipesIcon);

      await clearSearch();

      await driver.tap(Keys.recipesListLabelIcon);

      await driver.tap('${Keys.chooseRecipeLabelDialogOption}-2');

      await driver.tap(Keys.recipesListFilter);
      await driver.enterText('lol');

      await driver.scrollUntilVisible(
        Keys.recipesList,
        Keys.recipeListRowTitleText + '0',
        dyScroll: 300.0,
      );

      await checkItemName(0, 4);

      await expectNotifications(false, true);
    });
  });
}
