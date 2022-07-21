class MenuPlanningSideDish {
  MenuPlanningSideDish({
    this.recipeId,
    this.description,
  });
  MenuPlanningSideDish.fromSideDish(MenuPlanningSideDish sideDish) {
    this.recipeId = sideDish.recipeId;
    this.description = sideDish.description;
  }

  String recipeId;
  String description;

  static List<MenuPlanningSideDish> fromObject(Object object) {
    if (object == null || !(object is List<Object>)) {
      return null;
    }

    List<MenuPlanningSideDish> sideDishes = [];

    List<Object> objects = object;
    objects.forEach((object) {
      if (object is Map<String, Object>) {
        sideDishes.add(MenuPlanningSideDish.fromMap(object));
      }
    });

    return sideDishes;
  }

  factory MenuPlanningSideDish.fromMap(Map<String, Object> record) {
    return MenuPlanningSideDish(
      recipeId: record["recipeId"],
      description: record["description"],
    );
  }

  static Object toRecords(List<MenuPlanningSideDish> sideDishes) {
    if (sideDishes == null || sideDishes.length == 0) {
      return null;
    }

    List<Object> objects = [];
    sideDishes.forEach((sideDish) {
      objects.add({
        'recipeId': sideDish.recipeId,
        'description': sideDish.description,
      });
    });

    return objects;
  }
}
