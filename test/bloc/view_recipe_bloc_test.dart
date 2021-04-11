import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/view_recipe/events.dart';
import 'package:rtg_app/bloc/view_recipe/states.dart';
import 'package:rtg_app/bloc/view_recipe/view_recipe_bloc.dart';
import 'package:rtg_app/errors/errors.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/helper/id_generator.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/grocery_list_item.dart';
import 'package:rtg_app/model/grocery_lists_collection.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipe_ingredient.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:uuid/uuid.dart';

class MockGroceryListsRepository extends Mock
    implements GroceryListsRepository {}

class MockRecipesRepository extends Mock implements RecipesRepository {}

class MockUuid extends Mock implements Uuid {}

void main() {
  ViewRecipeBloc viewRecipeBloc;
  MockGroceryListsRepository groceryListsRepository;
  MockRecipesRepository recipesRepository;
  DateTime customTime = DateTime.parse("1969-07-20 20:18:04");

  setUp(() {
    groceryListsRepository = MockGroceryListsRepository();
    recipesRepository = MockRecipesRepository();
    viewRecipeBloc = ViewRecipeBloc(
        groceryListsRepository: groceryListsRepository,
        recipesRepository: recipesRepository);
    CustomDateTime.customTime = customTime;
    IdGenerator.mock = MockUuid();
  });

  tearDown(() {
    viewRecipeBloc?.close();
    CustomDateTime.customTime = null;
    IdGenerator.mock = null;
  });

  test('initial state is correct', () {
    expect(viewRecipeBloc.state, ViewRecipeInitState());
  });

  test('try to add recipe no grocery lists', () {
    SaveGroceryListResponse response = SaveGroceryListResponse(error: null);
    Recipe recipe = Recipe(id: '1', portions: 1, ingredients: []);
    double portions = 2;

    final expectedResponse = [
      AddedRecipeToGroceryListEvent(response: response),
    ];

    when(groceryListsRepository.fetch())
        .thenAnswer((_) => Future.value(GroceryListsCollection(total: 0)));
    when(recipesRepository.save(recipe: null))
        .thenAnswer((_) => Future.value(any));
    when(groceryListsRepository.save(any))
        .thenAnswer((_) => Future.value(response));

    expectLater(
      viewRecipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(viewRecipeBloc.state,
          AddedRecipeToGroceryListEvent(response: response));
      expect(recipe.lastUsed, customTime.millisecondsSinceEpoch);
    });

    viewRecipeBloc
        .add(TryToAddRecipeToGroceryListEvent(recipe, portions, "title"));
  });

  test('try to add recipe has grocery lists', () {
    Recipe recipe = Recipe(id: '1', ingredients: []);
    double portions = 2;
    GroceryListsCollection collection =
        GroceryListsCollection(total: 1, groceryLists: []);

    final expectedResponse = [
      ChooseGroceryListToRecipeEvent(
          collection: collection, recipe: recipe, portions: portions),
    ];

    when(groceryListsRepository.fetch())
        .thenAnswer((_) => Future.value(collection));

    expectLater(
      viewRecipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(
          viewRecipeBloc.state,
          ChooseGroceryListToRecipeEvent(
              collection: collection, recipe: recipe, portions: portions));
    });

    viewRecipeBloc
        .add(TryToAddRecipeToGroceryListEvent(recipe, portions, "title"));
  });

  test('add recipe to grocery lists', () {
    SaveGroceryListResponse response = SaveGroceryListResponse(error: null);
    RecipeIngredient ingredient =
        RecipeIngredient(name: "ingrediente 1", quantity: 1);
    Recipe recipe = Recipe(id: '1', portions: 1, ingredients: [ingredient]);
    double portions = 2;
    GroceryList groceryList = GroceryList(recipes: [], groceries: []);

    final expectedResponse = [
      AddedRecipeToGroceryListEvent(response: response),
    ];

    when(recipesRepository.save(recipe: null))
        .thenAnswer((_) => Future.value(any));
    when(groceryListsRepository.save(any))
        .thenAnswer((_) => Future.value(response));

    expectLater(
      viewRecipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(viewRecipeBloc.state,
          AddedRecipeToGroceryListEvent(response: response));
      expect(recipe.lastUsed, customTime.millisecondsSinceEpoch);

      expect(groceryList.updatedAt, customTime.millisecondsSinceEpoch);
      expect(groceryList.recipes, [recipe.id]);
      expect(groceryList.groceries, [
        GroceryListItem(
          ingredientName: ingredient.name,
          recipeIngredients: {recipe.id: 0},
        )
      ]);
    });

    viewRecipeBloc.add(
        AddRecipeToGroceryListEvent(recipe, portions, "title", groceryList));
  });

  test('add recipe to grocery lists, recipe already added', () {
    SaveGroceryListResponse response = SaveGroceryListResponse(error: null);
    RecipeIngredient ingredient =
        RecipeIngredient(name: "ingrediente 1", quantity: 1);
    Recipe recipe = Recipe(id: '1', portions: 1, ingredients: [ingredient]);
    double portions = 2;
    GroceryList groceryList = GroceryList(recipes: [recipe.id], groceries: []);

    final expectedResponse = [
      AddedRecipeToGroceryListEvent(
        response: SaveGroceryListResponse(
          error: RecipeAlreadyAddedToGroceryList(),
        ),
      ),
    ];

    when(recipesRepository.save(recipe: null))
        .thenAnswer((_) => Future.value(any));
    when(groceryListsRepository.save(any))
        .thenAnswer((_) => Future.value(response));

    expectLater(
      viewRecipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(
          viewRecipeBloc.state,
          AddedRecipeToGroceryListEvent(
            response: SaveGroceryListResponse(
              error: RecipeAlreadyAddedToGroceryList(),
            ),
          ));
      expect(recipe.lastUsed, null);

      expect(groceryList.updatedAt, null);
      expect(groceryList.recipes, [recipe.id]);
    });

    viewRecipeBloc.add(
        AddRecipeToGroceryListEvent(recipe, portions, "title", groceryList));
  });

  test('add recipe to new grocery lists', () {
    SaveGroceryListResponse response = SaveGroceryListResponse(error: null);
    RecipeIngredient ingredient =
        RecipeIngredient(name: "ingrediente 1", quantity: 1);
    Recipe recipe = Recipe(id: '1', portions: 1, ingredients: [ingredient]);
    double portions = 2;

    final expectedResponse = [
      AddedRecipeToGroceryListEvent(response: response),
    ];

    when(recipesRepository.save(recipe: null))
        .thenAnswer((_) => Future.value(any));
    when(groceryListsRepository.save(any))
        .thenAnswer((_) => Future.value(response));

    expectLater(
      viewRecipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(viewRecipeBloc.state,
          AddedRecipeToGroceryListEvent(response: response));
      expect(recipe.lastUsed, customTime.millisecondsSinceEpoch);
    });

    viewRecipeBloc
        .add(AddRecipeToGroceryListEvent(recipe, portions, "title", null));
  });
}
