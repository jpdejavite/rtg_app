import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'events.dart';
import 'states.dart';

class SaveGroceryListBloc
    extends Bloc<SaveGroceryListEvents, SaveGroceryListState> {
  final GroceryListsRepository groceryListsRepo;
  final RecipesRepository recipesRepository;
  SaveGroceryListBloc({this.groceryListsRepo, this.recipesRepository})
      : super(SaveGroceryListInitState());
  @override
  Stream<SaveGroceryListState> mapEventToState(
      SaveGroceryListEvents event) async* {
    if (event is ArchiveGroceryListEvent) {
      yield SaveGroceryListInitState();
      event.groceryList.updatedAt =
          CustomDateTime.current.millisecondsSinceEpoch;
      event.groceryList.status = GroceryListStatus.archived;
      SaveGroceryListResponse response =
          await groceryListsRepo.save(event.groceryList);
      yield GroceryListSaved(response);
    } else if (event is SaveGroceryListSilentlyEvent) {
      // yield SaveGroceryListInitState();
      event.groceryList.updatedAt =
          CustomDateTime.current.millisecondsSinceEpoch;
      SaveGroceryListResponse response =
          await groceryListsRepo.save(event.groceryList);
      if (response != null && response.error != null) {
        yield GroceryListSaved(response);
      }
    } else if (event is SaveGroceryListEvent) {
      yield SaveGroceryListInitState();
      event.groceryList.updatedAt =
          CustomDateTime.current.millisecondsSinceEpoch;
      SaveGroceryListResponse response =
          await groceryListsRepo.save(event.groceryList);
      yield GroceryListSaved(response);
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
