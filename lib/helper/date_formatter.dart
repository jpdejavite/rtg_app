import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDateInMili(int dateInMili, String format) {
    if (dateInMili > 0) {
      final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dateInMili);
      return DateFormat(format).format(dateTime);
    }

    return '';
  }

  static String formatDate(DateTime dateTime, String format) {
    if (dateTime != null) {
      return DateFormat(format).format(dateTime);
    }

    return '';
  }

  static int weekOfMonth(DateTime date) {
    DateTime firstDayOfMonth =
        DateTime.parse(DateFormat("yyyy-MM-01 HH:mm:ss").format(date));
    int dayOfMonth = int.parse(DateFormat("d").format(date));
    return ((dayOfMonth + firstDayOfMonth.weekday - 1) / 7).floor() + 1;
  }
}
