// remove ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:littlefish_auth/littlefish_auth_manager.dart';
import 'package:littlefish_core/auth/models/auth_user.dart';
import 'package:littlefish_core/auth/models/authentication_result.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_core/business/models/business.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/monitoring/services/monitoring_service.dart';
import 'package:littlefish_core_utils/error/error_code_manager.dart';
import 'package:littlefish_core_utils/error/models/error_codes/activation_error_codes.dart';
import 'package:littlefish_core_utils/error/models/error_codes/authentication_error_codes.dart';
import 'package:littlefish_core_utils/httpErrors/models/api_error.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/features/create_account/presentation/create_account_page.dart';
import 'package:littlefish_merchant/features/store_switching/presentation/pages/merchant_verify_page.dart';
import 'package:littlefish_merchant/models/activation/activation_request.dart';
import 'package:littlefish_merchant/models/activation/activation_response.dart';
import 'package:littlefish_merchant/models/activation/create_activation_request.dart';
import 'package:littlefish_merchant/models/activation/verify_activation_request.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/security/authentication/api_base_response.dart';
import 'package:littlefish_merchant/models/security/authentication/business_user_dto.dart';

import 'package:littlefish_merchant/ui/business/organisation/organisation_info/organisation_info.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';
import 'package:littlefish_merchant/ui/security/registration/activation_offline_page.dart';
import 'package:littlefish_merchant/ui/security/registration/functions/activation_functions.dart';
import 'package:littlefish_merchant/ui/security/registration/pages/register_complete_page.dart';
import 'package:littlefish_merchant/ui/security/registration/verify_merchant_information.dart';
import 'package:littlefish_payments/gateways/pos_payment_gateway.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/app/app.dart';

import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/services/user_profile_service.dart';
import 'package:littlefish_merchant/stores/stores.dart';
import 'package:littlefish_merchant/tools/exceptions/common_exceptions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/models/security/authentication/activation_user_input.dart';
import 'package:littlefish_merchant/models/security/authentication/generate_otp_request.dart';
import 'package:littlefish_merchant/services/api_authentication_service.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_merchant/ui/security/registration/activation_otp_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/models/security/authentication/verify_otp_request.dart';
import 'package:littlefish_merchant/models/security/user/business_user_profile.dart';
import 'package:littlefish_merchant/models/security/authentication/bank_merchant.dart';
import 'package:uuid/uuid.dart';

import '../../common/presentaion/components/navbars.dart';
import '../../ui/security/login/login_page.dart';
import '../../ui/security/login/landing_page.dart';
import '../../ui/security/login/splash_page.dart';

final secureStorage = FlutterSecureStorage();

// AuthenticationService? authenticationService; // we move this to the package  level so that the app does not need to know what package it uses.

LittleFishCore core = LittleFishCore.instance;

LittlefishAuthManager authManager = LittlefishAuthManager.instance;

LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

ThunkAction<AppState> usernameAndPasswordLogon({
  required String userName,
  required String? password,
  required BuildContext context,
  required String source,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    final MonitoringService monitoringService = core.get<MonitoringService>();

    var trace = await monitoringService.createTrace(
      name: 'logon-username-password',
    );
    trace.start();

    logger.debug(
      'auth_actions',
      '### auth action usernameAndPasswordLogon entry',
    );

    store.dispatch(SetAuthLoadingAction(true));

    try {
      // TODO(Michael): Why are we logging in with email and password + custom token
      // TODO: in the frontend if the backend 'login' method already does both?
      // TODO: We should consider removing this frontend logic

      final AuthUser authUser = await authManager.signInWithEmailAndPassword(
        email: userName,
        password: password!,
      );

      logger.info(
        'auth_actions_signInWithEmailAndPassword',
        '### auth action signInWithEmailAndPassword success for user ${authUser.email}',
      );

      final authResults = authManager.authenticationResult;

      logger.info(
        'auth_actions_signInWithEmailAndPassword',
        '### auth action obtained authenticationResult',
      );

      /// Tokens we use are from the backend and that is what we store
      if (authResults != null) {
        store.dispatch(
          LogonSuccessAction(authResults),
        ); // updating the store with the backend auth Result.
      }

      if (authResults?.refreshToken != null) {
        store.dispatch(SetRefreshTokenAction(authResults!.refreshToken!));
        await secureStorage.write(
          key: 'refresh_token',
          value: authResults.refreshToken!,
        );
      }

      var idTokenResult = await authUser.getAuthTokenResult();

      var r = LogonFirebaseSuccessAction.fromTokenResult(
        authUser,
        idTokenResult,
        source: source,
      );

      store.dispatch(r);

      Future(() async {
        try {
          verifyHelper(
            verifiedResult: authResults,
            store: store,
            context: context,
          );
        } catch (e) {
          reportCheckedError(e, trace: StackTrace.current);
          completer?.completeError(e);
        }
      });
    }
    // NEW: handle structured backend error and show its detail
    on ApiErrorException catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      Navigator.of(context).pop();

      completer?.completeError(e);
    } on StateError catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      Navigator.of(context).pop();
      completer?.completeError(e);
    } catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      Navigator.of(context).pop();
      completer?.completeError(e);
    } finally {
      store.dispatch(SetAuthLoadingAction(false));
      trace.stop();
    }
  };
}

ThunkAction<AppState> usernameAndPasswordLoginWithConditions({
  required String userName,
  required String? password,
  required String? mid,
  required PlatformType platformType,
  required BuildContext context,
  required String source,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    logger.debug(
      'auth_actions',
      '### auth action usernameAndPasswordLogonWithConditions entry',
    );

    final MonitoringService monitoringService = core.get<MonitoringService>();

    var trace = await monitoringService.createTrace(
      name: 'logon-username-password-conditions',
    );
    trace.start();

    store.dispatch(SetAuthLoadingAction(true));

    try {
      // this is your original firebase-based auth
      AuthUser authUser = await authManager.signInWithEmailAndPassword(
        email: userName,
        password: password!,
        merchantId: mid ?? '',
      );

      logger.info(
        'auth_actions_signInWithEmailAndPasswordWithConditions',
        '### auth action signInWithEmailAndPasswordWithConditions success for user ${authUser.email}',
      );
      final authResults = authManager.authenticationResult;

      var idTokenResult = await authUser.getAuthTokenResult();

      store.dispatch(
        LogonFirebaseSuccessAction.fromTokenResult(
          authUser,
          idTokenResult,
          source: source,
        ),
      );

      // background verify
      Future(() async {
        try {
          verifyHelper(
            verifiedResult: authResults,
            store: store,
            context: context,
          );
        } catch (e) {
          reportCheckedError(e, trace: StackTrace.current);
          completer?.completeError(e);
        }
      });
    }
    // 🔴 NEW: show backend detail to user
    on ApiErrorException catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      await authManager.signOut();
      Navigator.of(context).pop();
      completer?.completeError(e);
    } on StateError catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      await authManager.signOut();
      Navigator.of(context).pop();
      completer?.completeError(e);
    } catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      authManager.signOut();
      Navigator.of(context).pop();
      completer?.completeError(
        AuthorizationException('unable to authenticate', e.toString()),
      );
    } finally {
      store.dispatch(SetAuthLoadingAction(false));
      trace.stop();
    }
  };
}

