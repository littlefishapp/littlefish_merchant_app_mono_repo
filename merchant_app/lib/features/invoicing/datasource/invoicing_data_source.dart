import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:littlefish_core_utils/httpErrors/models/api_error.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/payment_links/domain/entities/paginated_payment_link_result.dart';
import 'package:littlefish_merchant/features/payment_links/domain/entities/payment_link_core_request.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';
import 'package:path_provider/path_provider.dart';
// import your structured error types
// import 'package:littlefish_merchant/models/security/authentication/api_error.dart';
// import 'package:littlefish_merchant/models/security/authentication/api_error_exception.dart';

import '../../../models/settings/accounts/linked_account.dart';
import '../../order_common/data/model/order.dart';

class InvoicingDataSource {
  static const String _controllerPathPaymentLink = '/payments/api/PaymentLink';
  static const String _controllerPath = '/payments/api';
  static const String _getPaymentLinkPath = '/link/api/v1/paymentlinks';
  late final String _url;
  late final String _url_payment_link;
  late final String _getPaymentLinkUrl;
  late final RestClient _restClient;
  late final String _payUrl;
  late final String _baseUrl;

  InvoicingDataSource({String? baseUrl, String? payUrl}) {
    _restClient = RestClient(store: AppVariables.store!);
    final cleanedBaseUrl = (baseUrl ?? AppVariables.store?.state.baseUrl)
        ?.replaceFirst(RegExp(r'/api/?$'), '');

    _baseUrl = cleanedBaseUrl ?? '';
    _url = '$cleanedBaseUrl$_controllerPath';
    _url_payment_link = '$cleanedBaseUrl$_controllerPathPaymentLink';
    _getPaymentLinkUrl = '$cleanedBaseUrl$_getPaymentLinkPath';
    _payUrl = payUrl ?? AppVariables.store?.state.paymentLinksPayUrl ?? '';
  }

  Future<List<Order>> fetchInvoices({required String businessId}) async {
    final url = '$_url/Invoice/GetInvoices/$businessId';

    final response = await _restClient.get(url: url);

    if (response?.statusCode == 200) {
      final items = response!.data['items'];
      if (items is! List) {
        throw ApiErrorException(
          ApiError(
            title: 'Unexpected response',
            detail: 'Expected "items" to be a List.',
            status: 500,
            errorCode: 'INVOICE_LIST_BAD_SHAPE',
          ),
        );
      }
      return items.map((e) => Order.fromJson(e)).toList();
    }

    throw ApiErrorException(
      _asApiError(
        response,
        fallbackTitle: 'Failed to fetch invoices',
        fallbackDetail: 'Unable to fetch invoices for this business.',
        fallbackCode: 'FETCH_INVOICES_FAILED',
      ),
    );
  }

