import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/bloc/home/events.dart';
import 'package:rtg_app/bloc/home/home_bloc.dart';
import 'package:rtg_app/bloc/home/states.dart';
import 'package:rtg_app/helper/log_helper.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/model/grocery_list.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/repository/backup_repository.dart';
import 'package:rtg_app/repository/grocery_list_item_market_section_repository.dart';
import 'package:rtg_app/repository/grocery_lists_repository.dart';
import 'package:rtg_app/repository/market_section_repository.dart';
import 'package:rtg_app/repository/menu_planning_repository.dart';
import 'package:rtg_app/repository/recipes_repository.dart';
import 'package:rtg_app/repository/user_data_repository.dart';
import 'package:rtg_app/screens/account_screen.dart';
import 'package:rtg_app/screens/save_grocery_list_screen.dart';
import 'package:rtg_app/screens/save_menu_planning_screen.dart';
import 'package:rtg_app/screens/save_note_screen.dart';
import 'package:rtg_app/screens/settings_screen.dart';
import 'package:rtg_app/screens/tutorial_screen.dart';
import 'package:rtg_app/screens/view_menu_planning_screen.dart';
import 'package:rtg_app/screens/view_recipe_screen.dart';
import 'package:rtg_app/theme/custom_colors.dart';
import 'package:rtg_app/widgets/custom_toast.dart';
import 'package:rtg_app/widgets/grocery_lists_widget.dart';
import 'package:rtg_app/widgets/home/home_card.dart';
import 'package:rtg_app/widgets/named_icon.dart';

