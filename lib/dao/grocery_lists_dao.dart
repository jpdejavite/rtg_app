import 'dart:async';
import 'dart:io';
import 'package:rtg_app/database/sembast_database.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/grocery_lists_collection.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';
import 'package:sembast/sembast.dart';

class GroceryListsDao {
  final dbProvider = SembastDatabaseProvider.dbProvider;
  final String storeName = 'groceryLists';

  Future<GroceryListsCollection> fetch({int offset, int limit}) async {
    var store = intMapStoreFactory.store(storeName);
    var db = await dbProvider.database;

    var finder = Finder(
      limit: limit,
      offset: offset != null ? offset : 0,
      filter: Filter.equals('status', GroceryListStatus.active.index),
      sortOrders: [
        SortOrder('updatedAt', false),
      ],
    );

    var records = await store.find(db, finder: finder);
    var total = await store.count(db,
        filter: Filter.equals('status', GroceryListStatus.active.index));

    List<GroceryList> groceryLists = groceryListsFromRecords(records);
    return GroceryListsCollection(groceryLists: groceryLists, total: total);
  }

  Future deleteAll() async {
    var store = intMapStoreFactory.store(storeName);
    var db = await dbProvider.database;
    await store.delete(db);
  }

  Future<SaveGroceryListResponse> save({GroceryList groceryList}) async {
    try {
      var store = intMapStoreFactory.store(storeName);
      var db = await dbProvider.database;
      if (!groceryList.hasId()) {
        await db.transaction((txn) async {
          int id = await store.add(txn, groceryList.toRecord());
          groceryList.id = id.toString();
        });
      } else {
        var record = store.record(int.parse(groceryList.id));
        await record.update(db, groceryList.toRecord());
      }

      return SaveGroceryListResponse(groceryList: groceryList);
    } catch (e) {
      return SaveGroceryListResponse(error: e);
    }
  }

  Future mergeFromBackup({File file}) async {
    try {
      final customDb =
          await SembastDatabaseProvider.dbProvider.createDatabase(file.path);
      var db = await dbProvider.database;
      var store = intMapStoreFactory.store(storeName);

      var total = await store.count(customDb);

      int limit = 100;
      for (int offset = 0; offset < total; offset += limit) {
        var finder = Finder(
          offset: offset,
          limit: limit,
        );
        var records = await store.find(customDb, finder: finder);
        records.forEach((record) async {
          GroceryList groceryList =
              GroceryList.fromRecord(record.key, record.value);

          var localRecord = store.record(int.parse(groceryList.id));
          var localRecordValue = await localRecord.get(db);
          if (localRecordValue == null || localRecordValue.isEmpty) {
            await db.transaction((txn) async {
              int id = await store.add(txn, groceryList.toRecord());
              groceryList.id = id.toString();
            });
          } else {
            GroceryList localGroceryList =
                GroceryList.fromRecord(localRecord.key, localRecordValue);
            if (localGroceryList.updatedAt < groceryList.updatedAt) {
              await localRecord.update(db, record.value);
            }
          }
        });
      }
      return null;
    } catch (e) {
      throw e;
    }
  }

  Future<DataSummary> getSummary({File file}) async {
    try {
      var db = await dbProvider.database;
      if (file != null) {
        db = await SembastDatabaseProvider.dbProvider.createDatabase(file.path);
      }
      var store = intMapStoreFactory.store(storeName);

      int total = await store.count(db);
      int lastUpdated = -1;

      var finder = Finder(
        limit: 1,
        sortOrders: [SortOrder('updatedAt', false)],
      );
      var records = await store.find(db, finder: finder);
      if (records != null && records.length > 0) {
        GroceryList groceryList =
            GroceryList.fromRecord(records[0].key, records[0].value);
        lastUpdated = groceryList.updatedAt;
      }
      return DataSummary(total: total, lastUpdated: lastUpdated);
    } catch (e) {
      throw e;
    }
  }
}
