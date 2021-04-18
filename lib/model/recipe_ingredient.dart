import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:rtg_app/helper/ingredient_parser.dart';
import 'package:rtg_app/model/ingredient_measure.dart';

class RecipeIngredient {
  RecipeIngredient({
    this.quantity,
    this.measureId,
    this.name,
    this.originalName,
    this.label,
  });

  double quantity;
  IngredientMeasureId measureId;
  String name;
  String originalName;
  String label;

  @override
  String toString() {
    return '$quantity $measureId $name $originalName $label';
  }

  String getQuantity(BuildContext context) {
    String quantityToShow = quantity.toString();
    if (quantity % 1 == 0) {
      quantityToShow = quantity.toInt().toString();
    } else {
      quantityToShow = quantity.toMixedFraction().toString();
    }

    return '$quantityToShow ${IngredientMeasure.i18nMeasure(measureId, quantity, context)}';
  }

  static RecipeIngredient fromInput(String originalText, String label) {
    IngredientParseResult result = IngredientParser.fromInput(originalText);
    return RecipeIngredient(
      originalName: result.originalName,
      name: result.name,
      quantity: result.quantity,
      measureId: result.measureId,
      label: label,
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
      label: record['label'],
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
        'label': i.label,
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
        originalName == other.originalName &&
        label == other.label;
  }

  @override
  int get hashCode => toString().hashCode;
}
