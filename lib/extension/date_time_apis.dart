extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return (year == other.year && month == other.month && day == other.day);
  }
  DateTime endOfYesterday() {
    final yesterday = DateTime(year, month, day).subtract(Duration(days: 1));
    return DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
  }
  DateTime startOfDay(){
    return DateTime(year, month, day);
  }
  DateTime endOfDay() {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }
}
