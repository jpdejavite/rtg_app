import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtg_app/widgets/preparation_time_label_text.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widget_helper.dart';

void main() {
  testWidgets('PreparationTimeLabelText 1 minute', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(
      preparationTime: 1,
    ));

    expect(
        WidgetHelper.findTextSpanWithText(find, 'Preparation time: 1 minute'),
        findsOneWidget);
  });

  testWidgets('PreparationTimeLabelText 4 minutes',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(
      preparationTime: 4,
    ));

    expect(
        WidgetHelper.findTextSpanWithText(find, 'Preparation time: 4 minutes'),
        findsOneWidget);
  });

  testWidgets('PreparationTimeLabelText 1 hour', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(
      preparationTime: 60,
    ));

    expect(WidgetHelper.findTextSpanWithText(find, 'Preparation time: 1 hour'),
        findsOneWidget);
  });

  testWidgets('PreparationTimeLabelText 3 hours', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(
      preparationTime: 60 * 3,
    ));

    expect(WidgetHelper.findTextSpanWithText(find, 'Preparation time: 3 hours'),
        findsOneWidget);
  });

  testWidgets('PreparationTimeLabelText 3 h 15 m', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(
      preparationTime: 60 * 3 + 15,
    ));

    expect(
        WidgetHelper.findTextSpanWithText(find, 'Preparation time: 3 h 15 m'),
        findsOneWidget);
  });

  testWidgets('PreparationTimeLabelText 1 day', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(
      preparationTime: 60 * 24 * 1,
    ));

    expect(WidgetHelper.findTextSpanWithText(find, 'Preparation time: 1 day'),
        findsOneWidget);
  });

  testWidgets('PreparationTimeLabelText 5 days', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(
      preparationTime: 60 * 24 * 5,
    ));

    expect(WidgetHelper.findTextSpanWithText(find, 'Preparation time: 5 days'),
        findsOneWidget);
  });

  testWidgets('PreparationTimeLabelText 5 d 1 h', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(
      preparationTime: 60 * 24 * 5 + 60,
    ));

    expect(WidgetHelper.findTextSpanWithText(find, 'Preparation time: 5 d 1 h'),
        findsOneWidget);
  });

  testWidgets('PreparationTimeLabelText 5 d 1 h 5 m',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(
      preparationTime: 60 * 24 * 5 + 60 + 5,
    ));

    expect(
        WidgetHelper.findTextSpanWithText(
            find, 'Preparation time: 5 d 1 h 5 m'),
        findsOneWidget);
  });

  testWidgets('PreparationTimeLabelText 1 week', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(
      preparationTime: 60 * 24 * 7 * 1,
    ));

    expect(WidgetHelper.findTextSpanWithText(find, 'Preparation time: 1 week'),
        findsOneWidget);
  });

  testWidgets('PreparationTimeLabelText 3 weeks', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(
      preparationTime: 60 * 24 * 7 * 3,
    ));

    expect(WidgetHelper.findTextSpanWithText(find, 'Preparation time: 3 weeks'),
        findsOneWidget);
  });

  testWidgets('PreparationTimeLabelText 3 w 2 d', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(
      preparationTime: (60 * 24 * 7 * 3) + (60 * 24 * 2),
    ));

    expect(WidgetHelper.findTextSpanWithText(find, 'Preparation time: 3 w 2 d'),
        findsOneWidget);
  });

  testWidgets('PreparationTimeLabelText 1 month', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(
      preparationTime: 60 * 24 * 7 * 4,
    ));

    expect(WidgetHelper.findTextSpanWithText(find, 'Preparation time: 1 month'),
        findsOneWidget);
  });

  testWidgets('PreparationTimeLabelText 2 months', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(
      preparationTime: 60 * 24 * 7 * 4 * 2 + 6,
    ));

    expect(
        WidgetHelper.findTextSpanWithText(find, 'Preparation time: 2 months'),
        findsOneWidget);
  });
}

class MyWidget extends StatelessWidget {
  final int preparationTime;

  const MyWidget({
    Key key,
    @required this.preparationTime,
  }) : super(key: key);

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
      home: Scaffold(
        appBar: AppBar(
          title: Text('test'),
        ),
        body: ListView(
          children: [
            PreparationTimeLabelText(
              preparationTime: preparationTime,
            )
          ],
        ),
      ),
    );
  }
}
