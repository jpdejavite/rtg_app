import 'package:flutter_test/flutter_test.dart';
import 'package:rtg_app/helper/ingredient_measure_converter.dart';
import 'package:rtg_app/model/ingredient_measure.dart';

void main() {
  test('find convertion with measures not convertable', () {
    expect(
        IngredientMeasureConverter.findConvertion(
            IngredientMeasureId.milliliters, IngredientMeasureId.grams),
        null);
  });

  test('find convertion with measures convertable', () {
    expect(
        IngredientMeasureConverter.findConvertion(
            IngredientMeasureId.milliliters, IngredientMeasureId.liter),
        IngredientMeasureConversionItem(
            IngredientMeasureId.liter, 1000, IngredientMeasureId.milliliters));
  });

  test('find convertion with measures convertable 2', () {
    expect(
        IngredientMeasureConverter.findConvertion(
            IngredientMeasureId.liter, IngredientMeasureId.milliliters),
        IngredientMeasureConversionItem(
            IngredientMeasureId.liter, 1000, IngredientMeasureId.milliliters));
  });

  test('find convertion with measures convertable 3', () {
    expect(
        IngredientMeasureConverter.findConvertion(
            IngredientMeasureId.milliliters, IngredientMeasureId.milliliters),
        IngredientMeasureConversionItem(IngredientMeasureId.milliliters, 1,
            IngredientMeasureId.milliliters));
  });

  test('convert between measures', () {
    expect(
        IngredientMeasureConverter.convert(
          measure: IngredientMeasureId.liter,
          quantity: 1,
          conversion: IngredientMeasureConversionItem(
              IngredientMeasureId.liter, 1000, IngredientMeasureId.milliliters),
          quantityToAdd: 500,
          measureToAdd: IngredientMeasureId.milliliters,
          portions: 1,
        ),
        IngredientMeasureConversionResult(IngredientMeasureId.liter, 1.5));
  });

  test('convert between measures 2', () {
    expect(
        IngredientMeasureConverter.convert(
          measure: IngredientMeasureId.milliliters,
          quantity: 500,
          conversion: IngredientMeasureConversionItem(
              IngredientMeasureId.liter, 1000, IngredientMeasureId.milliliters),
          quantityToAdd: 1,
          measureToAdd: IngredientMeasureId.liter,
          portions: 1,
        ),
        IngredientMeasureConversionResult(IngredientMeasureId.liter, 1.5));
  });

  test('convert between measures 3', () {
    expect(
        IngredientMeasureConverter.convert(
          measure: IngredientMeasureId.teaSpoon,
          quantity: 1,
          conversion: IngredientMeasureConversionItem(
              IngredientMeasureId.desertSpoon, 2, IngredientMeasureId.teaSpoon),
          quantityToAdd: 2,
          measureToAdd: IngredientMeasureId.desertSpoon,
          portions: 1,
        ),
        IngredientMeasureConversionResult(
            IngredientMeasureId.desertSpoon, 2.5));
  });

  test('convert between measures 4', () {
    expect(
        IngredientMeasureConverter.convert(
          measure: IngredientMeasureId.grams,
          quantity: 450,
          conversion: IngredientMeasureConversionItem(
              IngredientMeasureId.kilograms, 1000, IngredientMeasureId.grams),
          quantityToAdd: 3,
          measureToAdd: IngredientMeasureId.kilograms,
          portions: 1,
        ),
        IngredientMeasureConversionResult(
            IngredientMeasureId.kilograms, 3.450));
  });

  test('convert between measures 5 with portions', () {
    expect(
        IngredientMeasureConverter.convert(
          measure: IngredientMeasureId.grams,
          quantity: 160,
          conversion: IngredientMeasureConversionItem(
              IngredientMeasureId.kilograms, 1000, IngredientMeasureId.grams),
          quantityToAdd: 3,
          measureToAdd: IngredientMeasureId.kilograms,
          portions: 3,
        ),
        IngredientMeasureConversionResult(IngredientMeasureId.kilograms, 9.16));
  });
}
