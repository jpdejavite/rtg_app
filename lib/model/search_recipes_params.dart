import 'package:rtg_app/model/recipe_label.dart';
import 'package:rtg_app/model/recipe_sort.dart';

class SearchRecipesParams {
  final List<String> ids;
  final String filter;
  final RecipeLabel label;
  final int offset;
  final int limit;
  final RecipeSort sort;

  SearchRecipesParams({
    this.filter,
    this.label,
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
        label == other.label &&
        offset == other.offset &&
        limit == other.limit &&
        ids == other.ids &&
        sort == other.sort;
  }

  @override
  int get hashCode => super.hashCode;
}
