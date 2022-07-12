import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:rtg_app/helper/diacritics.dart';
import 'package:rtg_app/helper/id_generator.dart';
import 'package:rtg_app/helper/ingredient_measure_converter.dart';
import 'package:rtg_app/helper/ingredient_parser.dart';
import 'package:rtg_app/model/market_section.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:edit_distance/edit_distance.dart';
import 'ingredient_measure.dart';

class GroceryListItem {
  String id;
  double quantity;
  bool checked;
  // key => recipeID, value => ingredient index
  Map<String, int> recipeIngredients;
  IngredientMeasureId measureId;
  String ingredientName;
  String marketSectionId;

  GroceryListItem({
    this.id,
    this.quantity,
    this.checked,
    this.recipeIngredients,
    this.measureId,
    this.ingredientName,
    this.marketSectionId,
  });

  static newEmptyGroceryListItem() {
    return GroceryListItem(
      id: IdGenerator.id(),
      checked: false,
      ingredientName: '',
      recipeIngredients: Map<String, int>(),
    );
  }

  @override
  String toString() {
    return '$id $quantity $checked $recipeIngredients $measureId $ingredientName';
  }

  String getName(BuildContext context) {
    if (ingredientName == null) {
      return '';
    }

    if (measureId == null || quantity == null) {
      return ingredientName;
    }

    String quantityToShow = quantity.toString();
    if (quantity % 1 == 0) {
      quantityToShow = quantity.toInt().toString();
    } else {
      quantityToShow = isMeasureDisplaiedInRawFractions()
          ? quantity.toString()
          : quantity.toMixedFraction().toString();
    }

    if (measureId == IngredientMeasureId.unit) {
      return '$quantityToShow $ingredientName';
    }

    return '$quantityToShow ${IngredientMeasure.i18nMeasure(measureId, quantity, context)} $ingredientName';
  }

  bool isMeasureDisplaiedInRawFractions() {
    return measureId == IngredientMeasureId.pint ||
        measureId == IngredientMeasureId.pint ||
        measureId == IngredientMeasureId.ounce ||
        measureId == IngredientMeasureId.pound ||
        measureId == IngredientMeasureId.grams ||
        measureId == IngredientMeasureId.kilograms ||
        measureId == IngredientMeasureId.milliliters ||
        measureId == IngredientMeasureId.liter;
  }

  static List<GroceryListItem> fromObject(Object object) {
    if (object == null || !(object is List<Object>)) {
      return [];
    }

    List<GroceryListItem> ingredients = [];

    List<Object> objects = object;
    objects.forEach((e) {
      if (e is Map<String, Object>) {
        ingredients.add(GroceryListItem.fromMap(e));
      }
    });

    return ingredients;
  }

  factory GroceryListItem.fromMap(Map<String, Object> record) {
    Map<String, int> recipeIngredients = Map<String, int>();
    if (record['recipeIngredients'] is Map<String, Object>) {
      (record['recipeIngredients'] as Map<String, Object>)
          .forEach((key, index) {
        recipeIngredients[key] = index;
      });
    }

    return GroceryListItem(
      id: record['id'],
      quantity: record['quantity'],
      checked: record['checked'],
      recipeIngredients: recipeIngredients,
      measureId: record["measureId"] == null
          ? null
          : IngredientMeasureId.values[record["measureId"] as int],
      ingredientName: record['ingredientName'],
      marketSectionId: record['marketSectionId'],
    );
  }

  static Object toRecords(List<GroceryListItem> items) {
    if (items == null || items.length == 0) {
      return null;
    }

    List<Object> objects = [];
    items.forEach((i) {
      objects.add({
        'id': i.id,
        'quantity': i.quantity,
        'checked': i.checked,
        'recipeIngredients': i.recipeIngredients,
        'measureId': i.measureId == null ? null : i.measureId.index,
        'ingredientName': i.ingredientName,
        'marketSectionId': i.marketSectionId,
      });
    });

    return objects;
  }

  static List<GroceryListItem> addRecipeToItems(
      Recipe recipe, List<GroceryListItem> items, double portions) {
    portions = portions / recipe.portions;
    JaroWinkler jw = JaroWinkler();
    List<GroceryListItem> itemsToAdd = [];
    recipe.ingredients.asMap().forEach((index, ingredient) {
      String ingredientName =
          Diacritics.removeDiacritics(ingredient.name).toLowerCase();
      int matchIndex = -1;
      items.asMap().forEach((i, item) {
        String itemName =
            Diacritics.removeDiacritics(item.ingredientName).toLowerCase();
        if (1 - jw.normalizedDistance(itemName, ingredientName) >= 0.95) {
          matchIndex = i;
        }
      });

      if (matchIndex != -1) {
        IngredientMeasureConversionItem conversion =
            IngredientMeasureConverter.findConvertion(
                ingredient.measureId, items[matchIndex].measureId);
        if (conversion != null) {
          IngredientMeasureConversionResult result =
              IngredientMeasureConverter.convert(
            measure: items[matchIndex].measureId,
            quantity: items[matchIndex].quantity,
            conversion: conversion,
            quantityToAdd: ingredient.quantity,
            measureToAdd: ingredient.measureId,
            portions: portions,
          );

          items[matchIndex].quantity = result.quantity;
          items[matchIndex].measureId = result.measure;
          items[matchIndex].recipeIngredients[recipe.id] = index;
          items[matchIndex].ingredientName = ingredient.name;
          return;
        }
      }
      itemsToAdd.add(GroceryListItem(
        id: IdGenerator.id(),
        quantity: ingredient.quantity * portions,
        checked: false,
        recipeIngredients: {recipe.id: index},
        measureId: ingredient.measureId,
        ingredientName: ingredient.name,
      ));
    });

    if (itemsToAdd.length > 0) {
      items.insertAll(0, itemsToAdd);
    }

    return items;
  }

  static List<GroceryListItem> orderItemsByMarketSection(
      List<GroceryListItem> items, List<MarketSection> marketSections) {
    Map<String, int> marketSectionOrderMap = Map();
    marketSections.forEach((marketSection) {
      marketSectionOrderMap[marketSection.id] = marketSection.groceryListOrder;
    });

    List<GroceryListItem> uncheckedItems =
        items.where((item) => item.checked == null || !item.checked).toList();
    List<GroceryListItem> checkedItems =
        items.where((item) => item.checked != null && item.checked).toList();

    List<GroceryListItem> sortedItems = [...uncheckedItems];
    sortedItems.sort((item1, item2) {
      final int maxInt = 4294967296;
      int orderItem1 = maxInt;
      if (item1.marketSectionId != null) {
        orderItem1 = marketSectionOrderMap[item1.marketSectionId];
      }
      int orderItem2 = maxInt;
      if (item2.marketSectionId != null) {
        orderItem2 = marketSectionOrderMap[item2.marketSectionId];
      }

      return Comparable.compare(orderItem1, orderItem2);
    });
    return [...sortedItems, ...checkedItems];
  }

  static GroceryListItem fromInput(String originalText) {
    IngredientParseResult result = IngredientParser.fromInput(originalText);
    return GroceryListItem(
      ingredientName: result.name,
      quantity: result.hasParsedQuantity ? result.quantity : null,
      measureId: result.measureId,
    );
  }

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is GroceryListItem)) {
      return false;
    }

    return id == other.id;
  }

  @override
  int get hashCode => super.hashCode;
}
