import 'package:flutter_test/flutter_test.dart';
import 'package:rtg_app/model/ingredient_measure.dart';

void main() {
  test('get id from null', () {
    expect(IngredientMeasure.getId(null),
        IngredientMeasure(IngredientMeasureId.unit, ""));
  });

  test('get id from tea spoon', () {
    expect(IngredientMeasure.getId("colher de cha de acucar"),
        IngredientMeasure(IngredientMeasureId.teaSpoon, "colher de cha"));
  });

  test('get id from no match', () {
    expect(IngredientMeasure.getId("coler de cha de acucar"),
        IngredientMeasure(IngredientMeasureId.unit, ""));
  });
}