ThunkAction<AppState> guestLogin({
  required String merchantId,
  required PlatformType platformType,
  required BuildContext context,
  required String source,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetAuthLoadingAction(true));
    final MonitoringService monitoringService = core.get<MonitoringService>();
    logger.debug('auth_actions', '### auth action GuestCreationAndLogin entry');
    var trace = await monitoringService.createTrace(name: 'guest-logon');
    trace.start();

    // authenticationService ??= AuthenticationService(
    //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    //   store: store,
    // );

    var apiAuthenticationService = ApiAuthenticationService(
      baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      token: store.state.authState.token,
      store: store,
    );

    String? mid = merchantId;

    try {
      if (isBlank(mid) && AppVariables.isPOSBuild) {
        //To do we need to get the merchant ID from the device details
        mid = await tryGetMerchantId();

        if (isBlank(mid)) {
          throw AuthorizationException(
            'unable to authenticate',
            'Merchant ID is not available',
          );
        }

        merchantId = mid!;
      } else if (isBlank(mid)) {
        throw AuthorizationException(
          'unable to authenticate',
          'Merchant ID is not available',
        );
      }

      // 👇 this can now throw ApiErrorException
      ApiBaseResponse? guestUserExists = await apiAuthenticationService
          .verifyGuestUserExistsByMerchantId(
            merchantId: merchantId,
            token: encodeToken(),
          );

      BusinessUserDto businessInfo = BusinessUserDto.create();
      if (guestUserExists?.data != null && guestUserExists != null) {
        businessInfo = BusinessUserDto.fromJson(guestUserExists.data);
      }

      if (guestUserExists == null ||
          !guestUserExists.success ||
          isBlank(businessInfo.uid) ||
          isBlank(businessInfo.businessId)) {
        bool? activationStatus = await activationClientStatus(
          context: context,
          store: store,
          enableLoading: false,
        );
        if (activationStatus == true) {
          // 👇 this can now throw ApiErrorException
          await apiAuthenticationService.createBusinessFromMerchantId(
            merchantId: merchantId,
            token: encodeToken(),
          );
        } else {
          Navigator.of(context).push(
            CustomRoute(
              builder: (BuildContext context) {
                return const ActivationOfflinePage();
              },
            ),
          );
          store.dispatch(SetAuthLoadingAction(false));
          return;
        }
      } else if (guestUserExists.success) {
        BusinessUserDto.fromJson(guestUserExists.data);
      }

      final domain = getOrganisationInfo().domain;
      final email = '$merchantId@guestuser$domain';

      AuthUser authUser = await authManager.signInWithEmailAndPassword(
        email: email,
        password: merchantId,
      );

      var idTokenResult = await authUser.getAuthTokenResult();

      var authenticationResult = authManager.authenticationResult;

      store.dispatch(
        LogonFirebaseSuccessAction.fromTokenResult(
          authUser,
          idTokenResult,
          source: source,
        ),
      );
      store.dispatch(AuthResetErrorAction());
      Future(() async {
        try {
          saveKeyToPrefsBool('isGuestLogin', true);
          store.dispatch(AuthResetErrorAction());
          verifyHelper(
            verifiedResult: authenticationResult,
            store: store,
            context: context,
            navigateToSplashScreen: true,
          );
        } catch (e) {
          reportCheckedError(e, trace: StackTrace.current);
          completer?.completeError(e);
        }
      });
    }
    // 🔴 NEW: structured backend error (guest lookup, create business, api login)
    on ApiErrorException catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      authManager.signOut();
      store.dispatch(
        GuestLogonFailureAction(ErrorCodeManager.getUserMessage(e)),
      );
      completer?.completeError(e);
    } on StateError catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      authManager.signOut();
      store.dispatch(
        GuestLogonFailureAction(ErrorCodeManager.getUserMessage(e)),
      );
      completer?.completeError(e);
    } on AuthorizationException catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      authManager.signOut();
      store.dispatch(
        GuestLogonFailureAction(ErrorCodeManager.getUserMessage(e)),
      );
      completer?.completeError(e);
    } on Exception catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      authManager.signOut();
      store.dispatch(
        GuestLogonFailureAction(ErrorCodeManager.getUserMessage(e)),
      );
      completer?.completeError(e);
    } catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      authManager.signOut();
      store.dispatch(
        GuestLogonFailureAction(ErrorCodeManager.getUserMessage(e)),
      );
      completer?.completeError(e);
    } finally {
      store.dispatch(SetAuthLoadingAction(false));
      trace.stop();
    }
  };
}

ThunkAction<AppState> googleLogon({
  Completer? completer,
  required BuildContext context,
  required String source,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      var apiAuthenticationService = ApiAuthenticationService(
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        store: store,
      );

      final MonitoringService monitoringService = core.get<MonitoringService>();

      var trace = await monitoringService.createTrace(name: 'google-logon');
      trace.start();

      store.dispatch(SetAuthLoadingAction(true));

      authManager
          .signInWithGoogle()
          .then((result) async {
            if (result != null) {
              var tokenData = await result.getAuthTokenResult();

              store.dispatch(
                LogonFirebaseSuccessAction.fromTokenResult(
                  result,
                  tokenData,
                  source: source,
                ),
              );

              try {
                String? mid = await tryGetMerchantId();

                if (AppVariables.isPOSBuild && isBlank(mid)) {
                  logger.error(
                    'googleLogon',
                    AuthenticationErrorCodes.failedToVerifyMidOnPos.message,
                  );
                  showMessageDialog(
                    globalNavigatorKey.currentContext!,
                    AuthenticationErrorCodes.failedToVerifyMidOnPos.message,
                    LittleFishIcons.error,
                    status: StatusType.destructive,
                  );
                  throw Exception(
                    AuthenticationErrorCodes.failedToVerifyMidOnPos.message,
                  );
                }
                var verifiedResult = AppVariables.isPOSBuild
                    ? await apiAuthenticationService.verifyUserWithMID(
                        mid!,
                        result,
                        tokenData.token,
                      )
                    : await apiAuthenticationService.verifyUser(
                        result,
                        tokenData.token,
                      );

                verifyHelper(
                  store: store,
                  verifiedResult: verifiedResult,
                  context: context,
                );
              } catch (e) {
                // hasError = true;
                reportCheckedError(e, trace: StackTrace.current);
                completer?.completeError(e);
              }
            }
          })
          .catchError((e) {
            String errorText = getGoogleAuthError(e.code);

            reportCheckedError(e, trace: StackTrace.current);

            completer?.completeError(ManagedException(message: errorText));
          })
          .whenComplete(() {
            store.dispatch(SetAuthLoadingAction(false));
            trace.stop();
          });
    });
  };
}

