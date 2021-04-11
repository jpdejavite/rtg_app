import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/recipe.dart';

class HomeCard extends StatelessWidget {
  final Key cardKey;
  final Key dimissKey;
  final Key actionKey;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String action;
  final void Function() onDismiss;
  final void Function() onAction;
  final GroceryList lastUsedGroceryList;
  final List<Recipe> lastUsedGroceryListRecipes;
  final void Function(Recipe recipe) onTapRecipe;

  HomeCard({
    this.cardKey,
    this.dimissKey,
    this.actionKey,
    this.icon,
    this.iconColor,
    this.title,
    this.subtitle,
    this.onDismiss,
    this.action,
    this.onAction,
    this.lastUsedGroceryList,
    this.lastUsedGroceryListRecipes,
    this.onTapRecipe,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];
    if (onDismiss != null) {
      buttons.add(
        TextButton(
          key: dimissKey,
          child: Text(AppLocalizations.of(context).dismiss),
          onPressed: onDismiss,
        ),
      );
    }

    if (action != null) {
      buttons.addAll([
        const SizedBox(width: 8),
        TextButton(
          key: actionKey,
          child: Text(action),
          onPressed: onAction,
        ),
        const SizedBox(width: 8),
      ]);
    }

    List<Widget> lastUsedGroceryListWidgets = [];

    if (lastUsedGroceryList != null) {
      lastUsedGroceryListWidgets.addAll([
        Padding(
          child: TextButton(
            key: actionKey,
            child: Text(lastUsedGroceryList.title),
            onPressed: onAction,
          ),
          padding: EdgeInsets.only(left: 70),
        ),
        const SizedBox(width: 8),
      ]);

      if (lastUsedGroceryListRecipes != null) {
        lastUsedGroceryListWidgets.addAll([
          const SizedBox(width: 8),
          Padding(
            child: Text(AppLocalizations.of(context).recipes),
            padding: EdgeInsets.only(left: 76),
          ),
        ]);

        lastUsedGroceryListRecipes.asMap().forEach((index, recipe) {
          lastUsedGroceryListWidgets.addAll([
            Padding(
              child: TextButton(
                key: Key('${Keys.homeCardRecipeButton}-$index'),
                child: Text(recipe.title),
                onPressed: () {
                  onTapRecipe(recipe);
                },
              ),
              padding: EdgeInsets.only(left: 70),
            ),
            const SizedBox(width: 8),
          ]);
        });
      }
    }

    return Card(
      key: cardKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Icon(icon, color: iconColor),
            title: Text(title),
            subtitle: subtitle != null ? Text(subtitle) : null,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: buttons,
          ),
          ...lastUsedGroceryListWidgets,
        ],
      ),
    );
  }
}
