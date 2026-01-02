import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:littlefish_core_utils/httpErrors/models/api_error.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/payment_links/domain/entities/paginated_payment_link_result.dart';
import 'package:littlefish_merchant/features/payment_links/domain/entities/payment_link_core_request.dart';
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

class PaymentLinksDataSource {
  static const String _controllerPath = '/payments/api/PaymentLink';
  static const String _createLinkControllerPath = '/payments/api';
  static const String _getPaymentLinkPath = '/link/api/v1/paymentlinks';
  late final String _url;
  late final String _createLinkUrl;
  late final String _getPaymentLinkUrl;
  late final String _payUrl;
  late final String _baseUrl;

  late final RestClient _restClient;

  PaymentLinksDataSource({String? baseUrl, String? payUrl}) {
    _restClient = RestClient(store: AppVariables.store!);
    final cleanedBaseUrl = (baseUrl ?? AppVariables.store?.state.baseUrl)
        ?.replaceFirst(RegExp(r'/api/?$'), '');

    _baseUrl = cleanedBaseUrl ?? '';
    _url = '$cleanedBaseUrl$_controllerPath';
    _createLinkUrl = '$cleanedBaseUrl$_createLinkControllerPath';
    _getPaymentLinkUrl = '$cleanedBaseUrl$_getPaymentLinkPath';
    _payUrl = payUrl ?? AppVariables.store?.state.paymentLinksPayUrl ?? '';
  }

  Future<List<Order>> fetchPaymentLinks({required String businessId}) async {
    final url = '$_url/GetPaymentLinkOrders?businessId=$businessId';

    final response = await _restClient.get(url: url);

    if (response?.statusCode == 200) {
      final items = response!.data['items'];
      if (items is! List) {
        throw ApiErrorException(
          ApiError(
            title: 'Unexpected response',
            detail: 'Expected "items" to be a list.',
            status: 500,
            errorCode: 'PAYMENT_LINKS_BAD_SHAPE',
          ),
        );
      }
      return items.map((e) => Order.fromJson(e)).toList();
    }

    throw ApiErrorException(
      _asApiError(
        response,
        fallbackTitle: 'Failed to fetch payment links',
        fallbackDetail: 'Unable to load payment links for this business.',
        fallbackCode: 'FETCH_PAYMENT_LINKS_FAILED',
      ),
    );
  }

  Future<PaginatedPaymentLinkResult> fetchPaymentLinksPaginated({
    required String businessId,
    required int offset,
    required int limit,
  }) async {
    final url =
        '$_url/GetPaymentLinkOrders?businessId=$businessId&limit=$limit&offset=$offset';

    final response = await _restClient.get(url: url);

    if (response?.statusCode == 200) {
      final data = response!.data;
      final items = (data['items'] as List)
          .map((e) => Order.fromJson(e))
          .toList();
      final totalRecords = data['totalRecords'];

      return PaginatedPaymentLinkResult(
        items: items,
        totalRecords: totalRecords,
      );
    }

    throw ApiErrorException(
      _asApiError(
        response,
        fallbackTitle: 'Failed to fetch payment links',
        fallbackDetail: 'Unable to load payment links (paginated).',
        fallbackCode: 'FETCH_PAYMENT_LINKS_PAGINATED_FAILED',
      ),
    );
  }

  Future<Map<String, dynamic>> markPaymentLinkAsSent({
    required String businessId,
    required String linkId,
  }) async {
    final url = '$_url/MarkAsSent/businessId=$businessId,orderId=$linkId';

    final response = await _restClient.post(url: url);

    if (response?.statusCode == 200 && response?.data != null) {
      return {
        'id': response!.data['id'] as String,
        'status': response.data['status'] as String,
      };
    }

    throw ApiErrorException(
      _asApiError(
        response,
        fallbackTitle: 'Failed to mark link as sent',
        fallbackDetail: 'The payment link could not be marked as sent.',
        fallbackCode: 'MARK_PAYMENT_LINK_SENT_FAILED',
      ),
    );
  }

  Future<Map<String, dynamic>> markPaymentLinkAsDisabled({
    required String businessId,
    required String linkId,
  }) async {
    final url =
        '$_url/DisablePaymentLinkOrder/businessId=$businessId,orderId=$linkId';

    final response = await _restClient.post(url: url);

    if (response?.statusCode == 200 && response?.data != null) {
      return {
        'id': response!.data['id'] as String,
        'status': response.data['status'] as String,
      };
    }

    throw ApiErrorException(
      _asApiError(
        response,
        fallbackTitle: 'Failed to disable payment link',
        fallbackDetail: 'The payment link could not be disabled.',
        fallbackCode: 'DISABLE_PAYMENT_LINK_FAILED',
      ),
    );
  }

