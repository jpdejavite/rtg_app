import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/bloc/recipes/bloc.dart';
import 'package:rtg_app/bloc/recipes/events.dart';
import 'package:rtg_app/bloc/recipes/states.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe_list.dart';
import 'package:rtg_app/widgets/error.dart';
import 'package:rtg_app/widgets/list_row.dart';
import 'package:rtg_app/widgets/loading.dart';
import 'package:rtg_app/widgets/loading_row.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipesList extends StatefulWidget {
  static String id = 'recipe_list';
  @override
  _RecipesListState createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {
  //
  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  _loadRecipes() async {
    context.read<RecipesBloc>().add(FetchRecipesEvent(lastId: ""));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _body(),
    );
  }

  _body() {
    return Column(
      children: [
        BlocBuilder<RecipesBloc, RecipesState>(
            builder: (BuildContext context, RecipesState state) {
          if (state is RecipesListError) {
            final error = state.error;
            String message = '${error.message}\nTap to Retry.';
            return ErrorTxt(
              message: message,
              onTap: _loadRecipes,
            );
          }
          List<Recipe> recipes;
          if (state is RecipesLoaded) {
            recipes = state.recipes;
          }
          if (state is RecipesLoadingMore) {
            recipes = state.recipes;
          }

          if (recipes == null) {
            return Loading();
          }

          if (recipes.length > 0) {
            return _list(recipes);
          }

          return Expanded(
            child: Center(
              child: Text(AppLocalizations.of(context).empty_recipes_list),
            ),
          );
        }),
      ],
    );
  }

  Widget _list(List<Recipe> recipes) {
    return Expanded(
      key: Key(Keys.receipesList),
      child: ListView.builder(
        itemCount: recipes.length + 1,
        itemBuilder: (_, index) {
          if (index == recipes.length) {
            context
                .read<RecipesBloc>()
                .add(FetchRecipesEvent(lastId: recipes[recipes.length - 1].id));
            return LoadingRow();
          }

          Recipe recipe = recipes[index];
          return ListRow(recipe: recipe);
        },
      ),
    );
  }
}
