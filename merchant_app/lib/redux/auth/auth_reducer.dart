import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';

// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/app/app_routes.dart';
import 'package:littlefish_merchant/models/security/access_management/module.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/auth/auth_state.dart';

LittleFishCore core = LittleFishCore.instance;

LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

final authReducer = combineReducers<AuthState>([
  TypedReducer<AuthState, LogonSuccessAction>(onLogonSuccess).call,
  TypedReducer<AuthState, LogonFailureAction>(onLogonFailure).call,
  TypedReducer<AuthState, LogonFirebaseSuccessAction>(onFirebaseLogon).call,
  TypedReducer<AuthState, SetUserNameAction>(onSetUserName).call,
  TypedReducer<AuthState, SetAuthLoadingAction>(onSetLoading).call,
  TypedReducer<AuthState, SignoutAction>(onSignOut).call,
  TypedReducer<AuthState, RegisterSuccessAction>(onRegistered).call,
  TypedReducer<AuthState, RegistrationFailureAction>(onRegisterFailed).call,
  TypedReducer<AuthState, AuthResetErrorAction>(onAuthResetError).call,
  TypedReducer<AuthState, SetUserAccessPermissions>(onSetUserPermissions).call,
  TypedReducer<AuthState, RefreshTokenAction>(onRefreshToken).call,
  TypedReducer<AuthState, RefreshClaimsTokenAction>(onRefreshClaimsToken).call,
  TypedReducer<AuthState, ResetLockoutTimerAction>(onResetLockoutTimer).call,
  TypedReducer<AuthState, RebuildAccessManagerAction>(
    onRebuildAccessManager,
  ).call,
  TypedReducer<AuthState, SetHasAppInitializedAction>(
    onSetHasAppInitialized,
  ).call,
  TypedReducer<AuthState, UpdateAuthTokenErrorAction>(
    onUpdateAuthTokenErrorAction,
  ).call,
  TypedReducer<AuthState, SetRefreshTokenAction>(onSetRefreshToken).call,
]);

AuthState onRefreshToken(AuthState state, RefreshTokenAction action) {
  //ToDo (BHowes): please take a look, an additional refresh token action here, which does not look at if expired, which is potentially what you could look at in the centralised auth-helper.
  return state.rebuild((b) {
    state.currentUser
        ?.getAuthTokenResult(forceRefresh: true)
        .then((result) {
          b.token = result.token;
          b.expirationTime = result.expirationTime;
          b.authTime = result.authTime;
        })
        .catchError((e) {
          logger.debug(
            'auth_reducer',
            '### authReducer onRefreshToken error [$e]',
          );
        })
        .whenComplete(() {
          //ToDo: (BHowes), what does this auth-timer do, it looks like this is another fail-safe, which comes back and calles this ontokenrefresh function, can you see how this logic is attached, they all can run at once which is fine and ok, just want to be sure that they actually are.
          state.resetAuthTimer(b);
        });
  });
}

AuthState onRefreshClaimsToken(
  AuthState state,
  RefreshClaimsTokenAction action,
) {
  return state.rebuild((b) {
    b.token = action.token;
  });
}

AuthState onFirebaseLogon(AuthState state, LogonFirebaseSuccessAction action) {
  logger.debug(
    'auth_reducer',
    '### auth reducer onFirebaseLogon entry '
        ' action token[${action.token?.substring(0, 15)}]',
  );
  return state.rebuild((b) {
    var user = action.user;

    b.currentUser = action.user;
    b.authTime = action.authTime;
    b.expirationTime = action.expirationTime;
    b.issuedAtTime = action.issuedAtTime;
    b.userInfo = action.userInfo;
    b.signInProvider = action.signInProvider;
    b.errorMessage = null;
    b.token = action.token;
    b.userId = user?.uid;
    b.userName = user?.displayName;
    b.otpRequired = false;

    b.routes = allRoutes();

    //ensure that the correctly allocated userId is present always
    // AppVariables.analytics!.setUserId(id: b.userId);

    logger.debug(
      'auth_reducer',
      '### auth reducer onFirebaseLogon rebuild -> b'
          'user[${b.userId}] ${b.token?.substring(0, 15)}',
    );

    state.resetAuthTimer(b);
  });
}

AuthState onLogonSuccess(AuthState state, LogonSuccessAction action) {
  return state.rebuild((b) {
    b.otpId = action.result.otpId;
    b.otpRequired = b.otpId != null;

    b.errorMessage = null;

    if (b.otpRequired == true) {
      b.token = action.result.accessToken;
      b.sessionId = action.result.sessionId;

      var tokenData = TokenData.fromToken(state, b.token);
      b.userName = tokenData.userName;
    }

    b.refreshToken = action.result.refreshToken;
    b.routes = allRoutes();
  });
}

AuthState onRegistered(AuthState state, RegisterSuccessAction action) {
  return state.rebuild((b) {
    b.otpId = action.result.otpId;
    b.otpRequired = b.otpId != null;

    b.errorMessage = null;

    if (b.otpRequired == true) {
      b.token = action.result.accessToken;
      b.sessionId = action.result.sessionId;

      var tokenData = TokenData.fromToken(state, b.token);
      b.userName = tokenData.userName;
    }

    b.refreshToken = action.result.refreshToken;
    b.routes = allRoutes();
  });
}

AuthState onRegisterFailed(AuthState state, RegistrationFailureAction action) {
  return state.rebuild((b) {
    b.hasError = true;
    b.errorMessage = action.message;
  });
}

AuthState onLogonFailure(AuthState state, LogonFailureAction action) {
  return state.rebuild((b) {
    b.hasError = true;
    b.errorMessage = action.message;
  });
}

