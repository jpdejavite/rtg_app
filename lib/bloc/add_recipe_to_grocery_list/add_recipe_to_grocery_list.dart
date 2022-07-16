import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/errors/errors.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/grocery_list_item.dart';
import 'package:rtg_app/model/grocery_list_item_market_section.dart';
import 'package:rtg_app/model/grocery_lists_collection.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';
import 'package:rtg_app/repository/grocery_list_item_market_section_repository.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

import 'dart:async';

abstract class AddRecipeToGroceryListBloc<Event, State>
    extends Bloc<Event, State> {
  final GroceryListsRepository groceryListsRepository;
  final RecipesRepository recipesRepository;
  final GroceryListItemMarketSectionRepository
      groceryListItemMarketSectionRepository;

  AddRecipeToGroceryListBloc(
      this.groceryListsRepository,
      this.recipesRepository,
      this.groceryListItemMarketSectionRepository,
      State initialState)
      : super(initialState);

  Future<SaveGroceryListResponse> addRecipeToGroceryList(
      GroceryList groceryList,
      Recipe recipe,
      double portions,
      String groceryListTitle) async {
    if (groceryList != null) {
      if (groceryList.recipes.contains(recipe.id)) {
        return SaveGroceryListResponse(
          error: RecipeAlreadyAddedToGroceryList(),
        );
      }

      recipe.lastUsed = CustomDateTime.current.millisecondsSinceEpoch;
      recipe.updatedAt = CustomDateTime.current.millisecondsSinceEpoch;
      await recipesRepository.save(recipe: recipe);

      groceryList.updatedAt = CustomDateTime.current.millisecondsSinceEpoch;
      groceryList.recipes.add(recipe.id);
      if (groceryList.recipesPortions == null) {
        groceryList.recipesPortions = {recipe.id: portions};
      } else {
        groceryList.recipesPortions[recipe.id] = portions;
      }
      groceryList.groceries = GroceryListItem.addRecipeToItems(
          recipe, groceryList.groceries, portions);
      updateMarketSections(groceryList);

      return await groceryListsRepository.save(groceryList);
    }

    recipe.lastUsed = CustomDateTime.current.millisecondsSinceEpoch;
    recipe.updatedAt = CustomDateTime.current.millisecondsSinceEpoch;
    await recipesRepository.save(recipe: recipe);

    return await groceryListsRepository.save(
        GroceryList.newGroceryListWithRecipe(
            recipe, groceryListTitle, portions));
  }

  Future<TryToAddRecipeToGroceryListResponse> tryToAddRecipeToGroceryList(
      Recipe recipe, double portions, String groceryListTitle) async {
    GroceryListsCollection collection = await groceryListsRepository.fetch();
    if (collection.total == 0) {
      recipe.lastUsed = CustomDateTime.current.millisecondsSinceEpoch;
      recipe.updatedAt = CustomDateTime.current.millisecondsSinceEpoch;
      await recipesRepository.save(recipe: recipe);
      SaveGroceryListResponse response = await groceryListsRepository.save(
          GroceryList.newGroceryListWithRecipe(
              recipe, groceryListTitle, portions));
      return TryToAddRecipeToGroceryListResponse(true, null, response);
    }

    return TryToAddRecipeToGroceryListResponse(false, collection, null);
  }

  Future<void> updateMarketSections(GroceryList groceryList) async {
    for (int i = 0; i < (groceryList.groceries ?? []).length; i++) {
      final GroceryListItem item = groceryList.groceries[i];
      if (item.hasSelectedMarketSection()) {
        await groceryListItemMarketSectionRepository
            .save(GroceryListItemMarketSection(
          groceryListItemName: item.ingredientName,
          marketSectionId: item.marketSectionId,
        ));
      } else {
        GroceryListItemMarketSection savedMarketSection =
            await groceryListItemMarketSectionRepository
                .get(item.ingredientName);
        if (savedMarketSection != null) {
          item.marketSectionId = savedMarketSection.marketSectionId;
        }
      }
    }
  }
}

class TryToAddRecipeToGroceryListResponse {
  final GroceryListsCollection collection;
  final SaveGroceryListResponse saveResponse;
  final bool added;
  TryToAddRecipeToGroceryListResponse(
      this.added, this.collection, this.saveResponse);
}
