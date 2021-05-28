import 'package:equatable/equatable.dart';
import 'package:rtg_app/model/search_menu_plannings_params.dart';

abstract class MenuPlanningHistoryEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMenuPlanningEvent extends MenuPlanningHistoryEvents {
  final SearchMenuPlanningParams searchParams;
  FetchMenuPlanningEvent(this.searchParams);
  @override
  List<Object> get props => [searchParams];
}

class StartFetchMenuPlanningEvent extends FetchMenuPlanningEvent {
  StartFetchMenuPlanningEvent(SearchMenuPlanningParams searchParams)
      : super(searchParams);
}
