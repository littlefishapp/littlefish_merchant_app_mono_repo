import 'dart:core';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:littlefish_auth/littlefish_auth_manager.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core_utils/http/littlefish_http_client.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/errors/presentation/redux/error_actions.dart';

import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants.dart';

// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

class FirebaseTokenIsNullException implements Exception {
  final String message;

  FirebaseTokenIsNullException(this.message);

  @override
  String toString() => 'FirebaseTokenIsNullException: $message';
}

class RestClient {
  final bool monitor;

  final Store<AppState>? store;

  late bool _enableRetries;

  late LittleFishHttpClient client;

  LittleFishCore core = LittleFishCore.instance;

  LittlefishAuthManager get authManager => LittlefishAuthManager.instance;

  late String? _appIntegrityCheck;
  late String? _sslFingerPrint;

  RestClient({required this.store, this.monitor = true}) {
    _appIntegrityCheck = store?.state.appSettingsState.appIntegrityCheck;
    _sslFingerPrint = store?.state.appSettingsState.sslFingerPrint;
    _enableRetries = store?.state.configEnableSlowNetworkCheck ?? false;
    client = LittleFishHttpClient(
      compress: AppVariables.enableRequestCompression,
      onRetry: (url, retryAttempt, maxRetries) =>
          store?.dispatch(const ShowRequestRetryAction()),
      sharedHeaders: {
        appName: store?.state.appName ?? '',
        appVersion: store?.state.version ?? '',
        appBuild: store?.state.builderNumber ?? '',
        appIntegrityCheck: _appIntegrityCheck ?? '',
        channel: AppVariables.requestingChannel.name,
      },
    );

    if (!kDebugMode) {
      var doNotValidateCertificate =
          _sslFingerPrint == null || _sslFingerPrint!.isEmpty;
      client.restClient?.httpClientAdapter = IOHttpClientAdapter(
        validateCertificate: ((certificate, host, port) {
          var certificateHasProblem =
              certificate == null || host.isEmpty || port <= 0;
          if (certificateHasProblem) {
            return false;
          } else if (doNotValidateCertificate) {
            return true;
          }
          final certBytes = certificate.der;
          final certHash = sha256.convert(certBytes).toString();
          if (_sslFingerPrint! == certHash) {
            return true;
          }
          return false;
        }),
      );
    }
  }

  Future<Response?> delete({
    required String url,
    Map<String, dynamic>? requestData,
    String? token,
    int? retryCount,
    Duration? retryDelay,
  }) async => client.delete(
    url: url,
    requestData: requestData,
    user: authManager.user,
    retryCount: _enableRetries ? retryCount : 0,
    retryDelay: retryDelay,
  );

  Future<Response?> get({
    required String url,
    Map<String, dynamic>? requestData,
    String? token,
    Options? customHeaders,
    int? retryCount,
    Duration? retryDelay,
  }) async => client.get(
    url: url,
    requestData: requestData,
    basicToken: token,
    user: authManager.user,
    customHeaders: customHeaders,
    retryCount: _enableRetries ? retryCount : 0,
    retryDelay: retryDelay,
  );

  Future<Response?> getBasic({
    required String url,
    Map<String, dynamic>? requestData,
    String? token,
    Options? customHeaders,
    int? retryCount,
    Duration? retryDelay,
  }) async => client.getBasic(
    url: url,
    requestData: requestData,
    basicToken: token,
    customHeaders: customHeaders,
    retryCount: _enableRetries ? retryCount : 0,
    retryDelay: retryDelay,
  );

  Future<Response?> getFileStream({
    required url,
    required savePath,
    String? token,
    BaseOptions? extraOptions,
    dynamic data,
    String? method,
    int? timeout,
    int? retryCount,
    Duration? retryDelay,
  }) async => client.getFileStream(
    url: url,
    savePath: savePath,
    user: authManager.user,
    extraOptions: extraOptions,
    data: data,
    method: method,
    timeout: timeout,
    retryCount: _enableRetries ? retryCount : 0,
    retryDelay: retryDelay,
  );

  Future<Response?> post({
    required String url,
    dynamic requestData,
    String? token,
    Options? customHeaders,
    int? retryCount,
    Duration? retryDelay,
  }) async => client.post(
    url: url,
    requestData: requestData,
    user: authManager.user,
    customHeaders: customHeaders,
    retryCount: _enableRetries ? retryCount : 0,
    retryDelay: retryDelay,
  );

  Future<Response?> postBasic({
    required String url,
    dynamic requestData,
    String? token,
    Options? customHeaders,
    int? retryCount,
    Duration? retryDelay,
  }) async => client.postBasic(
    url: url,
    requestData: requestData,
    basicToken: token,
    customHeaders: customHeaders,
    retryCount: _enableRetries ? retryCount : 0,
    retryDelay: retryDelay,
  );

  Future<Response?> postFileStream({
    required url,
    required savePath,
    String? token,
    BaseOptions? extraOptions,
    dynamic data,
    String? method,
    int? timeout,
    int? retryCount,
    Duration? retryDelay,
  }) async => client.postFileStream(
    url: url,
    savePath: savePath,
    data: data,
    user: authManager.user,
    extraOptions: extraOptions,
    method: method,
    timeout: timeout,
    retryCount: _enableRetries ? retryCount : 0,
    retryDelay: retryDelay,
  );

  Future<Response?> put({
    required String url,
    dynamic requestData,
    String? token,
    int? retryCount,
    Duration? retryDelay,
  }) async => client.put(
    url: url,
    requestData: requestData,
    user: authManager.user,
    retryCount: _enableRetries ? retryCount : 0,
    retryDelay: retryDelay,
  );
}
