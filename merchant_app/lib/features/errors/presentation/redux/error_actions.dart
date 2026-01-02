import 'package:flutter/material.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/snackbars/snackbar_helper.dart';
import 'package:littlefish_merchant/features/errors/presentation/pages/error_page.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

LoggerService logger = LittleFishCore.instance.get<LoggerService>();

class SetAppErrorAction {
  final GeneralError error;

  SetAppErrorAction(this.error);
}

class ClearAppErrorAction {}

class SetErrorStateLoadingAction {
  final bool isLoading;

  SetErrorStateLoadingAction(this.isLoading);
}

class SetAppErrorReportedSuccessfullyAction {
  final bool value;

  SetAppErrorReportedSuccessfullyAction(this.value);
}

class ShowErrorPageAction {
  String callerMethod;
  String message;
  String? errorCode;
  Object? error;
  StackTrace? stackTrace;

  ShowErrorPageAction(
    this.callerMethod,
    this.message, {
    this.errorCode,
    this.error,
    this.stackTrace,
  });
}

class ShowRequestRetryAction {
  const ShowRequestRetryAction();
}

ThunkAction<AppState> showErrorPageAction(
  String callerMethod,
  String message, {
  String? errorCode,
  Object? error,
  StackTrace? stackTrace,
  bool showBackToSafetyButton = true,
  bool showExitAppButton = false,
  bool showTryAgainButton = true,
  bool showTestInternetButton = true,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      logger.error(
        callerMethod,
        message,
        error: error,
        stackTrace: stackTrace ?? StackTrace.current,
      );

      store.dispatch(
        SetAppErrorAction(
          GeneralError(
            message: message,
            methodName: callerMethod,
            error: error,
            errorCode: errorCode,
          ),
        ),
      );

      Navigator.push(
        globalNavigatorKey.currentContext!,
        CustomRoute(
          builder: (context) => ErrorPage(
            message: message,
            errorCode: errorCode,
            showBackToSafetyButton: showBackToSafetyButton,
            showExitAppButton: showExitAppButton,
            showTryAgainButton: showTryAgainButton,
            showTestInternetButton: showTestInternetButton,
          ),
        ),
      );
    });
  };
}

ThunkAction<AppState> retryRequestSnackbarAction() {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        String snackbarMessage =
            'Please check your internet connection - retrying...';

        BuildContext? context = globalNavigatorKey.currentContext;
        if (context == null || !context.mounted) {
          logger.debug(
            'retryRequestAction',
            'Context unavailable, could not show snackbar',
          );
          return;
        }

        SnackBarHelper.showFailureSnackbar(context, snackbarMessage);
      } catch (e) {
        logger.error(
          'retryRequestAction',
          '### Failed to show network request retrying snackbar',
        );
      }
    });
  };
}
