// removed ignore: depend_on_referenced_packages
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core_utils/error/models/error_codes/app_initialise_error_codes.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/errors/presentation/redux/error_actions.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/auth/auth_state.dart';

LittleFishCore core = LittleFishCore.instance;

LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

class AuthHelper {
  const AuthHelper();

  static Future<String?> refreshToken({required Store<AppState> store}) async {
    bool hasRefreshed = false;
    dynamic error;

    if (store.state.authState.currentUser == null ||
        store.state.currentUser == null) {
      return null;
    }
    //This allows us to check if the token has expired and if it there is a
    //token refesh issue regarding device time and if the checks are fine, we can refresh the token
    if (hasTokenExpired(store.state.authState) &&
        store.state.authState.hasTokenError != true) {
      for (int i = 0; i < 2; i++) {
        if (hasRefreshed == true) break;
        try {
          hasRefreshed = await _singleTokenRefreshAttempt(store: store);
          //Here we check the new token to see if it has expired,
          //if it has not then we set the token variable to false.
          if (hasRefreshed && !(hasTokenExpired(store.state.authState))) {
            store.dispatch(UpdateAuthTokenErrorAction(false));
          }
        } catch (e) {
          hasRefreshed = false;
          error = e;
        }
      }
    }
    // Here we check if the new token has expired and if the token refresh has succeeded
    // We need this to solve if the datetime of the device is not correct
    // If the datetime is not in sync, this will cause our tokens to think
    // they are expired and continuesly refresh and cause inconsistent behaviour throughout the app
    if (hasRefreshed && (hasTokenExpired(store.state.authState))) {
      store.dispatch(UpdateAuthTokenErrorAction(true));
      store.dispatch(
        ShowErrorPageAction(
          'token-refresh-failure',
          AppInitialiseErrorCodes.tokenRefreshExpirationTimeFailure(
            deviceId: AppVariables.deviceInfo?.deviceId ?? '',
            merchantId: AppVariables.merchantId,
            supportEmail: AppVariables.clientSupportEmail,
          ).message,
          errorCode: AppInitialiseErrorCodes.tokenRefreshExpirationTimeFailure(
            deviceId: AppVariables.deviceInfo?.deviceId ?? '',
            merchantId: AppVariables.merchantId,
            supportEmail: AppVariables.clientSupportEmail,
          ).code,
        ),
      );
      return null;
    }

    if (_canSignOut(store: store, hasRefreshed: hasRefreshed)) {
      logger.error(
        'tools.helpers.auth_helper',
        'Token refresh failed: ${error.toString()}',
      );

      logger.error(
        'tools.helpers.auth_helper',
        'Unable to reset expired token - user will be signed out',
      );

      reportCheckedError(error);
      store.dispatch(signOut(reason: 'token-refresh-failure'));
      return null;
    } else if (_hasError(store: store, hasRefreshed: hasRefreshed) &&
        error != null) {
      _errorHandling(store: store, hasRefreshed: hasRefreshed, error: error);
    }
    return store.state.token;
  }

  static Future<bool> _singleTokenRefreshAttempt({
    required Store<AppState> store,
  }) async {
    bool hasRefreshed = false;
    await store.state.currentUser?.getAuthTokenResult(forceRefresh: true).then((
      idTokenResult,
    ) {
      store.dispatch(
        LogonFirebaseSuccessAction.fromAuthChanged(
          store.state.currentUser,
          idTokenResult,
          source: 'auth_helper_refresh_token',
        ),
      );
      hasRefreshed = true;
    });
    return hasRefreshed;
  }

  static int tokenRemainingTime(AuthState authState) {
    if (authState.expirationTime == null) return -1;
    return authState.expirationTime!
        .difference(DateTime.now().toUtc())
        .inMinutes;
  }

  static bool hasTokenExpired(AuthState authState) {
    return tokenRemainingTime(authState) <= 0;
  }

  static void _errorHandling({
    required Store<AppState> store,
    required bool hasRefreshed,
    dynamic error,
  }) {
    LoggerService logger = LittleFishCore.instance.get<LoggerService>();
    String message = _errorMessage(store: store, hasRefreshed: hasRefreshed);
    logger.error(
      'tools.helpers.auth_helper',
      'Token refresh error: ${((error ?? '').toString()).substring(0, 50)}',
      error: error,
      stackTrace: StackTrace.current,
    );
    logger.error('tools.helpers.auth_helper', message);
  }

  static bool _canSignOut({
    required Store<AppState> store,
    required bool hasRefreshed,
  }) {
    bool isTokenExpired = hasTokenExpired(store.state.authState);
    bool hasInternet = store.state.hasInternet ?? false;
    bool isTokenNull = store.state.authState.token == null;

    return !hasRefreshed && isTokenExpired && hasInternet && isTokenNull;
  }

  static bool _hasError({
    required Store<AppState> store,
    required bool hasRefreshed,
  }) {
    bool isTokenExpired = hasTokenExpired(store.state.authState);
    bool hasInternet = store.state.hasInternet ?? false;
    bool isTokenNull = store.state.authState.token == null;

    return !hasRefreshed && !isTokenExpired && !hasInternet && !isTokenNull;
  }

  static String _errorMessage({
    required Store<AppState> store,
    required bool hasRefreshed,
  }) {
    bool isTokenExpired = hasTokenExpired(store.state.authState);
    bool hasInternet = store.state.hasInternet ?? false;
    bool isTokenNull = store.state.authState.token == null;

    if (!hasInternet) {
      return '### TokenRefreshMiddleware call refreshToken no internet return';
    }
    if (isTokenNull) {
      return '### TokenRefreshMiddleware call refreshToken token null return';
    }

    if (isTokenExpired && !hasRefreshed) {
      return '### TokenRefreshMiddleware call refreshToken token expired and could not refresh token return';
    }

    return '### TokenRefreshMiddleware call Token Refresh Issue';
  }
}
