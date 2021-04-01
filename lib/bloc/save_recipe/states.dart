import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/save_recipe_response.dart';

abstract class SaveRecipeState extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveRecipeInitState extends SaveRecipeState {}

class RecipeSaved extends SaveRecipeState {
  final SaveRecipeResponse response;
  RecipeSaved({this.response});
}
