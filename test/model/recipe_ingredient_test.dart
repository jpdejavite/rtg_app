import 'package:flutter_test/flutter_test.dart';
import 'package:rtg_app/model/ingredient_measure.dart';

import 'package:rtg_app/model/recipe_ingredient.dart';

void main() {
  test('fromInput ingredient parser integration', () {
    expect(
        RecipeIngredient.fromInput("3,33 colher    de café de   cúrcuma", null),
        RecipeIngredient(
          originalName: "3,33 colher de café de cúrcuma",
          name: "cúrcuma",
          quantity: 3.33,
          measureId: IngredientMeasureId.coffeSpoon,
        ));
  });

  test('fromInput ingredient parser integration with label', () {
    expect(
        RecipeIngredient.fromInput(
            "3,33 colher    de café de   cúrcuma", 'molho'),
        RecipeIngredient(
          originalName: "3,33 colher de café de cúrcuma",
          name: "cúrcuma",
          quantity: 3.33,
          measureId: IngredientMeasureId.coffeSpoon,
          label: 'molho',
        ));
  });
}
