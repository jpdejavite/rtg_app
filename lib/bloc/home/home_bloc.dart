import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/api/google_api.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/grocery_lists_collection.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
import 'package:rtg_app/model/user_data.dart';
import 'package:rtg_app/repository/backup_repository.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:rtg_app/repository/user_data_repository.dart';

import 'events.dart';
import 'states.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  final BackupRepository backupRepository;
  final RecipesRepository recipesRepository;
  final GroceryListsRepository groceryListsRepository;
  final UserDataRepository userDataRepository;
  final GoogleApi googleApi;
  HomeBloc({
    @required this.backupRepository,
    @required this.recipesRepository,
    @required this.googleApi,
    @required this.groceryListsRepository,
    @required this.userDataRepository,
  }) : super(HomeInitState());
  @override
  Stream<HomeState> mapEventToState(HomeEvents event) async* {
    if (event is GetHomeDataEvent) {
      yield await buildShowHomeInfo();
    } else if (event is DismissRecipeTutorial) {
      UserData userData = await userDataRepository.getUserData();
      userData.updatedAt = CustomDateTime.current.millisecondsSinceEpoch;
      userData.dimissRecipeTutorial = true;
      await userDataRepository.save(userData);

      yield await buildShowHomeInfo(userData: userData);
    } else if (event is DeleteAllDataEvent) {
      await backupRepository.deleteAll();
      await recipesRepository.deleteAll();
      await groceryListsRepository.deleteAll();
      await googleApi.logout();
      await userDataRepository.deleteAll();
      yield AllDataDeleted();
    }
  }

  Future<ShowHomeInfo> buildShowHomeInfo({
    Backup backup,
    UserData userData,
    RecipesCollection recipesCollection,
    GroceryListsCollection groceriesCollection,
  }) async {
    bool backupHasError = false;
    bool backupNotConfigured = false;
    bool backupOk = false;
    bool showRecipeTutorial = false;
    GroceryList lastUsedGroceryList;
    List<Recipe> lastUsedGroceryListRecipes;
    if (backup == null) {
      backup = await backupRepository.getBackup();
    }
    if (userData == null) {
      userData = await userDataRepository.getUserData();
    }
    if (recipesCollection == null) {
      recipesCollection = await recipesRepository.search();
    }
    if (groceriesCollection == null) {
      groceriesCollection =
          await groceryListsRepository.fetch(limit: 1, offset: 0);
    }

    if (recipesCollection.total == 0) {
      if (!userData.dimissRecipeTutorial) {
        showRecipeTutorial = true;
      }
    }

    if (backup.lastestBackupStatus == BackupStatus.error) {
      backupHasError = true;
    } else if ((recipesCollection.total > 0 || groceriesCollection.total > 0) &&
        backup.type == BackupType.none) {
      backupNotConfigured = true;
    } else {
      backupOk = true;
    }

    if (groceriesCollection.total > 0) {
      lastUsedGroceryList = groceriesCollection.groceryLists[0];
      if (groceriesCollection.groceryLists[0].recipes != null &&
          groceriesCollection.groceryLists[0].recipes.length > 0) {
        RecipesCollection collection = await recipesRepository.search(
            searchParams: SearchRecipesParams(
                ids: groceriesCollection.groceryLists[0].recipes,
                limit: groceriesCollection.groceryLists[0].recipes.length));
        lastUsedGroceryListRecipes = collection.recipes;
      }
    }

    return ShowHomeInfo(
      backupHasError: backupHasError,
      backupNotConfigured: backupNotConfigured,
      backupOk: backupOk,
      backup: backup,
      showRecipeTutorial: showRecipeTutorial,
      lastUsedGroceryList: lastUsedGroceryList,
      lastUsedGroceryListRecipes: lastUsedGroceryListRecipes,
    );
  }
}
