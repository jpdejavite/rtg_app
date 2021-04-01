class RtgError extends Error {
  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (runtimeType != other.runtimeType) {
      return false;
    }

    return toString() == other.toString();
  }
}

class NotFoundError extends RtgError {
  @override
  String toString() {
    return "not found";
  }
}

class GenericError extends RtgError {
  final String message;
  GenericError(this.message);

  @override
  String toString() {
    return this.message;
  }
}

class RecipeAlreadyAddedToGroceryList extends RtgError {
  @override
  String toString() {
    return "recipe_already_added_to_grocery_list";
  }
}
