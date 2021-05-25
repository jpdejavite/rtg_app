import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/menu_planning.dart';

abstract class SaveMenuPlanningEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveMenuPlanningEvent extends SaveMenuPlanningEvents {
  final MenuPlanning menuPlanning;
  SaveMenuPlanningEvent({this.menuPlanning});
}
