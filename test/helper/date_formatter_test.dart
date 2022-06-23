import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtg_app/helper/date_formatter.dart';
import 'package:sprintf/sprintf.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  test('weekDays', () {
    expect(DateFormatter.weekDays(), [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ]);
  });

  test('formatDateInMili valid date', () {
    DateTime time = DateTime.parse("2000-07-20 20:18:04");

    expect(DateFormatter.formatDateInMili(time.millisecondsSinceEpoch, 'yMd'),
        '7/20/2000');
  });

  test('formatDateInMili null date', () {
    expect(DateFormatter.formatDateInMili(-1, 'yMd'), '');
  });

  test('formatDate valid date', () {
    DateTime time = DateTime.parse("2000-07-20 20:18:04");

    expect(DateFormatter.formatDate(time, 'yMd'), '7/20/2000');
  });

  test('formatDate null date', () {
    expect(DateFormatter.formatDate(null, 'yMd'), '');
  });

  testWidgets('getMenuPlanningDayString', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget());
    final BuildContext context = tester.element(find.byType(Container));

    DateTime time = DateTime.parse("2000-07-20 20:18:04");

    expect(DateFormatter.getMenuPlanningDayString(time, context),
        '07/20/00 Thursday');
  });

  testWidgets('dateWeek valid date', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget());
    final BuildContext context = tester.element(find.byType(Container));

    DateTime time = DateTime.parse("2000-07-20 20:18:04");

    expect(DateFormatter.dateWeek(time, context), 'Thursday');
  });

  testWidgets('dateWeek null date', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget());
    final BuildContext context = tester.element(find.byType(Container));

    expect(DateFormatter.dateWeek(null, context), '');
  });

  testWidgets('dateMonth valid date', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget());
    final BuildContext context = tester.element(find.byType(Container));

    DateTime time = DateTime.parse("2000-07-20 20:18:04");

    expect(DateFormatter.dateMonth(time, context), 'July');
  });

  testWidgets('dateMonth null date', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget());
    final BuildContext context = tester.element(find.byType(Container));

    expect(DateFormatter.dateMonth(null, context), '');
  });
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('pt', 'BR'),
      ],
      home: Container(),
    );
  }
}
