import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/recipe.dart';

abstract class SaveRecipeEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveRecipeEvent extends SaveRecipeEvents {
  final Recipe recipe;
  SaveRecipeEvent({this.recipe});
}
