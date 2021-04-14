import 'package:flutter_test/flutter_test.dart';
import 'package:rtg_app/helper/ingredient_parser.dart';
import 'package:rtg_app/model/ingredient_measure.dart';

void main() {
  test('ingredient parser from null', () {
    expect(
        IngredientParser.fromInput(null),
        IngredientParseResult(
          originalName: null,
          name: null,
          quantity: 1,
          hasParsedQuantity: false,
          measureId: IngredientMeasureId.unit,
        ));
  });

  test('ingredient parser from empty', () {
    expect(
        IngredientParser.fromInput(""),
        IngredientParseResult(
          originalName: "",
          name: "",
          quantity: 1,
          hasParsedQuantity: false,
          measureId: IngredientMeasureId.unit,
        ));
  });

  test('ingredient parser no match', () {
    expect(
        IngredientParser.fromInput("mao de arroz"),
        IngredientParseResult(
          originalName: "mao de arroz",
          name: "mao de arroz",
          quantity: 1,
          hasParsedQuantity: false,
          measureId: IngredientMeasureId.unit,
        ));
  });

  test('ingredient parser from input', () {
    expect(
        IngredientParser.fromInput("5.3 colher de sopa arroz"),
        IngredientParseResult(
          originalName: "5.3 colher de sopa arroz",
          name: "arroz",
          quantity: 5.3,
          hasParsedQuantity: true,
          measureId: IngredientMeasureId.tableSpoon,
        ));
  });

  test('ingredient parser from input with diacritics', () {
    expect(
        IngredientParser.fromInput("5 colher de chá feijão"),
        IngredientParseResult(
          originalName: "5 colher de chá feijão",
          name: "feijão",
          quantity: 5,
          hasParsedQuantity: true,
          measureId: IngredientMeasureId.teaSpoon,
        ));
  });

  test('ingredient parser from input with diacriticsand white spaces', () {
    expect(
        IngredientParser.fromInput("3,33 colher    de café de   cúrcuma"),
        IngredientParseResult(
          originalName: "3,33 colher de café de cúrcuma",
          name: "cúrcuma",
          quantity: 3.33,
          hasParsedQuantity: true,
          measureId: IngredientMeasureId.coffeSpoon,
        ));
  });

  test('ingredient parser from input with fractions', () {
    expect(
        IngredientParser.fromInput("1 1/2 colher    de café de   cúrcuma"),
        IngredientParseResult(
          originalName: "1 1/2 colher de café de cúrcuma",
          name: "cúrcuma",
          quantity: 1.5,
          hasParsedQuantity: true,
          measureId: IngredientMeasureId.coffeSpoon,
        ));
  });

  test('ingredient parser from input "1 chuchu grande"', () {
    expect(
        IngredientParser.fromInput("1 chuchu grande"),
        IngredientParseResult(
          originalName: "1 chuchu grande",
          name: "chuchu grande",
          quantity: 1,
          hasParsedQuantity: true,
          measureId: IngredientMeasureId.unit,
        ));
  });
}
