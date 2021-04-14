import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/save_grocery_list/events.dart';
import 'package:rtg_app/bloc/save_grocery_list/save_grocery_list_bloc.dart';
import 'package:rtg_app/bloc/save_grocery_list/states.dart';
import 'package:rtg_app/errors/errors.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

class MockGroceryListsRepo extends Mock implements GroceryListsRepository {}

class MockRecipesRepository extends Mock implements RecipesRepository {}

void main() {
  SaveGroceryListBloc saveGroceryListBloc;
  GroceryListsRepository groceryListsRepository;
  RecipesRepository recipesRepository;
  DateTime customTime = DateTime.parse("1969-07-20 20:18:04");

  setUp(() {
    groceryListsRepository = MockGroceryListsRepo();
    recipesRepository = MockRecipesRepository();
    CustomDateTime.customTime = customTime;

    saveGroceryListBloc = SaveGroceryListBloc(
      groceryListsRepo: groceryListsRepository,
      recipesRepository: recipesRepository,
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
    GroceryList groceryList =
        GroceryList(title: "teste 1", status: GroceryListStatus.active);
    SaveGroceryListResponse response =
        SaveGroceryListResponse(groceryList: groceryList);

    final expectedResponse = [];

    when(groceryListsRepository.save(groceryList))
        .thenAnswer((_) => Future.value(response));

    expectLater(
      saveGroceryListBloc,
      emitsInOrder(expectedResponse),
    );

    saveGroceryListBloc.add(SaveGroceryListSilentlyEvent(groceryList));
  });

  test('save grocery list silenttly with error', () {
    GroceryList groceryList =
        GroceryList(title: "teste 1", status: GroceryListStatus.active);
    SaveGroceryListResponse response = SaveGroceryListResponse(
        groceryList: groceryList, error: GenericError("test error"));

    final expectedResponse = [
      GroceryListSaved(response),
    ];

    when(groceryListsRepository.save(groceryList))
        .thenAnswer((_) => Future.value(response));

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
    GroceryList groceryList =
        GroceryList(title: "teste 1", status: GroceryListStatus.active);
    SaveGroceryListResponse response = SaveGroceryListResponse(
        groceryList: groceryList, error: GenericError("test error"));

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
      expect(groceryList.status, GroceryListStatus.active);
      expect(groceryList.updatedAt, customTime.millisecondsSinceEpoch);
    });

    saveGroceryListBloc.add(SaveGroceryListEvent(groceryList));
  });

  test('load grocery list recipes no recipes', () {
    GroceryList groceryList =
        GroceryList(title: "teste 1", status: GroceryListStatus.active);

    final expectedResponse = [
      GroceryListRecipesLoaded([]),
    ];

    expectLater(
      saveGroceryListBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(saveGroceryListBloc.state, GroceryListRecipesLoaded([]));
    });

    saveGroceryListBloc.add(LoadGroceryListRecipesEvent(groceryList));
  });

  test('load grocery list recipes with recipes', () {
    List<String> recipes = ["1"];
    GroceryList groceryList = GroceryList(title: "teste 1", recipes: recipes);

    RecipesCollection collection =
        RecipesCollection(total: 1, recipes: [Recipe(id: "asd")]);

    final expectedResponse = [
      GroceryListRecipesLoaded(collection.recipes),
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
          GroceryListRecipesLoaded(collection.recipes));
    });

    saveGroceryListBloc.add(LoadGroceryListRecipesEvent(groceryList));
  });
}
