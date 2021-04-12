import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/search_recipes_params.dart';

abstract class RecipesEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchRecipesEvent extends RecipesEvents {
  final SearchRecipesParams searchParams;
  FetchRecipesEvent({this.searchParams});
  @override
  List<Object> get props => [searchParams];
}

class StartFetchRecipesEvent extends FetchRecipesEvent {
  final SearchRecipesParams searchParams;
  StartFetchRecipesEvent({this.searchParams});
  @override
  List<Object> get props => [searchParams];
}

class TryToAddRecipeToGroceryListEvent extends RecipesEvents {
  final Recipe recipe;
  final double portions;
  final String groceryListTitle;
  TryToAddRecipeToGroceryListEvent(
      this.recipe, this.portions, this.groceryListTitle);
}

class AddRecipeToGroceryListEvent extends TryToAddRecipeToGroceryListEvent {
  final GroceryList groceryList;
  AddRecipeToGroceryListEvent(
      recipe, portions, groceryListTitle, this.groceryList)
      : super(recipe, portions, groceryListTitle);
}
