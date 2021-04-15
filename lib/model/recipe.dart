import 'package:rtg_app/model/recipe_ingredient.dart';
import 'package:rtg_app/model/recipe_preparation_time_details.dart';
import 'package:sembast/sembast.dart';

List<Recipe> recipesFromRecords(
        List<RecordSnapshot<int, Map<String, Object>>> records) =>
    List<Recipe>.from(records.map((r) => Recipe.fromRecord(r.key, r.value)));

class Recipe {
  Recipe({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.lastUsed,
    this.title,
    this.source,
    this.portions,
    this.totalPreparationTime,
    this.preparationTimeDetails,
    this.instructions,
    this.ingredients,
  });

  String id;
  int createdAt;
  int updatedAt;
  int lastUsed;
  String title;
  String source;
  double portions;
  int totalPreparationTime;
  RecipePreparationTimeDetails preparationTimeDetails;
  String instructions;
  List<RecipeIngredient> ingredients;

  bool hasId() {
    return this.id != null && this.id != '' && this.id != '0';
  }

  factory Recipe.fromRecord(int id, Map<String, Object> record) {
    return Recipe(
      id: id.toString(),
      createdAt: record['createdAt'],
      updatedAt: record['updatedAt'],
      lastUsed: record['lastUsed'],
      title: record['title'],
      source: record['source'],
      portions: record['portions'],
      totalPreparationTime: record['totalPreparationTime'],
      preparationTimeDetails: RecipePreparationTimeDetails.fromRecord(
          record['preparationTimeDetails']),
      instructions: record['instructions'],
      ingredients:
          RecipeIngredient.recipeIngredientsFromObject(record['ingredients']),
    );
  }

  Object toRecord() {
    return {
      'title': this.title,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'lastUsed': this.lastUsed,
      'source': this.source == '' ? null : this.source,
      'portions': this.portions,
      'totalPreparationTime': this.totalPreparationTime,
      'preparationTimeDetails': this.preparationTimeDetails != null
          ? this.preparationTimeDetails.toRecord()
          : null,
      'instructions': this.instructions,
      'ingredients':
          RecipeIngredient.recipeIngredientsToRecord(this.ingredients),
    };
  }
}
