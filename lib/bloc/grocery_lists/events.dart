import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/search_grocery_lists_params.dart';

abstract class GroceryListsEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchGroceryListsEvent extends GroceryListsEvents {
  final SearchGroceryListsParams searchParams;
  FetchGroceryListsEvent(this.searchParams);
  @override
  List<Object> get props => [searchParams];
}

class StartFetchGroceryListsEvent extends FetchGroceryListsEvent {
  StartFetchGroceryListsEvent(searchParams) : super(searchParams);
}

class LoadGroceryListRecipesEvent extends GroceryListsEvents {
  final GroceryList groceryList;
  LoadGroceryListRecipesEvent(this.groceryList);

  @override
  List<Object> get props => [groceryList];
}
