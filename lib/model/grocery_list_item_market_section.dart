import 'package:sembast/sembast.dart';

List<GroceryListItemMarketSection> groceryListItemMarketSectionsFromRecords(
        List<RecordSnapshot<int, Map<String, Object>>> records) =>
    List<GroceryListItemMarketSection>.from(records
        .map((r) => GroceryListItemMarketSection.fromRecord(r.key, r.value)));

class GroceryListItemMarketSection {
  GroceryListItemMarketSection({
    this.id,
    this.marketSectionId,
    this.groceryListItemName,
  });

  String id;
  String marketSectionId;
  String groceryListItemName;

  static GroceryListItemMarketSection getFromList(String id,
      List<GroceryListItemMarketSection> groceryListItemMarketSections) {
    return groceryListItemMarketSections.singleWhere(
        (groceryListItemMarketSection) => id == groceryListItemMarketSection.id,
        orElse: () => null);
  }

  bool hasId() {
    return this.id != null && this.id != '' && this.id != '0';
  }

  factory GroceryListItemMarketSection.fromRecord(
      int id, Map<String, Object> record) {
    return GroceryListItemMarketSection(
      id: id.toString(),
      marketSectionId: record['marketSectionId'],
      groceryListItemName: record['groceryListItemName'],
    );
  }

  Object toRecord() {
    return {
      'marketSectionId': this.marketSectionId,
      'groceryListItemName': this.groceryListItemName,
    };
  }
}
