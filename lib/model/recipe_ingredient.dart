import 'package:rtg_app/helper/ingredient_parser.dart';
import 'package:rtg_app/model/ingredient_measure.dart';

class RecipeIngredient {
  RecipeIngredient({
    this.quantity,
    this.measureId,
    this.name,
    this.originalName,
  });

  double quantity;
  IngredientMeasureId measureId;
  String name;
  String originalName;

  @override
  String toString() {
    return '$quantity $measureId $name $originalName';
  }

  static RecipeIngredient fromInput(String originalText) {
    IngredientParseResult result = IngredientParser.fromInput(originalText);
    return RecipeIngredient(
      originalName: result.originalName,
      name: result.name,
      quantity: result.quantity,
      measureId: result.measureId,
    );
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
      measureId: IngredientMeasureId.values[record["measureId"] as int],
      name: record["name"],
      originalName: record["originalName"],
    );
  }

  static Object recipeIngredientsToRecord(List<RecipeIngredient> ingredients) {
    if (ingredients == null || ingredients.length == 0) {
      return null;
    }

    List<Object> objects = [];
    ingredients.forEach((i) {
      objects.add({
        'quantity': i.quantity,
        'measureId': i.measureId.index,
        'name': i.name,
        'originalName': i.originalName,
      });
    });

    return objects;
  }

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is RecipeIngredient)) {
      return false;
    }

    return quantity == other.quantity &&
        measureId == other.measureId &&
        name == other.name &&
        originalName == other.originalName;
  }

  @override
  int get hashCode => toString().hashCode;
}