Future<String?> tryGetMerchantId() async {
  if (!AppVariables.isPOSBuild) return null;

  String mid = AppVariables.deviceMerchantId;
  if (isNotBlank(mid)) {
    mid = formatMidValue(mid);

    return mid;
  }

  if (core.isRegistered<POSPaymentGateway>()) {
    final POSPaymentGateway gateway = core.get<POSPaymentGateway>();
    final details = await gateway.getTerminalInfo(AppVariables.businessId);
    mid = details.merchantId;
  }

  mid = formatMidValue(mid);

  return mid;
}

verifyHelper({
  required AuthenticationResult? verifiedResult,
  required Store<AppState> store,
  required BuildContext context,
  bool navigateToSplashScreen = true,
  String? selectedBusinessId,
  Business? business,
}) async {
  logger.info('auth_actions', '### auth actions verifyHelper entry ');
  store.dispatch(SetAuthLoadingAction(true));
  //here we would've loaded the business details, if there are any
  store.dispatch(SetBusinessListAction(verifiedResult?.businesses));

  if (verifiedResult?.businesses != null &&
      verifiedResult!.businesses!.isNotEmpty) {
    store.dispatch(
      SetSelectedBusinessAction(business ?? verifiedResult.businesses?.first),
    );

    store.dispatch(
      SetBusinessPermissionsListAction(verifiedResult.businessUsers),
    );

    store.dispatch(SetUserAccessPermissions(store.state.permissions));

    store.dispatch(
      setCurrentStore(
        selectedBusinessId ?? verifiedResult.businesses?.first.id,
      ),
    );
  }

  store.dispatch(SetAuthLoadingAction(false));
  if (verifiedResult == null ||
      (verifiedResult.businessUsers ?? []).isEmpty ||
      (verifiedResult.businesses ?? []).isEmpty &&
          (store.state.enableSignup ?? false)) {
    bool createUser = (verifiedResult?.businessUsers ?? []).isEmpty;
    bool createBusiness = (verifiedResult?.businesses ?? []).isEmpty;

    await Navigator.of(globalNavigatorKey.currentContext!).push(
      CustomRoute(
        builder: (ctx) => CreateAccountPage(
          createBusiness: createBusiness,
          createUser: createUser,
        ),
      ),
    );
    return;
  }

  if (navigateToSplashScreen) {
    await Navigator.pushNamedAndRemoveUntil(
      context,
      SplashPage.route,
      (route) => false,
    );
  }
}

ThunkAction<AppState> setCachedLogon(
  AuthUser user, {
  Completer? completer,
  bool isOnline = true,
  required BuildContext context,
  required String source,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      logger.debug(
        'auth_actions',
        '### auth actions setCachedLogon entry '
            'refreshToken [${user.getRefreshToken().toString().substring(0, 15)}]',
      );

      var apiAuthenticationService = ApiAuthenticationService(
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        store: store,
      );

      MonitoringService monitoringService = core.get<MonitoringService>();

      var trace = await monitoringService.createTrace(
        name: 'auth-cached-logon',
      );
      trace.start();

      try {
        DateTime? startDate = user.kUser.metadata.lastSignInTime;
        ApiBaseResponse? isGuestUser = await apiAuthenticationService
            .isGuestUser(userId: user.uid);

        logger.info(
          'auth_actions',
          '### auth actions setCachedLogon isGuestUser [${isGuestUser.success}]',
        );

        if (isGuestUser.success == true) {
          bool canSignOut = true;

          if (startDate != null) {
            Duration diff = DateTime.now().toUtc().difference(startDate);
            Duration maxDiff = Duration(
              days: int.parse(store.state.guestTimeOut!.split('D')[0]),
            );
            canSignOut = diff > maxDiff;
          }

          if (canSignOut) {
            store.dispatch(signOut(reason: 'guest-logon-signout'));
            return;
          }
        }
      } on ApiErrorException catch (e) {
        // structured error from backend
        reportCheckedError(e, trace: StackTrace.current);
        logger.warning(
          'auth_actions',
          'Guest check failed (ApiError): ${e.error.userMessage}',
        );
        // TODO: Should checking for guest be blocking any further checks? I dont think so.
        // completer?.completeError(e);
        // store.dispatch(
        //   ShowErrorPageAction(
        //     'setCachedLogon',
        //     AuthenticationErrorCodes.guestUserCheckError.message,
        //     errorCode: AuthenticationErrorCodes.guestUserCheckError.code,
        //     error: e,
        //   ),
        // );
        // return;
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        // TODO: Should checking for guest be blocking any further checks? I dont think so.
        // completer?.completeError(e);
        // store.dispatch(
        //   ShowErrorPageAction(
        //     'setCachedLogon',
        //     AuthenticationErrorCodes.guestUserCheckError.message,
        //     errorCode: AuthenticationErrorCodes.guestUserCheckError.code,
        //     error: e,
        //   ),
        // );
        // return;
      }

      final savedRefreshToken = await secureStorage.read(key: 'refresh_token');
      if (savedRefreshToken != null && savedRefreshToken.isNotEmpty) {
        store.dispatch(SetRefreshTokenAction(savedRefreshToken));
      }

      var tokenData = await user.getAuthTokenResult(forceRefresh: isOnline);
      logger.info(
        'auth_actions',
        '### auth actions setCachedLogon obtained token',
      );

      store.dispatch(
        LogonFirebaseSuccessAction.fromAuthChanged(
          user,
          tokenData,
          source: source,
        ),
      );

      bool hasError = false;

      //here we would've loaded the business details, if there are any
      try {
        // logger.debug(this,'### auth actions setCachedLogon call verifyUser '
        //     'tokenData [${tokenData.token?.substring(0, 15)}]');

        // TODO(lampian): check if state updated in time
        //ToDo: check with ian why this is there? and needed?
        // await Future.delayed(const Duration(seconds: 3));

        String? mid = await tryGetMerchantId();

        if (AppVariables.isPOSBuild && isBlank(mid)) {
          logger.error(
            'setCachedLogon',
            AuthenticationErrorCodes.failedToVerifyMidOnPos.message,
          );
          showMessageDialog(
            globalNavigatorKey.currentContext!,
            AuthenticationErrorCodes.failedToVerifyMidOnPos.message,
            LittleFishIcons.error,
            status: StatusType.destructive,
          );
          throw Exception(
            AuthenticationErrorCodes.failedToVerifyMidOnPos.message,
          );
        }

        final verifiedResult = AppVariables.isPOSBuild
            ? await apiAuthenticationService.verifyUserWithMID(
                mid!,
                user,
                tokenData.token,
              )
            : await apiAuthenticationService.verifyUser(user, tokenData.token);

        logger.info(
          'auth_actions',
          '### auth actions setCachedLogon obtained verifiedResult',
        );

        verifyHelper(
          store: store,
          verifiedResult: verifiedResult,
          context: context,
          navigateToSplashScreen: false,
        );
        logger.debug(
          'auth_actions',
          '### auth actions setCachedLogon exit ${verifiedResult?.message}',
        );
      }
      // 🔴 NEW: structured verify error
      on ApiErrorException catch (e) {
        hasError = true;
        reportCheckedError(e, trace: StackTrace.current);
        // keep your behavior of completing the completer with the error
        completer?.completeError(e);
      } catch (e) {
        // logger.debug(this,
        //   '### auth actions setCachedLogon exception [${(e.toString().substring(0, 60))}]',
        // );
        hasError = true;
        reportCheckedError(e, trace: StackTrace.current);
        completer?.completeError(e);
      } finally {
        trace.stop();
      }

      store.dispatch(SetAuthLoadingAction(false));
      if (!hasError) completer?.complete();
    });
  };
}

