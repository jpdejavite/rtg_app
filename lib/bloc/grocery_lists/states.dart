import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/grocery_lists_collection.dart';

abstract class GroceryListsListState extends Equatable {
  @override
  List<Object> get props => [];
}

class GroceryListsInitState extends GroceryListsListState {}

class GroceryListsLoaded extends GroceryListsListState {
  final GroceryListsCollection groceryListsCollection;
  GroceryListsLoaded(this.groceryListsCollection);
  @override
  List<Object> get props => [groceryListsCollection];
}
