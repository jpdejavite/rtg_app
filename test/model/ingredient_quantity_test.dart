import 'package:flutter_test/flutter_test.dart';

import 'package:rtg_app/model/ingredient_quantity.dart';

void main() {
  test('get quantity from null', () {
    expect(IngredientQuantity.getQuantity(null), IngredientQuantity(1, ""));
  });

  test('get quantity from ""', () {
    expect(IngredientQuantity.getQuantity(""), IngredientQuantity(1, ""));
  });

  test('get quantity from no match', () {
    expect(IngredientQuantity.getQuantity("Acho que 2 colher de cha de acucar"),
        IngredientQuantity(1, ""));
  });

  test('get quantity from int', () {
    expect(IngredientQuantity.getQuantity("1 colher de cha de acucar"),
        IngredientQuantity(1, "1"));
  });

  test('get quantity from double BRL', () {
    expect(IngredientQuantity.getQuantity("5,43 colher de cha de acucar"),
        IngredientQuantity(5.43, "5,43"));
  });

  test('get quantity from double US', () {
    expect(IngredientQuantity.getQuantity("8.1 colher de cha de acucar"),
        IngredientQuantity(8.1, "8.1"));
  });

  test('get quantity from invalid format', () {
    expect(IngredientQuantity.getQuantity("2,000.00 colher de cha de acucar"),
        IngredientQuantity(1, ""));
  });
}