Future<ActivationResponse> requestOTP({
  required Store<AppState> store,
  required ActivationRequest activationRequest,
}) async {
  try {
    // authenticationService ??= AuthenticationService(
    //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    //   store: store,
    // );

    var apiAuthenticationService = ApiAuthenticationService(
      baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      token: store.state.authState.token,
      store: store,
    );

    store.dispatch(SetAuthLoadingAction(true));

    final otpGeneratedResponse = await apiAuthenticationService.requestOTP(
      data: activationRequest,
      token: encodeToken(),
    );

    store.dispatch(SetAuthLoadingAction(false));

    if (otpGeneratedResponse == null) {
      throw Exception('Failed to generate OTP. Please try again.');
    }

    return otpGeneratedResponse;
  } on ApiErrorException catch (e) {
    store.dispatch(SetAuthLoadingAction(false));
    throw Exception(e.error.userMessage);
  } catch (e) {
    store.dispatch(SetAuthLoadingAction(false));
    throw Exception('Failed to generate OTP. Please try again.');
  }
}

Future<bool> verifyOTP({
  required String otpValue,
  required Store<AppState> store,
  required String userId,
}) async {
  try {
    // authenticationService ??= AuthenticationService(
    //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    //   store: store,
    // );

    var apiAuthenticationService = ApiAuthenticationService(
      baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      token: store.state.authState.token,
      store: store,
    );
    store.dispatch(SetAuthLoadingAction(true));

    final requestObj = VerifyOTPRequest(otpValue: otpValue);
    final didVerify = await apiAuthenticationService.verifyOTP(
      requestObj: requestObj,
      userId: userId,
      token: encodeToken(),
    );

    store.dispatch(SetAuthLoadingAction(false));

    if (didVerify == null) return false;

    return didVerify;
  } on ApiErrorException catch (e) {
    store.dispatch(SetAuthLoadingAction(false));
    logger.warning(
      'verifyOTP',
      'OTP verification failed: ${e.error.userMessage}',
    );
    return false;
  } catch (e) {
    store.dispatch(SetAuthLoadingAction(false));
    return false;
  }
}

ThunkAction<AppState> createActivation({
  required String merchantId,
  Completer? completer,
  bool? userLoggedIn,
  VoidCallback? onFailure,
  bool isActivation = true,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      // authenticationService ??= AuthenticationService(
      //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      //   store: store,
      // );

      var apiAuthenticationService = ApiAuthenticationService(
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        store: store,
      );

      store.dispatch(SetAuthLoadingAction(true));
      String formatedMid = formatMidValue(merchantId);

      try {
        final result = await apiAuthenticationService.createActivation(
          data: CreateActivationRequest(merchantId: formatedMid, userId: ''),
          token: encodeToken(),
        );

        BuildContext ctx = globalNavigatorKey.currentContext!;

        if (result == null || result.success == false) {
          store.dispatch(SetAuthLoadingAction(false));
          onFailure?.call();
          showErrorDialog(
            ctx,
            ActivationErrorCodes.couldNotFindBusinessWithMerchantId,
          );
          return;
        }

        if (isBlank(result.maskedEmail) && isBlank(result.maskedPhone)) {
          store.dispatch(SetAuthLoadingAction(false));
          onFailure?.call();
          showErrorDialog(ctx, ActivationErrorCodes.noContactInformation);
          return;
        }

        Navigator.of(ctx).push(
          CustomRoute(
            builder: ((context) => ActivationPageOTP(
              activationResponse: result,
              isActivation: isActivation,
            )),
          ),
        );

        store.dispatch(SetAuthLoadingAction(false));
      }
      // 🔴 NEW: structured error from backend
      on ApiErrorException catch (e) {
        store.dispatch(SetAuthLoadingAction(false));
        onFailure?.call();
        logger.error(
          'activateBusiness',
          'API error in activateBusiness: ${e.error.userMessage}',
          error: e,
          stackTrace: StackTrace.current,
        );
        BuildContext ctx = globalNavigatorKey.currentContext!;
        showErrorDialog(ctx, e);
      } catch (error) {
        store.dispatch(SetAuthLoadingAction(false));
        onFailure?.call();
        logger.error(
          'activateBusiness',
          'Error in activateBusiness',
          error: error,
          stackTrace: StackTrace.current,
        );

        BuildContext ctx = globalNavigatorKey.currentContext!;
        showErrorDialog(ctx, error);
      }
    });
  };
}

ThunkAction<AppState> hasMerchantBeenActivated({
  required String merchantId,
  required void Function(Map<String, dynamic> result) onResult,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetAuthLoadingAction(true));

    // authenticationService ??= AuthenticationService(
    //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    //   store: store,
    // );

    var apiAuthenticationService = ApiAuthenticationService(
      baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      token: store.state.authState.token,
      store: store,
    );

    try {
      final result = await apiAuthenticationService.hasMerchantBeenActivated(
        merchantId,
        encodeToken(),
      );
      store.dispatch(SetAuthLoadingAction(false));
      onResult(result);
    } catch (e) {
      store.dispatch(SetAuthLoadingAction(false));
      onResult({'error': ErrorCodeManager.getUserMessage(e)});
    }
  };
}

