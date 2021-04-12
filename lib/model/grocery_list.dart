import 'package:flutter/material.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/helper/date_formatter.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:sembast/sembast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprintf/sprintf.dart';

import 'grocery_list_item.dart';

enum GroceryListStatus { active, archived }

List<GroceryList> groceryListsFromRecords(
        List<RecordSnapshot<int, Map<String, Object>>> records) =>
    List<GroceryList>.from(
        records.map((r) => GroceryList.fromRecord(r.key, r.value)));

class GroceryList {
  GroceryList({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.groceries,
    this.recipes,
    this.status,
  });

  String id;
  int createdAt;
  int updatedAt;
  String title;
  List<GroceryListItem> groceries;
  List<String> recipes;
  GroceryListStatus status;

  bool hasId() {
    return this.id != null && this.id != "" && this.id != "0";
  }

  static newGroceryListWithRecipe(
      Recipe recipe, String title, double portions) {
    return GroceryList(
      createdAt: CustomDateTime.current.millisecondsSinceEpoch,
      updatedAt: CustomDateTime.current.millisecondsSinceEpoch,
      status: GroceryListStatus.active,
      title: title,
      recipes: [recipe.id],
      groceries: GroceryListItem.addRecipeToItems(recipe, [], portions),
    );
  }

  static String getGroceryListDefaultTitle(BuildContext context) {
    DateTime now = DateTime.now();
    return sprintf(AppLocalizations.of(context).grocery_list_title, [
      DateFormatter.weekOfMonth(now),
      DateFormatter.dateMonth(now, context)
    ]);
  }

  factory GroceryList.fromRecord(int id, Map<String, Object> record) {
    List<String> recipes = [];
    if (record["recipes"] is List<Object>) {
      (record["recipes"] as List<Object>).forEach((el) {
        recipes.add(el.toString());
      });
    }
    return GroceryList(
      id: id.toString(),
      createdAt: record["createdAt"],
      updatedAt: record["updatedAt"],
      title: record["title"],
      recipes: recipes,
      status: GroceryListStatus.values[record["status"] as int],
      groceries: GroceryListItem.fromObject(record["groceries"]),
    );
  }

  Object toRecord() {
    return {
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'title': this.title,
      'recipes': this.recipes,
      'status': this.status.index,
      'groceries': GroceryListItem.toRecords(this.groceries),
    };
  }
}
