class NotFoundError extends Error {
  @override
  String toString() {
    return "not found";
  }
}

class GenericError extends Error {
  final String message;
  GenericError(this.message);

  @override
  String toString() {
    return this.message;
  }
}

class RecipeAlreadyAddedToGroceryList extends Error {
  @override
  String toString() {
    return "recipe_already_added_to_grocery_list";
  }
}
