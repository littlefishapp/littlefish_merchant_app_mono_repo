// Dart imports:
import 'dart:async';

// Package imports:
import 'package:dio/dio.dart';
import 'package:littlefish_core/auth/models/auth_user.dart';
import 'package:littlefish_core/auth/models/authentication_result.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/monitoring/models/monitoring_http_metric.dart';
import 'package:littlefish_core/monitoring/services/monitoring_service.dart';
import 'package:littlefish_core_utils/httpErrors/models/api_error.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/activation/activation_request.dart';
import 'package:littlefish_merchant/models/activation/activation_response.dart';
import 'package:littlefish_merchant/models/activation/create_activation_request.dart';
import 'package:littlefish_merchant/models/activation/create_activation_response.dart';
import 'package:littlefish_merchant/models/activation/verify_activation_request.dart';
import 'package:littlefish_merchant/models/activation/verify_activation_response.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/security/authentication/activation_option.dart';
import 'package:littlefish_merchant/models/security/authentication/api_authentication_result.dart';
import 'package:littlefish_merchant/models/security/authentication/api_base_response.dart';

import 'package:littlefish_merchant/models/security/authentication/bank_merchant.dart';
import 'package:littlefish_merchant/models/security/authentication/base_response_business_user_dto.dart';
import 'package:littlefish_merchant/models/security/authentication/business_user_dto.dart';
import 'package:littlefish_merchant/models/security/authentication/generate_otp_request.dart';
import 'package:littlefish_merchant/models/security/authentication/verify_otp_request.dart';

import 'package:littlefish_merchant/models/security/user/business_user_profile.dart';
import 'package:littlefish_merchant/redux/app/app_actions.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

LittleFishCore core = LittleFishCore.instance;

LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

class ApiAuthenticationService {
  String? baseUrl;
  String? token;
  Store<AppState>? store;
  late RestClient client;

  ApiAuthenticationService({
    required this.baseUrl,
    required this.token,
    required this.store,
  }) {
    client = RestClient(store: store);
  }

  ApiAuthenticationService.fromStore(Store<AppState> storeValue) {
    store = storeValue;
    baseUrl = storeValue.state.baseUrl;
    token = storeValue.state.token;

    client = RestClient(store: store);
  }

  // Future<AuthenticationResult?> login(
  //   String username,
  //   String password,
  // ) async {
  //   logger.debug('services.api_auth', 'Starting login process');

  //   try {
  //     final response = await client.post(
  //       url: '$baseUrl/Authentication/Login',
  //       token: token,
  //       requestData: {
  //         'username': username,
  //         'password': password,
  //       },
  //     );

  //     if (response?.statusCode == 200) {
  //       if (response?.data == null) return null;
  //       return AuthenticationResult.fromJson(response!.data);
  //     }

  //     final apiError = ApiError.fromJson(
  //       (response?.data ?? {}) is Map<String, dynamic>
  //           ? (response?.data ?? {}) as Map<String, dynamic>
  //           : <String, dynamic>{},
  //     );

  //     logger.warning(
  //       'services.api_auth',
  //       'Login failed: status=${apiError.status}, code=${apiError.errorCode}, '
  //           'detail=${apiError.detail}, traceId=${apiError.traceId}',
  //     );

  //     throw ApiErrorException(apiError);
  //   } on ApiErrorException catch (e) {
  //     logger.error(
  //       'services.api_auth',
  //       'ApiErrorException during login: ${e.error.toJson()}',
  //     );
  //     rethrow;
  //   } catch (e, st) {
  //     logger.error(
  //       'services.api_auth',
  //       'Unexpected error during login: $e',
  //     );

  //     throw ApiErrorException(
  //       ApiError(
  //         title: 'Unexpected error',
  //         detail:
  //             'Unable to authenticate. Please check your credentials and try again.',
  //         status: 500,
  //         errorCode: 'UNEXPECTED_CLIENT_ERROR',
  //       ),
  //     );
  //   }
  // }

  // Future<AuthenticationResult?> loginWithConditions(
  //   String username,
  //   String password,
  //   String mid,
  //   PlatformType platformType,
  // ) async {
  //   logger.debug('services.api_auth', 'Starting conditional login process');