  Future<PaginatedPaymentLinkResult> fetchInvoicesPaginated({
    required String businessId,
    required int offset,
    required int limit,
  }) async {
    final url =
        '$_url/Invoice/GetInvoices/$businessId?limit=$limit&offset=$offset';

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
        fallbackTitle: 'Failed to fetch invoices',
        fallbackDetail: 'Unable to load paginated invoices.',
        fallbackCode: 'FETCH_INVOICES_PAGINATED_FAILED',
      ),
    );
  }

  Future<Order> createDraftInvoice({required Order request}) async {
    final createUrl = '$_url/order/CreateDraftOrder';

    final response = await _restClient.post(
      url: createUrl,
      requestData: request.toJson(),
    );

    if (response?.statusCode == 200 && response?.data != null) {
      return Order.fromJson(response!.data);
    }

    throw ApiErrorException(
      _asApiError(
        response,
        fallbackTitle: 'Unable to create draft invoice',
        fallbackDetail: 'Empty or invalid response from invoice API.',
        fallbackCode: 'CREATE_DRAFT_INVOICE_FAILED',
      ),
    );
  }

  Future<Order> updateDraftInvoice({required Order request}) async {
    final createUrl = '$_url/order/UpdateDraftOrder';

    final response = await _restClient.post(
      url: createUrl,
      requestData: request.toJson(),
    );

    if (response?.statusCode == 200 && response?.data != null) {
      return Order.fromJson(response!.data);
    }

    throw ApiErrorException(
      _asApiError(
        response,
        fallbackTitle: 'Unable to update draft invoice',
        fallbackDetail: 'Empty or invalid response from invoice API.',
        fallbackCode: 'UPDATE_DRAFT_INVOICE_FAILED',
      ),
    );
  }

  Future<Order> createInvoice({required Order request}) async {
    // 1. create order
    final createUrl = '$_url/order/CreateOrder';

    final response = await _restClient.post(
      url: createUrl,
      requestData: request.toJson(),
    );

    if (response == null || response.data == null) {
      throw ApiErrorException(
        ApiError(
          title: 'Unable to create invoice',
          detail: 'Empty response received from create invoice API',
          status: 500,
          errorCode: 'CREATE_INVOICE_EMPTY',
        ),
      );
    }

    if (response.statusCode != 200) {
      throw ApiErrorException(
        _asApiError(
          response,
          fallbackTitle: 'Failed to create invoice',
          fallbackDetail: 'The invoice could not be created.',
          fallbackCode: 'CREATE_INVOICE_FAILED',
        ),
      );
    }

    final createdOrder = Order.fromJson(response.data);

    // 2. generate hosted payment link
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
          title: 'Failed to generate hosted payment link URL',
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

    // 3. update payment link with hosted URL
    final updateUrl =
        '$_url_payment_link/UpdatePaymentLinkUrl/businessId=${request.businessId},orderId=${createdOrder.id}';

    final updateResponse = await _restClient.post(
      url: updateUrl,
      requestData: {'paymentLinkUrl': paymentUrl},
    );

    if (updateResponse == null || updateResponse.data == null) {
      throw ApiErrorException(
        ApiError(
          title: 'Failed to update invoice link',
          detail: 'Could not persist the hosted payment URL.',
          status: 500,
          errorCode: 'UPDATE_INVOICE_PAYMENT_URL_FAILED',
        ),
      );
    }

    return Order.fromJson(updateResponse.data);
  }

  Future<Order> updateInvoice({required Order request}) async {
    // 1. update order
    final createUrl = '$_url/order/UpdateOrder';

    final response = await _restClient.post(
      url: createUrl,
      requestData: request.toJson(),
    );

    if (response == null || response.data == null) {
      throw ApiErrorException(
        ApiError(
          title: 'Unable to update invoice',
          detail: 'Empty response received from update invoice API',
          status: 500,
          errorCode: 'UPDATE_INVOICE_EMPTY',
        ),
      );
    }

    if (response.statusCode != 200) {
      throw ApiErrorException(
        _asApiError(
          response,
          fallbackTitle: 'Failed to update invoice',
          fallbackDetail: 'The invoice could not be updated.',
          fallbackCode: 'UPDATE_INVOICE_FAILED',
        ),
      );
    }

    final updatedOrder = Order.fromJson(response.data);

    // 2. generate hosted payment link again
    final paymentLink = PaymentLinkCoreRequest(
      url: _payUrl,
      orderId: updatedOrder.id,
      businessId: updatedOrder.businessId,
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
          title: 'Failed to generate hosted payment link URL',
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

    // 3. update LF link
    final updateUrl =
        '$_url_payment_link/UpdatePaymentLinkUrl/businessId=${request.businessId},orderId=${updatedOrder.id}';

    final updateResponse = await _restClient.post(
      url: updateUrl,
      requestData: {'paymentLinkUrl': paymentUrl},
    );

    if (updateResponse == null || updateResponse.data == null) {
      throw ApiErrorException(
        ApiError(
          title: 'Failed to update payment link with hosted URL',
          detail: 'Could not persist the hosted payment URL.',
          status: 500,
          errorCode: 'UPDATE_INVOICE_PAYMENT_URL_FAILED',
        ),
      );
    }

    return Order.fromJson(updateResponse.data);
  }

  Future<void> sendInvoiceViaSms({
    required String businessId,
    required String invoiceId,
  }) async {
    final url =
        '$_url/PaymentLink/SendViaSms/businessId=$businessId,orderId=$invoiceId';
    final response = await _restClient.post(url: url);

    if (response == null || response.statusCode != 200) {
      throw ApiErrorException(
        _asApiError(
          response,
          fallbackTitle: 'Failed to send invoice via SMS',
          fallbackDetail: 'The SMS could not be sent for this invoice.',
          fallbackCode: 'SEND_INVOICE_SMS_FAILED',
        ),
      );
    }
  }

  Future<void> sendInvoiceViaEmail({
    required String businessId,
    required String invoiceId,
  }) async {
    final url =
        '$_url/PaymentLink/SendViaEmail/businessId=$businessId,orderId=$invoiceId';
    final response = await _restClient.post(url: url);

    if (response == null || response.statusCode != 200) {
      throw ApiErrorException(
        _asApiError(
          response,
          fallbackTitle: 'Failed to send invoice via Email',
          fallbackDetail: 'The email could not be sent for this invoice.',
          fallbackCode: 'SEND_INVOICE_EMAIL_FAILED',
        ),
      );
    }
  }

  Future<Map<String, dynamic>> markInvoiceAsSent({
    required String businessId,
    required String invoiceId,
  }) async {
    final url = '$_url/MarkAsSent/businessId=$businessId,orderId=$invoiceId';

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
        fallbackTitle: 'Failed to mark invoice as sent',
        fallbackDetail: 'The invoice could not be marked as sent.',
        fallbackCode: 'MARK_INVOICE_SENT_FAILED',
      ),
    );
  }

  Future<Order> markInvoiceAsDiscarded({required Order request}) async {
    final createUrl = '$_url/order/DiscardOrder';

    final response = await _restClient.post(
      url: createUrl,
      requestData: request.toJson(),
    );

    if (response?.statusCode == 200 && response?.data != null) {
      return Order.fromJson(response!.data);
    }

    throw ApiErrorException(
      _asApiError(
        response,
        fallbackTitle: 'Failed to discard invoice',
        fallbackDetail: 'The invoice could not be discarded.',
        fallbackCode: 'DISCARD_INVOICE_FAILED',
      ),
    );
  }

  Future<File> downloadInvoicePdf({
    required String orderId,
    required String businessId,
  }) async {
    final url = '$_url/Invoice/DownloadInvoice/$orderId/$businessId';

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/invoice_$orderId.pdf';

    final response = await _restClient.get(
      url: url,
      customHeaders: Options(
        responseType: ResponseType.bytes,
        headers: {
          'Authorization':
              'Bearer ${AppVariables.store?.state.authState.token}',
          'Accept': 'application/pdf',
        },
      ),
    );

    if (response?.statusCode == 200 && response?.data != null) {
      final file = File(filePath);
      await file.writeAsBytes(response!.data);
      return file;
    }

    throw ApiErrorException(
      _asApiError(
        response,
        fallbackTitle: 'Failed to download invoice PDF',
        fallbackDetail: 'The invoice PDF could not be downloaded.',
        fallbackCode: 'DOWNLOAD_INVOICE_PDF_FAILED',
      ),
    );
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

    // keeping return bool for now
    return false;
  }

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
