import 'package:rtg_app/helper/diacritics.dart';
import 'package:rtg_app/helper/string_helper.dart';
import 'package:rtg_app/model/ingredient_measure.dart';
import 'package:rtg_app/model/ingredient_quantity.dart';

class IngredientParseResult {
  IngredientParseResult({
    this.quantity,
    this.measureId,
    this.name,
    this.originalName,
  });

  double quantity;
  IngredientMeasureId measureId;
  String name;
  String originalName;

  @override
  String toString() {
    return '$quantity $measureId $name $originalName';
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
        originalName == other.originalName;
  }

  @override
  int get hashCode => toString().hashCode;
}

class IngredientParser {
  static IngredientParseResult fromInput(String originalText) {
    double quantity = 1.0;
    IngredientMeasureId measureId = IngredientMeasureId.unit;
    if (originalText == null) {
      return IngredientParseResult(
        originalName: originalText,
        name: originalText,
        quantity: quantity,
        measureId: measureId,
      );
    }
    originalText = originalText.trim().replaceAll(RegExp(r'[\s]+'), ' ');
    String text = originalText.toLowerCase();

    String formattedText = Diacritics.removeDiacritics(text);
    IngredientQuantity iq = IngredientQuantity.getQuantity(formattedText);
    quantity = iq.quantity;
    if (iq.hasMatch()) {
      text = text.substring(iq.textMatch.length).trim();
      formattedText = formattedText.substring(iq.textMatch.length).trim();
    }
    IngredientMeasure im = IngredientMeasure.getId(formattedText);
    measureId = im.id;
    if (im.hasMatch()) {
      text = text.substring(im.textMatch.length).trim();
      text = StringHelper.removeLeadingPropostion(text);
      formattedText = formattedText.substring(im.textMatch.length).trim();
      formattedText = StringHelper.removeLeadingPropostion(formattedText);
    }

    return IngredientParseResult(
      originalName: originalText,
      name: text,
      quantity: quantity,
      measureId: measureId,
    );
  }
}
