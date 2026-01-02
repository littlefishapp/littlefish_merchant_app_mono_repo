import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core_utils/error/models/error_codes/app_initialise_error_codes.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/errors/presentation/redux/error_actions.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:redux/redux.dart';

class ErrorMiddleware extends MiddlewareClass<AppState> {
  DateTime? _lastRetrySnackbarTime;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    LoggerService logger = LittleFishCore.instance.get<LoggerService>();

    if (action is ShowErrorPageAction) {
      try {
        store.dispatch(
          showErrorPageAction(
            action.callerMethod,
            action.message,
            errorCode: action.errorCode,
            error: action.error,
            stackTrace: action.stackTrace,
            showBackToSafetyButton: _isNotSystemFailure(action),
            showExitAppButton: _allowAppExit(action),
            showTryAgainButton: _allowTryAgain(action),
            showTestInternetButton: _allowTestInternet(action),
          ),
        );
      } catch (e) {
        logger.error(
          'ErrorMiddleware',
          'Failed to show error page: $e',
          error: e,
          stackTrace: StackTrace.current,
        );
      }
    }

    if (action is ShowRequestRetryAction) {
      try {
        DateTime now = DateTime.now();
        int notificationDelay = store.state.slowNetworkNotificationInterval;
        bool retriesEnabled = store.state.configEnableSlowNetworkCheck;
        if (!retriesEnabled) return;
        // Ensure at least notificationDelay (e.g. 1 minute) has passed since the last notification (to avoid spamming)
        if (_lastRetrySnackbarTime == null ||
            now.difference(_lastRetrySnackbarTime!).inMinutes >=
                notificationDelay) {
          _lastRetrySnackbarTime = now;
          store.dispatch(retryRequestSnackbarAction());
        }
      } catch (e) {
        logger.error(
          'ErrorMiddleware',
          'Failed to show request retry: $e',
          error: e,
          stackTrace: StackTrace.current,
        );
      }
    }
  }

  bool _isNotSystemFailure(ShowErrorPageAction action) {
    if (AppInitialiseErrorCodes.tokenRefreshExpirationTimeFailure(
          deviceId: AppVariables.deviceInfo?.deviceId ?? '',
          merchantId: AppVariables.merchantId,
          supportEmail: AppVariables.clientSupportEmail,
        ).code ==
        action.errorCode) {
      return false;
    }
    return action.errorCode !=
        AppInitialiseErrorCodes.environmentConfigFailed.code;
  }

  bool _allowAppExit(ShowErrorPageAction action) {
    if (AppInitialiseErrorCodes.tokenRefreshExpirationTimeFailure(
          deviceId: AppVariables.deviceInfo?.deviceId ?? '',
          merchantId: AppVariables.merchantId,
          supportEmail: AppVariables.clientSupportEmail,
        ).code ==
        action.errorCode) {
      return true;
    }
    return false;
  }

  bool _allowTestInternet(ShowErrorPageAction action) {
    if (AppInitialiseErrorCodes.tokenRefreshExpirationTimeFailure(
          deviceId: AppVariables.deviceInfo?.deviceId ?? '',
          merchantId: AppVariables.merchantId,
          supportEmail: AppVariables.clientSupportEmail,
        ).code ==
        action.errorCode) {
      return false;
    }
    return true;
  }

  bool _allowTryAgain(ShowErrorPageAction action) {
    if (AppInitialiseErrorCodes.tokenRefreshExpirationTimeFailure(
          deviceId: AppVariables.deviceInfo?.deviceId ?? '',
          merchantId: AppVariables.merchantId,
          supportEmail: AppVariables.clientSupportEmail,
        ).code ==
        action.errorCode) {
      return false;
    }
    return true;
  }
}
