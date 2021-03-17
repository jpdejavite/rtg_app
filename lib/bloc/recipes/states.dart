import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/recipe_list.dart';

abstract class RecipesState extends Equatable {
  @override
  List<Object> get props => [];
}

class RecipesInitState extends RecipesState {}

class RecipesLoading extends RecipesState {}

class RecipesLoadingMore extends RecipesState {
  final List<Recipe> recipes;
  RecipesLoadingMore({this.recipes});
  @override
  List<Object> get props => [recipes];
}

class RecipesLoaded extends RecipesState {
  final List<Recipe> recipes;
  RecipesLoaded({this.recipes});
  @override
  List<Object> get props => [recipes];
}

class RecipesListError extends RecipesState {
  final error;
  RecipesListError({this.error});
}
