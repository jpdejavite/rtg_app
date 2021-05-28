class SearchMenuPlanningParams {
  final int offset;
  final int limit;

  SearchMenuPlanningParams({
    this.offset,
    this.limit,
  });

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is SearchMenuPlanningParams)) {
      return false;
    }

    return offset == other.offset && limit == other.limit;
  }

  @override
  int get hashCode => super.hashCode;
}
