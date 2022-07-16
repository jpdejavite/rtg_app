import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/save_grocery_list/events.dart';
import 'package:rtg_app/bloc/save_grocery_list/save_grocery_list_bloc.dart';
import 'package:rtg_app/bloc/save_grocery_list/states.dart';
import 'package:rtg_app/errors/errors.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/grocery_list_item.dart';
import 'package:rtg_app/model/grocery_list_item_market_section.dart';
import 'package:rtg_app/model/market_section.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
import 'package:rtg_app/repository/grocery_list_item_market_section_repository.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/market_section_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

class MockGroceryListsRepo extends Mock implements GroceryListsRepository {}

class MockRecipesRepository extends Mock implements RecipesRepository {}

class MockMarketSectionRepository extends Mock
    implements MarketSectionRepository {}

class MockGroceryListItemMarketSectionRepository extends Mock
    implements GroceryListItemMarketSectionRepository {}

void main() {
  SaveGroceryListBloc saveGroceryListBloc;
  GroceryListsRepository groceryListsRepository;
  RecipesRepository recipesRepository;
  MarketSectionRepository marketSectionRepository;
  GroceryListItemMarketSectionRepository groceryListItemMarketSectionRepository;
  DateTime customTime = DateTime.parse("1969-07-20 20:18:04");

  setUp(() {
    groceryListsRepository = MockGroceryListsRepo();
    recipesRepository = MockRecipesRepository();
    marketSectionRepository = MockMarketSectionRepository();
    groceryListItemMarketSectionRepository =
        MockGroceryListItemMarketSectionRepository();
    CustomDateTime.customTime = customTime;

    saveGroceryListBloc = SaveGroceryListBloc(
      groceryListsRepo: groceryListsRepository,
      recipesRepository: recipesRepository,
      marketSectionRepository: marketSectionRepository,
      groceryListItemMarketSectionRepository:
          groceryListItemMarketSectionRepository,
    );
  });

  tearDown(() {
    CustomDateTime.customTime = null;

    saveGroceryListBloc?.close();
  });

  test('initial state is correct', () {
    expect(saveGroceryListBloc.state, SaveGroceryListInitState());
  });

  test('archive grocery list event', () {
    GroceryList groceryList =
        GroceryList(title: "teste 1", status: GroceryListStatus.active);
    SaveGroceryListResponse response =
        SaveGroceryListResponse(groceryList: groceryList);

    final expectedResponse = [
      SaveGroceryListInitState(),
      GroceryListSaved(response),
    ];

    when(groceryListsRepository.save(groceryList))
        .thenAnswer((_) => Future.value(response));

    expectLater(
      saveGroceryListBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(saveGroceryListBloc.state, GroceryListSaved(response));
      expect(groceryList.status, GroceryListStatus.archived);
      expect(groceryList.updatedAt, customTime.millisecondsSinceEpoch);
    });

    saveGroceryListBloc.add(ArchiveGroceryListEvent(groceryList));
  });

  test('save grocery list silenttly no error', () {
    String name1 = 'name-1';
    String name2 = 'name-2';
    String name3 = 'name-3';
    String marketSectionId = 'market-section-id';
    GroceryListItemMarketSection groceryListItemMarketSection =
        GroceryListItemMarketSection(
            groceryListItemName: name2, marketSectionId: marketSectionId);
    GroceryList groceryList = GroceryList(
        title: "teste 1",
        status: GroceryListStatus.active,
        groceries: [
          GroceryListItem(ingredientName: name1),
          GroceryListItem(ingredientName: name2),
          GroceryListItem(
              ingredientName: name3,
              marketSectionId: marketSectionId,
              selectedMarketSection: true),
        ]);
    SaveGroceryListResponse response =
        SaveGroceryListResponse(groceryList: groceryList);

    final expectedResponse = [];

    when(groceryListsRepository.save(groceryList)).thenAnswer((arg) {
      GroceryList editedGroceryList = arg.positionalArguments[0];
      expect(editedGroceryList.groceries[0].marketSectionId, null);
      expect(editedGroceryList.groceries[1].marketSectionId, marketSectionId);
      expect(editedGroceryList.groceries[2].marketSectionId, marketSectionId);
      return Future.value(response);
    });
    when(groceryListItemMarketSectionRepository.get(name1))
        .thenAnswer((_) => Future.value(null));
    when(groceryListItemMarketSectionRepository.get(name2))
        .thenAnswer((_) => Future.value(groceryListItemMarketSection));
    when(groceryListItemMarketSectionRepository
        .save(GroceryListItemMarketSection(
      groceryListItemName: name3,
      marketSectionId: marketSectionId,
    ))).thenAnswer((arg) => Future.value(null));

    expectLater(
      saveGroceryListBloc,
      emitsInOrder(expectedResponse),
    );

    saveGroceryListBloc.add(SaveGroceryListSilentlyEvent(groceryList));
  });

  test('save grocery list silenttly with error', () {
    String name1 = 'name-1';
    String name2 = 'name-2';
    String name3 = 'name-3';
    String marketSectionId = 'market-section-id';
    GroceryListItemMarketSection groceryListItemMarketSection =
        GroceryListItemMarketSection(
            groceryListItemName: name2, marketSectionId: marketSectionId);
    GroceryList groceryList = GroceryList(
        title: "teste 1",
        status: GroceryListStatus.active,
        groceries: [
          GroceryListItem(ingredientName: name1),
          GroceryListItem(ingredientName: name2),
          GroceryListItem(
              ingredientName: name3,
              marketSectionId: marketSectionId,
              selectedMarketSection: true),
        ]);
    SaveGroceryListResponse response = SaveGroceryListResponse(
        groceryList: groceryList, error: GenericError("test error"));

    final expectedResponse = [
      GroceryListSaved(response),
    ];

    when(groceryListsRepository.save(groceryList)).thenAnswer((arg) {
      GroceryList editedGroceryList = arg.positionalArguments[0];
      expect(editedGroceryList.groceries[0].marketSectionId, null);
      expect(editedGroceryList.groceries[1].marketSectionId, marketSectionId);
      expect(editedGroceryList.groceries[2].marketSectionId, marketSectionId);
      return Future.value(response);
    });
    when(groceryListItemMarketSectionRepository.get(name1))
        .thenAnswer((_) => Future.value(null));
    when(groceryListItemMarketSectionRepository.get(name2))
        .thenAnswer((_) => Future.value(groceryListItemMarketSection));
    when(groceryListItemMarketSectionRepository
        .save(GroceryListItemMarketSection(
      groceryListItemName: name3,
      marketSectionId: marketSectionId,
    ))).thenAnswer((arg) => Future.value(null));

    expectLater(
      saveGroceryListBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(saveGroceryListBloc.state, GroceryListSaved(response));
      expect(groceryList.status, GroceryListStatus.active);
      expect(groceryList.updatedAt, customTime.millisecondsSinceEpoch);
    });

    saveGroceryListBloc.add(SaveGroceryListSilentlyEvent(groceryList));
  });

  test('save grocery list', () {
    String name1 = 'name-1';
    String name2 = 'name-2';
    String name3 = 'name-3';
    String marketSectionId = 'market-section-id';
    GroceryListItemMarketSection groceryListItemMarketSection =
        GroceryListItemMarketSection(
            groceryListItemName: name2, marketSectionId: marketSectionId);
    GroceryList groceryList = GroceryList(
        title: "teste 1",
        status: GroceryListStatus.active,
        groceries: [
          GroceryListItem(ingredientName: name1),
          GroceryListItem(ingredientName: name2),
          GroceryListItem(
              ingredientName: name3,
              marketSectionId: marketSectionId,
              selectedMarketSection: true),
        ]);
    SaveGroceryListResponse response = SaveGroceryListResponse(
        groceryList: groceryList, error: GenericError("test error"));

    final expectedResponse = [
      SaveGroceryListInitState(),
      GroceryListSaved(response),
    ];

    when(groceryListsRepository.save(groceryList)).thenAnswer((arg) {
      GroceryList editedGroceryList = arg.positionalArguments[0];
      expect(editedGroceryList.groceries[0].marketSectionId, null);
      expect(editedGroceryList.groceries[1].marketSectionId, marketSectionId);
      expect(editedGroceryList.groceries[2].marketSectionId, marketSectionId);
      return Future.value(response);
    });
    when(groceryListItemMarketSectionRepository.get(name1))
        .thenAnswer((_) => Future.value(null));
    when(groceryListItemMarketSectionRepository.get(name2))
        .thenAnswer((_) => Future.value(groceryListItemMarketSection));
    when(groceryListItemMarketSectionRepository
        .save(GroceryListItemMarketSection(
      groceryListItemName: name3,
      marketSectionId: marketSectionId,
    ))).thenAnswer((arg) => Future.value(null));

    expectLater(
      saveGroceryListBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(saveGroceryListBloc.state, GroceryListSaved(response));
      expect(groceryList.status, GroceryListStatus.active);
      expect(groceryList.updatedAt, customTime.millisecondsSinceEpoch);
    });

    saveGroceryListBloc.add(SaveGroceryListEvent(groceryList));
  });

  test('load grocery list recipes no recipes', () {
    GroceryList groceryList =
        GroceryList(title: "teste 1", status: GroceryListStatus.active);

    List<MarketSection> marketSections = [
      MarketSection(id: 'market-1', groceryListOrder: 0),
      MarketSection(id: 'market-2', groceryListOrder: 1),
      MarketSection(id: 'market-3', groceryListOrder: 2)
    ];

    when(marketSectionRepository.getAll())
        .thenAnswer((_) => Future.value(marketSections));

    final expectedResponse = [
      InitalDataLoaded([], marketSections),
    ];

    expectLater(
      saveGroceryListBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(saveGroceryListBloc.state, InitalDataLoaded([], marketSections));
    });

    saveGroceryListBloc.add(LoadGroceryListRecipesEvent(groceryList));
  });

  test('load grocery list recipes with recipes', () {
    List<String> recipes = ["1"];
    GroceryList groceryList = GroceryList(title: "teste 1", recipes: recipes);

    RecipesCollection collection =
        RecipesCollection(total: 1, recipes: [Recipe(id: "asd")]);

    List<MarketSection> marketSections = [
      MarketSection(id: 'market-1', groceryListOrder: 0),
      MarketSection(id: 'market-2', groceryListOrder: 1),
      MarketSection(id: 'market-3', groceryListOrder: 2)
    ];

    when(marketSectionRepository.getAll())
        .thenAnswer((_) => Future.value(marketSections));

    final expectedResponse = [
      InitalDataLoaded(collection.recipes, marketSections),
    ];

    when(recipesRepository.search(
            searchParams:
                SearchRecipesParams(ids: recipes, limit: recipes.length)))
        .thenAnswer((_) => Future.value(collection));
    expectLater(
      saveGroceryListBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(saveGroceryListBloc.state,
          InitalDataLoaded(collection.recipes, marketSections));
    });

    saveGroceryListBloc.add(LoadGroceryListRecipesEvent(groceryList));
  });
}
