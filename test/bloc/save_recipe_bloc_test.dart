import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/recipes/recipes_bloc.dart';
import 'package:rtg_app/bloc/recipes/events.dart';
import 'package:rtg_app/bloc/recipes/states.dart';
import 'package:rtg_app/bloc/save_recipe/events.dart';
import 'package:rtg_app/bloc/save_recipe/save_recipe_bloc.dart';
import 'package:rtg_app/bloc/save_recipe/states.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
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

    final expectedResponse = [
      SavingRecipe(),
      RecipeSaved(),
    ];
    when(recipesRepository.save(recipe: recipe))
        .thenAnswer((_) => Future.value(null));

    expectLater(
      saveRecipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(saveRecipeBloc.state, RecipeSaved());
    });

    saveRecipeBloc.add(SaveRecipeEvent(recipe: recipe));
  });

  test('save recipe with error', () {
    Recipe recipe = Recipe(title: "teste 1");
    Error error = UnsupportedError('not supported');

    final expectedResponse = [
      SavingRecipe(),
      RecipeSaved(error: error),
    ];
    when(recipesRepository.save(recipe: recipe))
        .thenAnswer((_) => Future.value(error));

    expectLater(
      saveRecipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(saveRecipeBloc.state, RecipeSaved(error: error));
    });

    saveRecipeBloc.add(SaveRecipeEvent(recipe: recipe));
  });
}
