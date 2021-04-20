import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/recipes/recipes_bloc.dart';
import 'package:rtg_app/bloc/recipes/events.dart';
import 'package:rtg_app/bloc/recipes/states.dart';
import 'package:rtg_app/errors/errors.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/helper/id_generator.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/grocery_list_item.dart';
import 'package:rtg_app/model/grocery_lists_collection.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipe_ingredient.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:uuid/uuid.dart';

class MockGroceryListsRepository extends Mock
    implements GroceryListsRepository {}

class MockRecipesRepo extends Mock implements RecipesRepository {}

class MockUuid extends Mock implements Uuid {}

void main() {
  RecipesBloc recipeBloc;
  MockGroceryListsRepository groceryListsRepository;
  MockRecipesRepo recipesRepository;
  DateTime customTime = DateTime.parse("1969-07-20 20:18:04");

  setUp(() {
    recipesRepository = MockRecipesRepo();
    groceryListsRepository = MockGroceryListsRepository();
    CustomDateTime.customTime = customTime;
    IdGenerator.mock = MockUuid();

    recipeBloc = RecipesBloc(
      recipesRepository: recipesRepository,
      groceryListsRepository: groceryListsRepository,
    );
  });

  tearDown(() {
    recipeBloc?.close();
    CustomDateTime.customTime = null;
    IdGenerator.mock = null;
  });

  test('initial state is correct', () {
    expect(recipeBloc.state, RecipesInitState());
  });

  test('fetch recipes', () {
    List<Recipe> recipes = [
      Recipe(title: "teste 1"),
      Recipe(title: "teste 2"),
    ];
    RecipesCollection recipesCollection =
        RecipesCollection(recipes: recipes, total: 2);

    final expectedResponse = [
      RecipesLoaded(recipesCollection: recipesCollection),
    ];
    when(recipesRepository.search(searchParams: null))
        .thenAnswer((_) => Future.value(recipesCollection));

    expectLater(
      recipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(recipeBloc.state,
          RecipesLoaded(recipesCollection: recipesCollection));
    });

    recipeBloc.add(StartFetchRecipesEvent());
  });

  test('fetch more recipes', () {
    List<Recipe> moreRecipes = [
      Recipe(title: "teste 3"),
      Recipe(title: "teste 4"),
    ];
    RecipesCollection moreRecipesCollection =
        RecipesCollection(recipes: moreRecipes, total: 2);
    SearchRecipesParams searchParams = SearchRecipesParams(offset: 2);
    final expectedMoreResponse = [
      isNotNull,
    ];

    when(recipesRepository.search(searchParams: searchParams))
        .thenAnswer((_) => Future.value(moreRecipesCollection));

    expectLater(
      recipeBloc,
      emitsInOrder(expectedMoreResponse),
    ).then((_) {
      expect(recipeBloc.state is RecipesLoaded, true);

      RecipesLoaded state = (recipeBloc.state as RecipesLoaded);
      expect(state.recipesCollection.recipes.length,
          moreRecipesCollection.recipes.length);
      expect(state.recipesCollection.recipes[0].id,
          moreRecipesCollection.recipes[0].id);
      expect(state.recipesCollection.recipes[1].id,
          moreRecipesCollection.recipes[1].id);
    });

    recipeBloc.add(FetchRecipesEvent(searchParams: searchParams));
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
      recipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(
          recipeBloc.state, AddedRecipeToGroceryListEvent(response: response));
      expect(recipe.lastUsed, customTime.millisecondsSinceEpoch);
      expect(recipe.updatedAt, customTime.millisecondsSinceEpoch);
    });

    recipeBloc.add(TryToAddRecipeToGroceryListEvent(recipe, portions, "title"));
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
      recipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(
          recipeBloc.state,
          ChooseGroceryListToRecipeEvent(
              collection: collection, recipe: recipe, portions: portions));
    });

    recipeBloc.add(TryToAddRecipeToGroceryListEvent(recipe, portions, "title"));
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
      recipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(
          recipeBloc.state, AddedRecipeToGroceryListEvent(response: response));
      expect(recipe.lastUsed, customTime.millisecondsSinceEpoch);
      expect(recipe.updatedAt, customTime.millisecondsSinceEpoch);

      expect(groceryList.updatedAt, customTime.millisecondsSinceEpoch);
      expect(groceryList.recipes, [recipe.id]);
      expect(groceryList.recipesPortions, {recipe.id: portions});
      expect(groceryList.groceries, [
        GroceryListItem(
          ingredientName: ingredient.name,
          recipeIngredients: {recipe.id: 0},
        )
      ]);
    });

    recipeBloc.add(
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
      recipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(
          recipeBloc.state,
          AddedRecipeToGroceryListEvent(
            response: SaveGroceryListResponse(
              error: RecipeAlreadyAddedToGroceryList(),
            ),
          ));
      expect(recipe.lastUsed, null);
      expect(recipe.updatedAt, null);

      expect(groceryList.updatedAt, null);
      expect(groceryList.recipes, [recipe.id]);
    });

    recipeBloc.add(
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
      recipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(
          recipeBloc.state, AddedRecipeToGroceryListEvent(response: response));
      expect(recipe.lastUsed, customTime.millisecondsSinceEpoch);
      expect(recipe.updatedAt, customTime.millisecondsSinceEpoch);
    });

    recipeBloc
        .add(AddRecipeToGroceryListEvent(recipe, portions, "title", null));
  });
}
