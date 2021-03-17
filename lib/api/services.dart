import 'package:rtg_app/model/recipe_list.dart';

abstract class RecipesRepo {
  Future<List<Recipe>> getRecipeList();
}

class RecipeServices implements RecipesRepo {
  @override
  Future<List<Recipe>> getRecipeList() async {
    // TODO: get from database 
    const body = '''[{
      "title": "Ratatouille",
      "createdAt": "2021-03-16T00:27:30.151Z"
    },{
      "title": "Cassoulet",
      "createdAt": "2021-03-16T00:27:30.151Z"
    },{
      "title": "Arroz com fritas",
      "createdAt": "2021-03-16T00:27:30.151Z"
    },{
      "title": "Frango na cerveja",
      "createdAt": "2021-03-16T00:27:30.151Z"
    },{
      "title": "Isca de frango",
      "createdAt": "2021-03-16T00:27:30.151Z"
    },{
      "title": "Carne moída",
      "createdAt": "2021-03-16T00:27:30.151Z"
    },{
      "title": "Peixe assado",
      "createdAt": "2021-03-16T00:27:30.151Z"
    },{
      "title": "Feijoada",
      "createdAt": "2021-03-16T00:27:30.151Z"
    }]''';
    List<Recipe> recipes = recipesFromJson(body);
    return recipes;
  }
}
