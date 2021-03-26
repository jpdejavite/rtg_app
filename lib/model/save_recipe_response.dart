import 'package:rtg_app/model/recipe.dart';

class SaveRecipeResponse {
  final error;
  final Recipe recipe;

  SaveRecipeResponse({this.error, this.recipe});
}
