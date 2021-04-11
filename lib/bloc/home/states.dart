import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/recipe.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeInitState extends HomeState {}

class AllDataDeleted extends HomeState {}

class ShowHomeInfo extends HomeState {
  final bool backupHasError;
  final bool backupNotConfigured;
  final bool backupOk;
  final Backup backup;
  final bool showRecipeTutorial;
  final GroceryList lastUsedGroceryList;
  final List<Recipe> lastUsedGroceryListRecipes;
  ShowHomeInfo({
    this.backupHasError,
    this.backupNotConfigured,
    this.backupOk,
    this.backup,
    this.showRecipeTutorial,
    this.lastUsedGroceryList,
    this.lastUsedGroceryListRecipes,
  });
  @override
  List<Object> get props => [
        backupHasError,
        backupNotConfigured,
        backupOk,
        backup,
        showRecipeTutorial,
      ];
}
