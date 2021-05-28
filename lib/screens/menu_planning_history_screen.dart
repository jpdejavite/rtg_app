import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/bloc/menu_planning_history/events.dart';
import 'package:rtg_app/bloc/menu_planning_history/menu_planning_history_bloc.dart';
import 'package:rtg_app/bloc/menu_planning_history/states.dart';
import 'package:rtg_app/helper/date_formatter.dart';
import 'package:rtg_app/model/menu_planning.dart';
import 'package:rtg_app/model/menu_planning_collection.dart';
import 'package:rtg_app/model/recipe.dart';
import 'package:rtg_app/model/search_menu_plannings_params.dart';
import 'package:rtg_app/repository/menu_planning_repository.dart';
import 'package:rtg_app/screens/view_menu_planning_screen.dart';
import 'package:rtg_app/widgets/loading.dart';
import 'package:rtg_app/widgets/loading_row.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/keys/keys.dart';

class MenuPlanningHistoryScreen extends StatefulWidget {
  static String id = 'menu_planning_history_screen';

  static newChooseMenuPlanningBloc() {
    return BlocProvider(
      create: (context) => MenuPlanningHistoryBloc(
          menuPlanningRepository: MenuPlanningRepository()),
      child: MenuPlanningHistoryScreen(),
    );
  }

  @override
  _MenuPlanningHistoryState createState() => _MenuPlanningHistoryState();
}

class _MenuPlanningHistoryState extends State<MenuPlanningHistoryScreen> {
  int defaultLimit = 20;
  @override
  void initState() {
    super.initState();
    loadMenuPlannings();
  }

  loadMenuPlannings() async {
    context.read<MenuPlanningHistoryBloc>().add(
          StartFetchMenuPlanningEvent(
            SearchMenuPlanningParams(limit: defaultLimit),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuPlanningHistoryBloc, MenuPlanningHistoryState>(
        builder: (BuildContext context, MenuPlanningHistoryState state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).menu_planning_history),
        ),
        body: Container(
          child: body(state),
        ),
      );
    });
  }

  Widget body(MenuPlanningHistoryState state) {
    MenuPlanningCollection collection;
    if (state is MenuPlanningLoaded) {
      collection = state.collection;
    }

    return Column(
      children: [
        buildList(collection),
      ],
    );
  }

  Widget buildList(MenuPlanningCollection collection) {
    if (collection == null || collection.menuPlannings == null) {
      return Loading();
    }

    if (collection.menuPlannings.length == 0) {
      return Expanded(
        child: Center(
          child: Text(
            AppLocalizations.of(context).empty_menu_planning_list,
            key: Key(Keys.menuPlanningHistoryListEmptyText),
          ),
        ),
      );
    }

    bool hasLoadedAll = (collection.menuPlannings.length == collection.total);
    return Expanded(
      child: ListView.builder(
        key: Key(Keys.recipesList),
        itemCount: collection.menuPlannings.length + (hasLoadedAll ? 0 : 1),
        itemBuilder: (_, index) {
          if (!hasLoadedAll && index == collection.menuPlannings.length) {
            context.read<MenuPlanningHistoryBloc>().add(FetchMenuPlanningEvent(
                SearchMenuPlanningParams(
                    limit: defaultLimit,
                    offset: collection.menuPlannings.length)));
            return LoadingRow();
          }

          MenuPlanning menuPlanning = collection.menuPlannings[index];
          DateTime starAt = DateTime.parse(menuPlanning.startAt);
          DateTime endAt = DateTime.parse(menuPlanning.endAt);
          String title =
              '${DateFormatter.getMenuPlanningDayString(starAt, context)} - ${DateFormatter.getMenuPlanningDayString(endAt, context)}';
          List<Recipe> recipes = collection.menuPlanningsRecipes[menuPlanning];
          List<String> recipeTitles = [];
          if (recipes != null) {
            recipes.forEach((recipe) {
              recipeTitles.add(recipe.title);
            });
          }
          Widget item = InkWell(
              onTap: () async {
                await Navigator.pushNamed(context, ViewMenuPlanningScreen.id,
                    arguments:
                        ViewMenuPlanningArguments(menuPlanning, recipes));
              },
              child: Card(
                // key: cardKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline6,
                        key:
                            Key(Keys.recipeListRowTitleText + index.toString()),
                      ),
                      subtitle: Text(recipeTitles.join('\n')),
                    ),
                  ],
                ),
              ));
          if (hasLoadedAll && index == collection.menuPlannings.length - 1) {
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
