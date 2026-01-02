DateTime getFirstDayOfWeek() {
  var currentDay = DateTime.now().toUtc();
  return currentDay.subtract(Duration(days: currentDay.weekday));
}

DateTime getLastDayOfWeek() {
  var currentDay = DateTime.now().toUtc();

  var remainingDays = 6 - currentDay.weekday;

  return currentDay.add(Duration(days: remainingDays));
}

DateTime getFirstDayOfMonth() {
  var currentDay = DateTime.now().toUtc();

  return DateTime(currentDay.year, currentDay.month, 1);
}

DateTime getLastDayOfMonth() {
  var currentDay = DateTime.now().toUtc();

  return DateTime(currentDay.year, currentDay.month + 1, 0);
}

DateTime getFirstDayThreeMonths() {
  var currentDay = DateTime.now().toUtc();

  return DateTime(currentDay.year, currentDay.month - 2, 1);
}

DateTime getLastDayThreeMonths() {
  var currentDay = DateTime.now().toUtc();

  return DateTime(currentDay.year, currentDay.month + 1, 0);
}

DateTime getFirstDayOfYear() {
  var currentDay = DateTime.now().toUtc();

  return DateTime(currentDay.year, 1, 1);
}

DateTime getLastDayOfYear() {
  var currentDay = DateTime.now().toUtc();

  return DateTime(currentDay.year, 13, 0);
}

DateTime customToUTC(int year, int? month, int? day) {
  if (month != null && day != null) {
    return DateTime.utc(year, month, day).toLocal();
  }
  if (month != null) {
    return DateTime.utc(year, month).toLocal();
  }
  if (month == null && day == null) {
    return DateTime.utc(year).toLocal();
  }

  return DateTime.now().toLocal();
}