ThunkAction<AppState> sendGenericEmailOTP({
  required Completer<bool> completer,
  String? email,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SetAuthLoadingAction(true));

      // authenticationService ??= AuthenticationService(
      //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      //   store: store,
      // );

      var apiAuthenticationService = ApiAuthenticationService(
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        store: store,
      );

      final requestEmail = email ?? store.state.authManager.user?.email ?? '';
      final request = GenerateOTPRequest(
        recipient: requestEmail,
        type: 1,
        firstName: 'Customer',
      );
      final otpId = const Uuid().v4();
      store.dispatch(SetOTPIdentifier(otpId));

      try {
        final result = await apiAuthenticationService.sendGenericOTP(
          requests: [request],
          otpId: otpId,
        );

        store.dispatch(SetAuthLoadingAction(false));

        if (result == null || !result) {
          completer.complete(false);
          return;
        }
        completer.complete(true);
      } on ApiErrorException catch (e) {
        store.dispatch(SetAuthLoadingAction(false));
        logger.error(
          'sendGenericEmailOTP',
          'API error in sendGenericEmailOTP: ${e.error.userMessage}',
          error: e,
          stackTrace: StackTrace.current,
        );
        completer.complete(false);
      } catch (e) {
        store.dispatch(SetAuthLoadingAction(false));
        logger.error(
          'sendGenericEmailOTP',
          'Error in sendGenericEmailOTP',
          error: e,
          stackTrace: StackTrace.current,
        );
        completer.complete(false);
      }
    });
  };
}

ThunkAction<AppState> verifyGenericEmailOTP({
  required Completer<bool> completer,
  required String otp,
  required String otpId,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SetAuthLoadingAction(true));

      // authenticationService ??= AuthenticationService(
      //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      //   store: store,
      // );

      var apiAuthenticationService = ApiAuthenticationService(
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        store: store,
      );

      try {
        var result = await apiAuthenticationService.verifyOTP(
          requestObj: VerifyOTPRequest(otpValue: otp),
          userId: otpId,
          token: encodeToken(),
        );

        store.dispatch(SetAuthLoadingAction(false));

        if (result == null || !result) {
          completer.complete(false);
        }
        completer.complete(true);
      } catch (error) {
        store.dispatch(SetAuthLoadingAction(false));
        logger.error(
          'verifyGenericEmailOTP',
          'Error in verifyGenericEmailOTP',
          error: error,
          stackTrace: StackTrace.current,
        );
        completer.complete(false);
      }
    });
  };
}

ThunkAction<AppState> verifyActivation({
  required String otp,
  required String activationId,
  Completer? completer,
  bool isActivation = true,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      // authenticationService ??= AuthenticationService(
      //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      //   store: store,
      // );

      var apiAuthenticationService = ApiAuthenticationService(
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        store: store,
      );

      store.dispatch(SetAuthLoadingAction(true));

      try {
        final result = await apiAuthenticationService.verifyActivation(
          data: VerifyActivationRequest(activationId: activationId, otp: otp),
          token: encodeToken(),
        );

        BuildContext ctx = globalNavigatorKey.currentContext!;

        if (result == null) {
          store.dispatch(SetAuthLoadingAction(false));
          showErrorDialog(ctx, ActivationErrorCodes.verifyOtpResultNull);
          return;
        }
        if (result.success == false) {
          store.dispatch(SetAuthLoadingAction(false));
          showErrorDialog(
            ctx,
            result.errorMessage ?? ActivationErrorCodes.otpVerifiedFailed,
          );
          return;
        }

        if (isActivation) {
          Navigator.of(ctx).push(
            CustomRoute(
              builder: ((context) => VerifyMerchantInfoPage(
                activationData: result,
                isActivation: isActivation,
              )),
            ),
          );
        } else {
          Navigator.of(ctx).push(
            CustomRoute(
              builder: ((context) => MerchantVerifyPage(
                profile: BusinessUserProfile.fromBankMerchant(
                  result.merchantInfo,
                ),
                activationData: result,
              )),
            ),
          );
        }

        store.dispatch(SetAuthLoadingAction(false));
      } on ApiErrorException catch (e) {
        store.dispatch(SetAuthLoadingAction(false));
        logger.error(
          'verifyActivation',
          'API error in verifyActivation: ${e.error.userMessage}',
          error: e,
          stackTrace: StackTrace.current,
        );

        BuildContext ctx = globalNavigatorKey.currentContext!;
        showErrorDialog(ctx, e);
      } catch (error) {
        store.dispatch(SetAuthLoadingAction(false));
        logger.error(
          'verifyActivation',
          'Error in activateBusiness',
          error: error,
          stackTrace: StackTrace.current,
        );

        BuildContext ctx = globalNavigatorKey.currentContext!;
        showErrorDialog(ctx, error);
      }
    });
  };
}

ThunkAction<AppState> activateBusiness({
  required String activationId,
  required bool isActivation,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      // authenticationService ??= AuthenticationService(
      //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      //   store: store,
      // );

      var apiAuthenticationService = ApiAuthenticationService(
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        store: store,
      );

      store.dispatch(SetAuthLoadingAction(true));

      try {
        final result = await apiAuthenticationService.activationRequest(
          data: ActivationRequest(activationId: activationId),
          token: encodeToken(),
        );

        BuildContext ctx = globalNavigatorKey.currentContext!;
        if (result.success == false) {
          store.dispatch(SetAuthLoadingAction(false));
          showErrorDialog(ctx, ActivationErrorCodes.activateBusinessFailure);
          return;
        }
        Navigator.of(ctx).push(
          CustomRoute(
            builder: ((context) =>
                RegisterCompletePage(isActivation: isActivation)),
          ),
        );

        store.dispatch(SetAuthLoadingAction(false));
      } on ApiErrorException catch (e) {
        logger.error(
          'activateBusiness',
          'API error in activateBusiness: ${e.error.userMessage}',
          error: e,
          stackTrace: StackTrace.current,
        );
        store.dispatch(SetAuthLoadingAction(false));

        BuildContext ctx = globalNavigatorKey.currentContext!;
        showErrorDialog(ctx, e);
      } catch (error) {
        logger.error(
          'activateBusiness',
          'Error in activateBusiness',
          error: error,
          stackTrace: StackTrace.current,
        );
        store.dispatch(SetAuthLoadingAction(false));

        BuildContext ctx = globalNavigatorKey.currentContext!;
        showErrorDialog(ctx, error);
      }
    });
  };
}

