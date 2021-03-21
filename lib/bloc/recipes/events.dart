import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/search_recipes_params.dart';

abstract class RecipesEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchRecipesEvent extends RecipesEvents {
  final SearchRecipesParams searchParams;
  FetchRecipesEvent({this.searchParams});
}

class StartFetchRecipesEvent extends FetchRecipesEvent {
  final SearchRecipesParams searchParams;
  StartFetchRecipesEvent({this.searchParams});
}
