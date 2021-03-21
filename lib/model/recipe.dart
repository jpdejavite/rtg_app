import 'package:rtg_app/model/recipe_ingredient.dart';
import 'package:sembast/sembast.dart';

List<Recipe> recipesFromRecords(
        List<RecordSnapshot<int, Map<String, Object>>> records) =>
    List<Recipe>.from(records.map((r) => Recipe.fromRecord(r.key, r.value)));

class Recipe {
  Recipe({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.instructions,
    this.ingredients,
  });

  String id;
  int createdAt;
  int updatedAt;
  String title;
  String instructions;
  List<RecipeIngredient> ingredients;

  factory Recipe.fromRecord(int id, Map<String, Object> record) {
    return Recipe(
      id: id.toString(),
      createdAt: record["createdAt"],
      updatedAt: record["updatedAt"],
      title: record["title"],
      instructions: record["instructions"],
      ingredients:
          RecipeIngredient.recipeIngredientsFromObject(record["ingredients"]),
    );
  }
}
