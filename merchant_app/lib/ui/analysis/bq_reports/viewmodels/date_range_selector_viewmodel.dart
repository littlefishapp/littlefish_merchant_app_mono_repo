// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/date/date_tools.dart';
import 'package:littlefish_merchant/ui/analysis/reports/shared/report_vm_base.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class DateRangeSelectorVM extends StoreViewModel with ReportVMBase {
  DateRangeSelectorVM.fromStore(Store<AppState> store) : super.fromStore(store);

  Function? onReportLoaded;

  DateTime? _startDate;

  DateTime? _endDate;

  void setStartDate(String startDate, ReportMode? reportMode) {
    if (reportMode == null) {
      mode = ReportMode.custom;
    } else {
      mode = reportMode;
    }
    _startDate = DateTime.parse(startDate);
  }

  void setEndDate(String endDate, ReportMode? reportMode) {
    if (reportMode == null) {
      mode = ReportMode.custom;
    } else {
      mode = reportMode;
    }

    _endDate = DateTime.parse('${endDate.substring(0, 10)} 23:59:59');
  }

  @override
  DateTime get startDate {
    if (mode == ReportMode.custom) return _startDate ?? DateTime.now().toUtc();

    if (mode == ReportMode.day) return getStartOfDay();

    if (mode == ReportMode.week) return getFirstDayOfWeek();

    if (mode == ReportMode.month) return getFirstDayOfMonth();

    if (mode == ReportMode.threeMonths) return getFirstDayThreeMonths();

    if (mode == ReportMode.year) return getFirstDayOfYear();

    if (mode == ReportMode.prevDay) {
      return DateTime.now().toUtc().subtract(const Duration(days: 1));
    }

    if (mode == ReportMode.prevWeek) return getFirstDayOfPrevWeek();

    if (mode == ReportMode.prevMonth) return getFirstDayOfPrevMonth();

    if (mode == ReportMode.prevYear) return getFirstDayOfPrevYear();

    return DateTime.now().toUtc();
  }

  @override
  DateTime get endDate {
    if (mode == ReportMode.custom) return _endDate ?? DateTime.now().toUtc();

    if (mode == ReportMode.day) return getEndOfDay();

    if (mode == ReportMode.week) return getLastDayOfWeek();

    if (mode == ReportMode.month) return getLastDayOfMonth();

    if (mode == ReportMode.threeMonths) return getLastDayThreeMonths();

    if (mode == ReportMode.year) return getLastDayOfYear();

    if (mode == ReportMode.prevDay) {
      return DateTime.now().toUtc().subtract(const Duration(days: 1));
    }

    if (mode == ReportMode.prevWeek) return getLastDayOfPrevWeek();

    if (mode == ReportMode.prevMonth) return getLastDayOfPrevMonth();

    if (mode == ReportMode.prevYear) return getLastDayOfPrevYear();

    return DateTime.now().toUtc();
  }

  @override
  Null loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;

    return null;
  }
}