  Future<Order> createPaymentLink({required Order request}) async {
    // 1. create order
    final createUrl = '$_createLinkUrl/order/CreateOrder';

    final response = await _restClient.post(
      url: createUrl,
      requestData: request.toJson(),
    );

    if (response == null || response.data == null) {
      throw ApiErrorException(
        ApiError(
          title: 'Unable to create payment link',
          detail: 'Empty response received from create payment link API.',
          status: 500,
          errorCode: 'CREATE_PAYMENT_LINK_EMPTY',
        ),
      );
    }

    if (response.statusCode != 200) {
      throw ApiErrorException(
        _asApiError(
          response,
          fallbackTitle: 'Failed to create payment link',
          fallbackDetail: 'The order could not be created.',
          fallbackCode: 'CREATE_PAYMENT_LINK_FAILED',
        ),
      );
    }

    final createdOrder = Order.fromJson(response.data);

    // 2. get hosted link from core
    final paymentLink = PaymentLinkCoreRequest(
      url: _payUrl,
      orderId: createdOrder.id,
      businessId: createdOrder.businessId,
    );

    final coreApiResponse = await _restClient.post(
      url: _getPaymentLinkUrl,
      requestData: jsonEncode(paymentLink),
      customHeaders: Options(
        headers: {
          'Authorization':
              'Bearer ${AppVariables.store?.state.authState.token}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (coreApiResponse == null || coreApiResponse.data == null) {
      throw ApiErrorException(
        ApiError(
          title: 'Failed to generate hosted payment link',
          detail: 'Core API did not return a payment URL.',
          status: 500,
          errorCode: 'GENERATE_HOSTED_LINK_FAILED',
        ),
      );
    }

    final paymentUrl = coreApiResponse.data['paymentUrl'];
    if (paymentUrl == null) {
      throw ApiErrorException(
        ApiError(
          title: 'Hosted payment URL missing',
          detail: 'Hosted payment URL not returned from core API.',
          status: 500,
          errorCode: 'HOSTED_URL_MISSING',
        ),
      );
    }

    // 3. update LF payment link with hosted URL
    final updateUrl =
        '$_url/UpdatePaymentLinkUrl/businessId=${request.businessId},orderId=${createdOrder.id}';

    final updateResponse = await _restClient.post(
      url: updateUrl,
      requestData: {'paymentLinkUrl': paymentUrl},
    );

    if (updateResponse == null || updateResponse.data == null) {
      throw ApiErrorException(
        ApiError(
          title: 'Failed to update payment link',
          detail: 'Could not persist the hosted payment URL.',
          status: 500,
          errorCode: 'UPDATE_PAYMENT_LINK_URL_FAILED',
        ),
      );
    }

    return Order.fromJson(updateResponse.data);
  }

  Future<void> sendPaymentLinkViaSms({
    required String businessId,
    required String linkId,
  }) async {
    final url = '$_url/SendViaSms/businessId=$businessId,orderId=$linkId';
    final response = await _restClient.post(url: url);

    if (response == null || response.statusCode != 200) {
      throw ApiErrorException(
        _asApiError(
          response,
          fallbackTitle: 'Failed to send payment link via SMS',
          fallbackDetail: 'The SMS could not be sent for this link.',
          fallbackCode: 'SEND_LINK_SMS_FAILED',
        ),
      );
    }
  }

  Future<void> sendPaymentLinkViaEmail({
    required String businessId,
    required String linkId,
  }) async {
    final url = '$_url/SendViaEmail/businessId=$businessId,orderId=$linkId';
    final response = await _restClient.post(url: url);

    if (response == null || response.statusCode != 200) {
      throw ApiErrorException(
        _asApiError(
          response,
          fallbackTitle: 'Failed to send payment link via Email',
          fallbackDetail: 'The email could not be sent for this link.',
          fallbackCode: 'SEND_LINK_EMAIL_FAILED',
        ),
      );
    }
  }

  Future<List<LinkedAccount>> requestPaymentLinksActivation({
    String? businessId,
    required LinkedAccount linkedAccount,
  }) async {
    final url =
        '$_baseUrl/api/Accounts/UpsertLinkedAccount/businessId=$businessId';

    final response = await _restClient.put(
      url: url,
      requestData: linkedAccount.toJson(),
    );

    if (response == null ||
        response.statusCode != 200 ||
        response.data == null) {
      throw ApiErrorException(
        _asApiError(
          response,
          fallbackTitle: 'Failed to upsert linked account',
          fallbackDetail: 'Could not save linked account details.',
          fallbackCode: 'UPSERT_LINKED_ACCOUNT_FAILED',
        ),
      );
    }

    final data = response.data;
    if (data is! List) {
      throw ApiErrorException(
        ApiError(
          title: 'Unexpected response from UpsertLinkedAccount',
          detail: 'Expected a list of linked accounts.',
          status: 500,
          errorCode: 'UPSERT_LINKED_ACCOUNT_BAD_SHAPE',
        ),
      );
    }

    final List<LinkedAccount> updatedAccounts = data.map<LinkedAccount>((item) {
      return LinkedAccount.fromJson(item);
    }).toList();

    // still reusing the existing review call, but now it can throw too
    final reviewResponse = await submitOnlinePaymentsForReview(businessId);
    if (!reviewResponse) {
      throw ApiErrorException(
        ApiError(
          title: 'Failed to submit OnlinePayments for review',
          detail: 'Please try again later.',
          status: 500,
          errorCode: 'SUBMIT_ONLINE_PAYMENTS_REVIEW_FAILED',
        ),
      );
    }

    return updatedAccounts;
  }

  Future<bool> submitOnlinePaymentsForReview(String? businessId) async {
    final url = '$_baseUrl/api/Store/reviewOnlinePayments';
    final response = await _restClient.post(
      url: url,
      requestData: {'businessId': businessId},
    );

    if (response?.statusCode == 200 &&
        response?.data != null &&
        response!.data['success'] == true) {
      return true;
    }

    // keep return type as bool for now, but we still build the error
    return false;
  }

  // --------------------------------------------------------------------------
  // helpers
  // --------------------------------------------------------------------------
  ApiError _asApiError(
    Response? response, {
    required String fallbackTitle,
    required String fallbackDetail,
    required String fallbackCode,
  }) {
    final raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    if (apiError.detail != null && apiError.detail!.isNotEmpty) {
      return apiError;
    }

    return ApiError(
      title: apiError.title ?? fallbackTitle,
      detail: fallbackDetail,
      status: apiError.status ?? response?.statusCode ?? 500,
      errorCode: apiError.errorCode ?? fallbackCode,
      traceId: apiError.traceId,
    );
  }
}
