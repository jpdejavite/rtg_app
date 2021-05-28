import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/menu_planning_collection.dart';

abstract class MenuPlanningHistoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class MenuPlanningInitState extends MenuPlanningHistoryState {}

class MenuPlanningLoaded extends MenuPlanningHistoryState {
  final MenuPlanningCollection collection;
  MenuPlanningLoaded(this.collection);
  @override
  List<Object> get props => [collection];
}
