import 'package:pdf/widgets.dart';
import 'package:rtg_app/helper/pdf_export_constants.dart';

class PdfViewRecipeLabelText extends StatelessWidget {
  final String label;
  final String text;

  PdfViewRecipeLabelText({this.label, this.text});

  @override
  Widget build(Context context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: RichText(
        text: TextSpan(
          text: label + ": ",
          style: PdfExporterConstants.bodyLabelTextStyle,
          children: [
            TextSpan(
              text: text,
              style: PdfExporterConstants.bodyTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
