import 'package:rtg_app/model/recipe.dart';

class RecipesCollection {
  RecipesCollection({
    this.recipes,
    this.total,
  });

  List<Recipe> recipes;
  int total;

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is RecipesCollection)) {
      return false;
    }

    if (total != other.total) {
      return false;
    }

    if (recipes.length != other.recipes.length) {
      return false;
    }

    bool areEqual = true;
    recipes.asMap().forEach((i, recipe) {
      if (recipe.id != other.recipes[i].id) {
        areEqual = false;
      }
    });
    return areEqual;
  }

  @override
  int get hashCode => super.hashCode;
}
