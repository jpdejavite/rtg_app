import 'dart:io';

import 'package:rtg_app/dao/recipes_dao.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/save_recipe_response.dart';
import 'package:rtg_app/model/search_recipes_params.dart';

class RecipesRepository {
  final recipesDao = RecipesDao();

  Future<RecipesCollection> search({SearchRecipesParams searchParams}) =>
      recipesDao.searchRecipes(searchParams: searchParams);

  Future populateDB() => recipesDao.populateDB();

  Future<SaveRecipeResponse> save({Recipe recipe}) =>
      recipesDao.save(recipe: recipe);

  Future deleteAll() => recipesDao.deleteAll();

  Future mergeFromBackup({File file}) => recipesDao.mergeFromBackup(file: file);

  Future<DataSummary> getSummary({File file}) =>
      recipesDao.getSummary(file: file);
}
