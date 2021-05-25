import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:googleapis/drive/v3.dart' as drive;

import 'package:mockito/mockito.dart';
import 'package:rtg_app/api/google_api.dart';
import 'package:rtg_app/bloc/home/events.dart';
import 'package:rtg_app/bloc/home/home_bloc.dart';
import 'package:rtg_app/bloc/home/states.dart';
import 'package:rtg_app/errors/errors.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/model/backup.dart';
import 'package:rtg_app/model/data_summary.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/grocery_lists_collection.dart';
import 'package:rtg_app/model/menu_planning.dart';
import 'package:rtg_app/model/menu_planning_collection.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/recipes_collection.dart';
import 'package:rtg_app/model/save_grocery_list_response.dart';
import 'package:rtg_app/model/search_recipes_params.dart';
import 'package:rtg_app/model/user_data.dart';
import 'package:rtg_app/repository/backup_repository.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/menu_planning_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:rtg_app/repository/user_data_repository.dart';

class MockBackupRepository extends Mock implements BackupRepository {}

class MockRecipesRepository extends Mock implements RecipesRepository {}

class MockGroceryListsRepository extends Mock
    implements GroceryListsRepository {}

class MockUserDataRepository extends Mock implements UserDataRepository {}

class MockGoogleApi extends Mock implements GoogleApi {}

class MockMenuPlanningRepository extends Mock
    implements MenuPlanningRepository {}

