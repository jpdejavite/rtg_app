import 'package:flutter/material.dart';
import 'package:rtg_app/screens/save_recipe_screen.dart';
import 'package:rtg_app/screens/home_screen.dart';
import 'package:rtg_app/screens/view_recipe_screen.dart';
import 'package:rtg_app/screens/welcome_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

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
      theme: ThemeData.light(),
      initialRoute: HomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) {
          return WelcomeScreen();
        },
        HomeScreen.id: (context) {
          return HomeScreen();
        },
        SaveRecipeScreen.id: (context) {
          return SaveRecipeScreen.newSaveRecipeBloc();
        },
        ViewRecipeScreen.id: (context) {
          return ViewRecipeScreen();
        },
      },
      builder: EasyLoading.init(),
    );
  }
}
