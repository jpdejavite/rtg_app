import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/recipes_collection.dart';

abstract class RecipesState extends Equatable {
  @override
  List<Object> get props => [];
}

class RecipesInitState extends RecipesState {}

class RecipesLoading extends RecipesState {}

class RecipesLoadingMore extends RecipesState {
  final RecipesCollection recipesCollection;
  RecipesLoadingMore({this.recipesCollection});
  @override
  List<Object> get props => [recipesCollection];
}

class RecipesLoaded extends RecipesLoadingMore {
  final RecipesCollection recipesCollection;
  RecipesLoaded({this.recipesCollection});
  @override
  List<Object> get props => [recipesCollection];
}

class RecipesListError extends RecipesState {
  final error;
  RecipesListError({this.error});
}
