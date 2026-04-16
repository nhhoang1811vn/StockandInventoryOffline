class DateTimeUtils {
  DateTimeUtils._(); // coverage:ignore-line
  static DateTime addMonths(DateTime currentDate, int monthsToAdd) {
    // Calculate the new month
    int newMonth = currentDate.month + monthsToAdd;
    int newYear = currentDate.year;

    // Adjust the year and month if the month exceeds 12 or is less than 1
    while (newMonth > 12) {
      newMonth -= 12;
      newYear += 1;
    }
    while (newMonth < 1) {
      newMonth += 12;
      newYear -= 1;
    }

    // Create the new DateTime
    DateTime newDate = DateTime(newYear, newMonth, currentDate.day);

    // If the new month has fewer days than the original day, adjust the day
    if (newDate.month != newMonth) {
      newDate = DateTime(newYear, newMonth + 1, 0); // Last day of the new month
    }

    return newDate;
  }
}
