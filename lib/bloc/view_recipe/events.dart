import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/recipe.dart';

abstract class ViewRecipeEvents {}

class TryToAddRecipeToGroceryListEvent extends ViewRecipeEvents {
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
