import 'package:rtg_app/model/recipe_list.dart';

abstract class RecipesRepo {
  Future<List<Recipe>> getRecipeList(final String lastId);
}

class RecipeServices implements RecipesRepo {
  @override
  Future<List<Recipe>> getRecipeList(final String lastId) async {
    String baseId = lastId == "" ? "A" : lastId+ "-B";
    // TODO: get from database
    const String body = '''[{
      "id": "<id>-1",
      "title": "Ratatouille",
      "createdAt": "2021-03-16T00:27:30.151Z"
    },{
      "id": "<id>-2",
      "title": "Cassoulet",
      "createdAt": "2021-03-16T00:27:30.151Z"
    },{
      "id": "<id>-3",
      "title": "Arroz com fritas",
      "createdAt": "2021-03-16T00:27:30.151Z"
    },{
      "id": "<id>-4",
      "title": "Frango na cerveja",
      "createdAt": "2021-03-16T00:27:30.151Z"
    },{
      "id": "<id>-5",
      "title": "Isca de frango",
      "createdAt": "2021-03-16T00:27:30.151Z"
    },{
      "id": "<id>-6",
      "title": "Carne moída",
      "createdAt": "2021-03-16T00:27:30.151Z"
    },{
      "id": "<id>-7",
      "title": "Peixe assado",
      "createdAt": "2021-03-16T00:27:30.151Z"
    },{
      "id": "<id>-8",
      "title": "Feijoada",
      "createdAt": "2021-03-16T00:27:30.151Z"
    }]''';
    List<Recipe> recipes = recipesFromJson(body.replaceAll("<id>", baseId));

    await Future.delayed(Duration(seconds: 2));

    return recipes;
  }
}
