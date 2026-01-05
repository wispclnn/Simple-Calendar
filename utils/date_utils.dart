/// Number of days in a given month of a given year.
int daysInMonth(DateTime date) {
  final firstDayThisMonth = DateTime(date.year, date.month, 1);
  final firstDayNextMonth = DateTime(
    firstDayThisMonth.year,
    firstDayThisMonth.month + 1,
    1,
  );
  return firstDayNextMonth.subtract(const Duration(days: 1)).day;
}

/// Weekday of the first day of the month (1 = Monday, 7 = Sunday)
int firstWeekdayOfMonth(DateTime date) {
  final firstDay = DateTime(date.year, date.month, 1);
  return firstDay.weekday;
}

/// Compare dates ignoring time (year, month, day only)
bool isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Previous month, same day if possible (falls back to last valid day)
DateTime prevMonth(DateTime date) {
  final year = date.month == 1 ? date.year - 1 : date.year;
  final month = date.month == 1 ? 12 : date.month - 1;
  final day = date.day;
  final lastDay = daysInMonth(DateTime(year, month, 1));
  return DateTime(year, month, day > lastDay ? lastDay : day);
}

/// Next month, same day if possible (falls back to last valid day)
DateTime nextMonth(DateTime date) {
  final year = date.month == 12 ? date.year + 1 : date.year;
  final month = date.month == 12 ? 1 : date.month + 1;
  final day = date.day;
  final lastDay = daysInMonth(DateTime(year, month, 1));
  return DateTime(year, month, day > lastDay ? lastDay : day);
}

/// Friendly string like "2025-11-17"
String formatDateFriendly(DateTime date) {
  final mm = date.month.toString().padLeft(2, '0');
  final dd = date.day.toString().padLeft(2, '0');
  return '${date.year}-$mm-$dd';
}

/// Key for maps (yyyy-MM-dd)
String dateKey(DateTime date) => formatDateFriendly(date);
