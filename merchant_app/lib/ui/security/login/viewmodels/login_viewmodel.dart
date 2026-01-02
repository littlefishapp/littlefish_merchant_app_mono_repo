// Flutter imports:
import 'dart:async';

import 'package:flutter/material.dart';

// Package imports:
import 'package:littlefish_auth/littlefish_auth_manager.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_core_utils/httpErrors/models/api_error.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/device/interfaces/device_details.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/security/authentication/activation_option.dart';
import 'package:littlefish_merchant/models/security/authentication/generate_otp_request.dart';
import 'package:littlefish_merchant/redux/device/device_actions.dart';
import 'package:littlefish_merchant/services/api_authentication_service.dart';
import 'package:littlefish_merchant/ui/security/registration/functions/activation_functions.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/auth/auth_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/models/security/authentication/bank_merchant.dart';
import 'package:littlefish_merchant/models/security/user/business_user_profile.dart';

class LoginVM extends StoreViewModel<AuthUIState> {
  LoginVM.fromStore(Store<AppState> store) : super.fromStore(store);

  String? userName;

  String? password;

  bool? get hasDeviceDetailsLoaded {
    DeviceDetails? deviceDetails = store?.state.deviceState.deviceDetails;

    if (deviceDetails == null) return false;
    //Todo: Check if this is the right condition with terminal manager
    if (isBlank(deviceDetails.merchantId) || isBlank(deviceDetails.deviceId)) {
      return false;
    }
    return true;
  }

  String get parsedUserName => '$userName';

  LoginProvider? currentProvider;

  LittlefishAuthManager? authManager;

  late Function(BuildContext ctx) onLogon;

  Function(BuildContext ctx)? loginFacebook;

  late Function(BuildContext ctx) loginGoogle;

  Function(BuildContext ctx, String merchantId, PlatformType platformType)?
  loginGuest;

  late Function(String username) setUserName;

  late Function(String passsword) setPassword;

  late Function(BuildContext ctx, String userName) onResetPassword;

  Function()? checkActivationStatus;

  Function(BuildContext ctx)? checkDeviceDetailsStatus;

  Function(List<String>)? getActivationOptions;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    state = store!.state.authUIState;
    isLoading = state!.isLoading;
    hasError = state!.hasError;
    errorMessage = state!.errorMessage;

    authManager = store.state.authManager;

    userName = state!.userName;

    password = state!.password;

    currentProvider = state!.loginProvider;

    this.store = store;

    onResetErorr = () => store.dispatch(AuthResetErrorAction());

    checkDeviceDetailsStatus = (context) {
      Completer completer = Completer();

      store.dispatch(checkDeviceStatus(completer: completer));

      completer.future
          .then((_) {
            String? mid = formatMidValue(
              store.state.deviceState.deviceDetails?.merchantId,
            );
            loginGuest!(context, mid, platformType);
          })
          .catchError((error) {
            store.dispatch(SetAuthLoadingAction(false));
            store.dispatch(AuthSetErrorAction(true, error.toString()));
          });
    };

    getActivationOptions = (options) async {
      // authenticationService ??= AuthenticationService(
      //   baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      //   store: store,
      // );

      var apiAuthenticationService = ApiAuthenticationService(
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        store: store,
      );

      this.store?.dispatch(SetAuthLoadingAction(true));

      try {
        final activationOption = await apiAuthenticationService
            .getActivationOptions(options, encodeToken());

        return activationOption;
      } on ApiErrorException catch (e) {
        showMessageDialog(
          globalNavigatorKey.currentContext!,
          e.error.userMessage,
          LittleFishIcons.error,
          status: StatusType.destructive,
        );
        return null;
      } finally {
        this.store?.dispatch(SetAuthLoadingAction(false));
      }
    };

    setUserName = (username) {
      userName = username;
      store.dispatch(SetUserNameAction(username));
    };

