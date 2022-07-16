import 'package:flutter_driver/flutter_driver.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:test/test.dart';

import 'constants.dart';
import 'driver_helper.dart';

class GroceryListItemInput {
  final String name;
  final String marketSection;

  GroceryListItemInput(this.name, this.marketSection);
}

void main() {
  group('market section app test', () {
    final List<GroceryListItemInput> inputsGrocery1 = [
      GroceryListItemInput('item 1', 'Cervejas'),
      GroceryListItemInput('item 2', 'Congelados'),
      GroceryListItemInput('item 3', 'Congelados'),
      GroceryListItemInput('item 4', 'Açougue'),
      GroceryListItemInput('item 5', null),
      GroceryListItemInput('item 6', 'Açougue'),
    ];

    final List<GroceryListItemInput> inputsGrocery2 = [
      GroceryListItemInput('item 1', 'Cervejas'),
      GroceryListItemInput('item 2', 'Congelados'),
      GroceryListItemInput('item 3', 'Congelados'),
      GroceryListItemInput('item 4', 'Açougue'),
      GroceryListItemInput('item 5', null),
      GroceryListItemInput('item 6', 'Açougue'),
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

    checkItem(int index, String name) async {
      final itemKey = Keys.groceryItemTextField + index.toString();
      await driver.scrollUntilVisible(Keys.saveGroceryListList, itemKey,
          dyScroll: -300.0);
      expect(await driver.getText(itemKey), name);
    }

    test('add grocery list 1', () async {
      await driver.tap(Keys.homeBottomBarListsIcon);

      await driver.tap(Keys.homeFloatingActionNewGroceryListButton);

      for (int i = 0; i < inputsGrocery1.length; i++) {
        final itemKey = Keys.groceryItemTextField + i.toString();
        GroceryListItemInput input = inputsGrocery1[i];
        await driver.scrollUntilVisible(Keys.saveGroceryListList, itemKey,
            dyScroll: -300.0);
        await driver.tap(itemKey);
        await driver.enterText(input.name);
        await Future.delayed(Duration(milliseconds: 500));
        await driver.enterText(
            i == inputsGrocery1.length - 1 ? input.name : input.name + "\n");
      }

      await driver.tapBackButton();

      await driver.tap(Constants.groceryListRowTitleText0);

      await checkItem(0, inputsGrocery1[0].name);
      await checkItem(1, inputsGrocery1[1].name);
      await checkItem(2, inputsGrocery1[2].name);
      await checkItem(3, inputsGrocery1[3].name);
      await checkItem(4, inputsGrocery1[4].name);
      await checkItem(5, inputsGrocery1[5].name);

      await driver.tapBackButton();
    });

    test('edit grocery list items market section', () async {
      await driver.tap(Keys.homeBottomBarListsIcon);

      await driver.tap(Constants.groceryListRowTitleText0);

      await driver.tap(Keys.saveGroceryListBottomActionIcon);

      await driver.tap(Keys.saveGroceryListBottomActionEditMarketSections);

      for (int i = 0; i < inputsGrocery1.length; i++) {
        final itemKey = Keys.groceryItemAddMarketSectionIcon + i.toString();
        GroceryListItemInput input = inputsGrocery1[i];
        if (input.marketSection == null) {
          continue;
        }
        await driver.scrollUntilVisible(Keys.saveGroceryListList, itemKey,
            dyScroll: -300.0);
        await driver.tap(itemKey);
        await driver.tapInText(input.marketSection);

        await Future.delayed(Duration(milliseconds: 500));

        expect(
            await driver
                .getText(Keys.groceryItemMarketSectionText + i.toString()),
            input.marketSection);
      }

      await driver.tapBackButton();
    });

    test('order grocery list items by market section', () async {
      await driver.tap(Keys.homeBottomBarListsIcon);

      await driver.tap(Constants.groceryListRowTitleText0);

      String checkItemKey = Keys.groceryItemCheckBox + "5";
      await driver.scrollUntilVisible(Keys.saveGroceryListList, checkItemKey,
          dyScroll: -300.0);
      await driver.tap(checkItemKey);

      expect(await driver.isPresent(Keys.saveGroceryListShowChecked), true);

      await driver.tap(Keys.saveGroceryListBottomActionIcon);

      await driver.tap(Keys.saveGroceryListBottomActionOrderByMarketSections);

      await driver.scrollUntilVisible(
          Keys.saveGroceryListList, Keys.saveGroceryListShowChecked,
          dyScroll: -300.0);
      await driver.tap(Keys.saveGroceryListShowChecked);

      await checkItem(0, inputsGrocery1[3].name);
      await checkItem(1, inputsGrocery1[1].name);
      await checkItem(2, inputsGrocery1[2].name);
      await checkItem(3, inputsGrocery1[0].name);
      await checkItem(4, inputsGrocery1[4].name);
      await checkItem(5, inputsGrocery1[5].name);

      await driver.tapBackButton();
    });

    test('add grocery list 2', () async {
      await driver.tap(Keys.homeBottomBarListsIcon);

      await driver.tap(Keys.homeFloatingActionNewGroceryListButton);

      for (int i = 0; i < inputsGrocery2.length; i++) {
        final itemKey = Keys.groceryItemTextField + i.toString();
        GroceryListItemInput input = inputsGrocery1[i];
        await driver.scrollUntilVisible(Keys.saveGroceryListList, itemKey,
            dyScroll: -300.0);
        await driver.tap(itemKey);
        await driver.enterText(input.name);
        await Future.delayed(Duration(milliseconds: 500));
        await driver.enterText(
            i == inputsGrocery1.length - 1 ? input.name : input.name + "\n");
      }

      await driver.tapBackButton();

      await driver.tap(Constants.groceryListRowTitleText0);

      await checkItem(0, inputsGrocery2[0].name);
      await checkItem(1, inputsGrocery2[1].name);
      await checkItem(2, inputsGrocery2[2].name);
      await checkItem(3, inputsGrocery2[3].name);
      await checkItem(4, inputsGrocery2[4].name);
      await checkItem(5, inputsGrocery2[5].name);

      await driver.tapBackButton();
    });

    test('check grocery list items market section', () async {
      await driver.tap(Keys.homeBottomBarListsIcon);

      await driver.tap(Constants.groceryListRowTitleText0);

      await driver.tap(Keys.saveGroceryListBottomActionIcon);

      await driver.tap(Keys.saveGroceryListBottomActionEditMarketSections);

      for (int i = 0; i < inputsGrocery2.length; i++) {
        final itemKey = Keys.groceryItemMarketSectionText + i.toString();
        GroceryListItemInput input = inputsGrocery1[i];
        if (input.marketSection == null) {
          continue;
        }
        await driver.scrollUntilVisible(Keys.saveGroceryListList, itemKey,
            dyScroll: -300.0);

        expect(await driver.getText(itemKey), input.marketSection);
      }

      await driver.tapBackButton();
    });
  });
}
