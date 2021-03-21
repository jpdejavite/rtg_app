import 'package:rtg_app/dao/recipes_dao.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/search_recipes_params.dart';

class RecipesRepository {
  final recipesDao = RecipesDao();

  Future<RecipesCollection> search({SearchRecipesParams searchParams}) =>
      recipesDao.searchRecipes(searchParams: searchParams);

  Future populateDB() => recipesDao.populateDB();
}
