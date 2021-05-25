import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/bloc/recipes/events.dart';
import 'package:rtg_app/bloc/recipes/recipes_bloc.dart';
import 'package:rtg_app/bloc/recipes/states.dart';
import 'package:rtg_app/model/recipe_sort.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
import 'package:rtg_app/widgets/error.dart';
import 'package:rtg_app/widgets/loading.dart';
import 'package:rtg_app/widgets/loading_row.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

class ChooseRecipeScreen extends StatefulWidget {
  static String id = 'choose_recipe_screen';
  final List<Recipe> lastUsedRecipes;

  ChooseRecipeScreen(this.lastUsedRecipes);

  static newChooseRecipeBloc(args) {
    return BlocProvider(
      create: (context) => RecipesBloc(
        recipesRepository: RecipesRepository(),
        groceryListsRepository: GroceryListsRepository(),
      ),
      child: ChooseRecipeScreen(args),
    );
  }

  @override
  _ChooseRecipeState createState() => _ChooseRecipeState();
}

class _ChooseRecipeState extends State<ChooseRecipeScreen> {
  TextEditingController _filterController;
  bool hasShowChooseGroceryListToRecipeDialog = false;
  @override
  void initState() {
    super.initState();
    _filterController = TextEditingController();
    loadRecipes();
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  loadRecipes() async {
    context.read<RecipesBloc>().add(
          StartFetchRecipesEvent(
            searchParams: SearchRecipesParams(
                filter: _filterController.text, sort: RecipeSort.titleAz),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesBloc, RecipesState>(
        builder: (BuildContext context, RecipesState state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).choose_a_recipe),
        ),
        body: Container(
          child: body(state),
        ),
      );
    });
  }

  Widget body(RecipesState state) {
    EasyLoading.dismiss();
    if (state is RecipesListError) {
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

    return Column(
      children: [
        buildSearchFields(),
        buildList(mergeRecipes(recipesCollection)),
      ],
    );
  }

  ChooseRecipeItemCollection mergeRecipes(RecipesCollection recipesCollection) {
    ChooseRecipeItemCollection collection = ChooseRecipeItemCollection([], 0);

    bool isFiltered =
        _filterController.text != null && _filterController.text != '';
    if (!isFiltered && widget.lastUsedRecipes != null) {
      collection.items.add(ChooseRecipeItem(lastUsedRecipeTag: true));
      collection.total++;
      widget.lastUsedRecipes.forEach((recipe) {
        collection.items.add(ChooseRecipeItem(recipe: recipe));
        collection.total++;
      });
    }

    if (recipesCollection != null && recipesCollection.recipes != null) {
      if (!isFiltered) {
        collection.items.add(ChooseRecipeItem(othersRecipes: true));
      }
      collection.hasLoadedAll =
          (recipesCollection.recipes.length >= recipesCollection.total);
      collection.offset = recipesCollection.recipes.length;
      recipesCollection.recipes.forEach((recipe) {
        collection.items.add(ChooseRecipeItem(recipe: recipe));
        collection.total++;
      });
    }
    return collection;
  }

  Widget buildSearchFields() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        key: Key(Keys.recipesListFilter),
        controller: _filterController,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).type_in_to_filter_recipes,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          suffixIcon: IconButton(
            onPressed: () {
              if (FocusScope.of(context).hasFocus) {
                FocusScope.of(context).unfocus();
              }
              _filterController.text = '';
              context.read<RecipesBloc>().add(StartFetchRecipesEvent(
                    searchParams: SearchRecipesParams(
                        filter: _filterController.text,
                        sort: RecipeSort.titleAz),
                  ));
            },
            icon: Icon(
              Icons.clear,
              color:
                  FocusScope.of(context).hasFocus ? null : Colors.transparent,
            ),
          ),
        ),
        onChanged: (String newValue) {
          context.read<RecipesBloc>().add(StartFetchRecipesEvent(
                searchParams: SearchRecipesParams(
                    filter: _filterController.text, sort: RecipeSort.titleAz),
              ));
        },
      ),
    );
  }

  Widget buildList(ChooseRecipeItemCollection itemsCollection) {
    if (itemsCollection == null || itemsCollection.items == null) {
      return Loading();
    }

    if (itemsCollection.items.length == 0) {
      return Expanded(
        child: Center(
          child: Text(
            AppLocalizations.of(context).empty_recipes_list,
            key: Key(Keys.recipesListEmptyText),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        key: Key(Keys.recipesList),
        itemCount: itemsCollection.items.length +
            (itemsCollection.hasLoadedAll ? 0 : 1),
        itemBuilder: (_, index) {
          if (!itemsCollection.hasLoadedAll &&
              index == itemsCollection.items.length) {
            context.read<RecipesBloc>().add(FetchRecipesEvent(
                searchParams: SearchRecipesParams(
                    filter: _filterController.text,
                    sort: RecipeSort.titleAz,
                    offset: itemsCollection.offset)));
            return LoadingRow();
          }

          ChooseRecipeItem chooseRecipeItem = itemsCollection.items[index];
          Widget item;
          if (chooseRecipeItem.recipe != null) {
            item = InkWell(
                onTap: () {
                  Navigator.pop(context, chooseRecipeItem.recipe);
                },
                child: Card(
                  // key: cardKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          chooseRecipeItem.recipe.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                          key: Key(
                              Keys.recipeListRowTitleText + index.toString()),
                        ),
                        subtitle: Text(
                          chooseRecipeItem.recipe.instructions,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ));
          } else {
            item = Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                chooseRecipeItem.lastUsedRecipeTag
                    ? AppLocalizations.of(context).last_used_recipes
                    : AppLocalizations.of(context).other_recipes,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            );
          }
          if (itemsCollection.hasLoadedAll &&
              index == itemsCollection.items.length - 1) {
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

class ChooseRecipeItemCollection {
  final List<ChooseRecipeItem> items;
  int total;
  bool hasLoadedAll;
  int offset;
  ChooseRecipeItemCollection(this.items, this.total,
      {this.hasLoadedAll = true, this.offset = 0});
}

class ChooseRecipeItem {
  final Recipe recipe;
  bool lastUsedRecipeTag;
  bool othersRecipes;
  ChooseRecipeItem(
      {this.recipe,
      this.lastUsedRecipeTag = false,
      this.othersRecipes = false});
}
