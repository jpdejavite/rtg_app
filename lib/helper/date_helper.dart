class DateHelper {
  static DateTime endOfDay(DateTime d) {
    return DateTime(d.year, d.month, d.day, 23, 59, 59, 999, 999999);
  }

  static DateTime beginOfDay(DateTime d) {
    return DateTime(d.year, d.month, d.day, 0, 0, 0, 0, 0);
  }
}