ThunkAction<AppState> register({
  required String? username,
  required String? password,
  Completer? completer,
  required BuildContext context,
  required String source,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      // authenticationService ??= AuthenticationService(
      //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      //   store: store,
      // );

      var apiAuthenticationService = ApiAuthenticationService(
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        store: store,
      );
      store.dispatch(SetAuthLoadingAction(true));

      try {
        // 1) create firebase user
        final authUser = await authManager.signUpWithEmailAndPassword(
          email: username!,
          password: password!,
        );

        // 2) process firebase token into redux
        final tokenData = await _processTokenResult(
          authUser,
          store,
          source: source,
        );

        // 3) POS: ensure MID is present
        final mid = await tryGetMerchantId();

        if (AppVariables.isPOSBuild && isBlank(mid)) {
          logger.error(
            'register',
            AuthenticationErrorCodes.failedToVerifyMidOnPos.message,
          );
          showMessageDialog(
            globalNavigatorKey.currentContext!,
            AuthenticationErrorCodes.failedToVerifyMidOnPos.message,
            LittleFishIcons.error,
            status: StatusType.destructive,
          );
          throw Exception(
            AuthenticationErrorCodes.failedToVerifyMidOnPos.message,
          );
        }

        // 4) call backend verify (now can throw ApiErrorException)
        final verifiedResult = AppVariables.isPOSBuild
            ? await apiAuthenticationService.verifyUserWithMID(
                mid!,
                authUser,
                tokenData.token,
              )
            : await apiAuthenticationService.verifyUser(
                authUser,
                tokenData.token,
              );

        _processVerifiedResult(verifiedResult, store);

        await verifyHelper(
          verifiedResult: verifiedResult,
          store: store,
          context: context,
          navigateToSplashScreen: true,
        );

        store.dispatch(SetAuthLoadingAction(false));
      } on ApiErrorException catch (e) {
        final msg = e.error.userMessage;

        reportCheckedError(e, trace: StackTrace.current);

        completer?.completeError(ManagedException(message: msg, name: msg));

        showMessageDialog(
          globalNavigatorKey.currentContext!,
          msg,
          LittleFishIcons.error,
          status: StatusType.destructive,
        );

        store.dispatch(SetAuthLoadingAction(false));
      } catch (e) {
        final errorText = e.toString();

        reportCheckedError(e, trace: StackTrace.current);

        completer?.completeError(
          ManagedException(message: errorText, name: errorText),
        );

        showMessageDialog(
          globalNavigatorKey.currentContext!,
          errorText,
          LittleFishIcons.error,
          status: StatusType.destructive,
        );

        store.dispatch(SetAuthLoadingAction(false));
      }
    });
  };
}

Future<AuthTokenResult> _processTokenResult(
  AuthUser result,
  Store<AppState> store, {
  required String source,
}) async {
  var tokenData = await result.getAuthTokenResult();

  store.dispatch(
    LogonFirebaseSuccessAction.fromTokenResult(
      result,
      tokenData,
      source: source,
    ),
  );

  return tokenData;
}

void _processVerifiedResult(
  AuthenticationResult? verifiedResult,
  Store<AppState> store,
) {
  store.dispatch(SetBusinessListAction(verifiedResult?.businesses ?? []));

  if ((verifiedResult?.businesses?.isNotEmpty ?? false)) {
    store.dispatch(
      SetSelectedBusinessAction(verifiedResult!.businesses!.first),
    );

    store.dispatch(
      SetBusinessPermissionsListAction(verifiedResult.businessUsers ?? []),
    );

    store.dispatch(SetUserAccessPermissions(store.state.permissions));
  }
}

ThunkAction<AppState> onboardingRegister({
  required BuildContext context,
  required BusinessUserProfile businessUserProfile,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        store.dispatch(SetAuthLoadingAction(true));

        // authenticationService ??= AuthenticationService(
        //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        //   store: store,
        // );
        var apiAuthenticationService = ApiAuthenticationService(
          baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
          token: store.state.authState.token,
          store: store,
        );

        final result = await apiAuthenticationService
            .registerUserAndBusinessWithPassword(businessUserProfile);

        store.dispatch(SetAuthLoadingAction(false));
        var ctx = globalNavigatorKey.currentContext;

        if (result.success == true) {
          await showMessageDialog(
            ctx!,
            'Account Registered Successfully!',
            Icons.check,
            status: StatusType.success,
            iconColor: Theme.of(ctx).extension<AppliedTextIcon>()?.brand,
            confirmText: 'Continue to Login',
          ).then(
            (value) => Navigator.of(ctx).pushNamedAndRemoveUntil(
              LoginPage.route,
              ModalRoute.withName(LandingPage.route),
            ),
          );
          return true;
        } else {
          showMessageDialog(ctx!, result.error!, LittleFishIcons.error);
          return false;
        }
      } on ApiErrorException catch (e) {
        store.dispatch(SetAuthLoadingAction(false));

        final ctx = globalNavigatorKey.currentContext ?? context;
        final message = e.error.userMessage;

        showMessageDialog(ctx, message, LittleFishIcons.error);

        completer?.completeError(
          AuthorizationException('unable to register', message),
        );

        reportCheckedError(e, trace: StackTrace.current);
      } catch (e) {
        completer?.completeError(
          Exception('Something went wrong, Please contact Support'),
        );

        reportCheckedError(e, trace: StackTrace.current);

        store.dispatch(SetAuthLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> resetPassword({
  required String email,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      // authenticationService = AuthenticationService(
      //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      //   store: store,
      // );

      await authManager
          .sendPasswordResetEmail(email: email)
          .catchError((error) {
            reportCheckedError(error, trace: StackTrace.current);
            completer?.completeError(
              ManagedException(message: 'User not found'),
            );
            log(error.toString(), error: error, stackTrace: StackTrace.current);
          })
          .then((_) {
            completer?.complete();
          });
    });
  };
}

ThunkAction<AppState> resetPasswordSendGrid({
  required String email,
  Completer? completer,
  void Function(String message, IconData icon)? onComplete,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetAuthLoadingAction(true));

    try {
      var apiAuthenticationService = ApiAuthenticationService(
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        store: store,
      );
      final result = await apiAuthenticationService.resetPasswordSendGrid(
        emailAddress: email,
      );

      final success = result['success'] as bool? ?? false;
      final message = result['message'] as String? ?? 'Unexpected response';

      onComplete?.call(
        message,
        success ? Icons.check_circle_outline : LittleFishIcons.error,
      );

      completer?.complete();
    } catch (e) {
      reportCheckedError(e, trace: StackTrace.current);

      onComplete?.call(
        'An error occurred. Please try again later.',
        LittleFishIcons.error,
      );

      completer?.completeError(ManagedException(message: 'User not found'));
    } finally {
      store.dispatch(SetAuthLoadingAction(false));
    }
  };
}

ThunkAction<AppState> changePassword({
  required String email,
  required String oldPassword,
  required String newPassword,
  required void Function(String message, IconData icon) onComplete,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetAuthLoadingAction(true));

    try {
      var apiAuthenticationService = ApiAuthenticationService(
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        store: store,
      );

      final result = await apiAuthenticationService.changeUserPassword(
        email: email,
        oldPassword: oldPassword,
        newPassword: newPassword,
        token: store.state.authState.token,
      );

      final success = result['success'] as bool? ?? false;
      final message = result['message'] as String? ?? 'Unknown response';

      onComplete(
        message,
        success ? Icons.check_circle_outline : LittleFishIcons.error,
      );
    } catch (e) {
      reportCheckedError(e, trace: StackTrace.current);

      store.dispatch(
        AuthSetErrorAction(
          true,
          'Failed to change password. Please try again.',
        ),
      );

      onComplete('Failed to change password.', LittleFishIcons.error);
    } finally {
      store.dispatch(SetAuthLoadingAction(false));
    }
  };
}

