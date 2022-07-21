class ErrorWrapper extends Error {
  final String message;
  final Error e;

  ErrorWrapper(this.message, this.e);

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

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    return this.message;
  }
}
