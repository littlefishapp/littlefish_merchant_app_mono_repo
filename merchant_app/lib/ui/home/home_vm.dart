// removed ignore: depend_on_referenced_packages

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/ui/ui_state.dart';
import 'package:littlefish_merchant/redux/ui/ui_state_actions.dart';
import 'package:littlefish_merchant/redux/user/user_actions.dart';
import 'package:littlefish_merchant/redux/user/user_state.dart';
import 'package:littlefish_merchant/tools/date/date_tools.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class HomeVM extends StoreViewModel<HomeUIState> {
  HomeVM.fromStore(Store<AppState> store) : super.fromStore(store);

  BusinessOverviewCount? overview;

  ReportMode? mode;

  String? homeContentVersion;

  bool get isDefaultHomeContent =>
      (homeContentVersion ?? 'default') == 'default' ? true : false;

  int? homeUIIndex;

  UserViewingMode? viewMode;

  bool? canChangeViewingMode;

  Function(ReportMode mode)? onChangeMode;

  Function(int index)? onSetUIIndex;

  Function? onLoadOverview;

  DateTime get startDate {
    if (mode == ReportMode.day) return DateTime.now().toUtc();

    if (mode == ReportMode.week) return getFirstDayOfWeek();

    if (mode == ReportMode.month) return getFirstDayOfMonth();

    if (mode == ReportMode.threeMonths) return getFirstDayThreeMonths();

    if (mode == ReportMode.year) return getFirstDayOfYear();

    return DateTime.now().toUtc();
  }

  DateTime get endDate {
    if (mode == ReportMode.day) return DateTime.now().toUtc();

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

    return 'in progress';
  }

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    state = store!.state.homeUIState;

    viewMode = store.state.viewMode;
    canChangeViewingMode = store.state.canChangeViewMode;

    isLoading = state!.isLoading;
    hasError = state!.hasError;
    errorMessage = state!.errorMessage;

    homeContentVersion =
        store.state.appSettingsState.homeContentVersion ?? 'default';

    mode = state!.mode;
    overview = state!.overview;

    homeUIIndex = state!.homeUIIndex ?? 0;

    onChangeMode = (mode) {
      this.mode = mode;
      store.dispatch(SetHomeMode(mode));
    };

    onSetUIIndex = (index) {
      homeUIIndex = index;
      store.dispatch(SetHomeUIIndexAction(index));
    };

    if (isDefaultHomeContent) {
      onLoadOverview = () => store.dispatch(
        getBusinessOverviewCounts(
          mode: DateGroupType.values[(mode ?? ReportMode.day).index],
        ),
      );
    }
  }

  changeViewMode(BuildContext context) {
    store!.dispatch(
      changeUserViewMode(
        viewMode == UserViewingMode.full
            ? UserViewingMode.pointOfSale
            : UserViewingMode.full,
        completer: null,
      ),
    );
  }
}
