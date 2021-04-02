import 'grocery_list.dart';

class GroceryListsCollection {
  GroceryListsCollection({
    this.groceryLists,
    this.total,
  });

  List<GroceryList> groceryLists;
  int total;

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is GroceryListsCollection)) {
      return false;
    }

    if (total != other.total) {
      return false;
    }

    if (groceryLists.length != other.groceryLists.length) {
      return false;
    }

    bool areEqual = true;
    groceryLists.asMap().forEach((i, groceryList) {
      if (groceryList.id != other.groceryLists[i].id) {
        areEqual = false;
      }
    });
    return areEqual;
  }

  @override
  int get hashCode => super.hashCode;
}
