import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/api/services.dart';
import 'package:rtg_app/bloc/recipes/bloc.dart';
import 'package:rtg_app/bloc/recipes/events.dart';
import 'package:rtg_app/bloc/recipes/states.dart';
import 'package:rtg_app/model/recipe_list.dart';

class MockRecipesRepo extends Mock implements RecipesRepo {}

void main() {
  RecipesBloc recipeBloc;
  MockRecipesRepo recipesRepo;

  setUp(() {
    recipesRepo = MockRecipesRepo();
    recipeBloc = RecipesBloc(recipesRepo: recipesRepo);
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

    final expectedResponse = [
      RecipesLoading(),
      RecipesLoaded(recipes: recipes),
    ];
    when(recipesRepo.getRecipeList(""))
        .thenAnswer((_) => Future.value(recipes));

    expectLater(
      recipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(recipeBloc.state, RecipesLoaded(recipes: recipes));
    });

    recipeBloc.add(FetchRecipesEvent(lastId: ""));
  });

  test('fetch more recipes', () {
    List<Recipe> recipes = [
      Recipe(title: "teste 1"),
      Recipe(title: "teste 2"),
    ];
    List<Recipe> moreRecipes = [
      Recipe(title: "teste 3"),
      Recipe(title: "teste 4"),
    ];
    List<Recipe> totalRecipes = [];
    totalRecipes.addAll(recipes);
    totalRecipes.addAll(moreRecipes);

    final expectedResponse = [
      RecipesLoading(),
      RecipesLoaded(recipes: recipes),
    ];

    final expectedMoreResponse = [
      RecipesLoadingMore(recipes: recipes),
      RecipesLoaded(recipes: totalRecipes),
    ];
    when(recipesRepo.getRecipeList(""))
        .thenAnswer((_) => Future.value(recipes));
    when(recipesRepo.getRecipeList("1"))
        .thenAnswer((_) => Future.value(moreRecipes));

    expectLater(
      recipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(recipeBloc.state, RecipesLoaded(recipes: recipes));
      // load more recipes
      recipeBloc.add(FetchRecipesEvent(lastId: "1"));
      expectLater(
        recipeBloc,
        emitsInOrder(expectedMoreResponse),
      ).then((_) {
        expect(recipeBloc.state, RecipesLoaded(recipes: totalRecipes));
      });
    });

    recipeBloc.add(FetchRecipesEvent(lastId: ""));
  });
}
