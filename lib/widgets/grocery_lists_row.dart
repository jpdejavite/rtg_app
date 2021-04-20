import 'package:flutter/material.dart';
import 'package:rtg_app/helper/date_formatter.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprintf/sprintf.dart';
import 'package:fraction/fraction.dart';

class GroceryListListRow extends StatelessWidget {
  final GroceryList groceryList;
  final int index;
  final void Function() onTap;
  final void Function() onShowRecipes;
  GroceryListListRow(
      {this.onTap, this.groceryList, this.index, this.onShowRecipes});

  @override
  Widget build(BuildContext context) {
    List<Widget> groceries = [];
    int maxItensShown = 7;
    int itensChecked = 0;
    groceryList.groceries.forEach((grocery) {
      if (grocery.checked) {
        itensChecked++;
        return;
      }
      if (maxItensShown > 0) {
        if (maxItensShown == 7) {
          groceries.add(SizedBox(height: 4));
        }
        maxItensShown--;
        groceries.add(Row(
          children: [
            Icon(
              Icons.check_box_outline_blank,
              size: 16,
            ),
            SizedBox(width: 4),
            Text(
              grocery.getName(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ));
      } else {
        maxItensShown--;
      }
    });

    if (maxItensShown < 0) {
      groceries.add(Text('...'));
    }

    List<Widget> titleWidgets = [
      Expanded(
        child: Text(
          groceryList.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          key: Key(Keys.groceryListRowTitleText + index.toString()),
        ),
      ),
    ];
    if (groceryList.recipesPortions != null) {
      double totalPortions = 0;
      groceryList.recipesPortions.forEach((key, value) {
        totalPortions += value;
      });

      if (totalPortions != 0) {
        String portionsToShow = totalPortions.toInt().toString();
        if (totalPortions % 1 != 0) {
          portionsToShow = totalPortions.toMixedFraction().toString();
        }
        titleWidgets.addAll([
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
        ]);
      }
    }

    List<Widget> bottomRowItems = [
      SizedBox(width: 16),
      Icon(
        Icons.format_list_bulleted,
        size: 16,
        color: Theme.of(context).textTheme.headline1.color,
      ),
      SizedBox(width: 4),
      Text(
        itensChecked > 0
            ? '${groceryList.groceries.length - itensChecked}/${groceryList.groceries.length}'
            : groceryList.groceries.length.toString(),
        style: Theme.of(context)
            .textTheme
            .caption
            .copyWith(color: Theme.of(context).textTheme.headline1.color),
      ),
      Expanded(
        child: Text(
          sprintf(AppLocalizations.of(context).updated_at_date, [
            DateFormatter.formatDateInMili(groceryList.updatedAt,
                AppLocalizations.of(context).updated_at_format)
          ]),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.caption,
        ),
      ),
      IconButton(
        key: Key(Keys.groceryListRowShowRecipes + index.toString()),
        icon: Icon(Icons.library_books),
        tooltip: AppLocalizations.of(context).add_to_grocery_list,
        onPressed: () {
          onShowRecipes();
        },
      ),
    ];

    return InkWell(
      onTap: () {
        this.onTap();
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: titleWidgets,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: groceries,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: bottomRowItems,
            ),
          ],
        ),
      ),
    );
  }
}
