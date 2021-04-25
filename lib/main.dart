import 'package:flutter/material.dart';
import 'package:rtg_app/screens/edit_recipe_preparation_time_details_screen.dart';
import 'package:rtg_app/screens/home_screen.dart';
import 'package:rtg_app/screens/save_grocery_list_screen.dart';
import 'package:rtg_app/screens/save_recipe_screen.dart';
import 'package:rtg_app/screens/settings_screen.dart';
import 'package:rtg_app/screens/tutorial_screen.dart';
import 'package:rtg_app/screens/view_recipe_screen.dart';
import 'package:rtg_app/screens/welcome_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rtg_app/theme/custom_theme_data.dart';

import 'model/grocery_list.dart';
import 'model/recipe.dart';
import 'model/recipe_preparation_time_details.dart';

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
      theme: CustomThemeData.lightTheme,
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
        EditPreparationTimeDetailsScreen.id: (context) {
          var args = ModalRoute.of(context).settings.arguments;
          RecipePreparationTimeDetails preparationTimeDetails;
          if (args != null && args is RecipePreparationTimeDetails) {
            preparationTimeDetails = args;
          }
          return EditPreparationTimeDetailsScreen(preparationTimeDetails);
        },
        SaveGroceryListScreen.id: (context) {
          var args = ModalRoute.of(context).settings.arguments;
          GroceryList editGroceryList;
          if (args != null && args is GroceryList) {
            editGroceryList = args;
          }
          return SaveGroceryListScreen.newSaveGroceryListBloc(editGroceryList);
        },
        ViewRecipeScreen.id: (context) {
          return ViewRecipeScreen.newViewRecipeBloc();
        },
        SettingsScreen.id: (context) {
          return SettingsScreen.newSettingsBloc();
        },
        TutorialScreen.id: (context) {
          var args = ModalRoute.of(context).settings.arguments;
          TutorialData tutorialData;
          if (args != null && args is TutorialData) {
            tutorialData = args;
          }
          return TutorialScreen(tutorialData);
        },
      },
      builder: EasyLoading.init(),
    );
  }
}
