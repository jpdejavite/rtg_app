import 'dart:async';
import 'dart:io';
import 'package:rtg_app/database/sembast_database.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:sembast/sembast.dart';

import '../model/recipe_label.dart';
import '../model/save_recipe_label_response.dart';

class RecipeLabelDao {
  final dbProvider = SembastDatabaseProvider.dbProvider;
  final String storeName = 'labels';

  Future<List<RecipeLabel>> getAll() async {
    var store = intMapStoreFactory.store(storeName);
    var db = await dbProvider.database;

    var finder = Finder(sortOrders: [SortOrder('title')]);

    var records = await store.find(db, finder: finder);

    return recipeLabelsFromRecords(records);
  }

  Future deleteAll() async {
    var store = intMapStoreFactory.store(storeName);
    var db = await dbProvider.database;
    await store.delete(db);
  }

  Future<SaveRecipeLabelResponse> save({RecipeLabel label}) async {
    try {
      var store = intMapStoreFactory.store(storeName);
      var db = await dbProvider.database;
      if (!label.hasId()) {
        var record = await store.findFirst(db,
            finder: Finder(filter: Filter.equals('title', label.title)));

        if (record == null) {
          await db.transaction((txn) async {
            int id = await store.add(txn, label.toRecord());
            label.id = id.toString();
          });
        } else {
          await store.record(record.key).update(db, label.toRecord());
        }
      } else {
        var record = store.record(int.parse(label.id));
        await record.update(db, label.toRecord());
      }

      return SaveRecipeLabelResponse(label: label);
    } catch (e) {
      return SaveRecipeLabelResponse(error: e);
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
          RecipeLabel label = RecipeLabel.fromRecord(record.key, record.value);

          var localRecord = store.record(int.parse(label.id));
          var localRecordValue = await localRecord.get(db);
          if (localRecordValue == null || localRecordValue.isEmpty) {
            await db.transaction((txn) async {
              int id = await store.add(txn, label.toRecord());
              label.id = id.toString();
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
