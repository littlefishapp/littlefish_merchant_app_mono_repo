// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/tools/date/date_tools.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

// import 'package:date_range_picker/date_range_picker.dart' as dateRangePicker;

typedef LoadReportCallBack = Future Function(BuildContext? context);

typedef OnReportLoadedCallback = Function(dynamic data);

mixin ReportVMBase {
  ReportMode? mode;

  ReportMode? initialMode;

  Function? onLoad;

  Function? search;

  late LoadReportCallBack runReport;

  OnReportLoadedCallback? reportLoaded;

  DateTime? _startDate;

  DateTime get startDate {
    if (mode == ReportMode.custom) return _startDate ?? DateTime.now().toUtc();

    if (mode == ReportMode.day) return getStartOfDay();

    if (mode == ReportMode.week) return getFirstDayOfWeek();

    if (mode == ReportMode.month) return getFirstDayOfMonth();

    if (mode == ReportMode.threeMonths) return getFirstDayThreeMonths();

    if (mode == ReportMode.year) return getFirstDayOfYear();

    return DateTime.now().toUtc();
  }

  DateTime? _endDate;

  DateTime get endDate {
    if (mode == ReportMode.custom) return _endDate ?? DateTime.now().toUtc();

    if (mode == ReportMode.day) return getEndOfDay();

    if (mode == ReportMode.week) return getLastDayOfWeek();

    if (mode == ReportMode.month) return getLastDayOfMonth();

    if (mode == ReportMode.threeMonths) return getLastDayThreeMonths();

    if (mode == ReportMode.year) return getLastDayOfYear();

    return DateTime.now().toUtc();
  }

  String get dateSelectionString {
    if (mode == ReportMode.day) {
      return "Today, ${TextFormatter.toShortDate(dateTime: startDate, format: "MMM dd, yyyy")}";
    }

    if (mode == ReportMode.week) {
      return "This Week, ${TextFormatter.toShortDate(dateTime: startDate, format: "MMM dd, yyyy")} -  ${TextFormatter.toShortDate(dateTime: endDate, format: "MMM dd, yyyy")}";
    }

    if (mode == ReportMode.month) {
      return "This Month, ${TextFormatter.toShortDate(dateTime: startDate, format: "MMM dd, yyyy")} -  ${TextFormatter.toShortDate(dateTime: endDate, format: "MMM dd, yyyy")}";
    }

    if (mode == ReportMode.threeMonths) {
      return "Current 3 Months, ${TextFormatter.toShortDate(dateTime: startDate, format: "MMM dd, yyyy")} -  ${TextFormatter.toShortDate(dateTime: endDate, format: "MMM dd, yyyy")}";
    }

    if (mode == ReportMode.year) {
      return "This Year, ${TextFormatter.toShortDate(dateTime: startDate, format: "MMM dd, yyyy")} -  ${TextFormatter.toShortDate(dateTime: endDate, format: "MMM dd, yyyy")}";
    }

    if (mode == ReportMode.custom) {
      return "Custom, ${TextFormatter.toShortDate(dateTime: startDate, format: "MMM dd, yyyy")} -  ${TextFormatter.toShortDate(dateTime: endDate, format: "MMM dd, yyyy")}";
    }

    return 'in progress';
  }

  void changeDates(DateTime startDate, DateTime endDate) {
    _startDate = startDate;
    _endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
  }

  changeMode(ReportMode value) {
    if (mode != value) {
      mode = value;
    }
  }

  Future<List<DateTime>?> selectDateRange(BuildContext context) async {
    final themeData = Theme.of(context);

    final locale = MaterialLocalizations.of(context);

    final range = await showDateRangePicker(
      locale: const Locale('en', 'GB'),
      context: context,
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
      firstDate: DateTime(DateTime.now().toUtc().year - 1),
      lastDate: DateTime(DateTime.now().toUtc().year + 1),
      builder: (context, Widget? child) => Theme(
        data: themeData.copyWith(
          appBarTheme: themeData.appBarTheme.copyWith(color: Colors.white),
          colorScheme: ColorScheme.light(
            onPrimary: Theme.of(context).colorScheme.primary,
            primary: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: child!,
      ),
    );

    //need to get the report again...
    if (range != null) {
      return [range.start, range.end];
    } else {
      return null;
    }
  }
}
