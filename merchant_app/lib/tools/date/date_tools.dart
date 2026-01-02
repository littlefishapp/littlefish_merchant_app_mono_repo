DateTime getStartOfDay() {
  var currentDay = DateTime.now().toUtc();
  return DateTime(currentDay.year, currentDay.month, currentDay.day, 0, 1);
}

DateTime getEndOfDay() {
  return DateTime.now().toUtc();
}

DateTime getFirstDayOfWeek() {
  var currentDay = DateTime.now().toUtc();
  var firstDay = currentDay.subtract(Duration(days: currentDay.weekday));
  return DateTime(firstDay.year, firstDay.month, firstDay.day, 0, 1);
}

DateTime getLastDayOfWeek() {
  var currentDay = DateTime.now().toUtc();

  var remainingDays = 6 - currentDay.weekday;

  return currentDay.add(Duration(days: remainingDays));
}

DateTime getFirstDayOfMonth() {
  var currentDay = DateTime.now().toUtc();

  var firstDay = DateTime(currentDay.year, currentDay.month, 1);
  return DateTime(firstDay.year, firstDay.month, firstDay.day, 0, 1);
}

DateTime getLastDayOfMonth() {
  var currentDay = DateTime.now().toUtc();

  return DateTime(currentDay.year, currentDay.month + 1, 0);
}

DateTime getFirstDayThreeMonths() {
  var currentDay = DateTime.now().toUtc();

  var firstDay = DateTime(currentDay.year, currentDay.month - 2, 1);
  return DateTime(firstDay.year, firstDay.month, firstDay.day, 0, 1);
}

DateTime getLastDayThreeMonths() {
  var currentDay = DateTime.now().toUtc();

  return DateTime(currentDay.year, currentDay.month + 1, 0);
}

DateTime getFirstDayOfYear() {
  var currentDay = DateTime.now().toUtc();

  var firstDay = DateTime(currentDay.year, 1, 1);

  return DateTime(firstDay.year, firstDay.month, firstDay.day, 0, 1);
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

DateTime getFirstDayOfPrevWeek() {
  var currentDay = DateTime.now().toUtc();
  var firstDay = currentDay.subtract(Duration(days: currentDay.weekday + 7));

  return DateTime(firstDay.year, firstDay.month, firstDay.day, 0, 1);
}

DateTime getLastDayOfPrevWeek() {
  var currentDay0 = DateTime.now().toUtc();

  var currentDay = currentDay0.subtract(const Duration(days: 7));

  var remainingDays = 6 - currentDay.weekday;

  var lastDay = currentDay.add(Duration(days: remainingDays));

  return DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59);
}

DateTime getFirstDayOfPrevMonth() {
  var currentDay = DateTime.now().toUtc();

  var firstDay = DateTime(currentDay.year, currentDay.month - 1, 1);

  return DateTime(firstDay.year, firstDay.month, firstDay.day, 0, 1);
}

DateTime getLastDayOfPrevMonth() {
  var currentDay = DateTime.now().toUtc();

  var lastDay = DateTime(currentDay.year, currentDay.month, 0);
  return DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59);
}

// DateTime getFirstDayThreeMonths() {
//   var currentDay = DateTime.now().toUtc();

//   return DateTime(currentDay.year, currentDay.month - 2, 1);
// }

// DateTime getLastDayThreeMonths() {
//   var currentDay = DateTime.now().toUtc();

//   return DateTime(currentDay.year, currentDay.month + 1, 0);
// }

DateTime getFirstDayOfPrevYear() {
  var currentDay = DateTime.now().toUtc();

  var firstDay = DateTime(currentDay.year - 1, 1, 1);

  return DateTime(firstDay.year, firstDay.month, firstDay.day, 0, 1);
}

DateTime getLastDayOfPrevYear() {
  var currentDay = DateTime.now().toUtc();

  var lastDay = DateTime(currentDay.year - 1, 13, 0);
  return DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59);
}
