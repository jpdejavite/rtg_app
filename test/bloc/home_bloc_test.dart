import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:rtg_app/bloc/home/events.dart';
import 'package:rtg_app/bloc/home/home_bloc.dart';
import 'package:rtg_app/bloc/home/states.dart';
import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/model/backup.dart';
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
import 'package:rtg_app/repository/grocery_list_item_market_section_repository.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/market_section_repository.dart';
import 'package:rtg_app/repository/menu_planning_repository.dart';
import 'package:rtg_app/repository/recipe_label_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:rtg_app/repository/user_data_repository.dart';

class MockBackupRepository extends Mock implements BackupRepository {}

class MockRecipesRepository extends Mock implements RecipesRepository {}

class MockGroceryListsRepository extends Mock
    implements GroceryListsRepository {}

class MockUserDataRepository extends Mock implements UserDataRepository {}

class MockMenuPlanningRepository extends Mock
    implements MenuPlanningRepository {}

class MockRecipeLabelRepository extends Mock implements RecipeLabelRepository {}

class MockMarketSectionRepository extends Mock
    implements MarketSectionRepository {}

class MockGroceryListItemMarketSectionRepository extends Mock
    implements GroceryListItemMarketSectionRepository {}

void main() {
  HomeBloc homeBloc;
  MockBackupRepository backupRepository;
  MockRecipesRepository recipesRepository;
  MockGroceryListsRepository groceryListsRepository;
  UserDataRepository userDataRepository;
  MockMenuPlanningRepository menuPlanningRepository;
  MockRecipeLabelRepository recipeLabelRepository;
  MockMarketSectionRepository marketSectionRepository;
  MockGroceryListItemMarketSectionRepository
      groceryListItemMarketSectionRepository;
  DateTime customTime = DateTime.parse("2000-07-20 20:18:04");

  setUp(() {
    backupRepository = MockBackupRepository();
    recipesRepository = MockRecipesRepository();
    groceryListsRepository = MockGroceryListsRepository();
    userDataRepository = MockUserDataRepository();
    menuPlanningRepository = MockMenuPlanningRepository();
    recipeLabelRepository = MockRecipeLabelRepository();
    marketSectionRepository = MockMarketSectionRepository();
    groceryListItemMarketSectionRepository =
        MockGroceryListItemMarketSectionRepository();
    CustomDateTime.customTime = customTime;
    homeBloc = HomeBloc(
      backupRepository: backupRepository,
      recipesRepository: recipesRepository,
      groceryListsRepository: groceryListsRepository,
      userDataRepository: userDataRepository,
      menuPlanningRepository: menuPlanningRepository,
      recipeLabelRepository: recipeLabelRepository,
      marketSectionRepository: marketSectionRepository,
      groceryListItemMarketSectionRepository:
          groceryListItemMarketSectionRepository,
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
    when(menuPlanningRepository.fetch(SearchMenuPlanningParams(limit: 2)))
        .thenAnswer((_) => Future.value(MenuPlanningCollection(
            menuPlannings: [old1, old2], menuPlanningsRecipes: Map())));

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
    when(menuPlanningRepository.fetch(SearchMenuPlanningParams(limit: 2)))
        .thenAnswer((_) => Future.value(MenuPlanningCollection(
            menuPlannings: [current, old1], menuPlanningsRecipes: Map())));

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
    when(menuPlanningRepository.fetch(SearchMenuPlanningParams(limit: 2)))
        .thenAnswer((_) => Future.value(MenuPlanningCollection(
            menuPlannings: [future, current], menuPlanningsRecipes: Map())));

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
    when(recipeLabelRepository.deleteAll())
        .thenAnswer((_) => Future.value(null));
    when(marketSectionRepository.deleteAll())
        .thenAnswer((_) => Future.value(null));
    when(groceryListItemMarketSectionRepository.deleteAll())
        .thenAnswer((_) => Future.value(null));

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
}
