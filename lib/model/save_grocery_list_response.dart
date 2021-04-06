import 'grocery_list.dart';

class SaveGroceryListResponse {
  final error;
  final GroceryList groceryList;

  SaveGroceryListResponse({this.error, this.groceryList});

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is SaveGroceryListResponse)) {
      return false;
    }

    if (error != other.error) {
      return false;
    }

    return groceryList == other.groceryList;
  }

  @override
  int get hashCode => super.hashCode;
}
