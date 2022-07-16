import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/grocery_list_item.dart';
import 'package:rtg_app/model/grocery_list_item_market_section.dart';
import 'package:rtg_app/model/market_section.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
import 'package:rtg_app/repository/grocery_list_item_market_section_repository.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import '../../repository/market_section_repository.dart';
import 'events.dart';
import 'states.dart';

class SaveGroceryListBloc
    extends Bloc<SaveGroceryListEvents, SaveGroceryListState> {
  final GroceryListsRepository groceryListsRepo;
  final RecipesRepository recipesRepository;
  final MarketSectionRepository marketSectionRepository;
  final GroceryListItemMarketSectionRepository
      groceryListItemMarketSectionRepository;
  SaveGroceryListBloc({
    this.groceryListsRepo,
    this.recipesRepository,
    this.marketSectionRepository,
    this.groceryListItemMarketSectionRepository,
  }) : super(SaveGroceryListInitState());
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
      await updateMarketSections(event.groceryList);
      SaveGroceryListResponse response =
          await groceryListsRepo.save(event.groceryList);
      if (response != null && response.error != null) {
        yield GroceryListSaved(response);
      }
    } else if (event is SaveGroceryListEvent) {
      yield SaveGroceryListInitState();
      event.groceryList.updatedAt =
          CustomDateTime.current.millisecondsSinceEpoch;
      await updateMarketSections(event.groceryList);
      SaveGroceryListResponse response =
          await groceryListsRepo.save(event.groceryList);
      yield GroceryListSaved(response);
    } else if (event is LoadGroceryListRecipesEvent) {
      List<MarketSection> marketSections =
          await marketSectionRepository.getAll();
      if (event.groceryList.recipes != null &&
          event.groceryList.recipes.length > 0) {
        RecipesCollection collection = await recipesRepository.search(
            searchParams: SearchRecipesParams(
                ids: event.groceryList.recipes,
                limit: event.groceryList.recipes.length));
        yield InitalDataLoaded(collection.recipes, marketSections);
      } else {
        yield InitalDataLoaded([], marketSections);
      }
    }
  }

  Future<void> updateMarketSections(GroceryList groceryList) async {
    for (int i = 0; i < (groceryList.groceries ?? []).length; i++) {
      final GroceryListItem item = groceryList.groceries[i];
      if (item.hasSelectedMarketSection()) {
        await groceryListItemMarketSectionRepository
            .save(GroceryListItemMarketSection(
          groceryListItemName: item.ingredientName,
          marketSectionId: item.marketSectionId,
        ));
      } else {
        GroceryListItemMarketSection savedMarketSection =
            await groceryListItemMarketSectionRepository
                .get(item.ingredientName);
        if (savedMarketSection != null) {
          item.marketSectionId = savedMarketSection.marketSectionId;
        }
      }
    }
  }
}
