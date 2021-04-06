class SearchRecipesParams {
  final List<String> ids;
  final String filter;
  final int offset;
  final int limit;

  SearchRecipesParams({
    this.filter,
    this.offset,
    this.limit,
    this.ids,
  });

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is SearchRecipesParams)) {
      return false;
    }

    return filter == other.filter &&
        offset == other.offset &&
        limit == other.limit &&
        ids == other.ids;
  }

  @override
  int get hashCode => super.hashCode;
}
