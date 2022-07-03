import 'dart:async';
import 'dart:io';
import 'package:rtg_app/database/sembast_database.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/save_recipe_response.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
import 'package:sembast/sembast.dart';

class RecipesDao {
  final dbProvider = SembastDatabaseProvider.dbProvider;
  final String storeName = 'recipes';

  Filter getFilterContainingProducts(RegExp filter) {
    return Filter.custom((record) {
      var names = (record['ingredients'] as List)
          .map((tag) => (tag as Map)['name'] as String);
      for (var name in names) {
        if (filter.allMatches(name).length > 0) {
          return true;
        }
      }
      return false;
    });
  }

  Future<RecipesCollection> searchRecipes(
      {SearchRecipesParams searchParams}) async {
    var store = intMapStoreFactory.store(storeName);
    var db = await dbProvider.database;

    Filter filter;
    if (searchParams != null) {
      if (searchParams.ids != null && searchParams.ids.length > 0) {
        List<Filter> filters = [];
        searchParams.ids.forEach((id) {
          filters.add(Filter.byKey(int.parse(id)));
        });
        filter = Filter.or(filters);
      } else {
        Filter textFilter;
        Filter labelFilter;
        if (searchParams.filter != null && searchParams.filter != "") {
          textFilter = Filter.or([
            Filter.matchesRegExp(
                'title', RegExp(searchParams.filter, caseSensitive: false)),
            Filter.matchesRegExp('instructions',
                RegExp(searchParams.filter, caseSensitive: false)),
            getFilterContainingProducts(
                RegExp(searchParams.filter, caseSensitive: false)),
          ]);
        }
        if (searchParams.label != null) {
          labelFilter = Filter.equals('label', searchParams.label.title);
        }

        if (textFilter != null && labelFilter != null) {
          filter = Filter.and([textFilter, labelFilter]);
        } else if (textFilter != null) {
          filter = textFilter;
        } else if (labelFilter != null) {
          filter = labelFilter;
        }
      }
    }

    var finder = Finder(
      filter: filter,
      offset: searchParams != null ? searchParams.offset : 0,
      limit: searchParams != null && searchParams.limit != null
          ? searchParams.limit
          : 20,
      sortOrders: [
        searchParams != null && searchParams.sort != null
            ? SortOrder(searchParams.sort.field, searchParams.sort.ascending)
            : SortOrder('title'),
      ],
    );

    var records = await store.find(db, finder: finder);
    var total = await store.count(db, filter: filter);

    List<Recipe> recipes = recipesFromRecords(records);
    return RecipesCollection(recipes: recipes, total: total);
  }

  Future deleteAll() async {
    var store = intMapStoreFactory.store(storeName);
    var db = await dbProvider.database;
    await store.delete(db);
  }

  Future<SaveRecipeResponse> save({Recipe recipe}) async {
    try {
      var store = intMapStoreFactory.store(storeName);
      var db = await dbProvider.database;
      if (!recipe.hasId()) {
        await db.transaction((txn) async {
          int id = await store.add(txn, recipe.toRecord());
          recipe.id = id.toString();
        });
      } else {
        var record = store.record(int.parse(recipe.id));
        await record.update(db, recipe.toRecord());
      }

      return SaveRecipeResponse(recipe: recipe);
    } catch (e) {
      return SaveRecipeResponse(error: e);
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
          Recipe recipe = Recipe.fromRecord(record.key, record.value);

          var localRecord = store.record(int.parse(recipe.id));
          var localRecordValue = await localRecord.get(db);
          if (localRecordValue == null || localRecordValue.isEmpty) {
            await db.transaction((txn) async {
              int id = await store.add(txn, recipe.toRecord());
              recipe.id = id.toString();
            });
          } else {
            Recipe localRecipe =
                Recipe.fromRecord(localRecord.key, localRecordValue);
            if (localRecipe.updatedAt < recipe.updatedAt) {
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
        Recipe recipe = Recipe.fromRecord(records[0].key, records[0].value);
        lastUpdated = recipe.updatedAt;
      }
      return DataSummary(total: total, lastUpdated: lastUpdated);
    } catch (e) {
      throw e;
    }
  }
}
