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
      RecipeIngredient.fromInput('1 colher de chá de acúcar'),
      RecipeIngredient.fromInput('3.33 ml de água'),
    ];
    String recipeId = 'recipe-id-1';
    Recipe recipe = Recipe(id: recipeId, ingredients: ingredients);
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

  test('add recipe to list item with no matches', () {
    List<RecipeIngredient> ingredients = [
      RecipeIngredient.fromInput('1 tomate'),
      RecipeIngredient.fromInput('3.33 ml de água'),
    ];
    String recipeId = 'recipe-id-2';
    Recipe recipe = Recipe(id: recipeId, ingredients: ingredients);

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

    expect(groceries[0].id, item1.id);
    expect(groceries[0].quantity, item1.quantity);
    expect(groceries[0].checked, item1.checked);
    expect(groceries[0].recipeIngredients, item1.recipeIngredients);
    expect(groceries[0].measureId, item1.measureId);
    expect(groceries[0].ingredientName, item1.ingredientName);

    expect(groceries[1].id, item2.id);
    expect(groceries[1].quantity, item2.quantity);
    expect(groceries[1].checked, item2.checked);
    expect(groceries[1].recipeIngredients, item2.recipeIngredients);
    expect(groceries[1].measureId, item2.measureId);
    expect(groceries[1].ingredientName, item2.ingredientName);

    expect(groceries[2].id, 'id-3');
    expect(groceries[2].quantity, 3.0);
    expect(groceries[2].checked, false);
    expect(groceries[2].recipeIngredients, {recipeId: 0});
    expect(groceries[2].measureId, IngredientMeasureId.unit);
    expect(groceries[2].ingredientName, 'tomate');

    expect(groceries[3].id, 'id-4');
    expect(groceries[3].quantity, 9.99);
    expect(groceries[3].checked, false);
    expect(groceries[3].recipeIngredients, {recipeId: 1});
    expect(groceries[3].measureId, IngredientMeasureId.milliliters);
    expect(groceries[3].ingredientName, 'água');
  });

  test('add recipe to list item with no conversion', () {
    List<RecipeIngredient> ingredients = [
      RecipeIngredient.fromInput('1 tomate italian'),
      RecipeIngredient.fromInput('3.33 ml de água'),
    ];
    String recipeId = 'recipe-id-2';
    Recipe recipe = Recipe(id: recipeId, ingredients: ingredients);

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

    expect(groceries[0].id, item1.id);
    expect(groceries[0].quantity, item1.quantity);
    expect(groceries[0].checked, item1.checked);
    expect(groceries[0].recipeIngredients, item1.recipeIngredients);
    expect(groceries[0].measureId, item1.measureId);
    expect(groceries[0].ingredientName, item1.ingredientName);

    expect(groceries[1].id, item2.id);
    expect(groceries[1].quantity, item2.quantity);
    expect(groceries[1].checked, item2.checked);
    expect(groceries[1].recipeIngredients, item2.recipeIngredients);
    expect(groceries[1].measureId, item2.measureId);
    expect(groceries[1].ingredientName, item2.ingredientName);

    expect(groceries[2].id, 'id-3');
    expect(groceries[2].quantity, 3.0);
    expect(groceries[2].checked, false);
    expect(groceries[2].recipeIngredients, {recipeId: 0});
    expect(groceries[2].measureId, IngredientMeasureId.unit);
    expect(groceries[2].ingredientName, 'tomate italian');

    expect(groceries[3].id, 'id-4');
    expect(groceries[3].quantity, 9.99);
    expect(groceries[3].checked, false);
    expect(groceries[3].recipeIngredients, {recipeId: 1});
    expect(groceries[3].measureId, IngredientMeasureId.milliliters);
    expect(groceries[3].ingredientName, 'água');
  });

  test('add recipe to list item with conversions', () {
    List<RecipeIngredient> ingredients = [
      RecipeIngredient.fromInput('1 tomate italian'),
      RecipeIngredient.fromInput('1 l de água de coco'),
      RecipeIngredient.fromInput('2 colheres sopa de oleo'),
    ];
    String recipeId = 'recipe-id-2';
    Recipe recipe = Recipe(id: recipeId, ingredients: ingredients);

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

    expect(groceries[0].id, item1.id);
    expect(groceries[0].quantity, 3.1);
    expect(groceries[0].checked, item1.checked);
    expect(groceries[0].recipeIngredients, {'recipe-id-2': 0, recipeId: 0});
    expect(groceries[0].measureId, item1.measureId);
    expect(groceries[0].ingredientName, 'tomate italian');

    expect(groceries[1].id, item2.id);
    expect(groceries[1].quantity, 2.5);
    expect(groceries[1].checked, item2.checked);
    expect(groceries[1].recipeIngredients, {'recipe-id-2': 1, recipeId: 1});
    expect(groceries[1].measureId, IngredientMeasureId.liter);
    expect(groceries[1].ingredientName, 'água de coco');

    expect(groceries[2].id, 'id-3');
    expect(groceries[2].quantity, 4.0);
    expect(groceries[2].checked, false);
    expect(groceries[2].recipeIngredients, {recipeId: 2});
    expect(groceries[2].measureId, IngredientMeasureId.tableSpoon);
    expect(groceries[2].ingredientName, 'oleo');
  });
}
