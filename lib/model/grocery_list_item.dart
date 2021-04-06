import 'package:rtg_app/helper/id_generator.dart';
import 'package:rtg_app/model/recipe.dart';

class GroceryListItem {
  String id;
  int quantity;
  String name;
  List<String> recipes;
  bool checked;

  GroceryListItem({
    this.id,
    this.quantity,
    this.name,
    this.recipes,
    this.checked,
  });

  static newEmptyGroceryListItem() {
    return GroceryListItem(
      id: IdGenerator.id(),
      checked: false,
      name: '',
    );
  }

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
    if (record['recipes'] is List<Object>) {
      (record['recipes'] as List<Object>).forEach((el) {
        recipes.add(el.toString());
      });
    }

    return GroceryListItem(
      id: record['id'],
      quantity: record['quantity'],
      name: record['name'],
      checked: record['checked'],
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
        'id': i.id,
        'name': i.name,
        'recipes': i.recipes,
        'checked': i.checked,
      });
    });

    return objects;
  }

  static List<GroceryListItem> addRecipeToItems(
      Recipe recipe, List<GroceryListItem> items) {
    recipe.ingredients.forEach((ingredient) {
      items.add(GroceryListItem(
        id: IdGenerator.id(),
        name: ingredient.name,
        recipes: [recipe.id],
        checked: false,
      ));
    });

    return items;
  }

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is GroceryListItem)) {
      return false;
    }

    return id == other.id;
  }

  @override
  int get hashCode => super.hashCode;
}
