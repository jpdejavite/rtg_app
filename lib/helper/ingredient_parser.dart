import 'package:rtg_app/helper/diacritics.dart';
import 'package:rtg_app/helper/string_helper.dart';
import 'package:rtg_app/model/ingredient_measure.dart';
import 'package:rtg_app/model/ingredient_quantity.dart';

class IngredientParseResult {
  IngredientParseResult({
    this.quantity,
    this.hasParsedQuantity,
    this.measureId,
    this.name,
    this.originalName,
  });

  double quantity;
  bool hasParsedQuantity;
  IngredientMeasureId measureId;
  String name;
  String originalName;

  @override
  String toString() {
    return '$quantity $hasParsedQuantity $measureId $name $originalName';
  }

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is IngredientParseResult)) {
      return false;
    }

    return quantity == other.quantity &&
        measureId == other.measureId &&
        name == other.name &&
        originalName == other.originalName &&
        hasParsedQuantity == other.hasParsedQuantity;
  }

  @override
  int get hashCode => toString().hashCode;
}

class IngredientParser {
  static IngredientParseResult fromInput(String originalText) {
    double quantity = 1.0;
    bool hasParsedQuantity = false;
    IngredientMeasureId measureId = IngredientMeasureId.unit;
    if (originalText == null) {
      return IngredientParseResult(
        originalName: originalText,
        name: originalText,
        quantity: quantity,
        hasParsedQuantity: hasParsedQuantity,
        measureId: measureId,
      );
    }
    originalText = originalText.trim().replaceAll(RegExp(r'[\s]+'), ' ');
    String text = originalText.toLowerCase();

    String formattedText = Diacritics.removeDiacritics(text);
    IngredientQuantity iq = IngredientQuantity.getQuantity(formattedText);
    quantity = iq.quantity;
    if (iq.hasMatch()) {
      hasParsedQuantity = true;
      text = text.substring(iq.textMatch.length).trim();
      formattedText = formattedText.substring(iq.textMatch.length).trim();
    }
    IngredientMeasure im = IngredientMeasure.getId(formattedText);
    measureId = im.id;
    if (im.hasMatch()) {
      text = text.substring(im.textMatch.length).trim();
      text = StringHelper.removeLeadingPrepostion(text);
      formattedText = formattedText.substring(im.textMatch.length).trim();
      formattedText = StringHelper.removeLeadingPrepostion(formattedText);
    }

    return IngredientParseResult(
      originalName: originalText,
      name: text,
      quantity: quantity,
      hasParsedQuantity: hasParsedQuantity,
      measureId: measureId,
    );
  }
}
