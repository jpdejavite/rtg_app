import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/bloc/recipes/recipes_bloc.dart';
import 'package:rtg_app/bloc/recipes/events.dart';
import 'package:rtg_app/bloc/recipes/states.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
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
  String filter;
  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  _loadRecipes() async {
    context.read<RecipesBloc>().add(StartFetchRecipesEvent(
          searchParams: SearchRecipesParams(filter: filter),
        ));
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              // TODO: add icon to clear input
              child: TextField(
                decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context).type_in_to_filter_recipes,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    filter = newValue;
                  });
                  context.read<RecipesBloc>().add(StartFetchRecipesEvent(
                        searchParams: SearchRecipesParams(filter: filter),
                      ));
                },
              ),
            ),
            ElevatedButton(
              // TODO: change to filter
              child: Text('Refresh'),
              onPressed: () {
                context.read<RecipesBloc>().add(StartFetchRecipesEvent());
              },
            ),
          ],
        ),
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
          RecipesCollection recipesCollection;
          if (state is RecipesLoaded) {
            recipesCollection = state.recipesCollection;
          }
          if (state is RecipesLoadingMore) {
            recipesCollection = state.recipesCollection;
          }

          if (recipesCollection == null || recipesCollection.recipes == null) {
            return Loading();
          }

          if (recipesCollection.recipes.length > 0) {
            return _list(recipesCollection);
          }

          return Expanded(
            child: Center(
              child: Text(
                AppLocalizations.of(context).empty_recipes_list,
                key: Key(Keys.receipesListEmptyText),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _list(RecipesCollection recipesCollection) {
    return Expanded(
      key: Key(Keys.receipesList),
      child: ListView.builder(
        itemCount: recipesCollection.recipes.length +
            ((recipesCollection.recipes.length == recipesCollection.total)
                ? 0
                : 1),
        itemBuilder: (_, index) {
          if (index == recipesCollection.recipes.length) {
            context.read<RecipesBloc>().add(FetchRecipesEvent(
                searchParams: SearchRecipesParams(
                    filter: filter, offset: recipesCollection.recipes.length)));
            return LoadingRow();
          }

          Recipe recipe = recipesCollection.recipes[index];
          return ListRow(recipe: recipe);
        },
      ),
    );
  }
}
