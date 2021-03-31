import 'data_summary.dart';

class DatabaseSummary {
  final DataSummary recipes;
  DatabaseSummary({this.recipes});

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is DatabaseSummary)) {
      return false;
    }

    return recipes == other.recipes;
  }

  @override
  int get hashCode => super.hashCode;
}
