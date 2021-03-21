import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/recipes/recipes_bloc.dart';
import 'package:rtg_app/bloc/recipes/events.dart';
import 'package:rtg_app/bloc/recipes/states.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

class MockRecipesRepo extends Mock implements RecipesRepository {}

void main() {
  // TODO: Fix unit tests
  // RecipesBloc recipeBloc;
  // MockRecipesRepo recipesRepository;

  // setUp(() {
  //   recipesRepository = MockRecipesRepo();
  //   recipeBloc = RecipesBloc(recipesRepo: recipesRepository);
  // });

  // tearDown(() {
  //   recipeBloc?.close();
  // });

  // test('initial state is correct', () {
  //   expect(recipeBloc.state, RecipesInitState());
  // });

  // test('fetch recipes', () {
  //   List<Recipe> recipes = [
  //     Recipe(title: "teste 1"),
  //     Recipe(title: "teste 2"),
  //   ];

  //   final expectedResponse = [
  //     RecipesLoading(),
  //     RecipesLoaded(recipes: recipes),
  //   ];
  //   when(recipesRepository.search(lastRecipe: null))
  //       .thenAnswer((_) => Future.value(recipes));

  //   expectLater(
  //     recipeBloc,
  //     emitsInOrder(expectedResponse),
  //   ).then((_) {
  //     expect(recipeBloc.state, RecipesLoaded(recipes: recipes));
  //   });

  //   recipeBloc.add(FetchRecipesEvent());
  // });

  // test('fetch more recipes', () {
  //   List<Recipe> recipes = [
  //     Recipe(title: "teste 1"),
  //     Recipe(title: "teste 2"),
  //   ];
  //   List<Recipe> moreRecipes = [
  //     Recipe(title: "teste 3"),
  //     Recipe(title: "teste 4"),
  //   ];
  //   List<Recipe> totalRecipes = [];
  //   totalRecipes.addAll(recipes);
  //   totalRecipes.addAll(moreRecipes);

  //   final expectedResponse = [
  //     RecipesLoading(),
  //     RecipesLoaded(recipes: recipes),
  //   ];

  //   final expectedMoreResponse = [
  //     RecipesLoadingMore(recipes: recipes),
  //     RecipesLoaded(recipes: totalRecipes),
  //   ];
  //   when(recipesRepository.search(lastRecipe: null))
  //       .thenAnswer((_) => Future.value(recipes));
  //   when(recipesRepository.search(lastRecipe: recipes[1]))
  //       .thenAnswer((_) => Future.value(moreRecipes));

  //   expectLater(
  //     recipeBloc,
  //     emitsInOrder(expectedResponse),
  //   ).then((_) {
  //     expect(recipeBloc.state, RecipesLoaded(recipes: recipes));
  //     // load more recipes
  //     recipeBloc.add(FetchRecipesEvent(lastRecipe: recipes[1]));
  //     expectLater(
  //       recipeBloc,
  //       emitsInOrder(expectedMoreResponse),
  //     ).then((_) {
  //       expect(recipeBloc.state, RecipesLoaded(recipes: totalRecipes));
  //     });
  //   });

  //   recipeBloc.add(FetchRecipesEvent());
  // });
}
