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
