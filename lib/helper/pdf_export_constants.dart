import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../theme/custom_colors.dart';

class PdfExporterConstants {
  static final bodyTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: PdfColors.black,
  );
  static final bodyLabelTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: PdfColor.fromInt(CustomColors.primaryColorInt),
  );

  static final bodyDetailsTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 10,
    color: PdfColors.black,
  );

  static final bodyIngredientTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: PdfColors.black,
  );

  static final double defaultPadding = 5;

  static final double logoSize = 50;
}
