import 'package:rtg_app/model/ingredient_measure.dart';

final List<IngredientMeasureConversionItem> _conversionTable = [
  // coffeSpoon
  IngredientMeasureConversionItem(
      IngredientMeasureId.teaSpoon, 2, IngredientMeasureId.coffeSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.desertSpoon, 4, IngredientMeasureId.coffeSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.tableSpoon, 6, IngredientMeasureId.coffeSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.cup, 96, IngredientMeasureId.coffeSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.pint, 1182.94, IngredientMeasureId.coffeSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.quart, 2641.725, IngredientMeasureId.coffeSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.gallon, 660.43, IngredientMeasureId.coffeSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.ounce, 84535, IngredientMeasureId.coffeSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.coffeSpoon, 2.5, IngredientMeasureId.milliliters),
  IngredientMeasureConversionItem(
      IngredientMeasureId.liter, 400, IngredientMeasureId.coffeSpoon),

  // teaSpoon
  IngredientMeasureConversionItem(
      IngredientMeasureId.desertSpoon, 2, IngredientMeasureId.teaSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.tableSpoon, 3, IngredientMeasureId.teaSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.cup, 48, IngredientMeasureId.teaSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.pint, 591.47, IngredientMeasureId.teaSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.quart, 1320.8625, IngredientMeasureId.teaSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.gallon, 330.215, IngredientMeasureId.teaSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.ounce, 42267.5, IngredientMeasureId.teaSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.teaSpoon, 5, IngredientMeasureId.milliliters),
  IngredientMeasureConversionItem(
      IngredientMeasureId.liter, 200, IngredientMeasureId.teaSpoon),

  // desertSpoon
  IngredientMeasureConversionItem(
      IngredientMeasureId.tableSpoon, 1.5, IngredientMeasureId.desertSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.cup, 24, IngredientMeasureId.desertSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.pint, 295.735, IngredientMeasureId.desertSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.quart, 660.43125, IngredientMeasureId.desertSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.gallon, 165.1075, IngredientMeasureId.desertSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.ounce, 21133.75, IngredientMeasureId.desertSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.desertSpoon, 10, IngredientMeasureId.milliliters),
  IngredientMeasureConversionItem(
      IngredientMeasureId.liter, 100, IngredientMeasureId.desertSpoon),

  // tableSpoon
  IngredientMeasureConversionItem(
      IngredientMeasureId.cup, 16, IngredientMeasureId.tableSpoon),
  IngredientMeasureConversionItem(IngredientMeasureId.pint, 197.156666666667,
      IngredientMeasureId.tableSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.quart, 440.2875, IngredientMeasureId.tableSpoon),
  IngredientMeasureConversionItem(IngredientMeasureId.gallon, 110.071666666667,
      IngredientMeasureId.tableSpoon),
  IngredientMeasureConversionItem(IngredientMeasureId.ounce, 14089.1666666667,
      IngredientMeasureId.tableSpoon),
  IngredientMeasureConversionItem(
      IngredientMeasureId.tableSpoon, 15, IngredientMeasureId.milliliters),
  IngredientMeasureConversionItem(IngredientMeasureId.liter, 66.6666666666667,
      IngredientMeasureId.tableSpoon),

  // cup
  IngredientMeasureConversionItem(
      IngredientMeasureId.pint, 2, IngredientMeasureId.cup),
  IngredientMeasureConversionItem(
      IngredientMeasureId.quart, 4, IngredientMeasureId.cup),
  IngredientMeasureConversionItem(
      IngredientMeasureId.gallon, 16, IngredientMeasureId.cup),
  IngredientMeasureConversionItem(
      IngredientMeasureId.ounce, 0.125, IngredientMeasureId.cup),
  IngredientMeasureConversionItem(
      IngredientMeasureId.cup, 240, IngredientMeasureId.milliliters),
  IngredientMeasureConversionItem(
      IngredientMeasureId.liter, 4.16666666666667, IngredientMeasureId.cup),

  // pint
  IngredientMeasureConversionItem(
      IngredientMeasureId.quart, 2, IngredientMeasureId.pint),
  IngredientMeasureConversionItem(
      IngredientMeasureId.gallon, 8, IngredientMeasureId.pint),
  IngredientMeasureConversionItem(
      IngredientMeasureId.pint, 16, IngredientMeasureId.ounce),
  IngredientMeasureConversionItem(
      IngredientMeasureId.pint, 2473.176, IngredientMeasureId.milliliters),
  IngredientMeasureConversionItem(
      IngredientMeasureId.liter, 2.11338, IngredientMeasureId.pint),

  // quart
  IngredientMeasureConversionItem(
      IngredientMeasureId.gallon, 4, IngredientMeasureId.quart),
  IngredientMeasureConversionItem(
      IngredientMeasureId.quart, 32, IngredientMeasureId.ounce),
  IngredientMeasureConversionItem(
      IngredientMeasureId.quart, 946.353, IngredientMeasureId.milliliters),
  IngredientMeasureConversionItem(
      IngredientMeasureId.liter, 1.05669, IngredientMeasureId.quart),

  // gallon
  IngredientMeasureConversionItem(
      IngredientMeasureId.gallon, 128, IngredientMeasureId.ounce),
  IngredientMeasureConversionItem(
      IngredientMeasureId.gallon, 3785.41, IngredientMeasureId.milliliters),
  IngredientMeasureConversionItem(
      IngredientMeasureId.gallon, 3.78541, IngredientMeasureId.liter),

  // ounce
  IngredientMeasureConversionItem(
      IngredientMeasureId.ounce, 29.5735, IngredientMeasureId.milliliters),
  IngredientMeasureConversionItem(
      IngredientMeasureId.liter, 33.814, IngredientMeasureId.ounce),

  // milliliters
  IngredientMeasureConversionItem(
      IngredientMeasureId.liter, 1000, IngredientMeasureId.milliliters),

  // pound
  IngredientMeasureConversionItem(
      IngredientMeasureId.pound, 453.592, IngredientMeasureId.grams),
  IngredientMeasureConversionItem(
      IngredientMeasureId.kilograms, 2.20462, IngredientMeasureId.pound),

  // grams
  IngredientMeasureConversionItem(
      IngredientMeasureId.kilograms, 1000, IngredientMeasureId.grams),
];

