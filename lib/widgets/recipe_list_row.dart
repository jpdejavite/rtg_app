import 'package:flutter/material.dart';
import 'package:rtg_app/helper/date_formatter.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/theme/custom_colors.dart';
import 'package:rtg_app/widgets/preparation_time_label_text.dart';
import 'package:fraction/fraction.dart';

class RecipeListRow extends StatelessWidget {
  final Recipe recipe;
  final int index;
  final void Function() onTap;
  final void Function() onAddToGroceryList;
  RecipeListRow({this.onTap, this.onAddToGroceryList, this.recipe, this.index});

  @override
  Widget build(BuildContext context) {
    List<Widget> titleWidgets = [
      Expanded(
        child: Text(
          recipe.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline6,
          key: Key(Keys.recipeListRowTitleText + index.toString()),
        ),
      ),
    ];
    if (recipe.totalPreparationTime != null &&
        recipe.totalPreparationTime > 0) {
      titleWidgets.addAll([
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
        )
      ]);
    }

    String portionsToShow = recipe.portions.toInt().toString();
    if (recipe.portions % 1 != 0) {
      portionsToShow = recipe.portions.toMixedFraction().toString();
    }

    List<Widget> bottomRowItems = [
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
    ];

    if (recipe.lastUsed != null) {
      bottomRowItems.addAll([
        SizedBox(width: 8),
        Icon(
          Icons.calendar_today,
          size: 16,
          color: CustomColors.detailsIconColor,
        ),
        SizedBox(width: 4),
        Text(
          DateFormatter.formatDateInMili(
              recipe.lastUsed, AppLocalizations.of(context).last_used_format),
          style: Theme.of(context).textTheme.caption,
        ),
      ]);
    }

    if (recipe.label != null) {
      bottomRowItems.addAll([
        SizedBox(width: 8),
        Icon(
          Icons.label,
          size: 16,
          color: CustomColors.detailsIconColor,
        ),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            recipe.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ]);
    } else {
      bottomRowItems.add(Expanded(child: SizedBox()));
    }

    bottomRowItems.add(
      IconButton(
        key: Key(Keys.viewRecipeAddToGroceryListAction + index.toString()),
        icon: Icon(Icons.playlist_add),
        tooltip: AppLocalizations.of(context).add_to_grocery_list,
        onPressed: () {
          onAddToGroceryList();
        },
      ),
    );
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Card(
          // key: cardKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: titleWidgets,
                ),
                subtitle: Text(
                  recipe.instructions,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: bottomRowItems,
              ),
            ],
          ),
        ));
  }
}
