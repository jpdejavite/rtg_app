import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/theme/custom_colors.dart';
import 'package:rtg_app/widgets/preparation_time_label_text.dart';

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

    List<Widget> children = <Widget>[
      ListTile(
        leading: icon == null ? null : Icon(icon, color: iconColor),
        title: Text(title, style: Theme.of(context).textTheme.headline5),
        subtitle: subtitle != null ? Text(subtitle) : null,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: buttons,
      ),
    ];

    List<Widget> lastUsedGroceryListWidgets = [];
    if (lastUsedGroceryList != null) {
      int itensChecked = 0;
      lastUsedGroceryList.groceries.forEach((grocery) {
        if (grocery.checked) {
          itensChecked++;
          return;
        }
      });

      double totalPortions = 0;
      if (lastUsedGroceryList.recipesPortions != null) {
        lastUsedGroceryList.recipesPortions.forEach((key, value) {
          totalPortions += value;
        });
      }

      String portionsToShow = totalPortions.toInt().toString();
      if (totalPortions % 1 != 0) {
        portionsToShow = totalPortions.toMixedFraction().toString();
      }

      lastUsedGroceryListWidgets.addAll([
        TextButton(
          key: actionKey,
          child: Text(
            lastUsedGroceryList.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onPressed: onAction,
        ),
        Padding(
          child: Row(
            children: [
              Icon(
                Icons.format_list_bulleted,
                size: 16,
                color: CustomColors.detailsIconColor,
              ),
              SizedBox(width: 4),
              Text(
                itensChecked > 0
                    ? '${lastUsedGroceryList.groceries.length - itensChecked}/${lastUsedGroceryList.groceries.length}'
                    : lastUsedGroceryList.groceries.length.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(width: 16),
              Icon(
                Icons.fastfood,
                size: 16,
                color: CustomColors.detailsIconColor,
              ),
              SizedBox(width: 4),
              Text(
                portionsToShow,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 8),
        ),
        const SizedBox(height: 8),
      ]);

      if (lastUsedGroceryListRecipes != null) {
        lastUsedGroceryListWidgets.addAll([
          const SizedBox(height: 8),
          Padding(
            child: Text(AppLocalizations.of(context).list_recipes),
            padding: EdgeInsets.only(left: 8),
          ),
        ]);

        lastUsedGroceryListRecipes.asMap().forEach((index, recipe) {
          String portionsToShow = recipe.portions.toInt().toString();
          if (recipe.portions % 1 != 0) {
            portionsToShow = recipe.portions.toMixedFraction().toString();
          }

          List<Widget> detailsWidgets = [
            Icon(
              Icons.fastfood,
              size: 16,
              color: CustomColors.detailsIconColor,
            ),
            SizedBox(width: 4),
            Text(
              portionsToShow,
              style: Theme.of(context).textTheme.caption,
            ),
          ];

          if (recipe.totalPreparationTime != null &&
              recipe.totalPreparationTime > 0) {
            detailsWidgets.addAll([
              SizedBox(width: 16),
              Icon(
                Icons.schedule,
                size: 16,
                color: CustomColors.detailsIconColor,
              ),
              SizedBox(width: 4),
              Text(
                PreparationTimeLabelText.getPreparationTimeText(
                    recipe.totalPreparationTime, true, context),
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(width: 4),
              Expanded(
                  child: Text(
                recipe.preparationTimeDetails
                    .getPreparationTimeDetails(context),
                key: Key(Keys.viewRecipePreparationTimeDetailsText),
                style: Theme.of(context).textTheme.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ))
            ]);
          }

          lastUsedGroceryListWidgets.addAll([
            TextButton(
              key: Key('${Keys.homeCardRecipeButton}-$index'),
              child: Text(
                recipe.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                onTapRecipe(recipe);
              },
            ),
            Padding(
              child: Row(
                children: detailsWidgets,
              ),
              padding: EdgeInsets.only(left: 8),
            ),
            const SizedBox(height: 8),
          ]);
        });
      }

      children.add(
        Padding(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lastUsedGroceryListWidgets,
          ),
          padding: EdgeInsets.only(left: 8),
        ),
      );
    }

    return Card(
      key: cardKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