ThunkAction<AppState> lockoutUser(BuildContext context) {
  return (Store<AppState> store) async {
    Future(() async {
      // authenticationService = AuthenticationService(
      //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      //   store: store,
      // );
      await Navigator.pushNamedAndRemoveUntil(
        context,
        LandingPage.route,
        (route) => false,
      );
    });
  };
}

ThunkAction<AppState> getRefreshToken(Completer? completer, String source) {
  return (Store<AppState> store) async {
    Future(() async {
      // final authenticationService = AuthenticationService(
      //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      //   store: store,
      // );

      try {
        final apiAuthenticationService = ApiAuthenticationService(
          baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
          token: store.state.authState.token,
          store: store,
        );

        final apiAuthResults = await apiAuthenticationService.getRefreshToken();

        final authUser = await authManager.signInWithCustomToken(
          token: apiAuthResults.token!,
        );

        final tokenData = await authUser.getAuthTokenResult();

        // if (authUser != null && tokenData.token != null) {
        store.dispatch(
          LogonFirebaseSuccessAction.fromTokenResult(
            authUser,
            tokenData,
            source: source,
          ),
        );
        // }

        completer?.complete();
      } on ApiErrorException catch (e) {
        final msg = e.error.userMessage;
        completer?.completeError(
          AuthorizationException('unable to refresh session', msg),
        );
      } catch (e) {
        completer?.completeError(e);
      }
    });
  };
}

ThunkAction<AppState> submitOtp({
  required otpId,
  required otpValue,
  RouteSettings? onSuccessRoute,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      // if (authenticationService == null)
      //   authenticationService = AuthenticationService(
      //     baseUrl: store.state.environmentState.environmentConfig.baseUrl,
      //   );

      // store.dispatch(SetAuthLoadingAction(true));

      // authenticationService.submitOtp().catchError((error) {
      //   store.dispatch(
      //     OTPFailureAction(error.toString()),
      //   );
      // }).then((result) {
      //   if (result.authenticated) {
      //     {
      //       store.dispatch(LogonSuccessAction(result));

      //       if (onSuccessRoute != null)
      //         Catcher2.navigatorKey.currentState.pushNamedAndRemoveUntil(
      //           onSuccessRoute.name,
      //           ModalRoute.withName(onSuccessRoute.name),
      //         );
      //       else
      //         Catcher2.navigatorKey.currentState.pushNamedAndRemoveUntil(
      //           HomePage.route,
      //           ModalRoute.withName(HomePage.route),
      //         );
      //     }
      //   } else
      //     store.dispatch(OTPFailureAction(
      //       result?.message ?? "Invalid OTP Entered",
      //     ));
      // });
    });
  };
}

ThunkAction<AppState> resetActivityTimer() {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(ResetLockoutTimerAction());
    });
  };
}

ThunkAction<AppState> deleteAccount({
  required String? uid,
  Completer? completer,
  required BuildContext context,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      //we need to route from here
      // Catcher2?.navigatorKey?.currentState?.pushAndRemoveUntil(
      //     CustomRoute(builder: (c) => LoadingScreen()),
      //     ModalRoute.withName(LandingPage.route));

      var userService = UserProfileService.fromStore(store);

      await userService
          .deleteUserAccount(uid)
          .then((result) {
            store.dispatch(signOut(reason: 'user-deleted-account'));
          })
          .catchError((error) {
            reportCheckedError(error, trace: StackTrace.current);
            completer?.completeError(error);
          })
          .whenComplete(() {});
    });
  };
}

ThunkAction<AppState> signOut({required String reason, Completer? completer}) {
  return (Store<AppState> store) async {
    Future(() async {
      //we need to route from here
      // Catcher2.navigatorKey?.currentState?.pushAndRemoveUntil(
      //     CustomRoute(builder: (c) => LoadingScreen()),
      //     ModalRoute.withName(LandingPage.route));
      await secureStorage.delete(key: 'refresh_token');
      store.dispatch(SetAuthLoadingAction(true));
      //logout from the app completely
      await store.state.authManager
          .signOut()
          .catchError((e) {
            reportCheckedError(e, trace: StackTrace.current);
          })
          .then((value) {
            var salesStore = SalesStore();

            salesStore.clear();
          });
      store.dispatch(SignoutAction(reason));
      store.dispatch(SetAuthLoadingAction(false));
      await Navigator.pushNamedAndRemoveUntil(
        globalNavigatorKey.currentContext!,
        LandingPage.route,
        (route) => false,
      );
    });
  };
}

ThunkAction<AppState> resendOtp() {
  return (Store<AppState> store) async {
    Future(() async {
      // authenticationService ??= AuthenticationService(
      //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      //   store: store,
      // );
    });
  };
}

Future<bool?> validateUserExists({
  required BuildContext context,
  required Store<AppState> store,
  required String merchantId,
  required String email,
}) async {
  // authenticationService ??= AuthenticationService(
  //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
  //   store: store,
  // );

  var apiAuthenticationService = ApiAuthenticationService(
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    token: store.state.authState.token,
    store: store,
  );

  store.dispatch(SetAuthLoadingAction(true));
  try {
    final result = await apiAuthenticationService.validateUserExists(
      merchantId: merchantId,
      email: email,
      token: encodeToken(),
    );
    store.dispatch(SetAuthLoadingAction(false));
    return result;
  } on ApiErrorException catch (e) {
    store.dispatch(SetAuthLoadingAction(false));
    showMessageDialog(context, e.error.userMessage, LittleFishIcons.error);
    return null;
  } catch (_) {
    store.dispatch(SetAuthLoadingAction(false));
    showMessageDialog(
      context,
      'Could not find user using the provided information. Please try again.',
      LittleFishIcons.error,
    );
    return null;
  }
}

ThunkAction<AppState> checkUserExistsThunk({
  required BuildContext context,
  required String email,
  required Completer<bool> completer,
}) {
  return (Store<AppState> store) async {
    // authenticationService ??= AuthenticationService(
    //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    //   store: store,
    // );

    var apiAuthenticationService = ApiAuthenticationService(
      baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      token: store.state.authState.token,
      store: store,
    );

    store.dispatch(SetAuthLoadingAction(true));
    try {
      final exists = await apiAuthenticationService.checkUserExists(
        email: email,
      );
      completer.complete(exists);
    } on ApiErrorException catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      completer.complete(false);
    } catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      completer.complete(false); // fallback to false if error occurs
    } finally {
      store.dispatch(SetAuthLoadingAction(false));
    }
  };
}

