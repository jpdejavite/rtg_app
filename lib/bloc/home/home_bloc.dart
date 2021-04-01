import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/api/google_api.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/repository/backup_repository.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';

import 'events.dart';
import 'states.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  final BackupRepository backupRepository;
  final RecipesRepository recipesRepository;
  final GroceryListsRepository groceryListsRepository;
  final GoogleApi googleApi;
  HomeBloc({
    @required this.backupRepository,
    @required this.recipesRepository,
    @required this.googleApi,
    @required this.groceryListsRepository,
  }) : super(HomeInitState());
  @override
  Stream<HomeState> mapEventToState(HomeEvents event) async* {
    if (event is GetHomeDataEvent) {
      Backup backup = await backupRepository.getBackup();
      RecipesCollection recipesCollection = await recipesRepository.search();

      if (backup.lastestBackupStatus == BackupStatus.error) {
        yield BackupHasError(backup: backup);
      } else if (recipesCollection.total > 0 &&
          backup.type == BackupType.none) {
        yield BackupNotConfigured();
      } else {
        yield BackupOk();
      }
    } else if (event is DeleteAllDataEvent) {
      await backupRepository.deleteAll();
      await recipesRepository.deleteAll();
      await groceryListsRepository.deleteAll();
      await googleApi.logout();
      yield AllDataDeleted();
    }
  }
}
