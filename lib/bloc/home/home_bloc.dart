import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/api/google_api.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/helper/date_helper.dart';
import 'package:rtg_app/helper/log_helper.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/grocery_lists_collection.dart';
import 'package:rtg_app/model/menu_planning.dart';
import 'package:rtg_app/model/menu_planning_collection.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';
import 'package:rtg_app/model/search_menu_plannings_params.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
import 'package:rtg_app/model/user_data.dart';
import 'package:rtg_app/repository/backup_repository.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/menu_planning_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:rtg_app/repository/user_data_repository.dart';

import 'events.dart';
import 'states.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  final BackupRepository backupRepository;
  final RecipesRepository recipesRepository;
  final GroceryListsRepository groceryListsRepository;
  final UserDataRepository userDataRepository;
  final GoogleApi googleApi;
  final MenuPlanningRepository menuPlanningRepository;
  HomeBloc({
    @required this.backupRepository,
    @required this.recipesRepository,
    @required this.googleApi,
    @required this.groceryListsRepository,
    @required this.userDataRepository,
    @required this.menuPlanningRepository,
  }) : super(HomeInitState());
  @override
  Stream<HomeState> mapEventToState(HomeEvents event) async* {
    if (event is GetHomeDataEvent) {
      ShowHomeInfo showHomeInfo = await buildShowHomeInfo();
      yield showHomeInfo;
      checkAndDoBackup(showHomeInfo);
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
      await menuPlanningRepository.deleteAll();
      yield AllDataDeleted();
    } else if (event is SaveNewGroceryList) {
      SaveGroceryListResponse response = await groceryListsRepository
          .save(GroceryList.newEmptyGroceryList(event.groceryListTitle));
      yield SavedNewGroceryListState(response);
    }
  }

  Future<ShowHomeInfo> buildShowHomeInfo({
    Backup backup,
    UserData userData,
    RecipesCollection recipesCollection,
    GroceryListsCollection groceriesCollection,
    MenuPlanningCollection menuPlanningCollection,
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
    if (menuPlanningCollection == null) {
      menuPlanningCollection = await menuPlanningRepository
          .fetch(SearchMenuPlanningParams(limit: 2));
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

    MenuPlanning oldMenuPlanning = getOldMenuPlanning(menuPlanningCollection);
    MenuPlanning currentMenuPlanning =
        getCurrentMenuPlanning(menuPlanningCollection);
    MenuPlanning futureMenuPlanning =
        getFutureMenuPlanning(menuPlanningCollection);

    return ShowHomeInfo(
      backupHasError: backupHasError,
      backupNotConfigured: backupNotConfigured,
      backupOk: backupOk,
      backup: backup,
      showRecipeTutorial: showRecipeTutorial,
      lastUsedGroceryList: lastUsedGroceryList,
      lastUsedGroceryListRecipes: lastUsedGroceryListRecipes,
      oldMenuPlanning: oldMenuPlanning,
      oldMenuPlanningRecipes: oldMenuPlanning == null
          ? null
          : menuPlanningCollection.menuPlanningsRecipes[oldMenuPlanning],
      currentMenuPlanning: currentMenuPlanning,
      currentMenuPlanningRecipes: currentMenuPlanning == null
          ? null
          : menuPlanningCollection.menuPlanningsRecipes[currentMenuPlanning],
      futureMenuPlanning: futureMenuPlanning,
      futureMenuPlanningRecipes: futureMenuPlanning == null
          ? null
          : menuPlanningCollection.menuPlanningsRecipes[futureMenuPlanning],
    );
  }

  static MenuPlanning getOldMenuPlanning(
      MenuPlanningCollection menuPlanningCollection) {
    if (menuPlanningCollection == null ||
        menuPlanningCollection.menuPlannings == null ||
        menuPlanningCollection.menuPlannings.length < 1) {
      return null;
    }

    return menuPlanningCollection.menuPlannings.firstWhere((menu) {
      DateTime endAt = DateHelper.endOfDay(DateTime.parse(menu.endAt));
      return CustomDateTime.current.microsecondsSinceEpoch >
          endAt.microsecondsSinceEpoch;
    }, orElse: () => null);
  }

  static MenuPlanning getCurrentMenuPlanning(
      MenuPlanningCollection menuPlanningCollection) {
    if (menuPlanningCollection == null ||
        menuPlanningCollection.menuPlannings == null ||
        menuPlanningCollection.menuPlannings.length < 1) {
      return null;
    }

    return menuPlanningCollection.menuPlannings.firstWhere((menu) {
      DateTime endAt = DateHelper.endOfDay(DateTime.parse(menu.endAt));
      DateTime startAt = DateHelper.beginOfDay(DateTime.parse(menu.startAt));

      return CustomDateTime.current.microsecondsSinceEpoch >=
              startAt.microsecondsSinceEpoch &&
          CustomDateTime.current.microsecondsSinceEpoch <=
              endAt.microsecondsSinceEpoch;
    }, orElse: () => null);
  }

  static MenuPlanning getFutureMenuPlanning(
      MenuPlanningCollection menuPlanningCollection) {
    if (menuPlanningCollection == null ||
        menuPlanningCollection.menuPlannings == null ||
        menuPlanningCollection.menuPlannings.length < 1) {
      return null;
    }

    return menuPlanningCollection.menuPlannings.firstWhere((menu) {
      DateTime startAt = DateHelper.beginOfDay(DateTime.parse(menu.startAt));

      return CustomDateTime.current.microsecondsSinceEpoch <=
          startAt.microsecondsSinceEpoch;
    }, orElse: () => null);
  }

  Future<void> checkAndDoBackup(ShowHomeInfo showHomeInfo) async {
    if (showHomeInfo.backup.type == BackupType.none) {
      await LogHelper.log('backup not configured');
      return;
    }

    if (showHomeInfo.backup.type == BackupType.drive) {
      if (showHomeInfo.backup.lastestBackupAt == null) {
        await doBackupOnDrive(showHomeInfo.backup);
        return;
      }
      DataSummary recipeSummary = await recipesRepository.getSummary();
      DataSummary groceryListSummary =
          await groceryListsRepository.getSummary();

      if ((recipeSummary.lastUpdated > showHomeInfo.backup.lastestBackupAt) ||
          (groceryListSummary.lastUpdated >
              showHomeInfo.backup.lastestBackupAt)) {
        await doBackupOnDrive(showHomeInfo.backup);
        return;
      }
    }
  }

  Future<void> doBackupOnDrive(Backup backup) async {
    try {
      bool hasDoneBackup = false;
      drive.File file = await googleApi.getBackupOnDrive();
      if (file == null) {
        file = await googleApi.doBackupOnDrive();
        hasDoneBackup = true;
      } else if (backup.fileId == file.id) {
        File backupFile = await googleApi.downloadBackupFromDrive(file.id);
        await recipesRepository.mergeFromBackup(file: backupFile);
        await googleApi.updateBackupOnDrive(file.id);
        hasDoneBackup = true;
      }

      if (hasDoneBackup) {
        backup.updatedAt = CustomDateTime.current.millisecondsSinceEpoch;
        backup.lastestBackupAt = CustomDateTime.current.millisecondsSinceEpoch;
        backup.lastestBackupStatus = BackupStatus.done;
        backup.fileId = file.id;
        backup.error = null;
        await backupRepository.save(backup: backup);
        await LogHelper.log('backup done');
      }
    } catch (e) {
      backup.updatedAt = CustomDateTime.current.millisecondsSinceEpoch;
      backup.lastestBackupStatus = BackupStatus.error;
      backup.error = e.toString();
      await backupRepository.save(backup: backup);

      await LogHelper.log('backup error: $e');
    }
  }
}