  //   try {
  //     final response = await client.post(
  //       url: '$baseUrl/Authentication/LoginWithConditions',
  //       // token: token,
  //       requestData: {
  //         'username': username,
  //         'password': password,
  //         'deviceId': mid,
  //         'platformType': platformType.index,
  //       },
  //     );

  //     if (response?.statusCode == 200) {
  //       if (response?.data == null) return null;
  //       return AuthenticationResult.fromJson(response!.data);
  //     }

  //     final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
  //         ? response?.data as Map<String, dynamic>
  //         : <String, dynamic>{};
  //     final apiError = ApiError.fromJson(raw);

  //     if (response?.statusCode == 401) {
  //       logger.warning(
  //         'LoginWithConditions',
  //         'Unauthorized login attempt detected (Login with conditions). '
  //             'From user: $username and merchantId: $mid, traceId=${apiError.traceId}',
  //       );
  //     }

  //     throw ApiErrorException(apiError);
  //   } catch (e, st) {
  //     // if it's already our structured error, just rethrow
  //     if (e is ApiErrorException) {
  //       rethrow;
  //     }

  //     logger.error(
  //       'services.api_auth',
  //       'Unexpected error during loginWithConditions: $e',
  //     );

  //     // fallback structured error
  //     throw ApiErrorException(
  //       ApiError(
  //         title: 'Unexpected error',
  //         detail:
  //             'Unable to complete authentication. Please try again or contact support at ${AppVariables.clientSupportEmail} or ${AppVariables.clientSupportMobileNumber}.',
  //         status: 500,
  //         errorCode: 'UNEXPECTED_CLIENT_ERROR',
  //       ),
  //     );
  //   }
  // }

