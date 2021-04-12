import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/model/save_recipe_response.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

import 'events.dart';
import 'states.dart';

class SaveRecipeBloc extends Bloc<SaveRecipeEvents, SaveRecipeState> {
  final RecipesRepository recipesRepo;
  SaveRecipeBloc({this.recipesRepo}) : super(SaveRecipeInitState());
  @override
  Stream<SaveRecipeState> mapEventToState(SaveRecipeEvents event) async* {
    if (event is SaveRecipeEvent) {
      SaveRecipeResponse response =
          await recipesRepo.save(recipe: event.recipe);
      yield RecipeSaved(response: response);
    }
  }
}
