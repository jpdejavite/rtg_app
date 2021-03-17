import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/bloc/recipes/bloc.dart';
import 'package:rtg_app/bloc/recipes/events.dart';
import 'package:rtg_app/bloc/recipes/states.dart';
import 'package:rtg_app/model/recipe_list.dart';
import 'package:rtg_app/widgets/error.dart';
import 'package:rtg_app/widgets/list_row.dart';
import 'package:rtg_app/widgets/loading.dart';
import 'dart:developer';

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
    log('_loadRecipes');
  }

  _loadRecipes() async {
    context.read<RecipesBloc>().add(RecipesEvents.fetchRecipes);
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
          log('builder ' + state.toString());
          if (state is RecipesListError) {
            final error = state.error;
            String message = '${error.message}\nTap to Retry.';
            return ErrorTxt(
              message: message,
              onTap: _loadRecipes,
            );
          }
          if (state is RecipesLoaded) {
            log('builder ' + state.toString());
            List<Recipe> recipes = state.recipes;
            return _list(recipes);
          }
          return Loading();
        }),
      ],
    );
  }

  Widget _list(List<Recipe> recipes) {
    return Expanded(
      child: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (_, index) {
          Recipe recipe = recipes[index];
          return ListRow(recipe: recipe);
        },
      ),
    );
  }
}