  Future<ApiAuthenticationResult> getRefreshToken() async {
    final response = await client.get(
      url: '$baseUrl/Authentication/GetRefreshToken',
      token: token,
    );

    if (response?.statusCode == 200) {
      return ApiAuthenticationResult.fromJson(response!.data);
    }

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};

    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.api_auth',
      'Refresh token failed: status=${apiError.status}, code=${apiError.errorCode}, '
          'detail=${apiError.detail}, traceId=${apiError.traceId}',
    );

    if (apiError.detail != null && apiError.detail!.isNotEmpty) {
      throw ApiErrorException(apiError);
    } else {
      throw ApiErrorException(
        ApiError(
          title: apiError.title ?? 'Session expired',
          detail: 'Your session has expired. Please log in again.',
          status: apiError.status ?? response?.statusCode ?? 401,
          errorCode: apiError.errorCode ?? 'SESSION_EXPIRED',
          traceId: apiError.traceId,
        ),
      );
    }
  }

  Future<AuthenticationResult?> verifyUserWithMID(
    String mid,
    AuthUser? user,
    String? token,
  ) async {
    final restClient = RestClient(store: store as Store<AppState>?);
    final MonitoringService monitoringService = core.get<MonitoringService>();
    logger.info(
      'api_authentication_service',
      '### verifyUserWithMID entry for mid=$mid',
    );
    var trace = await monitoringService.createHttpTrace(
      name: 'verify-user-with-mid',
      url: '$baseUrl/Authentication/VerifyFirebaseUserWithMid/$mid',
      method: MonitoringHttpMethod.POST,
    );

    trace.start();
    final response = await restClient.post(
      url: '$baseUrl/Authentication/VerifyFirebaseUserWithMid/$mid',
      // token: 'Bearer $token', //this token not used downstream use store
    );

    if (response?.statusCode == 200) {
      if (response!.data != null) {
        return AuthenticationResult.fromJson(response.data);
      } else {
        logger.warning(
          'services.auth',
          'verifyUserWithMID returned 200 but no data for mid=$mid',
        );
        throw ApiErrorException(
          ApiError(
            title: 'Unable to verify user',
            detail: 'The server returned an empty response.',
            status: 500,
            errorCode: 'VERIFY_USER_WITH_MID_EMPTY',
          ),
        );
      }
    }
    trace.stop();
  }

  Future<ApiBaseResponse?> verifyGuestUserExistsByMerchantId({
    required String merchantId,
    required String token,
  }) async {
    final response = await RestClient(store: store as Store<AppState>?).postBasic(
      url:
          '$baseUrl/User/VerifyGuestUserExistsByMerchantId?merchantId=$merchantId',
      token: 'Basic $token',
    );

    if (response?.statusCode == 200) {
      if (response!.data != null) {
        return ApiBaseResponse.fromJson(response.data);
      } else {
        logger.warning(
          'services.auth',
          'verifyGuestUserExistsByMerchantId 200 but no data for merchantId=$merchantId',
        );
        throw ApiErrorException(
          ApiError(
            title: 'Unable to verify if guest user exists',
            detail: 'The server returned an empty response.',
            status: 500,
            errorCode: 'VERIFY_GUEST_USER_EMPTY',
          ),
        );
      }
    }

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'verifyGuestUserExistsByMerchantId failed: status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, detail=${apiError.detail}, traceId=${apiError.traceId}, merchantId=$merchantId',
    );

    throw ApiErrorException(
      (apiError.detail != null && apiError.detail!.isNotEmpty)
          ? apiError
          : ApiError(
              title: 'Unable to verify if guest user exists',
              detail: 'Please try again.',
              status: apiError.status ?? response?.statusCode ?? 500,
              errorCode: apiError.errorCode ?? 'VERIFY_GUEST_USER_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<BusinessUser?> createGuestUserFromMerchantId({
    required String merchantId,
    required String businessId,
    required String token,
  }) async {
    var response = await RestClient(store: store as Store<AppState>?).postBasic(
      url:
          '$baseUrl/User/RegisterGuestUserFromMerchantId?merchantId=$merchantId&businessId=$businessId',
      token: 'Basic $token',
    );

    if (response?.statusCode == 200) {
      if (response!.data != null) {
        return BusinessUser.fromJson(response.data);
      } else {
        throw Exception('Unable to create new guest user');
      }
    } else {
      throw Exception('Unable to create new guest user');
    }
  }

  Future<BusinessUserDto> createBusinessFromMerchantId({
    required String merchantId,
    required String token,
  }) async {
    final response = await RestClient(store: store as Store<AppState>?).postBasic(
      url:
          '$baseUrl/SbsaMasApi/RegisterGuestBusinessFromMerchantId?merchantId=$merchantId',
      // note: you were using encodeToken() before — keeping that
      token: 'Basic $token',
    );

    if (response?.statusCode == 200) {
      if (response!.data != null) {
        return BusinessUserDto.fromJson(response.data);
      } else {
        // 200 but empty
        logger.warning(
          'services.auth',
          'createBusinessFromMerchantId returned 200 but no data for merchantId=$merchantId',
        );
        throw ApiErrorException(
          ApiError(
            title: 'Failed to create business',
            detail: 'The server returned an empty response.',
            status: 500,
            errorCode: 'CREATE_BUSINESS_FROM_MID_EMPTY',
          ),
        );
      }
    }

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'createBusinessFromMerchantId failed: status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, detail=${apiError.detail}, traceId=${apiError.traceId}, '
          'merchantId=$merchantId',
    );

    throw ApiErrorException(
      (apiError.detail != null && apiError.detail!.isNotEmpty)
          ? apiError
          : ApiError(
              title: 'Login Failure',
              detail:
                  'Failed to authenticate Guest user. Please contact the bank support team to ensure your MID is valid or try again later.',
              status: apiError.status ?? response?.statusCode ?? 500,
              errorCode:
                  apiError.errorCode ??
                  'REGISTER_GUEST_BUSINESS_FROM_MID_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<AuthenticationResult?> verifyUser(
    AuthUser? user,
    String? token,
  ) async {
    final restClient = RestClient(store: store as Store<AppState>?);
    final MonitoringService monitoringService = core.get<MonitoringService>();
    logger.info('api_authentication_service', '### verifyUser entry');
    var trace = await monitoringService.createHttpTrace(
      name: 'verify-user',
      url: '$baseUrl/Authentication/VerifyFirebaseUser',
      method: MonitoringHttpMethod.POST,
    );

    trace.start();
    final response = await restClient.post(
      url: '$baseUrl/Authentication/VerifyFirebaseUser',
    );

    if (response?.statusCode == 200) {
      trace.stop();
      if (response!.data != null) {
        return AuthenticationResult.fromJson(response.data);
      } else {
        // 200 but empty — unlikely, still an error
        logger.warning('services.auth', 'verifyUser returned 200 but no data');

        throw ApiErrorException(
          ApiError(
            title: 'Unable to verify firebase user',
            detail: 'Server returned an empty response.',
            status: 500,
            errorCode: 'VERIFY_USER_EMPTY_RESPONSE',
          ),
        );
      }
    }
    trace.stop();
    // non-200 → try structured error
    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'verifyUser failed: status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, detail=${apiError.detail}, traceId=${apiError.traceId}',
    );

    throw ApiErrorException(
      (apiError.detail != null && apiError.detail!.isNotEmpty)
          ? apiError
          : ApiError(
              title: 'Unable to verify firebase user',
              detail: 'Please try again later.',
              status: apiError.status ?? response?.statusCode ?? 500,
              errorCode: apiError.errorCode ?? 'VERIFY_USER_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<ApiBaseResponse> isGuestUser({required String userId}) async {
    final MonitoringService monitoringService = core.get<MonitoringService>();
    logger.info('api_authentication_service', '### verifyUser entry');
    var trace = await monitoringService.createHttpTrace(
      name: 'is-guest-user',
      url: '$baseUrl/User/IsGuestUser?userId=$userId',
      method: MonitoringHttpMethod.POST,
    );
    trace.start();
    final response = await RestClient(store: store as Store<AppState>?)
        .postBasic(
          url: '$baseUrl/User/IsGuestUser?userId=$userId',
          token: 'Basic ${encodeToken()}',
        );

    if (response?.statusCode == 200) {
      trace.stop();
      if (response!.data != null) {
        return ApiBaseResponse.fromJson(response.data);
      } else {
        logger.warning(
          'services.auth',
          'isGuestUser returned 200 but no data for userId=$userId',
        );
        throw ApiErrorException(
          ApiError(
            title: 'Unable to verify if business exists',
            detail: 'The server returned an empty response.',
            status: 500,
            errorCode: 'IS_GUEST_USER_EMPTY',
          ),
        );
      }
    }
    trace.stop();

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'isGuestUser failed: status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, detail=${apiError.detail}, traceId=${apiError.traceId}',
    );

    throw ApiErrorException(
      apiError.detail != null && apiError.detail!.isNotEmpty
          ? apiError
          : ApiError(
              title: 'Unable to verify if business exists',
              detail: 'Please try again later.',
              status: apiError.status ?? response?.statusCode ?? 500,
              errorCode: apiError.errorCode ?? 'IS_GUEST_USER_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<ActivationResponse?> requestOTP({
    required ActivationRequest data,
    String? token,
  }) async {
    final response = await RestClient(store: store as Store<AppState>?)
        .postBasic(
          url: '$baseUrl/Activation/ResendOtp',
          token: 'Basic $token',
          requestData: data.toJson(),
        );

    if (response?.statusCode == 200) {
      if (response!.data != null) {
        return ActivationResponse.fromJson(response.data);
      } else {
        logger.warning('services.auth', 'requestOTP returned 200 but no data');
        throw ApiErrorException(
          ApiError(
            title: 'Unable to generate OTP',
            detail: 'The server returned an empty response.',
            status: 500,
            errorCode: 'REQUEST_OTP_EMPTY',
          ),
        );
      }
    }

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'requestOTP failed: status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, detail=${apiError.detail}, traceId=${apiError.traceId}',
    );

    throw ApiErrorException(
      (apiError.detail != null && apiError.detail!.isNotEmpty)
          ? apiError
          : ApiError(
              title: 'Unable to generate OTP',
              detail: 'Please try again later.',
              status: apiError.status ?? response?.statusCode ?? 500,
              errorCode: apiError.errorCode ?? 'REQUEST_OTP_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<bool?> verifyOTP({
    required VerifyOTPRequest requestObj,
    required String userId,
    String? token,
  }) async {
    final response = await RestClient(store: store as Store<AppState>?)
        .postBasic(
          url: '$baseUrl/Otp/Verify/userId=$userId',
          token: 'Basic $token',
          requestData: requestObj.toJson(),
        );

    if (response?.statusCode == 200) {
      if (response!.data != null) {
        return response.data['success'] as bool?;
      }
      // 200 but empty
      logger.warning(
        'services.auth',
        'verifyOTP returned 200 but no data for userId=$userId',
      );
      throw ApiErrorException(
        ApiError(
          title: 'Unable to verify OTP',
          detail: 'The server returned an empty response.',
          status: 500,
          errorCode: 'VERIFY_OTP_EMPTY',
        ),
      );
    }

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'verifyOTP failed: status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, detail=${apiError.detail}, traceId=${apiError.traceId}',
    );

    throw ApiErrorException(
      (apiError.detail != null && apiError.detail!.isNotEmpty)
          ? apiError
          : ApiError(
              title: 'Unable to verify OTP',
              detail: 'Please try again.',
              status: apiError.status ?? response?.statusCode ?? 500,
              errorCode: apiError.errorCode ?? 'VERIFY_OTP_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<CreateActivationResponse?> createActivation({
    required CreateActivationRequest data,
    required String token,
  }) async {
    final response = await RestClient(store: store as Store<AppState>?)
        .postBasic(
          url: '$baseUrl/Activation/CreateActivation',
          token: 'Basic $token',
          requestData: data.toJson(),
        );

    if (response?.statusCode == 200) {
      if (response!.data != null) {
        try {
          return CreateActivationResponse.fromJson(response.data);
        } catch (e) {
          logger.error('AuthenticationService', 'createActivation', error: e);
          throw Exception('Missing Data');
        }
      } else {
        logger.error(
          'AuthenticationService',
          'Activation data returned null for create activation attempt',
          error: Exception('Unable to start activation'),
        );
        throw Exception('Unable to start activation');
      }
    }

    // non-200
    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'createActivation failed: status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, detail=${apiError.detail}, traceId=${apiError.traceId}',
    );

    throw ApiErrorException(
      (apiError.detail != null && apiError.detail!.isNotEmpty)
          ? apiError
          : ApiError(
              title: 'Unable to start activation',
              detail: 'Please try again.',
              status: apiError.status ?? response?.statusCode ?? 500,
              errorCode: apiError.errorCode ?? 'CREATE_ACTIVATION_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<Map<String, dynamic>> hasMerchantBeenActivated(
    String merchantId,
    String token,
  ) async {
    try {
      final response = await RestClient(store: store as Store<AppState>?).get(
        url:
            '$baseUrl/Merchant/HasMerchantBeenActivated?merchantId=$merchantId',
        token: 'Basic $token',
      );

      final data = response?.data;

      if (data == null) {
        return {'error': 'Empty response from server.'};
      }

      if (data is bool) {
        return {'value': data};
      }

      if (data is Map && data.containsKey('publicMessage')) {
        return {'error': data['publicMessage'] ?? 'Something went wrong'};
      }

      return {'error': 'Unexpected response format.'};
    } catch (e) {
      logger.error(
        'LinkNewStore',
        'Exception in hasMerchantBeenActivated',
        error: e,
      );
      return {'error': 'Something went wrong. Please try again.'};
    }
  }

  Future<bool?> sendGenericOTP({
    required List<GenerateOTPRequest> requests,
    required String otpId,
  }) async {
    final requestData = requests.map((r) => r.toJson()).toList();

    final response = await RestClient(store: store as Store<AppState>?)
        .postBasic(
          url: '$baseUrl/Otp/Generate/userId=$otpId',
          token: 'Basic ${encodeToken()}',
          requestData: requestData,
        );

    if (response?.statusCode == 200 && response?.data != null) {
      return response!.data['success'] as bool?;
    }

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'sendGenericOTP failed: status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, detail=${apiError.detail}, traceId=${apiError.traceId}',
    );

    throw ApiErrorException(
      (apiError.detail != null && apiError.detail!.isNotEmpty)
          ? apiError
          : ApiError(
              title: 'Unable to send OTP',
              detail: 'Please try again.',
              status: apiError.status ?? response?.statusCode ?? 500,
              errorCode: apiError.errorCode ?? 'SEND_GENERIC_OTP_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<VerifyActivationResponse?> verifyActivation({
    required VerifyActivationRequest data,
    required String token,
  }) async {
    final response = await RestClient(store: store as Store<AppState>?)
        .postBasic(
          url: '$baseUrl/Activation/VerifyOtp',
          token: 'Basic $token',
          requestData: data.toJson(),
        );

    if (response?.statusCode == 200) {
      if (response!.data != null) {
        try {
          return VerifyActivationResponse.fromJson(response.data);
        } catch (e) {
          logger.error('AuthenticationService', 'verifyActivation', error: e);
          throw Exception('Missing Data');
        }
      } else {
        logger.warning(
          'services.auth',
          'verifyActivation returned 200 but no data',
        );
        throw ApiErrorException(
          ApiError(
            title: 'Unable to verify otp',
            detail: 'The server returned an empty response.',
            status: 500,
            errorCode: 'VERIFY_ACTIVATION_EMPTY',
          ),
        );
      }
    }

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'verifyActivation failed: status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, detail=${apiError.detail}, traceId=${apiError.traceId}',
    );

    throw ApiErrorException(
      (apiError.detail != null && apiError.detail!.isNotEmpty)
          ? apiError
          : ApiError(
              title: 'Unable to verify otp',
              detail: 'Please try again.',
              status: apiError.status ?? response?.statusCode ?? 500,
              errorCode: apiError.errorCode ?? 'VERIFY_ACTIVATION_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<ActivationResponse> activationRequest({
    required ActivationRequest data,
    required String token,
  }) async {
    final response = await RestClient(store: store as Store<AppState>?)
        .postBasic(
          url: '$baseUrl/Activation/Activate',
          token: 'Basic $token',
          requestData: data.toJson(),
        );

    if (response?.statusCode == 200) {
      if (response!.data != null) {
        try {
          return ActivationResponse.fromJson(response.data);
        } catch (e) {
          logger.error(
            'AuthenticationService',
            'Could Not pass Data after activation attempt',
            error: e,
          );
          throw Exception('Missing Data');
        }
      } else {
        logger.warning(
          'services.auth',
          'activationRequest returned 200 but no data',
        );
        throw ApiErrorException(
          ApiError(
            title: 'Unable to create business',
            detail: 'The server returned an empty response.',
            status: 500,
            errorCode: 'ACTIVATION_REQUEST_EMPTY',
          ),
        );
      }
    }

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'activationRequest failed: status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, detail=${apiError.detail}, traceId=${apiError.traceId}',
    );

    throw ApiErrorException(
      (apiError.detail != null && apiError.detail!.isNotEmpty)
          ? apiError
          : ApiError(
              title: 'Unable to create business',
              detail: 'Please try again later.',
              status: apiError.status ?? response?.statusCode ?? 500,
              errorCode: apiError.errorCode ?? 'ACTIVATION_REQUEST_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<BaseResponseBusinessUserDto> registerUserAndBusinessWithPassword(
    BusinessUserProfile businessUserProfile,
  ) async {
    final response = await RestClient(store: store as Store<AppState>?)
        .postBasic(
          url: '$baseUrl/Business/CreateBusinessWithUser',
          token: 'Basic ${encodeToken()}',
          requestData: businessUserProfile.toJson(),
        );

    if (response?.statusCode == 200) {
      if (response!.data != null) {
        final data = BusinessUserDto.fromJson(response.data);
        final success =
            isNotBlank(data.businessId) ||
            isNotBlank(data.uid) ||
            isNotBlank(data.userId);
        return BaseResponseBusinessUserDto(
          success: success,
          data: data,
          error: '',
        );
      } else {
        return BaseResponseBusinessUserDto(
          success: false,
          data: null,
          error: 'Could not create user',
        );
      }
    }

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'registerUserAndBusinessWithPassword failed: '
          'status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, '
          'detail=${apiError.detail}, '
          'traceId=${apiError.traceId}',
    );

    throw ApiErrorException(
      apiError.detail != null && apiError.detail!.isNotEmpty
          ? apiError
          : ApiError(
              title: 'Registration failed',
              detail: 'Could not create user. Please try again later.',
              status: apiError.status ?? response?.statusCode ?? 500,
              errorCode: apiError.errorCode ?? 'REGISTRATION_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<bool?> validateUserExists({
    required String merchantId,
    required String email,
    required String token,
  }) async {
    final response = await RestClient(store: store as Store<AppState>?).getBasic(
      url:
          '$baseUrl/Merchant/HasMerchantBeenActivated?merchantId=$merchantId&email=$email',
      token: 'Basic $token',
    );

    if (response?.statusCode == 200) {
      if (response!.data != null) {
        return response.data as bool;
      }
      return null;
    }

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'validateUserExists failed: status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, detail=${apiError.detail}, traceId=${apiError.traceId}, '
          'merchantId=$merchantId, email=$email',
    );

    throw ApiErrorException(
      (apiError.detail != null && apiError.detail!.isNotEmpty)
          ? apiError
          : ApiError(
              title: 'Unable to validate if user exists',
              detail: 'Please try again.',
              status: apiError.status ?? response?.statusCode ?? 500,
              errorCode: apiError.errorCode ?? 'VALIDATE_USER_EXISTS_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<bool> checkUserExists({required String email}) async {
    final response = await RestClient(
      store: store as Store<AppState>?,
    ).getBasic(url: '$baseUrl/User/DoesUserExist?email=$email');

    if (response?.statusCode == 200) {
      if (response!.data != null) {
        return response.data as bool;
      } else {
        logger.warning(
          'services.auth',
          'checkUserExists returned 200 but empty body for email=$email',
        );
        throw ApiErrorException(
          ApiError(
            title: 'Failed to check if user exists',
            detail: 'The server returned an empty response.',
            status: 500,
            errorCode: 'CHECK_USER_EXISTS_EMPTY',
          ),
        );
      }
    }

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'checkUserExists failed: status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, detail=${apiError.detail}, traceId=${apiError.traceId}, email=$email',
    );

    throw ApiErrorException(
      (apiError.detail != null && apiError.detail!.isNotEmpty)
          ? apiError
          : ApiError(
              title: 'Failed to check if user exists.',
              detail: 'Please try again later.',
              status: apiError.status ?? response?.statusCode ?? 500,
              errorCode: apiError.errorCode ?? 'CHECK_USER_EXISTS_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<BankMerchant?> getSBSAActivationUser({
    required String merchantId,
    required String token,
  }) async {
    final response = await RestClient(store: store as Store<AppState>?)
        .getBasic(
          url: '$baseUrl/SbsaMasApi/GetMerchantDetails?merchantId=$merchantId',
          token: 'Basic $token',
        );

    if (response?.statusCode == 200) {
      if (response!.data != null) {
        return BankMerchant.fromJson(response.data);
      } else {
        return null;
      }
    }

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'getSBSAActivationUser failed: status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, detail=${apiError.detail}, traceId=${apiError.traceId}, '
          'merchantId=$merchantId',
    );

    throw ApiErrorException(
      (apiError.detail != null && apiError.detail!.isNotEmpty)
          ? apiError
          : ApiError(
              title: 'Unable to get user by merchant ID',
              detail: 'Please try again later.',
              status: apiError.status ?? response?.statusCode ?? 500,
              errorCode:
                  apiError.errorCode ?? 'GET_SBSA_ACTIVATION_USER_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<bool?> activationClientStatus({required String token}) async {
    final response = await RestClient(store: store as Store<AppState>?)
        .getBasic(
          url: '$baseUrl/SbsaMasApi/GetConnectionStatus',
          token: 'Basic $token',
        );

    if (response?.statusCode == 200) {
      if (response!.data != null) {
        logger.debug(
          this,
          'SBSA MAS API Error code: ${response.data['error']}',
        );
        return response.data['success'] as bool?;
      } else {
        logger.debug(this, 'SBSA MAS API Error code: Something went wrong.');
        return false;
      }
    }

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'activationClientStatus failed: status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, detail=${apiError.detail}, traceId=${apiError.traceId}',
    );

    throw ApiErrorException(
      (apiError.detail != null && apiError.detail!.isNotEmpty)
          ? apiError
          : ApiError(
              title: 'Cannot check third party api connection',
              detail: 'Please try again later.',
              status: apiError.status ?? response?.statusCode ?? 500,
              errorCode:
                  apiError.errorCode ?? 'ACTIVATION_CLIENT_STATUS_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<ActivationOption> getActivationOptions(
    List<String> activations,
    String token,
  ) async {
    String url = '$baseUrl/Merchant/GetActivationOptions';
    url += '?';

    for (final activationType in activations) {
      url += '&activationTypes=$activationType';
    }

    final response = await RestClient(
      store: store as Store<AppState>?,
    ).getBasic(url: url, token: 'Basic $token');

    if (response?.statusCode == 200) {
      if (response!.data != null) {
        return ActivationOption.fromJson(response.data);
      }

      logger.warning(
        'services.auth',
        'getActivationOptions returned 200 but with empty body',
      );
      throw ApiErrorException(
        ApiError(
          title: 'Unable to get activation options',
          detail: 'The server returned an empty response.',
          status: 500,
          errorCode: 'GET_ACTIVATION_OPTIONS_EMPTY',
        ),
      );
    }

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'getActivationOptions failed: status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, detail=${apiError.detail}, traceId=${apiError.traceId}',
    );

    throw ApiErrorException(
      (apiError.detail != null && apiError.detail!.isNotEmpty)
          ? apiError
          : ApiError(
              title: 'Unable to get activation options',
              detail: 'Please try again later.',
              status: apiError.status ?? response?.statusCode ?? 500,
              errorCode: apiError.errorCode ?? 'GET_ACTIVATION_OPTIONS_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<Map<String, dynamic>> resetPasswordSendGrid({
    required String emailAddress,
  }) async {
    String url = '$baseUrl/Authentication/sendPasswordResetSendGrid';

    var response = await RestClient(
      store: store as Store<AppState>?,
    ).postBasic(url: url, requestData: {'email': emailAddress});

    if (response?.statusCode == 200) {
      final data = response!.data as Map<String, dynamic>;
      return {
        'success': data['success'] as bool? ?? false,
        'message': data['message'] as String? ?? 'Unknown response message',
      };
    } else {
      return {
        'success': false,
        'message': 'Failed to send password reset email',
      };
    }
  }

  Future<AuthenticationResult?> refreshWithCustomClaims(
    String? token,
    String? refreshToken,
  ) async {
    final restClient = RestClient(store: store as Store<AppState>?);

    final response = await restClient.get(
      url: '$baseUrl/Authentication/RefreshCustomClaims',
      customHeaders: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'RefreshToken': refreshToken ?? '',
        },
      ),
    );

    if (response?.statusCode == 200) {
      return response!.data != null
          ? AuthenticationResult.fromJson(response.data)
          : null;
    }

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    logger.warning(
      'services.auth',
      'refreshWithCustomClaims failed: status=${apiError.status ?? response?.statusCode}, '
          'code=${apiError.errorCode}, detail=${apiError.detail}, traceId=${apiError.traceId}',
    );

    throw ApiErrorException(
      apiError.detail != null && apiError.detail!.isNotEmpty
          ? apiError
          : ApiError(
              title: 'Unable to verify firebase user',
              detail:
                  'Your session could not be refreshed. Please log in again.',
              status: apiError.status ?? response?.statusCode ?? 401,
              errorCode: apiError.errorCode ?? 'REFRESH_CUSTOM_CLAIMS_FAILED',
              traceId: apiError.traceId,
            ),
    );
  }

  Future<Map<String, dynamic>> changeUserPassword({
    required String email,
    oldPassword,
    newPassword,
    token,
  }) async {
    String url = '$baseUrl/Authentication/changeUserPassword';

    var response = await RestClient(store: store as Store<AppState>?).postBasic(
      url: url,
      token: 'Bearer $token',
      requestData: {
        'email': email,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );

    if (response == null || response.data == null) {
      return {
        'success': false,
        'message': 'Something went wrong. Please try again.',
      };
    }

    final data = response.data as Map<String, dynamic>;
    return {
      'success': data['success'] as bool? ?? false,
      'message': data['message'] as String? ?? 'Unknown response message',
    };
  }
}
