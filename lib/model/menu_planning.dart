import 'package:sembast/sembast.dart';

import 'menu_planning_meal.dart';

enum MenuPlanningType { week }

List<MenuPlanning> menuPlanningsFromRecords(
        List<RecordSnapshot<int, Map<String, Object>>> records) =>
    List<MenuPlanning>.from(
        records.map((r) => MenuPlanning.fromRecord(r.key, r.value)));

class MenuPlanning {
  static String dateFormat = 'yyyyMMdd';

  MenuPlanning({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.startAt,
    this.endAt,
    this.days,
  });

  String id;
  int createdAt;
  int updatedAt;
  MenuPlanningType type;
  String startAt; // YYYYMMDD
  String endAt; // YYYYMMDD
  Map<String, List<MenuPlanningMeal>> days;

  bool hasId() {
    return this.id != null && this.id != "" && this.id != "0";
  }

  List<String> recipeIds() {
    if (days == null || days.length == 0) {
      return null;
    }

    List<String> recipeIds = [];
    days.forEach((day, meals) {
      meals.forEach((meal) {
        if (meal.recipeId != null && meal.recipeId != '') {
          recipeIds.add(meal.recipeId);
        }
      });
    });

    return recipeIds;
  }

  factory MenuPlanning.fromRecord(int id, Map<String, Object> record) {
    return MenuPlanning(
      id: id.toString(),
      createdAt: record["createdAt"],
      updatedAt: record["updatedAt"],
      type: MenuPlanningType.values[record["type"] as int],
      startAt: record["startAt"],
      endAt: record["endAt"],
      days: MenuPlanningMeal.fromObject(record["days"]),
    );
  }

  Object toRecord() {
    return {
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'type': this.type.index,
      'startAt': this.startAt,
      'endAt': this.endAt,
      'days': MenuPlanningMeal.toRecords(this.days),
    };
  }
}
