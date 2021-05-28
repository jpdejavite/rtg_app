import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/bloc/menu_planning_history/states.dart';
import 'package:rtg_app/model/menu_planning_collection.dart';
import 'package:rtg_app/repository/menu_planning_repository.dart';

import 'events.dart';

// TODO unit tests
class MenuPlanningHistoryBloc
    extends Bloc<MenuPlanningHistoryEvents, MenuPlanningHistoryState> {
  MenuPlanningCollection _collection =
      MenuPlanningCollection(menuPlannings: []);
  final MenuPlanningRepository menuPlanningRepository;
  MenuPlanningHistoryBloc({this.menuPlanningRepository})
      : super(MenuPlanningInitState());

  @override
  Stream<MenuPlanningHistoryState> mapEventToState(
      MenuPlanningHistoryEvents event) async* {
    if (event is StartFetchMenuPlanningEvent) {
      _collection = await menuPlanningRepository.fetch(event.searchParams);
      yield MenuPlanningLoaded(_collection);
    } else if (event is FetchMenuPlanningEvent) {
      MenuPlanningCollection menuPlanningsCollection =
          await menuPlanningRepository.fetch(event.searchParams);

      _collection.menuPlannings.addAll(menuPlanningsCollection.menuPlannings);
      _collection.total = menuPlanningsCollection.total;
      yield MenuPlanningLoaded(MenuPlanningCollection(
        menuPlannings: _collection.menuPlannings,
        total: _collection.total,
      ));
    }
  }
}
