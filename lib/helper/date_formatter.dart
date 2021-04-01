import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDateInMili(int dateInMili, String format) {
    if (dateInMili > 0) {
      final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dateInMili);
      return DateFormat(format).format(dateTime);
    }

    return '';
  }
}
