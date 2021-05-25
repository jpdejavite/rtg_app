import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/save_menu_planning_response.dart';

abstract class SaveMenuPlanningState extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveMenuPlanningInitState extends SaveMenuPlanningState {}

class MenuPlanningSaved extends SaveMenuPlanningState {
  final SaveMenuPlanningResponse response;
  MenuPlanningSaved({this.response});
}