Future<bool?> activationClientStatus({
  required BuildContext context,
  required Store<AppState> store,
  bool enableLoading = true,
}) async {
  // authenticationService ??= AuthenticationService(
  //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
  //   store: store,
  // );

  var apiAuthenticationService = ApiAuthenticationService(
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    token: store.state.authState.token,
    store: store,
  );
  if (enableLoading) {
    store.dispatch(SetAuthLoadingAction(true));
  }
  try {
    final result = await apiAuthenticationService.activationClientStatus(
      token: encodeToken(),
    );
    if (enableLoading) {
      store.dispatch(SetAuthLoadingAction(false));
    }
    if (result == null) return false;
    return result;
  } on ApiErrorException catch (e) {
    if (enableLoading) {
      store.dispatch(SetAuthLoadingAction(false));
    }
    reportCheckedError(e, trace: StackTrace.current);
    return false;
  } catch (_) {
    if (enableLoading) {
      store.dispatch(SetAuthLoadingAction(false));
    }
    return false;
  }
}

Future<BankMerchant?> getBankMerchant({
  required BuildContext context,
  required Store<AppState> store,
  required ActivationUserInput userInput,
}) async {
  // authenticationService ??= AuthenticationService(
  //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
  //   store: store,
  // );

  var apiAuthenticationService = ApiAuthenticationService(
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    token: store.state.authState.token,
    store: store,
  );

  store.dispatch(SetAuthLoadingAction(true));

  try {
    BankMerchant? result;

    result = await apiAuthenticationService.getSBSAActivationUser(
      merchantId: userInput.activationFields[0].value!,
      token: encodeToken(),
    );
    // if (isSBSA) {
    //   result = await authenticationService?.getSBSAActivationUser(
    //     merchantId: userInput.activationFields[0].value!,
    //     token: encodeToken(),
    //   );
    // } else {
    //   result = await authenticationService?.getUser(
    //     activationUserInput: userInput,
    //     token: encodeToken(),
    //   );
    // }
    store.dispatch(SetAuthLoadingAction(false));
    if (result == null) {
      return null;
    }
    store.dispatch(SetBankMerchantAction(result));
    return result;
  } on ApiErrorException catch (e) {
    store.dispatch(SetAuthLoadingAction(false));
    showMessageDialog(context, e.error.userMessage, LittleFishIcons.error);
    return null;
  } catch (_) {
    store.dispatch(SetAuthLoadingAction(false));
    showMessageDialog(
      context,
      'Could not find user using the provided information. Please try again.',
      LittleFishIcons.error,
    );
    return null;
  }
}

class LogonSuccessAction {
  AuthenticationResult result;

  LogonSuccessAction(this.result);
}

class RefreshTokenAction {}

class RefreshClaimsTokenAction {
  String? token;

  RefreshClaimsTokenAction(this.token);
}

class LogonFirebaseSuccessAction {
  String source;

  String? token;

  AuthUser? user; // User firebase

  AuthUserInfo? userInfo;

  dynamic claims;

  String? signInProvider;

  DateTime? issuedAtTime;

  DateTime? authTime;

  DateTime? expirationTime;

  // AuthUser? result; //User Credential

  LogonFirebaseSuccessAction(this.token, this.user, {required this.source});

  LogonFirebaseSuccessAction.fromTokenResult(
    AuthUser this.user,
    AuthTokenResult tokenResult, {
    required this.source,
  }) {
    logger.debug(
      'redux.auth.actions',
      'LogonFirebaseSuccess: Starting token result processing. Token: [${tokenResult.token?.substring(0, 15)}]',
    );

    token = tokenResult.token;
    authTime = tokenResult.authTime;
    issuedAtTime = tokenResult.issuedAtTime;
    expirationTime = tokenResult.expirationTime;
    signInProvider = tokenResult.signInProvider;
    claims = tokenResult.claims;
    user = user;
    userInfo = user?.additionalUserInfo;

    logger.debug(
      'redux.auth.actions',
      'LogonFirebaseSuccess: Token processed [${token?.substring(0, 15)}]',
    );
    logger.debug(
      'redux.auth.actions',
      'LogonFirebaseSuccess: Token result processing completed',
    );
  }

  LogonFirebaseSuccessAction.fromAuthChanged(
    this.user,
    AuthTokenResult tokenResult, {
    required this.source,
  }) {
    token = tokenResult.token;
    authTime = tokenResult.authTime;
    issuedAtTime = tokenResult.issuedAtTime;
    expirationTime = tokenResult.expirationTime;
    signInProvider = tokenResult.signInProvider;
    claims = tokenResult.claims;
    userInfo = user?.additionalUserInfo;
  }
}

class RegisterSuccessAction {
  AuthenticationResult result;

  RegisterSuccessAction(this.result);
}

class OnSetActivePermissions {
  UserPermissions value;

  List<NavbarItem> quickActions;

  List<NavbarItem> homeActions;

  List<NavbarItem> drawerActions;

  OnSetActivePermissions(
    this.value,
    this.drawerActions,
    this.homeActions,
    this.quickActions,
  );
}

class LogonFailureAction {
  String message;

  LogonFailureAction(this.message);
}

String encodeToken() {
  return base64.encode(
    utf8.encode(AppVariables.store!.state.authorizationToken ?? ''),
  );
}

class RegistrationFailureAction {
  String message;

  RegistrationFailureAction(this.message);
}

class GuestLogonFailureAction {
  String? message;

  GuestLogonFailureAction(this.message);
}

class OTPFailureAction {
  String message;

  OTPFailureAction(this.message);
}

class SetBankMerchantAction {
  BankMerchant bankMerchant;

  SetBankMerchantAction(this.bankMerchant);
}

class SetOTPIdentifier {
  String identifier;

  SetOTPIdentifier(this.identifier);
}

class SetMerchantOTPContactInfoAction {
  List<GenerateOTPRequest> value;

  SetMerchantOTPContactInfoAction(this.value);
}

class SetAuthLoadingAction {
  bool value;

  SetAuthLoadingAction(this.value);
}

class SetUserNameAction {
  String value;

  SetUserNameAction(this.value);
}

class SetUserAccessPermissions {
  UserPermissions? value;

  SetUserAccessPermissions(this.value);
}

class SignoutAction {
  String cause;

  SignoutAction(this.cause);
}

class DeleteAccountAction {}

//UI Actions

class AuthSetPasswordAction {
  String? value;

  AuthSetPasswordAction(this.value);
}

class AuthResetErrorAction {}

class AuthSetErrorAction {
  bool value;
  String message;

  AuthSetErrorAction(this.value, this.message);
}

class AuthLockoutAction {}

class ResetLockoutTimerAction {}

class RebuildAccessManagerAction {}

class SetHasAppInitializedAction {
  bool value;

  SetHasAppInitializedAction(this.value);
}

class UpdateAuthTokenErrorAction {
  bool value;

  UpdateAuthTokenErrorAction(this.value);
}

class SetRefreshTokenAction {
  final String refreshToken;
  SetRefreshTokenAction(this.refreshToken);
}

class SetAccessTokenAction {
  final String token;

  SetAccessTokenAction(this.token);
}