    setPassword = (password) {
      this.password = password;
      store.dispatch(AuthSetPasswordAction(password));
    };

    onResetPassword = (ctx, userName) {
      store.dispatch(
        resetPasswordSendGrid(
          email: userName,
          completer: snackBarCompleter(
            ctx,
            'Link Sent!',
            shouldPop: true,
            usePopup: false,
          ),
        ),
      );
    };

    onLogon = (ctx) {
      String? mid;

      if (key != null && key!.currentState!.validate()) {
        key!.currentState!.save();

        if (AppVariables.isPOSBuild && AppVariables.enableMidValidation) {
          mid = store.state.deviceState.deviceDetails?.merchantId;
          if (isBlank(mid)) {
            showMessageDialog(
              ctx,
              'Unable to find merchant ID.',
              LittleFishIcons.error,
              status: StatusType.destructive,
            ).then((_) {
              store.dispatch(SetAuthLoadingAction(false));
              if (ctx.mounted) Navigator.of(ctx).pop();
            });
            return;
          }
          store.dispatch(
            usernameAndPasswordLoginWithConditions(
              userName: parsedUserName,
              password: password,
              mid: mid,
              platformType: platformType,
              context: ctx,
              completer: snackBarCompleter(ctx, 'Welcome'),
              source: 'logonVM',
            ),
          );
        } else {
          store.dispatch(
            usernameAndPasswordLogon(
              userName: parsedUserName,
              password: password,
              context: ctx,
              completer: snackBarCompleter(ctx, 'Welcome'),
              source: 'logonVM',
            ),
          );
        }
      }
    };

    loginFacebook = (ctx) => store.dispatch(
      googleLogon(
        completer: snackBarCompleter(ctx, 'Welcome'),
        context: ctx,
        source: 'logonVM',
      ),
    );

    loginGoogle = (ctx) => store.dispatch(
      googleLogon(
        completer: snackBarCompleter(ctx, 'Welcome'),
        context: ctx,
        source: 'logonVM',
      ),
    );

    loginGuest = (ctx, mid, type) {
      store.dispatch(
        guestLogin(
          merchantId: mid,
          platformType: type,
          context: ctx,
          completer: snackBarCompleter(ctx, 'Welcome'),
          source: 'guestLogin_logonVM',
        ),
      );
    };
  }
}

class RegisterVM extends StoreViewModel<AuthUIState> {
  RegisterVM.fromStore(Store<AppState> store) : super.fromStore(store);

  String? userName;

  // String get parsedUserName => '$userName@nybble.africa';

  String get parsedUserName => '$userName';

  String? password;

  LoginProvider? currentProvider;

  LittlefishAuthManager? authManager;

  late Function(
    BuildContext ctx, {
    required String username,
    required String password,
  })
  onRegister;

  Function(BuildContext ctx)? loginFacebook;

  Function(String activationId, bool isActivation)? activateBusinessRequest;
  Function(String activationId, String otp, bool isActivation)?
  verifyActivationRequest;
  Function(String merchantId)? createActivationRequest;

  Function(BuildContext ctx)? loginGoogle;

  late Function(String username) setUserName;

  late Function(String passsword) setPassword;
  late Function(String identifier) setOtpIdentifier;

  late Function(
    BuildContext ctx, {
    required BusinessUserProfile businessUserProfile,
  })
  onOnboardingRegister;

  BankMerchant? bankMerchant;

  List<GenerateOTPRequest>? merchantOTPContactInfo;

  String? otpIdentifier;

  bool? hasDeviceDetailsLoaded;

  late Future<bool> Function(BuildContext context, String email)
  checkUserExists;

  late Future<Map<String, dynamic>> Function(
    BuildContext context,
    String merchantId,
  )
  merchantLookup;

  late Future<bool> Function(String otp) verifyOtp;

  late Future<bool> Function() sendOtp;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    state = store!.state.authUIState;

    isLoading = state!.isLoading;

