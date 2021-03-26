import 'dart:async';
import 'package:rtg_app/database/sembast_database.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/save_recipe_response.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
import 'package:sembast/sembast.dart';

class RecipesDao {
  final dbProvider = SembastDatabaseProvider.dbProvider;

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
    var store = intMapStoreFactory.store('recipes');
    var db = await dbProvider.database;

    Filter filter;
    if (searchParams != null &&
        searchParams.filter != null &&
        searchParams.filter != "") {
      filter = Filter.or([
        Filter.matchesRegExp(
            'title', RegExp(searchParams.filter, caseSensitive: false)),
        Filter.matchesRegExp(
            'instructions', RegExp(searchParams.filter, caseSensitive: false)),
        getFilterContainingProducts(
            RegExp(searchParams.filter, caseSensitive: false)),
      ]);
    }

    var finder = Finder(
      filter: filter,
      offset: searchParams != null ? searchParams.offset : 0,
      limit: 20,
      sortOrders: [
        SortOrder('title'),
      ],
    );

    var records = await store.find(db, finder: finder);
    var total = await store.count(db, filter: filter);

    List<Recipe> recipes = recipesFromRecords(records);
    return RecipesCollection(recipes: recipes, total: total);
  }

  Future populateDB() async {
    // var store = intMapStoreFactory.store('recipes');
    // var db = await dbProvider.database;
    // var records = await store.find(db);
    // await store.delete(db);
    // if (records.length != 200) {
    //   await db.transaction((txn) async {
    //     for (int i = 0; i < 200; i++) {
    //       await store.add(txn, {
    //         'title': 'Receita ' + i.toString().padLeft(3, '0'),
    //         'createdAt': DateTime.now().millisecondsSinceEpoch,
    //         'updatedAt': DateTime.now().millisecondsSinceEpoch,
    //         'instructions': 'Instrucao' + i.toString().padLeft(3, '0'),
    //         'ingredients': [
    //           {
    //             'quantity': 1,
    //             'name': 'Ingrediente-1-' + i.toString().padLeft(3, '0')
    //           },
    //           {
    //             'quantity': 2,
    //             'name': 'Ingrediente-2-' + i.toString().padLeft(3, '0')
    //           },
    //           {
    //             'quantity': 3,
    //             'name': 'Ingrediente-3-' + i.toString().padLeft(3, '0')
    //           }
    //         ]
    //       });
    //     }
    //   });
    // }
  }

  Future deleteAll() async {
    var store = intMapStoreFactory.store('recipes');
    var db = await dbProvider.database;
    await store.delete(db);
  }

  Future<SaveRecipeResponse> save({Recipe recipe}) async {
    try {
      var store = intMapStoreFactory.store('recipes');
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
}
