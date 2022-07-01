import 'dart:async';
import 'dart:io';
import 'package:rtg_app/dao/recipes_dao.dart';
import 'package:rtg_app/database/sembast_database.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:rtg_app/model/menu_planning.dart';
import 'package:rtg_app/model/menu_planning_collection.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/save_menu_planning_response.dart';
import 'package:rtg_app/model/search_menu_plannings_params.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
import 'package:sembast/sembast.dart';

class MenuPlanningDao {
  final dbProvider = SembastDatabaseProvider.dbProvider;
  final String storeName = 'menuPlannings';
  final recipesDao = RecipesDao();

  Future<MenuPlanningCollection> fetch(
      SearchMenuPlanningParams searchParams) async {
    var store = intMapStoreFactory.store(storeName);
    var db = await dbProvider.database;

    var finder = Finder(
      limit: searchParams.limit,
      offset: searchParams.offset,
      sortOrders: [
        SortOrder('endAt', false),
      ],
    );

    var records = await store.find(db, finder: finder);
    var total = await store.count(db);

    List<MenuPlanning> menuPlannings = menuPlanningsFromRecords(records);
    Map<MenuPlanning, List<Recipe>> menuPlanningsRecipes = Map();

    if (menuPlannings != null) {
      for (MenuPlanning menuPlanning in menuPlannings) {
        List<String> recipeIds = menuPlanning.recipeIds();
        if (recipeIds != null && recipeIds.length > 0) {
          RecipesCollection recipesCollection = await recipesDao.searchRecipes(
              searchParams: SearchRecipesParams(ids: recipeIds));
          menuPlanningsRecipes[menuPlanning] = recipesCollection.recipes;
        }
      }
    }
    return MenuPlanningCollection(
        menuPlannings: menuPlannings,
        menuPlanningsRecipes: menuPlanningsRecipes,
        total: total);
  }

  Future deleteAll() async {
    var store = intMapStoreFactory.store(storeName);
    var db = await dbProvider.database;
    await store.delete(db);
  }

  Future<SaveMenuPlanningResponse> save({MenuPlanning menuPlanning}) async {
    try {
      menuPlanning.days.forEach((day, meals) {
        meals.sort((m1, m2) {
          return Comparable.compare(m1.type.index, m2.type.index);
        });
      });
      var store = intMapStoreFactory.store(storeName);
      var db = await dbProvider.database;
      if (!menuPlanning.hasId()) {
        await db.transaction((txn) async {
          int id = await store.add(txn, menuPlanning.toRecord());
          menuPlanning.id = id.toString();
        });
      } else {
        var record = store.record(int.parse(menuPlanning.id));
        await record.update(db, menuPlanning.toRecord());
      }

      return SaveMenuPlanningResponse(menuPlanning: menuPlanning);
    } catch (e) {
      return SaveMenuPlanningResponse(error: e);
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
          MenuPlanning menuPlanning =
              MenuPlanning.fromRecord(record.key, record.value);

          var localRecord = store.record(int.parse(menuPlanning.id));
          var localRecordValue = await localRecord.get(db);
          if (localRecordValue == null || localRecordValue.isEmpty) {
            await db.transaction((txn) async {
              int id = await store.add(txn, menuPlanning.toRecord());
              menuPlanning.id = id.toString();
            });
          } else {
            MenuPlanning localGroceryList =
                MenuPlanning.fromRecord(localRecord.key, localRecordValue);
            if (localGroceryList.updatedAt < menuPlanning.updatedAt) {
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
        MenuPlanning menuPlanning =
            MenuPlanning.fromRecord(records[0].key, records[0].value);
        lastUpdated = menuPlanning.updatedAt;
      }
      return DataSummary(total: total, lastUpdated: lastUpdated);
    } catch (e) {
      throw e;
    }
  }
}
