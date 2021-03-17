import 'package:flutter/material.dart';
import 'package:rtg_app/screens/home_screen.dart';
import 'package:rtg_app/screens/welcome_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; 

void main() {
  runApp(RtgApp());
}

class RtgApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      // theme: ThemeData.light().copyWith(
      //   textTheme: TextTheme(
      //     bodyText1: TextStyle(color: Colors.red),
      //   ),
      // ),
      initialRoute: HomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) {
          return WelcomeScreen();
        },
        HomeScreen.id: (context) {
          return HomeScreen();
        }
      },
    );
  }
}
