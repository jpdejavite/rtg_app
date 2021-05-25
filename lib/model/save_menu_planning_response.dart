import 'menu_planning.dart';

class SaveMenuPlanningResponse {
  final error;
  final MenuPlanning menuPlanning;

  SaveMenuPlanningResponse({this.error, this.menuPlanning});

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is SaveMenuPlanningResponse)) {
      return false;
    }

    if (error != other.error) {
      return false;
    }

    return menuPlanning == other.menuPlanning;
  }

  @override
  int get hashCode => super.hashCode;
}
