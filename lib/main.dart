import 'package:flutter/material.dart';
import 'package:rtg_app/screens/save_recipe_screen.dart';
import 'package:rtg_app/screens/home_screen.dart';
import 'package:rtg_app/screens/settings_screen.dart';
import 'package:rtg_app/screens/view_recipe_screen.dart';
import 'package:rtg_app/screens/welcome_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'model/recipe.dart';

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
          return HomeScreen.newHomeBloc();
        },
        SaveRecipeScreen.id: (context) {
          var args = ModalRoute.of(context).settings.arguments;
          Recipe editRecipe;
          if (args != null && args is Recipe) {
            editRecipe = args;
          }
          return SaveRecipeScreen.newSaveRecipeBloc(editRecipe);
        },
        ViewRecipeScreen.id: (context) {
          return ViewRecipeScreen.newViewRecipeBloc();
        },
        SettingsScreen.id: (context) {
          return SettingsScreen.newSettingsBloc();
        },
      },
      builder: EasyLoading.init(),
    );
  }
}
