import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/recipe.dart';

abstract class ViewRecipeEvents {}

class TryToAddRecipeToGroceryListEvent extends ViewRecipeEvents {
  final Recipe recipe;
  final int portions;
  TryToAddRecipeToGroceryListEvent(this.recipe, this.portions);
}

class AddRecipeToGroceryListEvent extends ViewRecipeEvents {
  final Recipe recipe;
  final GroceryList groceryList;
  final int portions;
  AddRecipeToGroceryListEvent(this.recipe, this.portions, this.groceryList);
}
