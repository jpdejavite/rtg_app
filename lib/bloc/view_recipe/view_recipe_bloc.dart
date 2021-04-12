import 'package:rtg_app/bloc/add_recipe_to_grocery_list.dart/add_recipe_to_grocery_list.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

import 'events.dart';
import 'states.dart';

class ViewRecipeBloc
    extends AddRecipeToGroceryListBloc<ViewRecipeEvents, ViewRecipeState> {
  ViewRecipeBloc(
      {GroceryListsRepository groceryListsRepository,
      RecipesRepository recipesRepository})
      : super(groceryListsRepository, recipesRepository, ViewRecipeInitState());
  @override
  Stream<ViewRecipeState> mapEventToState(ViewRecipeEvents event) async* {
    if (event is AddRecipeToGroceryListEvent) {
      SaveGroceryListResponse response = await addRecipeToGroceryList(
          event.groceryList,
          event.recipe,
          event.portions,
          event.groceryListTitle);
      yield AddedRecipeToGroceryListEvent(response: response);
    } else if (event is TryToAddRecipeToGroceryListEvent) {
      TryToAddRecipeToGroceryListResponse response =
          await tryToAddRecipeToGroceryList(
              event.recipe, event.portions, event.groceryListTitle);
      if (response.added) {
        yield AddedRecipeToGroceryListEvent(response: response.saveResponse);
      } else {
        yield ChooseGroceryListToRecipeEvent(
          collection: response.collection,
          recipe: event.recipe,
          portions: event.portions,
        );
      }
    }
  }
}