import 'package:rtg_app/widgets/recipes_list_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../repository/recipe_label_repository.dart';
import '../widgets/home/bottom_bar_navgation_option.dart';
import '../widgets/home/home_grocery_list_card.dart';
import '../widgets/home/home_menu_planning_card.dart';
import 'menu_planning_history_screen.dart';
import 'save_recipe_screen.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  static newHomeBloc() {
    return BlocProvider(
      create: (context) => HomeBloc(
        backupRepository: BackupRepository(),
        recipesRepository: RecipesRepository(),
        groceryListsRepository: GroceryListsRepository(),
        userDataRepository: UserDataRepository(),
        menuPlanningRepository: MenuPlanningRepository(),
        recipeLabelRepository: RecipeLabelRepository(),
        marketSectionRepository: MarketSectionRepository(),
        groceryListItemMarketSectionRepository:
            GroceryListItemMarketSectionRepository(),
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
    if (Foundation.kDebugMode) {
      LogHelper.printAll();
    }
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
      if (state is SavedNewGroceryListState) {
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => onTapGroceryList(state.response.groceryList));
      }

      if (state is AllDataDeleted) {
        refreshData();
      }
      if (state is ShowHomeInfo) {
        showHomeInfo = state;
      }

      _widgetOptions = BottomBarNavigationOption.buildBottomBarNavigationOption(
        context,
        buildHomeBody(),
        _recipeKeyListkey,
        onTapRecipe,
        onRecipesFloatingActionButtonPressed,
        _groceryListsKeyListkey,
        onTapGroceryList,
        onGroceryListFloatingActionButtonPressed,
      );
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
        bottomNavigationBar: BottomBarNavigationOption.buildBottomNavigationBar(
            context, _selectedIndex, _onItemTapped),
      );
    });
  }

  List<Widget> getAppBarActions(HomeState state) {
    List<Widget> actions = [
      IconButton(
        key: Key(Keys.actionAccountIcon),
        icon: Icon(Icons.account_circle),
        tooltip: AppLocalizations.of(context).manage_account,
        onPressed: () async {
          await Navigator.pushNamed(context, AccountScreen.id);
          refreshData();
        },
      ),
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

  void onRecipesFloatingActionButtonPressed() async {
    final result = await Navigator.pushNamed(context, SaveRecipeScreen.id);
    if (result != null && result is Recipe) {
      CustomToast.showToast(
        text: AppLocalizations.of(context).saved_recipe,
        context: context,
        time: CustomToast.timeShort,
      );
    }
    refreshData();
  }

  void onGroceryListFloatingActionButtonPressed() {
    context.read<HomeBloc>().add(
        SaveNewGroceryList(GroceryList.getGroceryListDefaultTitle(context)));
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

  Widget buildHomeBody() {
    List<Widget> cards = [];

    if (showHomeInfo.backupNotConfigured) {
      cards.add(HomeCard(
        cardKey: Key(Keys.homeCardConfigureBackup),
        icon: Icons.warning,
        iconColor: CustomColors.darkRed,
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
        onAction: () async {
          await Navigator.pushNamed(
            context,
            TutorialScreen.id,
            arguments: TutorialData.createRecipe(context),
          );
        },
      ));
    }

    if (showHomeInfo.oldMenuPlanning != null ||
        showHomeInfo.currentMenuPlanning != null ||
        showHomeInfo.futureMenuPlanning != null) {
      cards.add(HomeCard(
        cardKey: Key(Keys.homeCardEditNote),
        title: AppLocalizations.of(context).notes,
        titleIcon: Icons.edit_note,
        titleIconKey: Key(Keys.homeCardEditNoteIcon),
        titleTooltip: AppLocalizations.of(context).make_notes,
        onTitleIconPressed: () {
          Navigator.pushNamed(context, SaveNoteScreen.id);
        },
      ));
    }

    if (showHomeInfo.currentMenuPlanning != null) {
      cards.add(HomeMenuPlanningCard(
        cardKey: Key(Keys.homeCardShowMenuPlanning),
        actionKey: Key(Keys.homeCardSeeCurrentMenuPlanning),
        title: AppLocalizations.of(context).current_menu_planning,
        currentMenuPlanning: showHomeInfo.currentMenuPlanning,
        currentMenuPlanningRecipes: showHomeInfo.currentMenuPlanningRecipes,
        action: AppLocalizations.of(context).see_details,
        onAction: () async {
          await Navigator.pushNamed(context, ViewMenuPlanningScreen.id,
              arguments: ViewMenuPlanningArguments(
                  showHomeInfo.currentMenuPlanning,
                  showHomeInfo.currentMenuPlanningRecipes));
          refreshData();
        },
        secundaryActionKey: Key(Keys.homeCardNewMenuPlanning),
        secundaryAction: AppLocalizations.of(context).create_new,
        onSecundaryAction: () async {
          await Navigator.pushNamed(context, SaveMenuPlanningScreen.id,
              arguments: SaveMenuPlanningArguments(
                  null, null, showHomeInfo.lastUsedGroceryListRecipes));
          refreshData();
        },
      ));
    }

    if (showHomeInfo.futureMenuPlanning != null) {
      cards.add(HomeMenuPlanningCard(
        cardKey: Key(Keys.homeCardShowMenuPlanning),
        actionKey: Key(Keys.homeCardSeeFutureMenuPlanning),
        title: AppLocalizations.of(context).next_menu_planning,
        currentMenuPlanning: showHomeInfo.futureMenuPlanning,
        currentMenuPlanningRecipes: showHomeInfo.futureMenuPlanningRecipes,
        action: AppLocalizations.of(context).see_details,
        onAction: () async {
          await Navigator.pushNamed(context, ViewMenuPlanningScreen.id,
              arguments: ViewMenuPlanningArguments(
                  showHomeInfo.futureMenuPlanning,
                  showHomeInfo.futureMenuPlanningRecipes));
          refreshData();
        },
      ));
    }

    if (showHomeInfo.lastUsedGroceryList != null) {
      if (showHomeInfo.currentMenuPlanning == null &&
          showHomeInfo.futureMenuPlanning == null) {
        cards.add(HomeCard(
          cardKey: Key(Keys.homeCardFirstMenuPlanning),
          icon: Icons.restaurant_menu,
          actionKey: Key(Keys.homeCardDoMenuPlanning),
          title: AppLocalizations.of(context).new_menu_planning_question,
          subtitle:
              AppLocalizations.of(context).first_menu_planning_explanation,
          action: AppLocalizations.of(context).create_new,
          onAction: () async {
            await Navigator.pushNamed(context, SaveMenuPlanningScreen.id,
                arguments: SaveMenuPlanningArguments(
                    null, null, showHomeInfo.lastUsedGroceryListRecipes));
            refreshData();
          },
        ));
      }
      cards.add(HomeGroceryListCard(
        cardKey: Key(Keys.homeCardLastGroceryListUsed),
        actionKey: Key(Keys.homeCardLastGroceryListUsedAction),
        title: AppLocalizations.of(context).last_grocery_list_used,
        lastUsedGroceryList: showHomeInfo.lastUsedGroceryList,
        lastUsedGroceryListRecipes: showHomeInfo.lastUsedGroceryListRecipes,
        onTapRecipe: onTapRecipe,
        onAction: () {
          onTapGroceryList(showHomeInfo.lastUsedGroceryList);
        },
      ));
    }

    if (showHomeInfo.oldMenuPlanning != null) {
      cards.add(HomeCard(
        cardKey: Key(Keys.homeCardOldMenuPlanning),
        actionKey: Key(Keys.homeCardMenuPlanningHistory),
        title: AppLocalizations.of(context).old_menu_plannings,
        subtitle:
            AppLocalizations.of(context).see_menu_planning_history_explanation,
        action: AppLocalizations.of(context).see_history,
        onAction: () async {
          await Navigator.pushNamed(context, MenuPlanningHistoryScreen.id);
          refreshData();
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
