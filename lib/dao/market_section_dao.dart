import 'dart:async';
import 'dart:io';
import 'package:rtg_app/database/sembast_database.dart';
import 'package:rtg_app/helper/market_section_data.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:rtg_app/model/market_section.dart';
import 'package:rtg_app/model/save_market_section_response.dart';
import 'package:sembast/sembast.dart';

import '../helper/custom_date_time.dart';

class MarketSectionDao {
  final dbProvider = SembastDatabaseProvider.dbProvider;
  final String storeName = 'marketSections';

  Future<List<MarketSection>> getAll() async {
    var store = intMapStoreFactory.store(storeName);
    var db = await dbProvider.database;

    var finder = Finder(sortOrders: [SortOrder('title')]);

    var records = await store.find(db, finder: finder);

    if (records.length == 0) {
      await this.saveAll(marketSections: MarketSectionData.data());
    }

    return marketSectionsFromRecords(records);
  }

  Future deleteAll() async {
    var store = intMapStoreFactory.store(storeName);
    var db = await dbProvider.database;
    await store.delete(db);
  }

  Future<List<MarketSection>> saveAll(
      {List<MarketSection> marketSections}) async {
    List<MarketSection> response = [];
    await Future.forEach(marketSections, (marketSection) async {
      SaveMarketSectionResponse saveResponse =
          await this.save(marketSection: marketSection);
      if (saveResponse.marketSection != null) {
        response.add(saveResponse.marketSection);
      }
    });
    return response;
  }

  Future<SaveMarketSectionResponse> save({MarketSection marketSection}) async {
    try {
      marketSection.updatedAt = CustomDateTime.current.millisecondsSinceEpoch;
      var store = intMapStoreFactory.store(storeName);
      var db = await dbProvider.database;
      if (!marketSection.hasId()) {
        var record = await store.findFirst(db,
            finder:
                Finder(filter: Filter.equals('title', marketSection.title)));

        if (record == null) {
          marketSection.createdAt =
              CustomDateTime.current.millisecondsSinceEpoch;

          await db.transaction((txn) async {
            int id = await store.add(txn, marketSection.toRecord());
            marketSection.id = id.toString();
          });
        } else {
          await store.record(record.key).update(db, marketSection.toRecord());
        }
      } else {
        var record = store.record(int.parse(marketSection.id));
        await record.update(db, marketSection.toRecord());
      }

      return SaveMarketSectionResponse(marketSection: marketSection);
    } catch (e) {
      return SaveMarketSectionResponse(error: e);
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
          MarketSection marketSection =
              MarketSection.fromRecord(record.key, record.value);

          var localRecord = store.record(int.parse(marketSection.id));
          var localRecordValue = await localRecord.get(db);
          if (localRecordValue == null || localRecordValue.isEmpty) {
            await db.transaction((txn) async {
              int id = await store.add(txn, marketSection.toRecord());
              marketSection.id = id.toString();
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