void main() {
  HomeBloc homeBloc;
  MockBackupRepository backupRepository;
  MockRecipesRepository recipesRepository;
  MockGroceryListsRepository groceryListsRepository;
  UserDataRepository userDataRepository;
  MockGoogleApi googleApi;
  MockMenuPlanningRepository menuPlanningRepository;
  DateTime customTime = DateTime.parse("2000-07-20 20:18:04");

  setUp(() {
    backupRepository = MockBackupRepository();
    recipesRepository = MockRecipesRepository();
    groceryListsRepository = MockGroceryListsRepository();
    userDataRepository = MockUserDataRepository();
    googleApi = MockGoogleApi();
    menuPlanningRepository = MockMenuPlanningRepository();
    CustomDateTime.customTime = customTime;
    homeBloc = HomeBloc(
      backupRepository: backupRepository,
      recipesRepository: recipesRepository,
      groceryListsRepository: groceryListsRepository,
      userDataRepository: userDataRepository,
      googleApi: googleApi,
      menuPlanningRepository: menuPlanningRepository,
    );
  });

  tearDown(() {
    CustomDateTime.customTime = null;
    homeBloc?.close();
  });

  test('initial state is correct', () {
    expect(homeBloc.state, HomeInitState());
  });

  test('no recipes show recipe turorial', () {
    Backup backup = Backup(lastestBackupStatus: BackupStatus.error);
    GroceryList groceryList = GroceryList();

    final ShowHomeInfo state = ShowHomeInfo(
      backupHasError: true,
      backupNotConfigured: false,
      backupOk: false,
      backup: backup,
      showRecipeTutorial: true,
      lastUsedGroceryList: groceryList,
    );

    final expectedResponse = [state];
    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(recipesRepository.search())
        .thenAnswer((_) => Future.value(RecipesCollection(total: 0)));
    when(groceryListsRepository.fetch(limit: 1, offset: 0)).thenAnswer((_) =>
        Future.value(
            GroceryListsCollection(total: 1, groceryLists: [groceryList])));
    when(userDataRepository.getUserData())
        .thenAnswer((_) => Future.value(UserData(dimissRecipeTutorial: false)));

    expectLater(
      homeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(homeBloc.state, state);
    });

    homeBloc.add(GetHomeDataEvent());
  });

  test('no recipes dismiss recipe turorial', () {
    Backup backup = Backup(lastestBackupStatus: BackupStatus.error);
    GroceryList groceryList = GroceryList(recipes: ["1"]);
    Recipe recipe = Recipe();

    final ShowHomeInfo state = ShowHomeInfo(
      backupHasError: true,
      backupNotConfigured: false,
      backupOk: false,
      backup: backup,
      showRecipeTutorial: false,
      lastUsedGroceryList: groceryList,
      lastUsedGroceryListRecipes: [recipe],
    );

    final expectedResponse = [state];
    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(recipesRepository.search())
        .thenAnswer((_) => Future.value(RecipesCollection(total: 0)));
    when(recipesRepository.search(
            searchParams: SearchRecipesParams(
                ids: groceryList.recipes, limit: groceryList.recipes.length)))
        .thenAnswer((_) =>
            Future.value(RecipesCollection(total: 1, recipes: [recipe])));

    when(groceryListsRepository.fetch(limit: 1, offset: 0)).thenAnswer((_) =>
        Future.value(
            GroceryListsCollection(total: 1, groceryLists: [groceryList])));
    when(userDataRepository.getUserData())
        .thenAnswer((_) => Future.value(UserData(dimissRecipeTutorial: true)));

    expectLater(
      homeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(homeBloc.state, state);
    });

    homeBloc.add(GetHomeDataEvent());
  });

  test('backup has error', () {
    Backup backup = Backup(lastestBackupStatus: BackupStatus.error);
    GroceryList groceryList = GroceryList();

    final ShowHomeInfo state = ShowHomeInfo(
      backupHasError: true,
      backupNotConfigured: false,
      backupOk: false,
      backup: backup,
      showRecipeTutorial: false,
      lastUsedGroceryList: groceryList,
    );

    final expectedResponse = [state];
    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(recipesRepository.search())
        .thenAnswer((_) => Future.value(RecipesCollection(total: 1)));
    when(groceryListsRepository.fetch(limit: 1, offset: 0)).thenAnswer((_) =>
        Future.value(
            GroceryListsCollection(total: 1, groceryLists: [groceryList])));
    when(userDataRepository.getUserData())
        .thenAnswer((_) => Future.value(UserData()));

    expectLater(
      homeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(homeBloc.state, state);
    });

    homeBloc.add(GetHomeDataEvent());
  });

  test('backup not configured has recipes', () {
    Backup backup = Backup(type: BackupType.none);

    final ShowHomeInfo state = ShowHomeInfo(
        backupHasError: false,
        backupNotConfigured: true,
        backupOk: false,
        backup: backup,
        showRecipeTutorial: false);

    final expectedResponse = [state];
    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(recipesRepository.search())
        .thenAnswer((_) => Future.value(RecipesCollection(total: 1)));
    when(groceryListsRepository.fetch(limit: 1, offset: 0))
        .thenAnswer((_) => Future.value(GroceryListsCollection(total: 0)));
    when(userDataRepository.getUserData())
        .thenAnswer((_) => Future.value(UserData()));

    expectLater(
      homeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(homeBloc.state, state);
    });

    homeBloc.add(GetHomeDataEvent());
  });

  test('backup not configured has groceries', () {
    Backup backup = Backup(type: BackupType.none);
    GroceryList groceryList = GroceryList();

    final ShowHomeInfo state = ShowHomeInfo(
      backupHasError: false,
      backupNotConfigured: true,
      backupOk: false,
      backup: backup,
      showRecipeTutorial: true,
      lastUsedGroceryList: groceryList,
    );

    final expectedResponse = [state];
    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(recipesRepository.search())
        .thenAnswer((_) => Future.value(RecipesCollection(total: 0)));
    when(groceryListsRepository.fetch(limit: 1, offset: 0)).thenAnswer((_) =>
        Future.value(
            GroceryListsCollection(total: 1, groceryLists: [groceryList])));
    when(userDataRepository.getUserData())
        .thenAnswer((_) => Future.value(UserData(dimissRecipeTutorial: false)));

    expectLater(
      homeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(homeBloc.state, state);
    });

    homeBloc.add(GetHomeDataEvent());
  });

  test('backup ok', () {
    Backup backup = Backup(type: BackupType.drive);

    final ShowHomeInfo state = ShowHomeInfo(
        backupHasError: false,
        backupNotConfigured: false,
        backupOk: true,
        backup: backup,
        showRecipeTutorial: false);

    final expectedResponse = [state];
    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(recipesRepository.search())
        .thenAnswer((_) => Future.value(RecipesCollection(total: 1)));
    when(groceryListsRepository.fetch(limit: 1, offset: 0))
        .thenAnswer((_) => Future.value(GroceryListsCollection(total: 0)));

    expectLater(
      homeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(homeBloc.state, state);
    });

    homeBloc.add(GetHomeDataEvent());
  });

  test('old menu', () {
    Backup backup = Backup(type: BackupType.drive);
    MenuPlanning old1 = MenuPlanning(startAt: '20000712', endAt: '20000719');
    MenuPlanning old2 = MenuPlanning(startAt: '20000711', endAt: '20000718');

    final ShowHomeInfo state = ShowHomeInfo(
        backupHasError: false,
        backupNotConfigured: false,
        backupOk: true,
        backup: backup,
        showRecipeTutorial: false,
        oldMenuPlanning: old1);

    final expectedResponse = [state];
    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(recipesRepository.search())
        .thenAnswer((_) => Future.value(RecipesCollection(total: 1)));
    when(groceryListsRepository.fetch(limit: 1, offset: 0))
        .thenAnswer((_) => Future.value(GroceryListsCollection(total: 0)));
    when(menuPlanningRepository.fetch(limit: 2)).thenAnswer((_) =>
        Future.value(MenuPlanningCollection(menuPlannings: [old1, old2])));

    expectLater(
      homeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(homeBloc.state, state);
    });

    homeBloc.add(GetHomeDataEvent());
  });

  test('current menu', () {
    Backup backup = Backup(type: BackupType.drive);
    MenuPlanning current = MenuPlanning(startAt: '20000711', endAt: '20000721');
    MenuPlanning old1 = MenuPlanning(startAt: '20000712', endAt: '20000719');

    final ShowHomeInfo state = ShowHomeInfo(
        backupHasError: false,
        backupNotConfigured: false,
        backupOk: true,
        backup: backup,
        showRecipeTutorial: false,
        oldMenuPlanning: old1,
        currentMenuPlanning: current);

    final expectedResponse = [state];
    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(recipesRepository.search())
        .thenAnswer((_) => Future.value(RecipesCollection(total: 1)));
    when(groceryListsRepository.fetch(limit: 1, offset: 0))
        .thenAnswer((_) => Future.value(GroceryListsCollection(total: 0)));
    when(menuPlanningRepository.fetch(limit: 2)).thenAnswer((_) =>
        Future.value(MenuPlanningCollection(menuPlannings: [current, old1])));

    expectLater(
      homeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(homeBloc.state, state);
    });

    homeBloc.add(GetHomeDataEvent());
  });

  test('future menu', () {
    Backup backup = Backup(type: BackupType.drive);
    MenuPlanning future = MenuPlanning(startAt: '20000722', endAt: '20000729');
    MenuPlanning current = MenuPlanning(startAt: '20000711', endAt: '20000721');

    final ShowHomeInfo state = ShowHomeInfo(
        backupHasError: false,
        backupNotConfigured: false,
        backupOk: true,
        backup: backup,
        showRecipeTutorial: false,
        currentMenuPlanning: current,
        futureMenuPlanning: future);

    final expectedResponse = [state];
    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(recipesRepository.search())
        .thenAnswer((_) => Future.value(RecipesCollection(total: 1)));
    when(groceryListsRepository.fetch(limit: 1, offset: 0))
        .thenAnswer((_) => Future.value(GroceryListsCollection(total: 0)));
    when(menuPlanningRepository.fetch(limit: 2)).thenAnswer((_) =>
        Future.value(MenuPlanningCollection(menuPlannings: [future, current])));

    expectLater(
      homeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(homeBloc.state, state);
    });

    homeBloc.add(GetHomeDataEvent());
  });

  test('dismiss recipe tutorial turorial', () {
    Backup backup = Backup(lastestBackupStatus: BackupStatus.error);
    UserData userData = UserData(dimissRecipeTutorial: false);
    GroceryList groceryList = GroceryList();

    final ShowHomeInfo state = ShowHomeInfo(
      backupHasError: true,
      backupNotConfigured: false,
      backupOk: false,
      backup: backup,
      showRecipeTutorial: false,
      lastUsedGroceryList: groceryList,
    );

    final expectedResponse = [state];
    when(userDataRepository.getUserData())
        .thenAnswer((_) => Future.value(userData));
    when(userDataRepository.save(any)).thenAnswer((_) => Future.value(null));
    when(backupRepository.getBackup()).thenAnswer((_) => Future.value(backup));
    when(recipesRepository.search())
        .thenAnswer((_) => Future.value(RecipesCollection(total: 0)));
    when(groceryListsRepository.fetch(limit: 1, offset: 0)).thenAnswer((_) =>
        Future.value(
            GroceryListsCollection(total: 1, groceryLists: [groceryList])));

    expectLater(
      homeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(homeBloc.state, state);

      expect(userData.dimissRecipeTutorial, true);
      expect(userData.updatedAt, customTime.millisecondsSinceEpoch);
    });

    homeBloc.add(DismissRecipeTutorial());
  });

  test('delete all data', () {
    final expectedResponse = [AllDataDeleted()];
    when(backupRepository.deleteAll()).thenAnswer((_) => Future.value(null));
    when(recipesRepository.deleteAll()).thenAnswer((_) => Future.value(null));
    when(groceryListsRepository.deleteAll())
        .thenAnswer((_) => Future.value(null));
    when(userDataRepository.deleteAll()).thenAnswer((_) => Future.value(null));
    when(googleApi.logout()).thenAnswer((_) => Future.value(null));

    expectLater(
      homeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(homeBloc.state, AllDataDeleted());
    });

    homeBloc.add(DeleteAllDataEvent());
  });

  test('save new grocery list', () {
    SaveGroceryListResponse response = SaveGroceryListResponse();
    final expectedResponse = [SavedNewGroceryListState(response)];

    when(groceryListsRepository.save(any))
        .thenAnswer((_) => Future.value(response));

    expectLater(
      homeBloc,
      emitsInOrder(expectedResponse),
    ).then((_) {
      expect(homeBloc.state, SavedNewGroceryListState(response));
    });

    homeBloc.add(SaveNewGroceryList("title"));
  });

  test('check and do backup: backup type none', () async {
    Backup backup = Backup(type: BackupType.none);

    final ShowHomeInfo input = ShowHomeInfo(backup: backup);

    await homeBloc.checkAndDoBackup(input);
  });

  test('check and do backup: lastestBackupAt null and no file at backup',
      () async {
    Backup backup = Backup(type: BackupType.drive);

    drive.File newDriveFile = drive.File();
    newDriveFile.id = 'new-drive-file-id';

    when(backupRepository.save(backup: backup))
        .thenAnswer((_) => Future.value(null));
    when(googleApi.getBackupOnDrive()).thenAnswer((_) => Future.value(null));
    when(googleApi.doBackupOnDrive())
        .thenAnswer((_) => Future.value(newDriveFile));

    final ShowHomeInfo input = ShowHomeInfo(backup: backup);

    await homeBloc.checkAndDoBackup(input);

    expect(backup.updatedAt, customTime.millisecondsSinceEpoch);
    expect(backup.lastestBackupAt, customTime.millisecondsSinceEpoch);
    expect(backup.lastestBackupStatus, BackupStatus.done);
    expect(backup.fileId, newDriveFile.id);
    expect(backup.error, null);
  });

  test(
      'check and do backup: lastestBackupAt null and no file at backup with error',
      () async {
    Backup backup = Backup(type: BackupType.drive);
    Error e = GenericError("my generic error");

    when(backupRepository.save(backup: backup))
        .thenAnswer((_) => Future.value(null));
    when(googleApi.getBackupOnDrive()).thenAnswer((_) => Future.value(null));
    when(googleApi.doBackupOnDrive()).thenAnswer((_) => throw e);

    final ShowHomeInfo input = ShowHomeInfo(backup: backup);

    await homeBloc.checkAndDoBackup(input);

    expect(backup.updatedAt, customTime.millisecondsSinceEpoch);
    expect(backup.lastestBackupAt, null);
    expect(backup.lastestBackupStatus, BackupStatus.error);
    expect(backup.fileId, null);
    expect(backup.error, e.toString());
  });

  test('check and do backup: lastestBackupAt lower than recipe last updated at',
      () async {
    drive.File driveFile = drive.File();
    driveFile.id = 'new-drive-file-id';
    File backupFile = File('');

    Backup backup = Backup(
      type: BackupType.drive,
      lastestBackupAt: 9,
      fileId: driveFile.id,
    );

    DataSummary recipeSummary = DataSummary(lastUpdated: 11);
    DataSummary groceryListSummary = DataSummary(lastUpdated: 7);
    when(recipesRepository.getSummary())
        .thenAnswer((_) => Future.value(recipeSummary));
    when(groceryListsRepository.getSummary())
        .thenAnswer((_) => Future.value(groceryListSummary));
    when(backupRepository.save(backup: backup))
        .thenAnswer((_) => Future.value(null));
    when(googleApi.getBackupOnDrive())
        .thenAnswer((_) => Future.value(driveFile));
    when(googleApi.downloadBackupFromDrive(driveFile.id))
        .thenAnswer((_) => Future.value(backupFile));
    when(recipesRepository.mergeFromBackup(file: backupFile))
        .thenAnswer((_) => Future.value(null));
    when(googleApi.updateBackupOnDrive(driveFile.id))
        .thenAnswer((_) => Future.value(null));

    final ShowHomeInfo input = ShowHomeInfo(backup: backup);

    await homeBloc.checkAndDoBackup(input);

    expect(backup.updatedAt, customTime.millisecondsSinceEpoch);
    expect(backup.lastestBackupAt, customTime.millisecondsSinceEpoch);
    expect(backup.lastestBackupStatus, BackupStatus.done);
    expect(backup.fileId, driveFile.id);
    expect(backup.error, null);
  });

  test(
      'check and do backup: lastestBackupAt lower than grocery list last updated at',
      () async {
    drive.File driveFile = drive.File();
    driveFile.id = 'new-drive-file-id';
    File backupFile = File('');
    Error e = GenericError("my generic error");

    Backup backup = Backup(
      type: BackupType.drive,
      lastestBackupAt: 10,
      fileId: driveFile.id,
    );

    DataSummary recipeSummary = DataSummary(lastUpdated: 9);
    DataSummary groceryListSummary = DataSummary(lastUpdated: 12);
    when(recipesRepository.getSummary())
        .thenAnswer((_) => Future.value(recipeSummary));
    when(groceryListsRepository.getSummary())
        .thenAnswer((_) => Future.value(groceryListSummary));
    when(backupRepository.save(backup: backup))
        .thenAnswer((_) => Future.value(null));
    when(googleApi.getBackupOnDrive())
        .thenAnswer((_) => Future.value(driveFile));
    when(googleApi.downloadBackupFromDrive(driveFile.id))
        .thenAnswer((_) => Future.value(backupFile));
    when(recipesRepository.mergeFromBackup(file: backupFile))
        .thenAnswer((_) => Future.value(null));
    when(googleApi.updateBackupOnDrive(driveFile.id))
        .thenAnswer((_) => throw e);

    final ShowHomeInfo input = ShowHomeInfo(backup: backup);

    await homeBloc.checkAndDoBackup(input);

    expect(backup.updatedAt, customTime.millisecondsSinceEpoch);
    expect(backup.lastestBackupAt, 10);
    expect(backup.lastestBackupStatus, BackupStatus.error);
    expect(backup.fileId, driveFile.id);
    expect(backup.error, e.toString());
  });

  test('check and do backup: lastestBackupAt greater than all', () async {
    Backup backup = Backup(
      type: BackupType.drive,
      lastestBackupStatus: BackupStatus.pending,
      lastestBackupAt: 10,
    );

    DataSummary recipeSummary = DataSummary(lastUpdated: 9);
    DataSummary groceryListSummary = DataSummary(lastUpdated: 2);
    when(recipesRepository.getSummary())
        .thenAnswer((_) => Future.value(recipeSummary));
    when(groceryListsRepository.getSummary())
        .thenAnswer((_) => Future.value(groceryListSummary));

    final ShowHomeInfo input = ShowHomeInfo(backup: backup);

    await homeBloc.checkAndDoBackup(input);

    expect(backup.updatedAt, null);
    expect(backup.lastestBackupAt, 10);
    expect(backup.lastestBackupStatus, BackupStatus.pending);
    expect(backup.fileId, null);
    expect(backup.error, null);
  });
}
