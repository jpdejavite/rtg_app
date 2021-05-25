import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/model/save_menu_planning_response.dart';
import 'package:rtg_app/repository/menu_planning_repository.dart';

import 'events.dart';
import 'states.dart';

class SaveMenuPlanningBloc
    extends Bloc<SaveMenuPlanningEvents, SaveMenuPlanningState> {
  final MenuPlanningRepository menuPlanningRepo;
  SaveMenuPlanningBloc({this.menuPlanningRepo})
      : super(SaveMenuPlanningInitState());
  @override
  Stream<SaveMenuPlanningState> mapEventToState(
      SaveMenuPlanningEvents event) async* {
    if (event is SaveMenuPlanningEvent) {
      SaveMenuPlanningResponse response =
          await menuPlanningRepo.save(event.menuPlanning);
      yield MenuPlanningSaved(response: response);
    }
  }
}
