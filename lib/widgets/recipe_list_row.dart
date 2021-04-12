import 'package:flutter/material.dart';
import 'package:rtg_app/helper/date_formatter.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/widgets/add_recipe_to_grocery_list_dialog.dart';
import 'package:rtg_app/widgets/preparation_time_label_text.dart';
import 'package:fraction/fraction.dart';

class RecipeListRow extends StatelessWidget {
  final Recipe recipe;
  final int index;
  final void Function(int index) onTap;
  RecipeListRow({this.onTap, this.recipe, this.index});

  @override
  Widget build(BuildContext context) {
    List<Widget> titleWidgets = [
      Expanded(
        child: Text(
          recipe.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          key: Key(Keys.recipeListRowTitleText + index.toString()),
        ),
      ),
    ];
    if (recipe.totalPrepartionTime != null && recipe.totalPrepartionTime > 0) {
      titleWidgets.addAll([
        Icon(
          Icons.schedule,
          size: 16,
          color: Theme.of(context).textTheme.caption.color,
        ),
        SizedBox(width: 4),
        Text(
          PreparationTimeLabelText.getPreparationTimeText(
              recipe.totalPrepartionTime, true, context),
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
        color: Theme.of(context).textTheme.headline1.color,
      ),
      SizedBox(width: 4),
      Text(
        portionsToShow,
        style: Theme.of(context)
            .textTheme
            .caption
            .copyWith(color: Theme.of(context).textTheme.headline1.color),
      ),
    ];

    if (recipe.lastUsed != null) {
      bottomRowItems.addAll([
        SizedBox(width: 8),
        Icon(
          Icons.calendar_today,
          size: 16,
          color: Theme.of(context).textTheme.headline1.color,
        ),
        SizedBox(width: 4),
        Text(
          DateFormatter.formatDateInMili(
              recipe.lastUsed, AppLocalizations.of(context).updated_at_format),
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(color: Theme.of(context).textTheme.headline1.color),
        ),
      ]);
    }

    bottomRowItems.addAll([
      Expanded(
        child: SizedBox(),
      ),
      IconButton(
        key: Key(Keys.viewRecipeAddToGroceryListAction),
        icon: Icon(Icons.playlist_add),
        tooltip: AppLocalizations.of(context).add_to_grocery_list,
        onPressed: () {
          AddRecipeToGroceryListDialog.showChooseGroceryListToRecipeEvent(
              context: context,
              recipe: recipe,
              onConfirm: (Recipe recipe, double portions) {
                // context.read<ViewRecipeBloc>().add(
                //     TryToAddRecipeToGroceryListEvent(
                //         recipe,
                //         portions,
                //         getGroceryListDefaultTitle()));
                // EasyLoading.show(
                //   maskType: EasyLoadingMaskType.black,
                //   status: AppLocalizations.of(context)
                //       .saving_recipe,
                // );
              });
        },
      ),
    ]);
    return InkWell(
        onTap: () {
          this.onTap(index);
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
