import 'package:flutter_test/flutter_test.dart';
import 'package:rtg_app/model/ingredient_measure.dart';

import 'package:rtg_app/model/recipe_ingredient.dart';

void main() {
  test('get quantity from null', () {
    expect(
        RecipeIngredient.fromInput(null),
        RecipeIngredient(
          originalName: null,
          name: null,
          quantity: 1,
          measureId: IngredientMeasureId.unit,
        ));
  });

  test('get quantity from empty', () {
    expect(
        RecipeIngredient.fromInput(""),
        RecipeIngredient(
          originalName: "",
          name: "",
          quantity: 1,
          measureId: IngredientMeasureId.unit,
        ));
  });

  test('get quantity no match', () {
    expect(
        RecipeIngredient.fromInput("mao de arroz"),
        RecipeIngredient(
          originalName: "mao de arroz",
          name: "mao de arroz",
          quantity: 1,
          measureId: IngredientMeasureId.unit,
        ));
  });

  test('get quantity from match', () {
    expect(
        RecipeIngredient.fromInput("5.3 colher de sopa arroz"),
        RecipeIngredient(
          originalName: "5.3 colher de sopa arroz",
          name: "arroz",
          quantity: 5.3,
          measureId: IngredientMeasureId.tableSpoon,
        ));
  });

  test('get quantity from match with diacritics', () {
    expect(
        RecipeIngredient.fromInput("5 colher de chá feijão"),
        RecipeIngredient(
          originalName: "5 colher de chá feijão",
          name: "feijão",
          quantity: 5,
          measureId: IngredientMeasureId.teaSpoon,
        ));
  });
}
