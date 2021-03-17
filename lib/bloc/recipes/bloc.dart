import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/api/exceptions.dart';
import 'package:rtg_app/api/services.dart';
import 'package:rtg_app/bloc/recipes/events.dart';
import 'package:rtg_app/bloc/recipes/states.dart';
import 'package:rtg_app/model/recipe_list.dart';

class RecipesBloc extends Bloc<RecipesEvents, RecipesState> {
  final RecipesRepo recipesRepo;
  List<Recipe> recipes;
  RecipesBloc({this.recipesRepo}) : super(RecipesInitState());
  @override
  Stream<RecipesState> mapEventToState(RecipesEvents event) async* {
    switch (event) {
      case RecipesEvents.fetchRecipes:
        yield RecipesLoading();
        try {
          recipes = await recipesRepo.getRecipeList();
          yield RecipesLoaded(recipes: recipes);
        } on SocketException {
          yield RecipesListError(
            error: NoInternetException('No Internet'),
          );
        } on HttpException {
          yield RecipesListError(
            error: NoServiceFoundException('No Service Found'),
          );
        } on FormatException {
          yield RecipesListError(
            error: InvalidFormatException('Invalid Response format'),
          );
        } catch (e) {
          yield RecipesListError(
            error: UnknownException(e.toString()),
          );
        }
        break;
    }
  }
}
