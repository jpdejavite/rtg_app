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
    final List<GroceryListItemInput> inputs = [
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

    test('new grocery list', () async {
      await driver.tap(Keys.homeBottomBarListsIcon);

      await driver.tap(Keys.homeFloatingActionNewGroceryListButton);

      for (int i = 0; i < inputs.length; i++) {
        final itemKey = Keys.groceryItemTextField + i.toString();
        GroceryListItemInput input = inputs[i];
        await driver.scrollUntilVisible(Keys.saveGroceryListList, itemKey,
            dyScroll: -300.0);
        await driver.tap(itemKey);
        await driver.enterText(input.name);
        await Future.delayed(Duration(milliseconds: 500));
        await driver
            .enterText(i == inputs.length - 1 ? input.name : input.name + "\n");
      }

      await driver.tapBackButton();

      await driver.tap(Constants.groceryListRowTitleText0);

      await checkItem(0, inputs[0].name);
      await checkItem(1, inputs[1].name);
      await checkItem(2, inputs[2].name);
      await checkItem(3, inputs[3].name);
      await checkItem(4, inputs[4].name);
      await checkItem(5, inputs[5].name);

      await driver.tapBackButton();
    });

    test('edit grocery list items market section', () async {
      await driver.tap(Keys.homeBottomBarListsIcon);

      await driver.tap(Constants.groceryListRowTitleText0);

      await driver.tap(Keys.saveGroceryListBottomActionIcon);

      await driver.tap(Keys.saveGroceryListBottomActionEditMarketSections);

      for (int i = 0; i < inputs.length; i++) {
        final itemKey = Keys.groceryItemAddMarketSectionIcon + i.toString();
        GroceryListItemInput input = inputs[i];
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

      await checkItem(0, inputs[3].name);
      await checkItem(1, inputs[1].name);
      await checkItem(2, inputs[2].name);
      await checkItem(3, inputs[0].name);
      await checkItem(4, inputs[4].name);
      await checkItem(5, inputs[5].name);

      await driver.tapBackButton();
    });
  });
}
