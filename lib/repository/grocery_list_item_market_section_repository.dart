import 'dart:io';

import 'package:rtg_app/dao/grocery_list_item_market_section_dao.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:rtg_app/model/grocery_list_item_market_section.dart';
import 'package:rtg_app/model/save_grocery_list_item_market_section_response.dart';

class GroceryListItemMarketSectionRepository {
  final groceryListItemMarketSectionDao = GroceryListItemMarketSectionDao();

  Future<GroceryListItemMarketSection> get(String groceryListItemName) =>
      groceryListItemMarketSectionDao.get(groceryListItemName);

  Future<SaveGroceryListItemMarketSectionResponse> save(
          GroceryListItemMarketSection
              groceryListItemGroceryListItemMarketSection) =>
      groceryListItemMarketSectionDao.save(
              groceryListItemGroceryListItemMarketSection);

  Future deleteAllFromMarketSection(String marketSectionId) =>
      groceryListItemMarketSectionDao
          .deleteAllFromMarketSection(marketSectionId);

  Future deleteAll() => groceryListItemMarketSectionDao.deleteAll();

  Future mergeFromBackup({File file}) =>
      groceryListItemMarketSectionDao.mergeFromBackup(file: file);

  Future<DataSummary> getSummary({File file}) =>
      groceryListItemMarketSectionDao.getSummary(file: file);
}