AuthState onSetLoading(AuthState state, SetAuthLoadingAction action) {
  return state.rebuild((b) {
    b.isLoading = action.value;
    b.errorMessage = null;
  });
}

AuthState onAuthResetError(AuthState state, AuthResetErrorAction action) {
  return state.rebuild((b) {
    b.hasError = false;
    b.errorMessage = null;
  });
}

AuthState onSetUserName(AuthState state, SetUserNameAction action) {
  return state.rebuild((b) => b.userName = action.value);
}

//ToDo: add the sign-out action to all the reducers, this will ensure they are all cleared respectfully where requried
AuthState onSignOut(AuthState state, SignoutAction action) {
  return state.rebuild((b) {
    b.token = null;
    b.currentUser = null;
    b.refreshToken = null;
    b.otpId = null;
    b.sessionId = null;
    b.expirationTime = null;
    b.refreshToken = null;
    b.authTimer?.cancel();
    b.authTimer = null;
    b.permissions = null;
    b.userId = null;
    b.userInfo = null;
    b.accessManager = null;
  });
}

AuthState onUpdateAuthTokenErrorAction(
  AuthState state,
  UpdateAuthTokenErrorAction action,
) => state.rebuild((b) {
  b.hasTokenError = action.value;
});

final authUIReducer = combineReducers<AuthUIState>([
  TypedReducer<AuthUIState, SetUserNameAction>(onSetUIUserName).call,
  TypedReducer<AuthUIState, AuthSetPasswordAction>(onSetPassword).call,
  TypedReducer<AuthUIState, AuthResetErrorAction>(onResetError).call,
  TypedReducer<AuthUIState, GuestLogonFailureAction>(onGuestLoginFailed).call,
  TypedReducer<AuthUIState, LogonSuccessAction>(onResetAuth).call,
  TypedReducer<AuthUIState, RegisterSuccessAction>(onResetAuth).call,
  TypedReducer<AuthUIState, SetAuthLoadingAction>(onSetUILoading).call,
  TypedReducer<AuthUIState, SetBankMerchantAction>(onSetBankMerchantState).call,
  TypedReducer<AuthUIState, SetMerchantOTPContactInfoAction>(
    onSetMerchantOTPContactInfoState,
  ).call,
  TypedReducer<AuthUIState, SetOTPIdentifier>(onSetOtpIdentifier).call,
]);

AuthUIState onSetOtpIdentifier(AuthUIState state, SetOTPIdentifier action) {
  return state.rebuild((b) => b.otpIdentifier = action.identifier);
}

AuthUIState onGuestLoginFailed(
  AuthUIState state,
  GuestLogonFailureAction action,
) {
  return state.rebuild((b) {
    b.errorMessage = action.message;
  });
}

AuthUIState onSetBankMerchantState(
  AuthUIState state,
  SetBankMerchantAction action,
) {
  return state.rebuild((b) {
    b.bankMerchant = action.bankMerchant;
  });
}

AuthUIState onSetMerchantOTPContactInfoState(
  AuthUIState state,
  SetMerchantOTPContactInfoAction action,
) {
  return state.rebuild((b) => b.merchantOTPContactInfo = action.value);
}

AuthUIState onSetUIUserName(AuthUIState state, SetUserNameAction action) =>
    state.rebuild((b) => b.userName = action.value);

AuthUIState onSetPassword(AuthUIState state, AuthSetPasswordAction action) =>
    state.rebuild((b) {
      b.password = action.value;
      b.pin = action.value;
    });

AuthUIState onResetError(AuthUIState state, AuthResetErrorAction action) =>
    state.rebuild((b) {
      b.hasError = false;
      b.errorMessage = null;
    });

AuthUIState onResetAuth(AuthUIState state, dynamic action) =>
    state.rebuild((b) {
      b.hasError = false;
      b.errorMessage = null;
      b.password = null;
    });

AuthUIState onSetUILoading(AuthUIState state, SetAuthLoadingAction action) =>
    state.rebuild((b) => b.isLoading = action.value);

class TokenData {
  TokenData.fromToken(AuthState state, String? token) {
    if (token == null || token.isEmpty) return;

    var data = _parseToken(token);
    if (data.isEmpty) return;

    userName = data.containsKey('UserName') ? data['UserName'] : null;
    expires = data.containsKey('Expires') ? data['Expires'] : null;
  }

  String? userName;

  int? expires;

  Map<String, dynamic> _parseToken(String token) {
    final parts = token.split('.');
    final payload = parts[1];
    String normalizedSource = base64Url.normalize(payload);
    return json.decode(utf8.decode(base64Url.decode(normalizedSource)))
        as Map<String, dynamic>;
  }
}

AuthState onSetUserPermissions(
  AuthState state,
  SetUserAccessPermissions action,
) => state.rebuild((b) {
  b.accessManager = AccessManager.fromPermissions(action.value);
});

AuthState onResetLockoutTimer(
  AuthState state,
  ResetLockoutTimerAction action,
) => state.rebuild((b) {
  //logger.debug('redux.auth.reducer', 'Resetting lockout timer');
  state.resetLockTimer(b);
});

AuthState onRebuildAccessManager(
  AuthState state,
  RebuildAccessManagerAction action,
) => state.rebuild((b) {
  //a quick rebuild to reset anything recieved from server or user actions
  b.accessManager = AccessManager.fromPermissions(state.permissions);
});

AuthState onSetHasAppInitialized(
  AuthState state,
  SetHasAppInitializedAction action,
) => state.rebuild((b) {
  b.hasAppInitialized = action.value;
});

AuthState onSetRefreshToken(AuthState state, SetRefreshTokenAction action) {
  return state.rebuild((b) => b.refreshToken = action.refreshToken);
}
