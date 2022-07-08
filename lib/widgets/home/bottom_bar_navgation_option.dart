import 'package:flutter/material.dart';

import '../../keys/keys.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../model/grocery_list.dart';
import '../../model/recipe.dart';
import '../grocery_lists_widget.dart';
import '../recipes_list_widget.dart';

class BottomBarNavigationOption {
  final String title;
  final Widget body;
  final FloatingActionButton floatingActionButton;
  BottomBarNavigationOption({this.body, this.title, this.floatingActionButton});

  static BottomNavigationBar buildBottomNavigationBar(
      BuildContext context, int selectedIndex, void onItemTapped(int index)) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            key: Key(Keys.homeBottomBarHomeIcon),
          ),
          label: AppLocalizations.of(context).home,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.library_books,
            key: Key(Keys.homeBottomBarRecipesIcon),
          ),
          label: AppLocalizations.of(context).recipes,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list,
            key: Key(Keys.homeBottomBarListsIcon),
          ),
          label: AppLocalizations.of(context).lists,
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }

  static List<BottomBarNavigationOption> buildBottomBarNavigationOption(
      BuildContext context,
      Widget homeBody,
      GlobalKey<RecipesListState> recipeKeyListkey,
      void Function(Recipe recipe) onTapRecipe,
      void Function() onRecipesFloatingActionButtonPressed,
      GlobalKey<GroceryListsState> groceryListsKeyListkey,
      void Function(GroceryList groceryList) onTapGroceryList,
      void Function() onGroceryListFloatingActionButtonPressed) {
    return [
      BottomBarNavigationOption(
        title: AppLocalizations.of(context).home,
        body: homeBody,
      ),
      BottomBarNavigationOption(
        title: AppLocalizations.of(context).recipes,
        floatingActionButton: FloatingActionButton(
          key: Key(Keys.homeFloatingActionNewRecipeButton),
          onPressed: onRecipesFloatingActionButtonPressed,
          child: Icon(Icons.add),
        ),
        body: RecipesList.newRecipeListBloc(
          key: recipeKeyListkey,
          onTapRecipe: onTapRecipe,
        ),
      ),
      BottomBarNavigationOption(
        title: AppLocalizations.of(context).lists,
        body: GroceryLists.newGroceryListsBloc(
          key: groceryListsKeyListkey,
          onTapGroceryList: onTapGroceryList,
        ),
        floatingActionButton: FloatingActionButton(
          key: Key(Keys.homeFloatingActionNewGroceryListButton),
          onPressed: onGroceryListFloatingActionButtonPressed,
          child: Icon(Icons.add),
        ),
      ),
    ];
  }
}
