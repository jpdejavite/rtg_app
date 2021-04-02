import 'package:flutter_test/flutter_test.dart';
import 'package:rtg_app/helper/date_formatter.dart';
import 'package:sprintf/sprintf.dart';

void main() {
  test('weekOfMonth in 2021-04', () {
    DateTime customTime = DateTime.parse("2021-04-01 20:18:04");
    expect(DateFormatter.weekOfMonth(customTime), 1);

    for (int i = 1; i <= 30; i++) {
      String dateString = sprintf("2021-04-%02d 20:18:04", [i]);
      DateTime customTime = DateTime.parse(dateString);
      int weekOfMonth = 1;
      if (i >= 25) {
        weekOfMonth = 5;
      } else if (i >= 18) {
        weekOfMonth = 4;
      } else if (i >= 11) {
        weekOfMonth = 3;
      } else if (i >= 4) {
        weekOfMonth = 2;
      }
      expect(DateFormatter.weekOfMonth(customTime), weekOfMonth,
          reason:
              '$dateString should be week of month $weekOfMonth ${customTime.weekday}');
    }
  });
}
