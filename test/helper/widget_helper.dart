import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

String fromRichTextToPlainText(final Widget widget) {
  if (widget is RichText) {
    if (widget.text is TextSpan) {
      final buffer = StringBuffer();
      (widget.text as TextSpan).computeToPlainText(buffer);
      return buffer.toString();
    }
  }
  return "";
}

class WidgetHelper {
  static Finder findTextSpanWithText(CommonFinders find, String text) {
    return find.byWidgetPredicate((widget) {
      String stringFound = fromRichTextToPlainText(widget);
      // print('stringFound:' + stringFound);
      return stringFound == text;
    });
  }
}
