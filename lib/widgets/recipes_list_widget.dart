import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rtg_app/bloc/recipes/recipes_bloc.dart';
import 'package:rtg_app/bloc/recipes/events.dart';
import 'package:rtg_app/bloc/recipes/states.dart';
import 'package:rtg_app/errors/errors.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:rtg_app/widgets/error.dart';
import 'package:rtg_app/widgets/recipe_list_row.dart';
import 'package:rtg_app/widgets/loading.dart';
import 'package:rtg_app/widgets/loading_row.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'choose_grocery_list_to_recipe_dialog.dart';
import 'add_recipe_to_grocery_list_dialog.dart';
import 'custom_toast.dart';

class RecipesList extends StatefulWidget {
  static String id = 'recipe_list';

  final Key key;
  final Function(Recipe recipe) onTapRecipe;

  RecipesList({this.key, this.onTapRecipe});

  static newRecipeListBloc(
      {Key key, final Function(Recipe recipe) onTapRecipe}) {
    return BlocProvider(
      create: (context) => RecipesBloc(
          recipesRepository: RecipesRepository(),
          groceryListsRepository: GroceryListsRepository()),
      child: RecipesList(
        key: key,
        onTapRecipe: onTapRecipe,
      ),
    );
  }

  @override
  RecipesListState createState() => RecipesListState();
}

class RecipesListState extends State<RecipesList> {
  String filter;
  @override
  void initState() {
    super.initState();
    loadRecipes();
    setState(() {});
  }

  loadRecipes() async {
    context.read<RecipesBloc>().add(
          StartFetchRecipesEvent(
            searchParams: SearchRecipesParams(filter: filter),
          ),
        );
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
          EasyLoading.dismiss();
          if (state is AddedRecipeToGroceryListEvent) {
            String text =
                AppLocalizations.of(context).recipe_added_to_grocery_list;
            if (state.response.error != null) {
              text = state.response.error is RecipeAlreadyAddedToGroceryList
                  ? AppLocalizations.of(context)
                      .recipe_already_added_to_grocery_list
                  : AppLocalizations.of(context)
                      .error_when_adding_to_grocery_list;
            }
            CustomToast.showToast(
              text: text,
              context: context,
              time: CustomToast.timeLong,
            );
          } else if (state is ChooseGroceryListToRecipeEvent) {
            WidgetsBinding.instance.addPostFrameCallback((_) =>
                ChooseGroceryListToRecipeDialog
                    .showChooseGroceryListToRecipeDialog(
                  context: context,
                  groceryLists: state.collection.groceryLists,
                  onSelectGroceryList: (GroceryList groceryList) {
                    context.read<RecipesBloc>().add(AddRecipeToGroceryListEvent(
                        state.recipe,
                        state.portions,
                        GroceryList.getGroceryListDefaultTitle(context),
                        groceryList));
                    EasyLoading.show(
                      maskType: EasyLoadingMaskType.black,
                      status: AppLocalizations.of(context).saving_recipe,
                    );
                  },
                ));
          } else if (state is RecipesListError) {
            final error = state.error;
            String message = '${error.message}\nTap to Retry.';
            return ErrorTxt(
              message: message,
              onTap: loadRecipes,
            );
          }
          RecipesCollection recipesCollection;
          if (state is RecipesLoaded) {
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
                key: Key(Keys.recipesListEmptyText),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _list(RecipesCollection recipesCollection) {
    bool hasLoadedAll =
        (recipesCollection.recipes.length == recipesCollection.total);
    return Expanded(
      key: Key(Keys.recipesList),
      child: ListView.builder(
        itemCount: recipesCollection.recipes.length + (hasLoadedAll ? 0 : 1),
        itemBuilder: (_, index) {
          if (index == recipesCollection.recipes.length) {
            context.read<RecipesBloc>().add(FetchRecipesEvent(
                searchParams: SearchRecipesParams(
                    filter: filter, offset: recipesCollection.recipes.length)));
            return LoadingRow();
          }

          Recipe recipe = recipesCollection.recipes[index];
          Widget item = RecipeListRow(
              recipe: recipe,
              index: index,
              onTap: () {
                widget.onTapRecipe(recipe);
              },
              onAddToGroceryList: () {
                AddRecipeToGroceryListDialog.showChooseGroceryListToRecipeEvent(
                    context: context,
                    recipe: recipe,
                    onConfirm: (Recipe recipe, double portions) {
                      context.read<RecipesBloc>().add(
                          TryToAddRecipeToGroceryListEvent(recipe, portions,
                              GroceryList.getGroceryListDefaultTitle(context)));
                      EasyLoading.show(
                        maskType: EasyLoadingMaskType.black,
                        status: AppLocalizations.of(context).saving_recipe,
                      );
                    });
              });
          if (hasLoadedAll && index == recipesCollection.recipes.length - 1) {
            return Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: item,
            );
          }
          return item;
        },
      ),
    );
  }
}
