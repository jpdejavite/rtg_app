import 'package:fraction/fraction.dart';

class IngredientQuantity {
  final double quantity;
  final String textMatch;

  IngredientQuantity(this.quantity, this.textMatch);

  bool hasMatch() {
    return textMatch != null && textMatch != "";
  }

  static IngredientQuantity getQuantity(String text) {
    if (text == null || text == "") {
      return IngredientQuantity(1, "");
    }
    RegExp exp = RegExp(r"^\d+ \d+/\d+");
    RegExpMatch match = exp.firstMatch(text);
    if (match != null) {
      final mixed = MixedFraction.fromString(match.group(0));
      return IngredientQuantity(mixed.toDouble(), match.group(0));
    }

    exp = RegExp(r"^\d+/\d+");
    match = exp.firstMatch(text);
    if (match != null) {
      final fraction = Fraction.fromString(match.group(0));
      return IngredientQuantity(fraction.toDouble(), match.group(0));
    }

    exp = RegExp(r"^[\d\.,]+");
    match = exp.firstMatch(text);

    if (match == null) {
      return IngredientQuantity(1, "");
    }

    try {
      double quantity = double.parse(match.group(0).replaceAll(",", "."));
      return IngredientQuantity(quantity, match.group(0));
    } catch (e) {
      return IngredientQuantity(1, "");
    }
  }

  @override
  String toString() {
    return '$quantity $textMatch';
  }

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is IngredientQuantity)) {
      return false;
    }

    return quantity == other.quantity && textMatch == other.textMatch;
  }

  @override
  int get hashCode => toString().hashCode;
}
