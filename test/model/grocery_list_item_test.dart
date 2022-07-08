import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rtg_app/helper/id_generator.dart';
import 'package:rtg_app/model/grocery_list_item.dart';
import 'package:rtg_app/model/ingredient_measure.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipe_ingredient.dart';

import 'package:uuid/uuid.dart';

class MockUuid extends Mock implements Uuid {}

void main() {
  Uuid mockUuid;
  setUp(() {
    mockUuid = MockUuid();
    IdGenerator.mock = mockUuid;
  });

  tearDown(() {
    IdGenerator.mock = null;
  });

  test('add recipe to empty list item', () {
    List<RecipeIngredient> ingredients = [
      RecipeIngredient.fromInput('1 colher de chá de acúcar', null),
      RecipeIngredient.fromInput('3.33 ml de água', null),
    ];
    String recipeId = 'recipe-id-1';
    Recipe recipe = Recipe(id: recipeId, portions: 1, ingredients: ingredients);
    List<GroceryListItem> items = [];
    double portions = 3;

    List<String> ids = ['id-1', 'id-2'];

    when(mockUuid.v4()).thenAnswer((_) => ids.removeAt(0));

    List<GroceryListItem> groceries =
        GroceryListItem.addRecipeToItems(recipe, items, portions);

    expect(groceries[0].id, 'id-1');
    expect(groceries[0].quantity, 3.0);
    expect(groceries[0].checked, false);
    expect(groceries[0].recipeIngredients, {recipeId: 0});
    expect(groceries[0].measureId, IngredientMeasureId.teaSpoon);
    expect(groceries[0].ingredientName, 'acúcar');

    expect(groceries[1].id, 'id-2');
    expect(groceries[1].quantity, 9.99);
    expect(groceries[1].checked, false);
    expect(groceries[1].recipeIngredients, {recipeId: 1});
    expect(groceries[1].measureId, IngredientMeasureId.milliliters);
    expect(groceries[1].ingredientName, 'água');
  });

  test('add recipe to empty list item calculation proportional portion', () {
    List<RecipeIngredient> ingredients = [
      RecipeIngredient.fromInput('3 kg de farinha', null),
      RecipeIngredient.fromInput('300 ml de água', null),
    ];
    String recipeId = 'recipe-id-1';
    Recipe recipe =
        Recipe(id: recipeId, portions: 30, ingredients: ingredients);
    List<GroceryListItem> items = [];
    double portions = 10;

    List<String> ids = ['id-1', 'id-2'];

    when(mockUuid.v4()).thenAnswer((_) => ids.removeAt(0));

    List<GroceryListItem> groceries =
        GroceryListItem.addRecipeToItems(recipe, items, portions);

    expect(groceries[0].id, 'id-1');
    expect(groceries[0].quantity, 1.0);
    expect(groceries[0].checked, false);
    expect(groceries[0].recipeIngredients, {recipeId: 0});
    expect(groceries[0].measureId, IngredientMeasureId.kilograms);
    expect(groceries[0].ingredientName, 'farinha');

    expect(groceries[1].id, 'id-2');
    expect(groceries[1].quantity, 100);
    expect(groceries[1].checked, false);
    expect(groceries[1].recipeIngredients, {recipeId: 1});
    expect(groceries[1].measureId, IngredientMeasureId.milliliters);
    expect(groceries[1].ingredientName, 'água');
  });

  test('add recipe to list item with no matches', () {
    List<RecipeIngredient> ingredients = [
      RecipeIngredient.fromInput('1 tomate', null),
      RecipeIngredient.fromInput('3.33 ml de água', null),
    ];
    String recipeId = 'recipe-id-2';
    Recipe recipe = Recipe(id: recipeId, portions: 1, ingredients: ingredients);

    GroceryListItem item1 = GroceryListItem(
      id: 'id-1',
      quantity: 1.1,
      checked: true,
      recipeIngredients: {'recipe-id-2': 0},
      measureId: IngredientMeasureId.liter,
      ingredientName: 'tomate italiano',
    );
    GroceryListItem item2 = GroceryListItem(
      id: 'id-1',
      quantity: 500,
      checked: true,
      recipeIngredients: {'recipe-id-2': 1},
      measureId: IngredientMeasureId.milliliters,
      ingredientName: 'água de coco',
    );
    List<GroceryListItem> items = [item1, item2];
    double portions = 3;

    List<String> ids = ['id-3', 'id-4'];

    when(mockUuid.v4()).thenAnswer((_) => ids.removeAt(0));

    List<GroceryListItem> groceries =
        GroceryListItem.addRecipeToItems(recipe, items, portions);

    expect(groceries[0].id, 'id-3');
    expect(groceries[0].quantity, 3.0);
    expect(groceries[0].checked, false);
    expect(groceries[0].recipeIngredients, {recipeId: 0});
    expect(groceries[0].measureId, IngredientMeasureId.unit);
    expect(groceries[0].ingredientName, 'tomate');

    expect(groceries[1].id, 'id-4');
    expect(groceries[1].quantity, 9.99);
    expect(groceries[1].checked, false);
    expect(groceries[1].recipeIngredients, {recipeId: 1});
    expect(groceries[1].measureId, IngredientMeasureId.milliliters);
    expect(groceries[1].ingredientName, 'água');

    expect(groceries[2].id, item1.id);
    expect(groceries[2].quantity, item1.quantity);
    expect(groceries[2].checked, item1.checked);
    expect(groceries[2].recipeIngredients, item1.recipeIngredients);
    expect(groceries[2].measureId, item1.measureId);
    expect(groceries[2].ingredientName, item1.ingredientName);

    expect(groceries[3].id, item2.id);
    expect(groceries[3].quantity, item2.quantity);
    expect(groceries[3].checked, item2.checked);
    expect(groceries[3].recipeIngredients, item2.recipeIngredients);
    expect(groceries[3].measureId, item2.measureId);
    expect(groceries[3].ingredientName, item2.ingredientName);
  });

  test('add recipe to list item with no conversion', () {
    List<RecipeIngredient> ingredients = [
      RecipeIngredient.fromInput('1 tomate italian', null),
      RecipeIngredient.fromInput('3.33 ml de água', null),
    ];
    String recipeId = 'recipe-id-2';
    Recipe recipe = Recipe(id: recipeId, portions: 1, ingredients: ingredients);

    GroceryListItem item1 = GroceryListItem(
      id: 'id-1',
      quantity: 1.1,
      checked: true,
      recipeIngredients: {'recipe-id-2': 0},
      measureId: IngredientMeasureId.liter,
      ingredientName: 'tomate italiano',
    );
    GroceryListItem item2 = GroceryListItem(
      id: 'id-1',
      quantity: 500,
      checked: true,
      recipeIngredients: {'recipe-id-2': 1},
      measureId: IngredientMeasureId.milliliters,
      ingredientName: 'água de coco',
    );
    List<GroceryListItem> items = [item1, item2];
    double portions = 3;

    List<String> ids = ['id-3', 'id-4'];

    when(mockUuid.v4()).thenAnswer((_) => ids.removeAt(0));

    List<GroceryListItem> groceries =
        GroceryListItem.addRecipeToItems(recipe, items, portions);

    expect(groceries[0].id, 'id-3');
    expect(groceries[0].quantity, 3.0);
    expect(groceries[0].checked, false);
    expect(groceries[0].recipeIngredients, {recipeId: 0});
    expect(groceries[0].measureId, IngredientMeasureId.unit);
    expect(groceries[0].ingredientName, 'tomate italian');

    expect(groceries[1].id, 'id-4');
    expect(groceries[1].quantity, 9.99);
    expect(groceries[1].checked, false);
    expect(groceries[1].recipeIngredients, {recipeId: 1});
    expect(groceries[1].measureId, IngredientMeasureId.milliliters);
    expect(groceries[1].ingredientName, 'água');

    expect(groceries[2].id, item1.id);
    expect(groceries[2].quantity, item1.quantity);
    expect(groceries[2].checked, item1.checked);
    expect(groceries[2].recipeIngredients, item1.recipeIngredients);
    expect(groceries[2].measureId, item1.measureId);
    expect(groceries[2].ingredientName, item1.ingredientName);

    expect(groceries[3].id, item2.id);
    expect(groceries[3].quantity, item2.quantity);
    expect(groceries[3].checked, item2.checked);
    expect(groceries[3].recipeIngredients, item2.recipeIngredients);
    expect(groceries[3].measureId, item2.measureId);
    expect(groceries[3].ingredientName, item2.ingredientName);
  });

  test('add recipe to list item with conversions', () {
    List<RecipeIngredient> ingredients = [
      RecipeIngredient.fromInput('1 tomate italian', null),
      RecipeIngredient.fromInput('1 l de água de coco', null),
      RecipeIngredient.fromInput('2 colheres sopa de oleo', null),
    ];
    String recipeId = 'recipe-id-2';
    Recipe recipe = Recipe(id: recipeId, portions: 1, ingredients: ingredients);

    GroceryListItem item1 = GroceryListItem(
      id: 'id-1',
      quantity: 1.1,
      checked: true,
      recipeIngredients: {'recipe-id-2': 0},
      measureId: IngredientMeasureId.unit,
      ingredientName: 'tomate italiano',
    );
    GroceryListItem item2 = GroceryListItem(
      id: 'id-1',
      quantity: 500,
      checked: true,
      recipeIngredients: {'recipe-id-2': 1},
      measureId: IngredientMeasureId.milliliters,
      ingredientName: 'ága de coco',
    );
    List<GroceryListItem> items = [item1, item2];
    double portions = 2;

    List<String> ids = ['id-3'];

    when(mockUuid.v4()).thenAnswer((_) => ids.removeAt(0));

    List<GroceryListItem> groceries =
        GroceryListItem.addRecipeToItems(recipe, items, portions);

    expect(groceries[0].id, 'id-3');
    expect(groceries[0].quantity, 4.0);
    expect(groceries[0].checked, false);
    expect(groceries[0].recipeIngredients, {recipeId: 2});
    expect(groceries[0].measureId, IngredientMeasureId.tableSpoon);
    expect(groceries[0].ingredientName, 'oleo');

    expect(groceries[1].id, item1.id);
    expect(groceries[1].quantity, 3.1);
    expect(groceries[1].checked, item1.checked);
    expect(groceries[1].recipeIngredients, {'recipe-id-2': 0, recipeId: 0});
    expect(groceries[1].measureId, item1.measureId);
    expect(groceries[1].ingredientName, 'tomate italian');

    expect(groceries[2].id, item2.id);
    expect(groceries[2].quantity, 2.5);
    expect(groceries[2].checked, item2.checked);
    expect(groceries[2].recipeIngredients, {'recipe-id-2': 1, recipeId: 1});
    expect(groceries[2].measureId, IngredientMeasureId.liter);
    expect(groceries[2].ingredientName, 'água de coco');
  });

  test('get name null ingredient name', () {
    expect(GroceryListItem().getName(null), '');
  });

  test('get name null measureId', () {
    expect(
        GroceryListItem(
          ingredientName: 'ingrediente',
        ).getName(null),
        'ingrediente');
  });

  test('get name null quantity', () {
    expect(
        GroceryListItem(
          ingredientName: 'ingrediente',
          measureId: IngredientMeasureId.unit,
        ).getName(null),
        'ingrediente');
  });

  test('get name measure unit', () {
    expect(
        GroceryListItem(
          ingredientName: 'ingrediente',
          measureId: IngredientMeasureId.unit,
          quantity: 2,
        ).getName(null),
        '2 ingrediente');
  });

  test('get name measure coffe spoon', () {
    expect(
        GroceryListItem(
          ingredientName: 'ingrediente',
          measureId: IngredientMeasureId.coffeSpoon,
          quantity: 2,
        ).getName(null),
        '2 1 ingrediente');
  });

  test('get name quantity as mixed fraction', () {
    expect(
        GroceryListItem(
          ingredientName: 'ingrediente',
          measureId: IngredientMeasureId.coffeSpoon,
          quantity: 2.75,
        ).getName(null),
        '2 3/4 1 ingrediente');
  });

  test('get name quantity as raw fraction', () {
    expect(
        GroceryListItem(
          ingredientName: 'ingrediente',
          measureId: IngredientMeasureId.kilograms,
          quantity: 2.75,
        ).getName(null),
        '2.75 12 ingrediente');
  });

  test('fromInput has NOT parsed quantity', () {
    expect(
        GroceryListItem.fromInput("colher    de café de   cúrcuma"),
        GroceryListItem(
          ingredientName: "colher de café de cúrcuma",
          quantity: null,
          measureId: IngredientMeasureId.coffeSpoon,
        ));
  });

  test('fromInput has parsed quantity', () {
    expect(
        GroceryListItem.fromInput("2 1/2 colher    de café de   cúrcuma"),
        GroceryListItem(
          ingredientName: "cúrcuma",
          quantity: 2.5,
          measureId: IngredientMeasureId.coffeSpoon,
        ));
  });
}
