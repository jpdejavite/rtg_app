import 'package:pdf/widgets.dart';
import 'package:rtg_app/helper/string_helper.dart';

class PdfTextWrapper extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int maxLineSize;

  PdfTextWrapper({this.text, this.style, this.maxLineSize});

  @override
  Widget build(Context context) {
    List<String> paragraph =
        StringHelper.breakTextIntoParagraph(this.text, this.maxLineSize);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...paragraph.map<Widget>((line) => Text(line, style: this.style))
      ],
    );
  }
}
