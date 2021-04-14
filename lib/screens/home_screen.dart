import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/api/google_api.dart';
import 'package:rtg_app/bloc/home/events.dart';
import 'package:rtg_app/bloc/home/home_bloc.dart';
import 'package:rtg_app/bloc/home/states.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/repository/backup_repository.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:rtg_app/repository/user_data_repository.dart';
import 'package:rtg_app/screens/save_grocery_list_screen.dart';
import 'package:rtg_app/screens/settings_screen.dart';
import 'package:rtg_app/screens/view_recipe_screen.dart';
import 'package:rtg_app/widgets/custom_toast.dart';
import 'package:rtg_app/widgets/grocery_lists_widget.dart';
import 'package:rtg_app/widgets/home_card.dart';
import 'package:rtg_app/widgets/named_icon.dart';

import 'package:rtg_app/widgets/recipes_list_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'save_recipe_screen.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  static newHomeBloc() {
    return BlocProvider(
      create: (context) => HomeBloc(
        backupRepository: BackupRepository(),
        recipesRepository: RecipesRepository(),
        googleApi: GoogleApi.getGoogleApi(),
        groceryListsRepository: GroceryListsRepository(),
        userDataRepository: UserDataRepository(),
      ),
      child: HomeScreen(),
    );
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetHomeDataEvent());
    showHomeInfo = ShowHomeInfo(
        backupHasError: false,
        backupNotConfigured: false,
        backupOk: false,
        showRecipeTutorial: false);
  }

  ShowHomeInfo showHomeInfo;
  int _selectedIndex = 0;
  List<BottomBarNavigationOption> _widgetOptions;
  GlobalKey<RecipesListState> _recipeKeyListkey = GlobalKey();
  GlobalKey<GroceryListsState> _groceryListsKeyListkey = GlobalKey();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void refreshData() {
    if (_recipeKeyListkey != null && _recipeKeyListkey.currentState != null) {
      _recipeKeyListkey.currentState.loadRecipes();
    }
    if (_groceryListsKeyListkey != null &&
        _groceryListsKeyListkey.currentState != null) {
      _groceryListsKeyListkey.currentState.loadGroceryLists();
    }
    context.read<HomeBloc>().add(GetHomeDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, HomeState state) {
      if (state is AllDataDeleted) {
        refreshData();
      }
      if (state is ShowHomeInfo) {
        showHomeInfo = state;
      }

      buildWidgetList();
      return Scaffold(
        appBar: AppBar(
          title: Text(_widgetOptions.elementAt(_selectedIndex).title),
          actions: getAppBarActions(state),
        ),
        body: Container(
          child: Column(
            children: [
              _widgetOptions.elementAt(_selectedIndex).body,
            ],
          ),
        ),
        floatingActionButton:
            _widgetOptions.elementAt(_selectedIndex).floatingActionButton,
        bottomNavigationBar: getBottomNavigationBar(),
      );
    });
  }

  List<Widget> getAppBarActions(HomeState state) {
    List<Widget> actions = [
      NamedIcon(
        key: Key(Keys.homeActionSettingsIcon),
        tooltip: AppLocalizations.of(context).open_settings,
        iconData: Icons.settings,
        showNotification: showHomeInfo.backupNotConfigured,
        notificationKey: Keys.homeActionSettingsNotification,
        onPressed: () async {
          await Navigator.pushNamed(context, SettingsScreen.id);
          refreshData();
        },
      )
    ];

    if (Foundation.kDebugMode) {
      actions.add(IconButton(
        key: Key(Keys.actionDeleteAllIcon),
        icon: Icon(Icons.delete_forever),
        tooltip: 'Delete all database',
        onPressed: () async {
          context.read<HomeBloc>().add(DeleteAllDataEvent());
        },
      ));
    }

    return actions;
  }

  BottomNavigationBar getBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            key: Key(Keys.homeBottomBarHomeIcon),
          ),
          label: AppLocalizations.of(context).home,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.library_books,
            key: Key(Keys.homeBottomBarRecipesIcon),
          ),
          label: AppLocalizations.of(context).recipes,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list,
            key: Key(Keys.homeBottomBarListsIcon),
          ),
          label: AppLocalizations.of(context).lists,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }

  void buildWidgetList() {
    _widgetOptions = [
      BottomBarNavigationOption(
        title: AppLocalizations.of(context).home,
        body: buildHomeWidget(),
      ),
      BottomBarNavigationOption(
        title: AppLocalizations.of(context).recipes,
        floatingActionButton: FloatingActionButton(
          key: Key(Keys.homeFloatingActionNewRecipeButton),
          onPressed: () async {
            final result =
                await Navigator.pushNamed(context, SaveRecipeScreen.id);
            if (result != null && result is Recipe) {
              CustomToast.showToast(
                text: AppLocalizations.of(context).saved_recipe,
                context: context,
                time: CustomToast.timeShort,
              );
            }
            refreshData();
          },
          child: Icon(Icons.add),
        ),
        body: RecipesList.newRecipeListBloc(
          key: _recipeKeyListkey,
          onTapRecipe: onTapRecipe,
        ),
      ),
      BottomBarNavigationOption(
        title: AppLocalizations.of(context).lists,
        body: GroceryLists.newGroceryListsBloc(
          key: _groceryListsKeyListkey,
          onTapGroceryList: onTapGroceryList,
        ),
      ),
    ];
  }

  void onTapGroceryList(GroceryList groceryList) async {
    await Navigator.pushNamed(
      context,
      SaveGroceryListScreen.id,
      arguments: groceryList,
    );
    refreshData();
  }

  void onTapRecipe(Recipe recipe) async {
    await Navigator.pushNamed(
      context,
      ViewRecipeScreen.id,
      arguments: recipe,
    );
    refreshData();
  }

  Widget buildHomeWidget() {
    List<Widget> cards = [];

    if (showHomeInfo.backupNotConfigured) {
      cards.add(HomeCard(
        cardKey: Key(Keys.homeCardConfigureBackup),
        icon: Icons.warning,
        iconColor: Colors.yellowAccent,
        dimissKey: Key(Keys.homeCardConfigureBackupDismiss),
        actionKey: Key(Keys.homeCardConfigureBackupAction),
        title: AppLocalizations.of(context).no_backup_yet,
        subtitle: AppLocalizations.of(context).configure_backup_explanation,
        action: AppLocalizations.of(context).configure_backup_action,
        onAction: () async {
          await Navigator.pushNamed(context, SettingsScreen.id);
          refreshData();
        },
      ));
    }
    if (showHomeInfo.showRecipeTutorial) {
      cards.add(HomeCard(
        cardKey: Key(Keys.homeCardRecipeTutorial),
        icon: Icons.info,
        dimissKey: Key(Keys.homeCardRecipeTutorialDismiss),
        actionKey: Key(Keys.homeCardRecipeTutorialSeeTutorial),
        title: AppLocalizations.of(context).new_arround_here,
        subtitle: AppLocalizations.of(context).recipe_tutorial_explanation,
        onDismiss: () {
          context.read<HomeBloc>().add(DismissRecipeTutorial());
        },
        action: AppLocalizations.of(context).see_tutorial,
        onAction: () {
          CustomToast.showToast(
            text: 'TODO',
            context: context,
            time: CustomToast.timeShort,
          );
        },
      ));
    }

    if (showHomeInfo.lastUsedGroceryList != null) {
      cards.add(HomeCard(
        cardKey: Key(Keys.homeCardLastGroceryListUsed),
        actionKey: Key(Keys.homeCardLastGroceryListUsedAction),
        icon: Icons.list,
        title: AppLocalizations.of(context).last_grocery_list_used,
        lastUsedGroceryList: showHomeInfo.lastUsedGroceryList,
        lastUsedGroceryListRecipes: showHomeInfo.lastUsedGroceryListRecipes,
        onTapRecipe: onTapRecipe,
        onAction: () {
          onTapGroceryList(showHomeInfo.lastUsedGroceryList);
        },
      ));
    }

    return Expanded(
      child: cards.length > 0
          ? SingleChildScrollView(
              padding: EdgeInsets.all(5),
              child: ListBody(
                children: cards,
              ),
            )
          : Center(
              child: Text(
                AppLocalizations.of(context).no_relevant_info_for_you,
                key: Key(Keys.homeBottomBarHomeText),
              ),
            ),
    );
  }
}

class BottomBarNavigationOption {
  final String title;
  final Widget body;
  final FloatingActionButton floatingActionButton;
  BottomBarNavigationOption({this.body, this.title, this.floatingActionButton});
}
