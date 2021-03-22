// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:test/test.dart';

import 'constants.dart';
import 'database_helper.dart';
import 'helper.dart';

void main() {
  group('New User RTG App', () {
    final homeBottomBarHomeIcon = find.byValueKey(Keys.homeBottomBarHomeIcon);
    final homeBottomBarRecipesIcon =
        find.byValueKey(Keys.homeBottomBarRecipesIcon);
    final homeBottomBarListsIcon = find.byValueKey(Keys.homeBottomBarListsIcon);

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await DatbaseHelper.initDB(Users.newUser);
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
              find.byValueKey(Keys.receipesListEmptyText), driver,
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
  });
}
