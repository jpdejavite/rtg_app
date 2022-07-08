import 'package:rtg_app/bloc/add_recipe_to_grocery_list/add_recipe_to_grocery_list.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:rtg_app/bloc/recipes/events.dart';
import 'package:rtg_app/bloc/recipes/states.dart';

import '../../repository/recipe_label_repository.dart';

class RecipesBloc
    extends AddRecipeToGroceryListBloc<RecipesEvents, RecipesState> {
  RecipesCollection _recipesCollection = RecipesCollection(recipes: []);
  RecipeLabelRepository recipeLabelRepository;
  RecipesBloc(
      {GroceryListsRepository groceryListsRepository,
      RecipesRepository recipesRepository,
      RecipeLabelRepository recipeLabelRepository})
      : recipeLabelRepository = recipeLabelRepository,
        super(groceryListsRepository, recipesRepository, RecipesInitState());

  @override
  Stream<RecipesState> mapEventToState(RecipesEvents event) async* {
    if (event is StartFetchRecipesEvent) {
      _recipesCollection =
          await recipesRepository.search(searchParams: event.searchParams);
      _recipesCollection.recipes.forEach((element) {});
      yield RecipesLoaded(
          recipesCollection: _recipesCollection,
          labels: await recipeLabelRepository.getAll());
    } else if (event is FetchRecipesEvent) {
      RecipesCollection recipesCollection =
          await recipesRepository.search(searchParams: event.searchParams);

      _recipesCollection.recipes.addAll(recipesCollection.recipes);
      _recipesCollection.total = recipesCollection.total;
      yield RecipesLoaded(
          recipesCollection: RecipesCollection(
            recipes: _recipesCollection.recipes,
            total: _recipesCollection.total,
          ),
          labels: await recipeLabelRepository.getAll());
    } else if (event is AddRecipeToGroceryListEvent) {
      SaveGroceryListResponse response = await addRecipeToGroceryList(
        event.groceryList,
        event.recipe,
        event.portions,
        event.groceryListTitle,
      );
      yield AddedRecipeToGroceryListEvent(
          response: response,
          recipesCollection: RecipesCollection(
            recipes: _recipesCollection.recipes,
            total: _recipesCollection.total,
          ));
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
            recipesCollection: RecipesCollection(
              recipes: _recipesCollection.recipes,
              total: _recipesCollection.total,
            ));
      }
    }
  }
}
