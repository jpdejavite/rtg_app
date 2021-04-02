import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/grocery_lists/events.dart';
import 'package:rtg_app/bloc/grocery_lists/grocery_lists_bloc.dart';
import 'package:rtg_app/bloc/grocery_lists/states.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/grocery_lists_collection.dart';
import 'package:rtg_app/model/search_grocery_lists_params.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';

class MockGroceryListsRepo extends Mock implements GroceryListsRepository {}

void main() {
  GroceryListsBloc groceryListBloc;
  MockGroceryListsRepo groceryListsRepository;

  setUp(() {
    groceryListsRepository = MockGroceryListsRepo();
    groceryListBloc =
        GroceryListsBloc(groceryListsRepository: groceryListsRepository);
  });

  tearDown(() {
    groceryListBloc?.close();
  });

  test('initial state is correct', () {
    expect(groceryListBloc.state, GroceryListsInitState());
  });

  test('fetch groceryLists', () {
    List<GroceryList> groceryLists = [
      GroceryList(title: "teste 1"),
      GroceryList(title: "teste 2"),
    ];
    GroceryListsCollection groceryListsCollection =
        GroceryListsCollection(groceryLists: groceryLists, total: 2);
    SearchGroceryListsParams searchParams =
        SearchGroceryListsParams(limit: 20, offset: 0);

    final expectedResponse = [
      GroceryListsLoaded(groceryListsCollection),
    ];
    when(groceryListsRepository.fetch(
            limit: searchParams.limit, offset: searchParams.offset))
        .thenAnswer((_) => Future.value(groceryListsCollection));

    expectLater(
      groceryListBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(groceryListBloc.state, GroceryListsLoaded(groceryListsCollection));
    });

    groceryListBloc.add(StartFetchGroceryListsEvent(searchParams));
  });

  test('fetch more groceryLists', () {
    List<GroceryList> moreGroceryLists = [
      GroceryList(title: "teste 3"),
      GroceryList(title: "teste 4"),
    ];
    GroceryListsCollection moreGroceryListsCollection =
        GroceryListsCollection(groceryLists: moreGroceryLists, total: 2);
    SearchGroceryListsParams searchParams =
        SearchGroceryListsParams(limit: 20, offset: 0);
    final expectedMoreResponse = [
      GroceryListsLoaded(moreGroceryListsCollection),
    ];

    when(groceryListsRepository.fetch(
            limit: searchParams.limit, offset: searchParams.offset))
        .thenAnswer((_) => Future.value(moreGroceryListsCollection));

    expectLater(
      groceryListBloc,
      emitsInOrder(expectedMoreResponse),
    ).then((_) {
      expect(groceryListBloc.state is GroceryListsLoaded, true);
    });

    groceryListBloc.add(FetchGroceryListsEvent(searchParams));
  });
}