    hasError = state!.hasError;

    errorMessage = state!.errorMessage;

    authManager = store.state.authManager;

    userName = state!.userName;

    password = state!.password;

    currentProvider = state!.loginProvider;

    this.store = store;

    bankMerchant = state!.bankMerchant;

    merchantOTPContactInfo = state!.merchantOTPContactInfo;

    otpIdentifier = state!.otpIdentifier;

    hasDeviceDetailsLoaded = store.state.deviceState.deviceDetails != null;

    onResetErorr = () => store.dispatch(AuthResetErrorAction());

    setUserName = (username) {
      userName = username;
      store.dispatch(SetUserNameAction(username));
    };

    setPassword = (password) {
      this.password = password;
      store.dispatch(AuthSetPasswordAction(password));
    };
    setOtpIdentifier = (identifer) {
      otpIdentifier = identifer;
      store.dispatch(SetOTPIdentifier(otpIdentifier!));
    };

    onRegister =
        (
          BuildContext ctx, {
          required String username,
          required String password,
        }) {
          store.dispatch(
            register(
              username: username,
              password: password,
              completer: snackBarCompleter(ctx, 'Welcome', usePopup: false),
              context: ctx,
              source: 'logonVM_register',
            ),
          );
        };

    onOnboardingRegister =
        (BuildContext ctx, {required BusinessUserProfile businessUserProfile}) {
          store.dispatch(
            onboardingRegister(
              context: ctx,
              businessUserProfile: businessUserProfile,
              completer: snackBarCompleter(ctx, 'Welcome', usePopup: false),
            ),
          );
        };

    loginFacebook = (ctx) => store.dispatch(
      googleLogon(
        completer: snackBarCompleter(ctx, 'Welcome'),
        context: ctx,
        source: 'logonVM_facebook',
      ),
    );

    loginGoogle = (ctx) => store.dispatch(
      googleLogon(
        completer: snackBarCompleter(ctx, 'Welcome'),
        context: ctx,
        source: 'logonVM_google',
      ),
    );

    activateBusinessRequest = (activationId, isActivation) {
      store.dispatch(
        activateBusiness(
          activationId: activationId,
          isActivation: isActivation,
        ),
      );
    };
    verifyActivationRequest = (activationId, otp, isActivation) {
      store.dispatch(
        verifyActivation(
          otp: otp,
          activationId: activationId,
          isActivation: isActivation,
        ),
      );
    };
    createActivationRequest = (merchantId) {
      store.dispatch(createActivation(merchantId: merchantId));
    };
    checkUserExists = (ctx, email) async {
      final completer = Completer<bool>();
      store.dispatch(
        checkUserExistsThunk(context: ctx, email: email, completer: completer),
      );
      return completer.future;
    };

    merchantLookup = (context, merchantId) async {
      final completer = Completer<Map<String, dynamic>>();

      store.dispatch(
        hasMerchantBeenActivated(
          merchantId: merchantId,
          onResult: (result) {
            completer.complete(result);
          },
        ),
      );

      return completer.future;
    };

    sendOtp = () async {
      final completer = Completer<bool>();
      store.dispatch(sendGenericEmailOTP(completer: completer));
      bool success = await completer.future;
      if (!success) {
        await showMessageDialog(
          globalNavigatorKey.currentContext!,
          'Could not send OTP. Please try again.',
          LittleFishIcons.error,
        );
      }
      return success;
    };

    verifyOtp = (otp) async {
      final completer = Completer<bool>();
      store.dispatch(
        verifyGenericEmailOTP(
          otp: otp,
          otpId: otpIdentifier ?? '',
          completer: completer,
        ),
      );
      bool result = await completer.future;
      if (!result) {
        await showMessageDialog(
          globalNavigatorKey.currentContext!,
          'Could not verify OTP. Please try again.',
          LittleFishIcons.error,
        );
      }
      return result;
    };
  }
}
