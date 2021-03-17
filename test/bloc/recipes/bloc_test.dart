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
    final expectedResponse = [
      RecipesLoading(),
      RecipesLoaded(),
    ];

    List<Recipe> recipes = [
      Recipe(title: "teste 1"),
      Recipe(title: "teste 2"),
    ];

    when(recipesRepo.getRecipeList()).thenAnswer((_) => Future.value(recipes));

    expectLater(
      recipeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(recipeBloc.state, RecipesLoaded(recipes: recipes));
    });

    recipeBloc.add(RecipesEvents.fetchRecipes);
  });
}
