import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/grocery_lists_collection.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';

abstract class ViewRecipeState extends Equatable {
  @override
  List<Object> get props => [];
}

class ViewRecipeInitState extends ViewRecipeState {}

class AddedRecipeToGroceryListEvent extends ViewRecipeState {
  final SaveGroceryListResponse response;
  AddedRecipeToGroceryListEvent({this.response});

  @override
  List<Object> get props => [response];
}

class ChooseGroceryListToRecipeEvent extends ViewRecipeState {
  final GroceryListsCollection collection;
  final Recipe recipe;
  final int portions;
  ChooseGroceryListToRecipeEvent({this.collection, this.recipe, this.portions});

  @override
  List<Object> get props => [collection, recipe, portions];
}
