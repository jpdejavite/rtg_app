import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/save_recipe/events.dart';
import 'package:rtg_app/bloc/save_recipe/save_recipe_bloc.dart';
import 'package:rtg_app/bloc/save_recipe/states.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/save_recipe_response.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

class MockRecipesRepo extends Mock implements RecipesRepository {}

void main() {
  SaveRecipeBloc saveRecipeBloc;
  MockRecipesRepo recipesRepository;

  setUp(() {
    recipesRepository = MockRecipesRepo();
    saveRecipeBloc = SaveRecipeBloc(recipesRepo: recipesRepository);
  });

  tearDown(() {
    saveRecipeBloc?.close();
  });

  test('initial state is correct', () {
    expect(saveRecipeBloc.state, SaveRecipeInitState());
  });

  test('save recipe without error', () {
    Recipe recipe = Recipe(title: "teste 1");
    SaveRecipeResponse recipeResponse = SaveRecipeResponse(recipe: recipe);

    final expectedResponse = [
      SavingRecipe(),
      RecipeSaved(),
    ];
    when(recipesRepository.save(recipe: recipe))
        .thenAnswer((_) => Future.value(recipeResponse));

    expectLater(
      saveRecipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(saveRecipeBloc.state, RecipeSaved(response: recipeResponse));
    });

    saveRecipeBloc.add(SaveRecipeEvent(recipe: recipe));
  });

  test('save recipe with error', () {
    Recipe recipe = Recipe(title: "teste 1");
    Error error = UnsupportedError('not supported');

    SaveRecipeResponse recipeResponse = SaveRecipeResponse(error: error);

    final expectedResponse = [
      SavingRecipe(),
      RecipeSaved(response: recipeResponse),
    ];
    when(recipesRepository.save(recipe: recipe))
        .thenAnswer((_) => Future.value(recipeResponse));

    expectLater(
      saveRecipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(saveRecipeBloc.state, RecipeSaved(response: recipeResponse));
    });

    saveRecipeBloc.add(SaveRecipeEvent(recipe: recipe));
  });
}
