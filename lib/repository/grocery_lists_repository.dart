import 'dart:io';

import 'package:rtg_app/dao/grocery_lists_dao.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/grocery_lists_collection.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';

class GroceryListsRepository {
  final groceryListsDao = GroceryListsDao();

  Future<GroceryListsCollection> fetch({int limit, int offset}) =>
      groceryListsDao.fetch(limit: limit, offset: offset);

  Future<SaveGroceryListResponse> save(GroceryList groceryList) =>
      groceryListsDao.save(groceryList: groceryList);

  Future deleteAll() => groceryListsDao.deleteAll();

  Future mergeFromBackup({File file}) =>
      groceryListsDao.mergeFromBackup(file: file);

  Future<DataSummary> getSummary({File file}) =>
      groceryListsDao.getSummary(file: file);
}
