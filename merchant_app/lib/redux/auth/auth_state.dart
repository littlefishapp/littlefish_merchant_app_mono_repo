// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_auth/littlefish_auth_manager.dart';
import 'package:littlefish_core/auth/models/auth_user.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_core/core/littlefish_core.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/security/access_management/module.dart';
import 'package:littlefish_merchant/models/security/authentication/bank_merchant.dart';
import 'package:littlefish_merchant/models/security/authentication/generate_otp_request.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'auth_state.g.dart';

@immutable
@JsonSerializable()
@IsoDateTimeConverter()
abstract class AuthState implements Built<AuthState, AuthStateBuilder> {
  const AuthState._();

  factory AuthState({
    AuthProviderType authProviderType = AuthProviderType.systemDefault,
  }) => _$AuthState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    currentUser: null,
    userInfo: null,
    hasTokenError: false,
  );

  Timer? get authTimer;

  Timer? get lockoutTimer;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  String? get token;

  String? get sessionId;

  String? get refreshToken;

  String? get userId;

  String? get userName;

  DateTime? get expirationTime;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasAppInitialized;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get otpRequired;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get otpId;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, dynamic>? get routes;

  @JsonKey(includeFromJson: false, includeToJson: false)
  UserPermissions? get permissions;

  bool? get canAddProducts => permissions?.manageProducts;

  bool? get canAddCustomers => permissions?.manageCustomers;

  @JsonKey(includeFromJson: false, includeToJson: false)
  AccessManager? get accessManager;

  AuthUser? get currentUser;

  AuthUserInfo? get userInfo;

  String? get signInProvider;

  DateTime? get issuedAtTime;

  bool? get hasTokenError;

  DateTime? get authTime;

  LittlefishAuthManager get authManager => LittlefishAuthManager.instance;

  bool get isAuthenticated => currentUser != null;

  resetAuthTimer(AuthStateBuilder builder) {
    if (builder.authTimer != null) {
      builder.authTimer?.cancel();
      builder.authTimer = null;
    }

    int timeToExpiry = builder.expirationTime!
        .difference(DateTime.now().toUtc())
        .inMinutes;

    if (timeToExpiry < 5) timeToExpiry = 5;

    builder.authTimer?.cancel();
    builder.authTimer = Timer(Duration(minutes: timeToExpiry - 5), () {
      AppVariables.store!.dispatch(RefreshTokenAction());
    });
  }

  resetLockTimer(AuthStateBuilder builder) {
    if (builder.lockoutTimer != null) {
      builder.lockoutTimer?.cancel();
      builder.lockoutTimer = null;
    }

    int timeToExpiry = 15;

    if (timeToExpiry < 5) timeToExpiry = 5;

    builder.lockoutTimer?.cancel();
    builder.lockoutTimer = Timer(Duration(minutes: timeToExpiry), () {
      //ToDo (BHowes): a lock is not the same as a logout, this logic needs to be looked at in the future (tech-debt)
      //we need to invoke a signout as the user is not active at this point
      // AppVariables.store!.dispatch(signOut());
    });
  }

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);

  Map<String, dynamic> toJson() => _$AuthStateToJson(this);
}

abstract class AuthUIState implements Built<AuthUIState, AuthUIStateBuilder> {
  AuthUIState._();

  factory AuthUIState() =>
      _$AuthUIState._(hasError: false, isLoading: false, errorMessage: null);

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  String? get userName;

  String? get password;

  String? get pin;

  LoginProvider? get loginProvider;

  String? get otpIdentifier;

  BankMerchant? get bankMerchant;

  List<GenerateOTPRequest>? get merchantOTPContactInfo;

  String? parseUserName(AuthProviderType authType) {
    if (authType == AuthProviderType.systemDefault) {
      return userName;
    } else {
      if (loginProvider == LoginProvider.mobile) {
        return '$userName@nybble.africa';
      } else {
        return userName;
      }
    }
  }
}

enum LoginProvider { email, mobile }
