import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/model/save_recipe_label_response.dart';
import 'package:rtg_app/model/save_recipe_response.dart';
import 'package:rtg_app/repository/recipe_label_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

import '../../model/recipe_label.dart';
import 'events.dart';
import 'states.dart';

class SaveRecipeBloc extends Bloc<SaveRecipeEvents, SaveRecipeState> {
  final RecipesRepository recipesRepo;
  final RecipeLabelRepository recipeLabelRepo;
  SaveRecipeBloc({this.recipesRepo, this.recipeLabelRepo})
      : super(SaveRecipeInitState());
  @override
  Stream<SaveRecipeState> mapEventToState(SaveRecipeEvents event) async* {
    if (event is SaveRecipeEvent) {
      if (event.recipe.label != null) {
        SaveRecipeLabelResponse labelResponse = await this
            .recipeLabelRepo
            .save(label: RecipeLabel(title: event.recipe.label));
        if (labelResponse.error != null) {
          yield RecipeSaved(
              response: SaveRecipeResponse(error: labelResponse.error));
          return;
        }
      }
      SaveRecipeResponse response =
          await recipesRepo.save(recipe: event.recipe);
      yield RecipeSaved(response: response);
    } else if (event is LoadRecipeLabelsEvent) {
      yield RecipeLabelsLoaded(labels: await recipeLabelRepo.getAll());
    }
  }
}
