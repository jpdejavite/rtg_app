import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/grocery_list.dart';

abstract class SaveGroceryListEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadGroceryListRecipesEvent extends SaveGroceryListEvents {
  final GroceryList groceryList;
  LoadGroceryListRecipesEvent(this.groceryList);

  @override
  List<Object> get props => [groceryList];
}

class SaveGroceryListEvent extends LoadGroceryListRecipesEvent {
  SaveGroceryListEvent(groceryList) : super(groceryList);
}

class SaveGroceryListSilentlyEvent extends LoadGroceryListRecipesEvent {
  SaveGroceryListSilentlyEvent(groceryList) : super(groceryList);
}

class ArchiveGroceryListEvent extends LoadGroceryListRecipesEvent {
  ArchiveGroceryListEvent(groceryList) : super(groceryList);
}
