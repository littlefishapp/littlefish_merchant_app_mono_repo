import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/features/errors/data/models/error_reports.dart';
import 'package:littlefish_merchant/features/errors/presentation/redux/error_state.dart';
import 'package:littlefish_merchant/models/device/interfaces/device_details.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/redux/app/app_actions.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';
import 'package:littlefish_merchant/ui/security/login/landing_page.dart';

import 'package:redux/redux.dart';

class ErrorVM extends StoreCollectionViewModel<ErrorReport, ErrorState> {
  ErrorVM.fromStore(Store<AppState> store) : super.fromStore(store);

  ErrorReport? errorReport;
  GeneralError? error;

  UserProfile? userProfile;
  BusinessProfile? businessProfile;
  DeviceDetails? deviceDetails;

  late Future<bool> Function(String message) reportError;
  late void Function() testInternet;
  late void Function(BuildContext context) backToSafety;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    store = store;
    state = store.state.uiState.errorState;
    errorReport = state?.errorReport;
    error = state?.error;
    isLoading = state?.isLoading ?? false;

    userProfile = store.state.userState.profile;
    businessProfile = store.state.businessState.profile;

    reportError = (message) async {
      Completer? completer = Completer<bool>();
      store.dispatch(
        sendBugReportAction(
          message: message,
          callerMethod: error?.methodName ?? 'ErrorVM: reportError',
          error: error,
          errorCode: error?.errorCode,
          stackTrace: error?.stackTrace,
          completer: completer,
        ),
      );
      return await completer.future as bool;
    };

    testInternet = () => store.dispatch(testInternetWithSnackbarAction());

    backToSafety = (context) {
      Navigator.of(context).pushReplacementNamed(LandingPage.route);
    };
  }
}
