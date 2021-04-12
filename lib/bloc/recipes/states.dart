import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/grocery_lists_collection.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';

abstract class RecipesState extends Equatable {
  @override
  List<Object> get props => [];
}

class RecipesInitState extends RecipesState {}

class RecipesLoaded extends RecipesState {
  final RecipesCollection recipesCollection;
  RecipesLoaded({this.recipesCollection});
  @override
  List<Object> get props => [recipesCollection];
}

class RecipesListError extends RecipesState {
  final error;
  RecipesListError({this.error});
}

class AddedRecipeToGroceryListEvent extends RecipesLoaded {
  final SaveGroceryListResponse response;
  AddedRecipeToGroceryListEvent(
      {this.response, RecipesCollection recipesCollection})
      : super(recipesCollection: recipesCollection);

  @override
  List<Object> get props => [response];
}

class ChooseGroceryListToRecipeEvent extends RecipesLoaded {
  final GroceryListsCollection collection;
  final Recipe recipe;
  final double portions;
  ChooseGroceryListToRecipeEvent(
      {this.collection,
      this.recipe,
      this.portions,
      RecipesCollection recipesCollection})
      : super(recipesCollection: recipesCollection);

  @override
  List<Object> get props => [collection, recipe, portions];
}
