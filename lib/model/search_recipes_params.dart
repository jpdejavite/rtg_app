import 'package:rtg_app/model/recipe_sort.dart';

class SearchRecipesParams {
  final List<String> ids;
  final String filter;
  final int offset;
  final int limit;
  final RecipeSort sort;

  SearchRecipesParams({
    this.filter,
    this.offset,
    this.limit,
    this.ids,
    this.sort,
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
        ids == other.ids &&
        sort == other.sort;
  }

  @override
  int get hashCode => super.hashCode;
}
