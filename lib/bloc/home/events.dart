import 'package:equatable/equatable.dart';

abstract class HomeEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetHomeDataEvent extends HomeEvents {}

class DeleteAllDataEvent extends HomeEvents {}

class DismissRecipeTutorial extends HomeEvents {}

class SaveNewGroceryList extends HomeEvents {
  final String groceryListTitle;

  SaveNewGroceryList(this.groceryListTitle);

  @override
  List<Object> get props => [this.groceryListTitle];
}
