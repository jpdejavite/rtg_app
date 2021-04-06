import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';

abstract class SaveGroceryListState extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveGroceryListInitState extends SaveGroceryListState {}

class GroceryListSaved extends SaveGroceryListState {
  final SaveGroceryListResponse response;
  GroceryListSaved(this.response);
  @override
  List<Object> get props => [response];
}

class GroceryListRecipesLoaded extends SaveGroceryListState {
  final List<Recipe> recipes;
  GroceryListRecipesLoaded(this.recipes);
  @override
  List<Object> get props => [recipes];
}