class IngredientMeasureConversionItem {
  final IngredientMeasureId fromMeasure;
  final double multiplier;
  final IngredientMeasureId toMeasure;

  IngredientMeasureConversionItem(
      this.fromMeasure, this.multiplier, this.toMeasure);

  @override
  String toString() {
    return '$fromMeasure $multiplier $toMeasure';
  }

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is IngredientMeasureConversionItem)) {
      return false;
    }

    return fromMeasure == other.fromMeasure &&
        multiplier == other.multiplier &&
        toMeasure == other.toMeasure;
  }

  @override
  int get hashCode => toString().hashCode;
}

class IngredientMeasureConversionResult {
  final IngredientMeasureId measure;
  final double quantity;

  IngredientMeasureConversionResult(this.measure, this.quantity);

  @override
  String toString() {
    return '$measure $quantity';
  }

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is IngredientMeasureConversionResult)) {
      return false;
    }

    return measure == other.measure && quantity == other.quantity;
  }

  @override
  int get hashCode => toString().hashCode;
}

class IngredientMeasureConverter {
  static IngredientMeasureConversionItem findConvertion(
      IngredientMeasureId measure1, measure2) {
    if (measure1 == measure2) {
      return IngredientMeasureConversionItem(measure1, 1, measure2);
    }

    Iterable<IngredientMeasureConversionItem> matches =
        _conversionTable.where((element) {
      return ((element.fromMeasure == measure1 &&
              element.toMeasure == measure2) ||
          (element.fromMeasure == measure2 && element.toMeasure == measure1));
    });

    return (matches != null && matches.length > 0) ? matches.first : null;
  }

  static IngredientMeasureConversionResult convert({
    IngredientMeasureId measure,
    double quantity,
    IngredientMeasureConversionItem conversion,
    IngredientMeasureId measureToAdd,
    double quantityToAdd,
    double portions,
  }) {
    IngredientMeasureId newMeasure = measure;
    double finalQuantity = 0;

    if (conversion.fromMeasure == measure) {
      finalQuantity =
          quantity + (quantityToAdd * portions / conversion.multiplier);
    } else {
      newMeasure = measureToAdd;
      finalQuantity =
          (portions * quantityToAdd) + (quantity / conversion.multiplier);
    }

    return IngredientMeasureConversionResult(newMeasure, finalQuantity);
  }
}
