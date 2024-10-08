import 'package:rtg_app/model/menu_planning_side_dish.dart';

import 'menu_planning_meal_type.dart';
import 'menu_planning_meal_type_preparation.dart';

class MenuPlanningMeal {
  MenuPlanningMeal({
    this.type,
    this.preparation,
    this.recipeId,
    this.description,
    this.sideDishes,
  });
  MenuPlanningMeal.fromMeal(MenuPlanningMeal meal) {
    this.type = meal.type;
    this.preparation = meal.preparation;
    this.recipeId = meal.recipeId;
    this.description = meal.description;
    if (meal.sideDishes != null) {
      this.sideDishes = meal.sideDishes.map<MenuPlanningSideDish>((sideDish) {
        return MenuPlanningSideDish.fromSideDish(sideDish);
      }).toList();
    }
  }

  MenuPlanningMealType type;
  MenuPlanningMealPreparation preparation;
  String recipeId;
  String description;
  List<MenuPlanningSideDish> sideDishes;

  int sideDishesCount() {
    return this.sideDishes == null ? 0 : this.sideDishes.length;
  }

  static Map<String, List<MenuPlanningMeal>> fromObject(Object object) {
    if (object == null || !(object is Map<String, Object>)) {
      return Map<String, List<MenuPlanningMeal>>();
    }

    Map<String, List<MenuPlanningMeal>> map =
        Map<String, List<MenuPlanningMeal>>();

    Map<String, Object> objects = object;
    objects.forEach((key, value) {
      if (value is List<Object>) {
        List<MenuPlanningMeal> meals = [];
        value.forEach((element) {
          if (element is Map<String, Object>) {
            meals.add(MenuPlanningMeal.fromMap(element));
          }
        });
        map[key] = meals;
      }
    });

    return map;
  }

  factory MenuPlanningMeal.fromMap(Map<String, Object> record) {
    return MenuPlanningMeal(
      type: MenuPlanningMealType.values[record["type"] as int],
      preparation:
          MenuPlanningMealPreparation.values[record["preparation"] as int],
      recipeId: record["recipeId"],
      description: record["description"],
      sideDishes: MenuPlanningSideDish.fromObject(record["sideDishes"]),
    );
  }

  static Object toRecords(Map<String, List<MenuPlanningMeal>> days) {
    if (days == null || days.length == 0) {
      return null;
    }

    Map<String, Object> objects = Map<String, Object>();
    days.forEach((day, meals) {
      List<Object> objs = [];
      meals.forEach((meal) {
        objs.add({
          'type': meal.type.index,
          'preparation': meal.preparation.index,
          'recipeId': meal.recipeId,
          'description': meal.description,
          'sideDishes': MenuPlanningSideDish.toRecords(meal.sideDishes),
        });
      });
      objects[day] = objs;
    });

    return objects;
  }
}
