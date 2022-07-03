import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/save_recipe/events.dart';
import 'package:rtg_app/bloc/save_recipe/save_recipe_bloc.dart';
import 'package:rtg_app/bloc/save_recipe/states.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipe_label.dart';
import 'package:rtg_app/model/save_recipe_label_response.dart';
import 'package:rtg_app/model/save_recipe_response.dart';
import 'package:rtg_app/repository/recipe_label_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

class MockRecipesRepo extends Mock implements RecipesRepository {}

class MocRecipeLabelRepository extends Mock implements RecipeLabelRepository {}

void main() {
  SaveRecipeBloc saveRecipeBloc;
  MockRecipesRepo recipesRepository;
  MocRecipeLabelRepository recipeLabelRepository;

  setUp(() {
    recipesRepository = MockRecipesRepo();
    recipeLabelRepository = MocRecipeLabelRepository();
    saveRecipeBloc = SaveRecipeBloc(
        recipesRepo: recipesRepository, recipeLabelRepo: recipeLabelRepository);
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

  test('save recipe with label and without error', () {
    Recipe recipe = Recipe(title: "teste 1", label: "label");
    SaveRecipeResponse recipeResponse = SaveRecipeResponse(recipe: recipe);
    SaveRecipeLabelResponse recipeLabelResponse = SaveRecipeLabelResponse();

    final expectedResponse = [
      RecipeSaved(),
    ];
    when(recipesRepository.save(recipe: recipe))
        .thenAnswer((_) => Future.value(recipeResponse));
    when(recipeLabelRepository.save(label: RecipeLabel(title: recipe.label)))
        .thenAnswer((_) => Future.value(recipeLabelResponse));

    expectLater(
      saveRecipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(saveRecipeBloc.state, RecipeSaved(response: recipeResponse));
    });

    saveRecipeBloc.add(SaveRecipeEvent(recipe: recipe));
  });

  test('save recipe with label and save label with error', () {
    Recipe recipe = Recipe(title: "teste 1", label: "label");
    Error error = UnsupportedError('not supported');

    SaveRecipeResponse recipeResponse = SaveRecipeResponse(error: error);
    SaveRecipeLabelResponse recipeLabelResponse =
        SaveRecipeLabelResponse(error: error);

    final expectedResponse = [
      RecipeSaved(),
    ];
    when(recipeLabelRepository.save(label: RecipeLabel(title: recipe.label)))
        .thenAnswer((_) => Future.value(recipeLabelResponse));

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

  test('load recipe labels', () {
    List<RecipeLabel> labels = [
      RecipeLabel(title: 'label1'),
      RecipeLabel(title: 'label2')
    ];

    final expectedResponse = [
      RecipeLabelsLoaded(labels: labels),
    ];
    when(recipeLabelRepository.getAll())
        .thenAnswer((_) => Future.value(labels));

    expectLater(
      saveRecipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(saveRecipeBloc.state, RecipeLabelsLoaded(labels: labels));
    });

    saveRecipeBloc.add(LoadRecipeLabelsEvent());
  });
}
