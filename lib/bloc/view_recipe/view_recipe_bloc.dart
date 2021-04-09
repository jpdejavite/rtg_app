import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/errors/errors.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/grocery_list_item.dart';
import 'package:rtg_app/model/grocery_lists_collection.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

import 'events.dart';
import 'states.dart';

class ViewRecipeBloc extends Bloc<ViewRecipeEvents, ViewRecipeState> {
  final GroceryListsRepository groceryListsRepository;
  final RecipesRepository recipesRepository;

  ViewRecipeBloc({this.groceryListsRepository, this.recipesRepository})
      : super(ViewRecipeInitState());
  @override
  Stream<ViewRecipeState> mapEventToState(ViewRecipeEvents event) async* {
    if (event is AddRecipeToGroceryListEvent) {
      if (event.groceryList != null) {
        if (event.groceryList.recipes.contains(event.recipe.id)) {
          yield AddedRecipeToGroceryListEvent(
            response: SaveGroceryListResponse(
              error: RecipeAlreadyAddedToGroceryList(),
            ),
          );
          return;
        }

        event.recipe.lastUsed = CustomDateTime.current.millisecondsSinceEpoch;
        await recipesRepository.save(recipe: event.recipe);

        event.groceryList.updatedAt =
            CustomDateTime.current.millisecondsSinceEpoch;
        event.groceryList.recipes.add(event.recipe.id);
        event.groceryList.groceries = GroceryListItem.addRecipeToItems(
            event.recipe, event.groceryList.groceries, event.portions);

        SaveGroceryListResponse response =
            await groceryListsRepository.save(event.groceryList);
        yield AddedRecipeToGroceryListEvent(response: response);
        return;
      }

      event.recipe.lastUsed = CustomDateTime.current.millisecondsSinceEpoch;
      await recipesRepository.save(recipe: event.recipe);

      SaveGroceryListResponse response = await groceryListsRepository.save(
          GroceryList.newGroceryListWithRecipe(
              event.recipe, event.groceryListTitle, event.portions));
      yield AddedRecipeToGroceryListEvent(response: response);
    } else if (event is TryToAddRecipeToGroceryListEvent) {
      GroceryListsCollection collection = await groceryListsRepository.fetch();
      if (collection.total == 0) {
        event.recipe.lastUsed = CustomDateTime.current.millisecondsSinceEpoch;
        await recipesRepository.save(recipe: event.recipe);
        SaveGroceryListResponse response = await groceryListsRepository.save(
            GroceryList.newGroceryListWithRecipe(
                event.recipe, event.groceryListTitle, event.portions));
        yield AddedRecipeToGroceryListEvent(response: response);
        return;
      }

      yield ChooseGroceryListToRecipeEvent(
        collection: collection,
        recipe: event.recipe,
        portions: event.portions,
      );
    }
  }
}
