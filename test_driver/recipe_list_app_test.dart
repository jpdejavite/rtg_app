import 'package:flutter_driver/flutter_driver.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe_preparation_time_details.dart';
import 'package:test/test.dart';

import 'helper.dart';

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
    final homeBottomBarRecipesIcon =
        find.byValueKey(Keys.homeBottomBarRecipesIcon);
    final recipesList = find.byValueKey(Keys.recipesList);
    final actionDeleteAllIcon = find.byValueKey(Keys.actionDeleteAllIcon);
    final recipesListFilter = find.byValueKey(Keys.recipesListFilter);
    final recipesListSort = find.byValueKey(Keys.recipesListSort);
    final recipesListLabelIcon = find.byValueKey(Keys.recipesListLabelIcon);
    final chooseRecipeSortDialogNewestRadio =
        find.byValueKey(Keys.chooseRecipeSortDialogNewestRadio);
    final chooseRecipeSortDialogOldesRadio =
        find.byValueKey(Keys.chooseRecipeSortDialogOldesRadio);
    final chooseRecipeSortDialogFasterRadio =
        find.byValueKey(Keys.chooseRecipeSortDialogFasterRadio);
    final chooseRecipeSortDialogSlowerRadio =
        find.byValueKey(Keys.chooseRecipeSortDialogSlowerRadio);
    final chooseRecipeSortDialogTitleAzRadio =
        find.byValueKey(Keys.chooseRecipeSortDialogTitleAzRadio);
    final chooseRecipeSortDialogTitleZaRadio =
        find.byValueKey(Keys.chooseRecipeSortDialogTitleZaRadio);
    final chooseRecipeSortDialogClear =
        find.byValueKey(Keys.chooseRecipeSortDialogClear);
    final chooseRecipeLabelDialogClear =
        find.byValueKey(Keys.chooseRecipeLabelDialogClear);

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

    clearSearch() async {
      await driver.tap(recipesListSort);

      await driver.tap(chooseRecipeSortDialogClear);

      await driver.tap(recipesListLabelIcon);

      await driver.tap(chooseRecipeLabelDialogClear);

      await driver.tap(recipesListFilter);
      await driver.enterText('');
    }

    expectNotifications(bool shouldSortNoficitaionBePresent,
        bool shouldLabelNoficitaionBePresent) async {
      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.recipesListSortNotification), driver),
          shouldSortNoficitaionBePresent);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.recipesListLabelNotification), driver),
          shouldLabelNoficitaionBePresent);
    }

    Future<void> checkItemName(int listIndex, int inputIndex) async {
      final itemFinder =
          find.byValueKey(Keys.recipeListRowTitleText + listIndex.toString());
      await driver.scrollUntilVisible(recipesList, itemFinder,
          dyScroll: -300.0);
      expect(await driver.getText(itemFinder), recipeInputs[inputIndex].name);
    }

    test('recipes initial screen', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      expect(
          await Helper.isPresent(
              find.byValueKey(Keys.recipesListEmptyText), driver,
              timeout: Duration(seconds: 10)),
          true);
    });

    test('insert recipes', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      for (int i = 0; i < recipeInputs.length; i++) {
        RecipeInput input = recipeInputs[i];
        await Helper.addRecipe(driver, input.name, input.portion, input.label,
            input.preparationTime, null, input.ingredients, input.instructions);
      }
    });

    test('newest recipes sorting', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      await driver.tap(recipesListSort);

      await driver.tap(chooseRecipeSortDialogNewestRadio);

      await driver.scrollUntilVisible(
        recipesList,
        find.byValueKey(Keys.recipeListRowTitleText + '0'),
        dyScroll: 300.0,
      );

      for (int i = 0; i < recipeInputs.length; i++) {
        final itemFinder =
            find.byValueKey(Keys.recipeListRowTitleText + i.toString());
        RecipeInput input = recipeInputs[recipeInputs.length - i - 1];
        await driver.scrollUntilVisible(recipesList, itemFinder,
            dyScroll: -300.0);
        expect(await driver.getText(itemFinder), input.name);
      }

      await expectNotifications(true, false);
    });

    test('oldest recipes sorting', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      await driver.tap(recipesListSort);

      await driver.tap(chooseRecipeSortDialogOldesRadio);

      await driver.scrollUntilVisible(
        recipesList,
        find.byValueKey(Keys.recipeListRowTitleText + '0'),
        dyScroll: 300.0,
      );

      for (int i = 0; i < recipeInputs.length; i++) {
        final itemFinder =
            find.byValueKey(Keys.recipeListRowTitleText + i.toString());
        RecipeInput input = recipeInputs[i];
        await driver.scrollUntilVisible(recipesList, itemFinder,
            dyScroll: -300.0);
        expect(await driver.getText(itemFinder), input.name);
      }

      await expectNotifications(true, false);
    });

    test('faster recipes sorting', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      await driver.tap(recipesListSort);

      await driver.tap(chooseRecipeSortDialogFasterRadio);

      await driver.scrollUntilVisible(
        recipesList,
        find.byValueKey(Keys.recipeListRowTitleText + '0'),
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
      await driver.tap(homeBottomBarRecipesIcon);

      await driver.tap(recipesListSort);

      await driver.tap(chooseRecipeSortDialogSlowerRadio);

      await driver.scrollUntilVisible(
        recipesList,
        find.byValueKey(Keys.recipeListRowTitleText + '0'),
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
      await driver.tap(homeBottomBarRecipesIcon);

      await driver.tap(recipesListSort);

      await driver.tap(chooseRecipeSortDialogTitleAzRadio);

      await driver.scrollUntilVisible(
        recipesList,
        find.byValueKey(Keys.recipeListRowTitleText + '0'),
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
      await driver.tap(homeBottomBarRecipesIcon);

      await driver.tap(recipesListSort);

      await driver.tap(chooseRecipeSortDialogTitleZaRadio);

      await driver.scrollUntilVisible(
        recipesList,
        find.byValueKey(Keys.recipeListRowTitleText + '0'),
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
      await driver.tap(homeBottomBarRecipesIcon);

      await clearSearch();

      await driver.tap(recipesListFilter);
      await driver.enterText('lol');

      await driver.scrollUntilVisible(
        recipesList,
        find.byValueKey(Keys.recipeListRowTitleText + '0'),
        dyScroll: 300.0,
      );

      await checkItemName(0, 3);
      await checkItemName(1, 4);

      await expectNotifications(false, false);
    });

    test('filter ingredient name', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      await clearSearch();

      await driver.tap(recipesListFilter);
      await driver.enterText('açucar demerara');

      await driver.scrollUntilVisible(
        recipesList,
        find.byValueKey(Keys.recipeListRowTitleText + '0'),
        dyScroll: 300.0,
      );

      await checkItemName(0, 1);

      await expectNotifications(false, false);
    });

    test('filter instructions name', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      await clearSearch();

      await driver.tap(recipesListFilter);
      await driver.enterText('nao acredito');

      await driver.scrollUntilVisible(
        recipesList,
        find.byValueKey(Keys.recipeListRowTitleText + '0'),
        dyScroll: 300.0,
      );

      await checkItemName(0, 5);

      await expectNotifications(false, false);
    });

    test('filter by label', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      await clearSearch();

      await driver.tap(recipesListLabelIcon);

      await driver
          .tap(find.byValueKey('${Keys.chooseRecipeLabelDialogOption}-1'));

      await driver.scrollUntilVisible(
        recipesList,
        find.byValueKey(Keys.recipeListRowTitleText + '0'),
        dyScroll: 300.0,
      );

      await checkItemName(0, 5);
      await checkItemName(1, 2);

      await expectNotifications(false, true);
    });

    test('filter by label and recipe name', () async {
      await driver.tap(homeBottomBarRecipesIcon);

      await clearSearch();

      await driver.tap(recipesListLabelIcon);

      await driver
          .tap(find.byValueKey('${Keys.chooseRecipeLabelDialogOption}-2'));

      await driver.tap(recipesListFilter);
      await driver.enterText('lol');

      await driver.scrollUntilVisible(
        recipesList,
        find.byValueKey(Keys.recipeListRowTitleText + '0'),
        dyScroll: 300.0,
      );

      await checkItemName(0, 4);

      await expectNotifications(false, true);
    });
  });
}
