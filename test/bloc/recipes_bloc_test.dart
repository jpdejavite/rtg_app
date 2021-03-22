import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/recipes/recipes_bloc.dart';
import 'package:rtg_app/bloc/recipes/events.dart';
import 'package:rtg_app/bloc/recipes/states.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

class MockRecipesRepo extends Mock implements RecipesRepository {}

void main() {
  RecipesBloc recipeBloc;
  MockRecipesRepo recipesRepository;

  setUp(() {
    recipesRepository = MockRecipesRepo();
    recipeBloc = RecipesBloc(recipesRepo: recipesRepository);
  });

  tearDown(() {
    recipeBloc?.close();
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
      RecipesLoading(),
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
    List<Recipe> recipes = [
      Recipe(title: "teste 1"),
      Recipe(title: "teste 2"),
    ];
    RecipesCollection recipesCollection =
        RecipesCollection(recipes: recipes, total: 4);
    List<Recipe> moreRecipes = [
      Recipe(title: "teste 3"),
      Recipe(title: "teste 4"),
    ];
    RecipesCollection moreRecipesCollection =
        RecipesCollection(recipes: moreRecipes, total: 4);
    List<Recipe> totalRecipes = [];
    totalRecipes.addAll(recipes);
    totalRecipes.addAll(moreRecipes);
    RecipesCollection toalRecipesCollection =
        RecipesCollection(recipes: totalRecipes, total: 4);

    final expectedResponse = [
      RecipesLoading(),
      RecipesLoaded(recipesCollection: recipesCollection),
    ];

    final expectedMoreResponse = [
      RecipesLoadingMore(recipesCollection: recipesCollection),
      RecipesLoaded(recipesCollection: toalRecipesCollection),
    ];
    when(recipesRepository.search())
        .thenAnswer((_) => Future.value(recipesCollection));
    when(recipesRepository.search(searchParams: SearchRecipesParams(offset: 2)))
        .thenAnswer((_) => Future.value(moreRecipesCollection));

    expectLater(
      recipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(recipeBloc.state,
          RecipesLoaded(recipesCollection: recipesCollection));
      // load more recipes
      recipeBloc
          .add(FetchRecipesEvent(searchParams: SearchRecipesParams(offset: 2)));
      expectLater(
        recipeBloc,
        emitsInOrder(expectedMoreResponse),
      ).then((_) {
        expect(recipeBloc.state,
            RecipesLoaded(recipesCollection: toalRecipesCollection));
      });
    });

    recipeBloc.add(StartFetchRecipesEvent());
  });
}
