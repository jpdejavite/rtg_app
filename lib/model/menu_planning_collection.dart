import 'package:rtg_app/model/recipe.dart';

import 'menu_planning.dart';

class MenuPlanningCollection {
  MenuPlanningCollection({
    this.menuPlannings,
    this.menuPlanningsRecipes,
    this.total,
  });

  List<MenuPlanning> menuPlannings;
  Map<MenuPlanning, List<Recipe>> menuPlanningsRecipes;
  int total;

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is MenuPlanningCollection)) {
      return false;
    }

    if (total != other.total) {
      return false;
    }

    if (menuPlannings.length != other.menuPlannings.length) {
      return false;
    }

    bool areEqual = true;
    menuPlannings.asMap().forEach((i, menuPlanning) {
      if (menuPlanning.id != other.menuPlannings[i].id) {
        areEqual = false;
      }
    });
    return areEqual;
  }

  @override
  int get hashCode => super.hashCode;
}
