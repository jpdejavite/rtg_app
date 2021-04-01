import 'package:rtg_app/model/recipe.dart';

class GroceryListItem {
  GroceryListItem({
    this.quantity,
    this.name,
    this.recipes,
  });

  int quantity;
  String name;
  List<String> recipes;

  @override
  String toString() {
    return name.toString();
  }

  static List<GroceryListItem> fromObject(Object object) {
    if (object == null || !(object is List<Object>)) {
      return [];
    }

    List<GroceryListItem> ingredients = [];

    List<Object> objects = object;
    objects.forEach((e) {
      if (e is Map<String, Object>) {
        ingredients.add(GroceryListItem.fromMap(e));
      }
    });

    return ingredients;
  }

  factory GroceryListItem.fromMap(Map<String, Object> record) {
    List<String> recipes = [];
    if (record["recipes"] is List<Object>) {
      (record["recipes"] as List<Object>).forEach((el) {
        recipes.add(el.toString());
      });
    }

    return GroceryListItem(
      quantity: record["quantity"],
      name: record["name"],
      recipes: recipes,
    );
  }

  static Object toRecords(List<GroceryListItem> items) {
    if (items == null || items.length == 0) {
      return null;
    }

    List<Object> objects = [];
    items.forEach((i) {
      objects.add({
        'name': i.name,
        'recipes': i.recipes,
      });
    });

    return objects;
  }

  static List<GroceryListItem> addRecipeToItems(
      Recipe recipe, List<GroceryListItem> items) {
    recipe.ingredients.forEach((ingredient) {
      items.add(GroceryListItem(
        name: ingredient.name,
        recipes: [recipe.id],
      ));
    });

    return items;
  }
}
