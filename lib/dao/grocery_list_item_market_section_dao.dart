import 'dart:async';
import 'dart:io';
import 'package:rtg_app/database/sembast_database.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:rtg_app/model/grocery_list_item_market_section.dart';
import 'package:rtg_app/model/save_grocery_list_item_market_section_response.dart';
import 'package:sembast/sembast.dart';

class GroceryListItemMarketSectionDao {
  final dbProvider = SembastDatabaseProvider.dbProvider;
  final String storeName = 'groceryListItemMarketSections';

  Future<GroceryListItemMarketSection> get(String groceryListItemName) async {
    var store = intMapStoreFactory.store(storeName);
    var db = await dbProvider.database;

    var record = await store.findFirst(db,
        finder: Finder(
            filter: Filter.equals('groceryListItemName', groceryListItemName)));

    if (record == null) {
      return null;
    }

    return GroceryListItemMarketSection.fromRecord(record.key, record.value);
  }

  Future deleteAllFromMarketSection(String marketSectionId) async {
    var store = intMapStoreFactory.store(storeName);
    var db = await dbProvider.database;
    await store.delete(db,
        finder:
            Finder(filter: Filter.equals('marketSectionId', marketSectionId)));
  }

  Future deleteAll() async {
    var store = intMapStoreFactory.store(storeName);
    var db = await dbProvider.database;
    await store.delete(db);
  }

  Future<SaveGroceryListItemMarketSectionResponse> save(
      GroceryListItemMarketSection groceryListItemMarketSection) async {
    try {
      var store = intMapStoreFactory.store(storeName);
      var db = await dbProvider.database;
      if (!groceryListItemMarketSection.hasId()) {
        var record = await store.findFirst(db,
            finder: Finder(
              filter: Filter.equals('groceryListItemName',
                  groceryListItemMarketSection.groceryListItemName),
            ));

        if (record == null) {
          await db.transaction((txn) async {
            int id =
                await store.add(txn, groceryListItemMarketSection.toRecord());
            groceryListItemMarketSection.id = id.toString();
          });
        } else {
          await store
              .record(record.key)
              .update(db, groceryListItemMarketSection.toRecord());
        }
      } else {
        var record = store.record(int.parse(groceryListItemMarketSection.id));
        await record.update(db, groceryListItemMarketSection.toRecord());
      }

      return SaveGroceryListItemMarketSectionResponse(
          groceryListItemMarketSection: groceryListItemMarketSection);
    } catch (e) {
      return SaveGroceryListItemMarketSectionResponse(error: e);
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
          GroceryListItemMarketSection groceryListItemMarketSection =
              GroceryListItemMarketSection.fromRecord(record.key, record.value);

          var localRecord =
              store.record(int.parse(groceryListItemMarketSection.id));
          var localRecordValue = await localRecord.get(db);
          if (localRecordValue == null || localRecordValue.isEmpty) {
            await db.transaction((txn) async {
              int id =
                  await store.add(txn, groceryListItemMarketSection.toRecord());
              groceryListItemMarketSection.id = id.toString();
            });
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
      return DataSummary(total: total, lastUpdated: -1);
    } catch (e) {
      throw e;
    }
  }
}
