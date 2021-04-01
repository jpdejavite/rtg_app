import 'grocery_list.dart';

class SaveGroceryListResponse {
  final error;
  final GroceryList groceryList;

  SaveGroceryListResponse({this.error, this.groceryList});
}
