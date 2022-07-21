import 'package:rtg_app/helper/custom_date_time.dart';
import 'package:rtg_app/helper/id_generator.dart';
import 'package:sembast/sembast.dart';

List<MarketSection> marketSectionsFromRecords(
        List<RecordSnapshot<int, Map<String, Object>>> records) =>
    List<MarketSection>.from(
        records.map((r) => MarketSection.fromRecord(r.key, r.value)));

class MarketSection {
  MarketSection({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.groceryListOrder,
  });

  String id;
  int createdAt;
  int updatedAt;
  String title;
  int groceryListOrder;

  static newEmptyMarketSection() {
    return MarketSection(
      id: IdGenerator.id(),
      title: '',
      createdAt: CustomDateTime.current.millisecondsSinceEpoch,
    );
  }

  static MarketSection getFromList(
      String id, List<MarketSection> marketSections) {
    return marketSections.singleWhere((marketSection) => id == marketSection.id,
        orElse: () => null);
  }

  bool hasId() {
    return this.id != null && this.id != '' && this.id != '0';
  }

  factory MarketSection.fromRecord(int id, Map<String, Object> record) {
    return MarketSection(
      id: id.toString(),
      createdAt: record['createdAt'],
      updatedAt: record['updatedAt'],
      title: record['title'],
      groceryListOrder: record['groceryListOrder'],
    );
  }

  Object toRecord() {
    return {
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'title': this.title,
      'groceryListOrder': this.groceryListOrder,
    };
  }
}
