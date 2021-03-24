import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/recipes_collection.dart';

abstract class SaveRecipeState extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveRecipeInitState extends SaveRecipeState {}

class SavingRecipe extends SaveRecipeState {}

class RecipeSaved extends SaveRecipeState {
  final error;
  RecipeSaved({this.error});
}
