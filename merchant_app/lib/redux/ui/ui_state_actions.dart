// Dart imports:
import 'dart:async';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

// Project imports:
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/analysis_service.dart';

ThunkAction<AppState> getBusinessOverviewCounts({
  DateGroupType mode = DateGroupType.daily,
  Completer? completer,
  bool refresh = false,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      var service = AnalysisService.fromStore(store);

      store.dispatch(SetHomeLoadingAction(true));

      await service
          .getBusinessCountOverview(mode: mode)
          .catchError((e) {
            store.dispatch(SetHomeFailureAction(e.toString()));
            store.dispatch(SetHomeLoadingAction(false));

            completer?.completeError(e);
            return BusinessOverviewCount();
          })
          .then((result) {
            store.dispatch(SetHomeOverview(result));
            store.dispatch(SetHomeLoadingAction(false));

            completer?.complete();
          });
    });
  };
}

class SetSettingUpTextAction {
  String? value;

  SetSettingUpTextAction(this.value);
}

class SetRouteAction {
  String? value;

  SetRouteAction(this.value);
}

class SetHomeOverview {
  BusinessOverviewCount value;

  SetHomeOverview(this.value);
}

class SetHomeMode {
  ReportMode value;

  SetHomeMode(this.value);
}

class SetHomeLoadingAction {
  bool value;

  SetHomeLoadingAction(this.value);
}

class SetHomeFailureAction {
  String value;

  SetHomeFailureAction(this.value);
}

class SetHomeUIIndexAction {
  int value;

  SetHomeUIIndexAction(this.value);
}
