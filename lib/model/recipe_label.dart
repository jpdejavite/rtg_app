import 'package:sembast/sembast.dart';

List<RecipeLabel> recipeLabelsFromRecords(
        List<RecordSnapshot<int, Map<String, Object>>> records) =>
    List<RecipeLabel>.from(
        records.map((r) => RecipeLabel.fromRecord(r.key, r.value)));

class RecipeLabel {
  RecipeLabel({
    this.id,
    this.title,
  });

  String id;
  String title;

  bool hasId() {
    return this.id != null && this.id != '' && this.id != '0';
  }

  factory RecipeLabel.fromRecord(int id, Map<String, Object> record) {
    return RecipeLabel(
      id: id.toString(),
      title: record['title'],
    );
  }

  Object toRecord() {
    return {
      'title': this.title,
    };
  }

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is RecipeLabel)) {
      return false;
    }

    return id == other.id && title == other.title;
  }

  @override
  int get hashCode => super.hashCode;
}
