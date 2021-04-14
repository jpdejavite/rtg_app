import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/bloc/grocery_lists/states.dart';
import 'package:rtg_app/model/grocery_lists_collection.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

import 'events.dart';

class GroceryListsBloc extends Bloc<GroceryListsEvents, GroceryListsListState> {
  final GroceryListsRepository groceryListsRepository;
  final RecipesRepository recipesRepository;

  GroceryListsCollection _groceryListssCollection =
      GroceryListsCollection(groceryLists: []);
  GroceryListsBloc({this.groceryListsRepository, this.recipesRepository})
      : super(GroceryListsInitState());
  @override
  Stream<GroceryListsListState> mapEventToState(
      GroceryListsEvents event) async* {
    if (event is StartFetchGroceryListsEvent) {
      _groceryListssCollection = await groceryListsRepository.fetch(
        limit: event.searchParams.limit,
        offset: event.searchParams.offset,
      );
      yield GroceryListsLoaded(_groceryListssCollection);
    } else if (event is FetchGroceryListsEvent) {
      GroceryListsCollection groceryListssCollection =
          await groceryListsRepository.fetch(
        limit: event.searchParams.limit,
        offset: event.searchParams.offset,
      );

      _groceryListssCollection.groceryLists
          .addAll(groceryListssCollection.groceryLists);
      _groceryListssCollection.total = groceryListssCollection.total;
      yield GroceryListsLoaded(GroceryListsCollection(
        groceryLists: _groceryListssCollection.groceryLists,
        total: _groceryListssCollection.total,
      ));
    } else if (event is LoadGroceryListRecipesEvent) {
      if (event.groceryList.recipes != null &&
          event.groceryList.recipes.length > 0) {
        RecipesCollection collection = await recipesRepository.search(
            searchParams: SearchRecipesParams(
                ids: event.groceryList.recipes,
                limit: event.groceryList.recipes.length));
        yield GroceryListRecipesLoaded(collection.recipes);
      } else {
        yield GroceryListRecipesLoaded([]);
      }
    }
  }
}
