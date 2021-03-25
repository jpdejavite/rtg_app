class RecipeIngredient {
  RecipeIngredient({
    this.quantity,
    this.name,
  });

  int quantity;
  String name;

  @override
  String toString() {
    return name.toString();
  }

  static List<RecipeIngredient> recipeIngredientsFromObject(Object object) {
    if (object == null || !(object is List<Object>)) {
      return [];
    }

    List<RecipeIngredient> ingredients = [];

    List<Object> objects = object;
    objects.forEach((e) {
      if (e is Map<String, Object>) {
        ingredients.add(RecipeIngredient.fromMap(e));
      }
    });

    return ingredients;
  }

  factory RecipeIngredient.fromMap(Map<String, Object> record) {
    return RecipeIngredient(
      quantity: record["quantity"],
      name: record["name"],
    );
  }

  static Object recipeIngredientsToRecord(List<RecipeIngredient> ingredients) {
    if (ingredients == null || ingredients.length == 0) {
      return null;
    }

    List<Object> objects = [];
    ingredients.forEach((i) {
      objects.add({
        'name': i.name,
      });
    });

    return objects;
  }
}
