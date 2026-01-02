import 'package:littlefish_core_utils/httpErrors/models/api_error_helper.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction_filter_options.dart';

import '../../../../app/app.dart';
import '../../../../tools/http/rest_client.dart';
import '../model/order.dart';
import '../model/order_line_item.dart';
import 'order_data_source.dart';
import '../model/order_refund.dart';

class LFOrderDataSource implements OrderDataSource {
  static const String _controllerPath = '/Order';
  late final String _url;
  late final RestClient _restClient;

  LFOrderDataSource({required String baseUrl}) {
    _restClient = RestClient(store: AppVariables.store!);
    _url = baseUrl + _controllerPath;
  }

  @override
  Future<Order> getOrderById(String id) async {
    final response = await _restClient.get(url: '$_url/getOrderById/$id');

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to retrieve order',
        fallbackDetail:
            'Unable to retrieve order details. Please try again or contact support.',
        fallbackCode: 'ORDER_GET_BY_ID_FAILED',
      );
    }

    return Order.fromJson(response.data);
  }

  @override
  Future<int> getOrdersCount({
    required String businessId,
    FulfillmentStatus? fulfillmentStatus,
    List<FinancialStatus>? financialStatuses,
    OrderStatus? orderStatus,
    List<CapturedChannel>? capturedChannels,
  }) async {
    var url = '$_url/GetOrdersCount?businessId=$businessId&fulfillmentStatus=';

    if (financialStatuses != null && financialStatuses.isNotEmpty) {
      for (final status in financialStatuses) {
        url += '&financialStatuses=${Order.financialStatusToJson(status)}';
      }
    }

    if (orderStatus != null) {
      url += '&orderStatus=${Order.orderStatusToJson(orderStatus)}';
    }

    if (capturedChannels != null && capturedChannels.isNotEmpty) {
      for (final channel in capturedChannels) {
        url += '&capturedChannels=${Order.capturedChannelToJson(channel)}';
      }
    }

    final response = await _restClient.get(url: url);

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to retrieve order count',
        fallbackDetail: 'Please check your filters and try again.',
        fallbackCode: 'ORDER_COUNT_FAILED',
      );
    }

    return response.data is int ? response.data as int : 0;
  }

  @override
  Future<Map<String, dynamic>> getAllFulfillmentOrdersCount({
    required String businessId,
    List<FinancialStatus>? financialStatuses,
    OrderStatus? orderStatus,
    List<CapturedChannel>? capturedChannels,
  }) async {
    var url = '$_url/GetAllFulfillmentStatusOrdersCount?businessId=$businessId';

    if (financialStatuses != null && financialStatuses.isNotEmpty) {
      for (final status in financialStatuses) {
        url += '&financialStatuses=${Order.financialStatusToJson(status)}';
      }
    }

    if (orderStatus != null) {
      url += '&orderStatus=${Order.orderStatusToJson(orderStatus)}';
    }

    if (capturedChannels != null && capturedChannels.isNotEmpty) {
      for (final channel in capturedChannels) {
        url += '&capturedChannels=${Order.capturedChannelToJson(channel)}';
      }
    }

    final response = await _restClient.get(url: url);

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to retrieve fulfillment counts',
        fallbackDetail: 'Please check your filters and try again.',
        fallbackCode: 'ORDER_FULFILLMENT_COUNT_FAILED',
      );
    }

    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Order> updateOrderShipperDetails({
    required String businessId,
    required Order order,
  }) async {
    final url =
        '$_url/UpdateOrderShipperDetails?businessId=$businessId&orderId=${order.id}&shipperName=${order.shipperName}&trackingNumber=${order.trackingNumber}&estimateDeliverydate=${order.estimateDeliverydate}';

    final response = await _restClient.put(url: url);

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to update shipper details',
        fallbackDetail: 'Please verify the information and try again.',
        fallbackCode: 'ORDER_UPDATE_SHIPPER_FAILED',
      );
    }

    return Order.fromJson(response.data);
  }

  @override
  Future<Order> cancelOrder({
    required String businessId,
    required Order order,
    required String reason,
  }) async {
    final url =
        '$_url/CancelOrder?businessId=$businessId&orderId=${order.id}&cancelReason=$reason';

    final response = await _restClient.put(url: url);

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to cancel order',
        fallbackDetail: 'Please verify the cancellation reason and try again.',
        fallbackCode: 'ORDER_CANCEL_FAILED',
      );
    }

    return Order.fromJson(response.data);
  }

  @override
  Future<Order> confirmOrder({
    required String businessId,
    required String orderId,
  }) async {
    final url = '$_url/ConfirmOrder?businessId=$businessId&orderId=$orderId';

    final response = await _restClient.put(url: url);

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to confirm order',
        fallbackDetail: 'Please check order status and try again.',
        fallbackCode: 'ORDER_CONFIRM_FAILED',
      );
    }

    return Order.fromJson(response.data);
  }

  @override
  Future<Order> markReadyForDeliveryOrCollection({
    required String businessId,
    required Order order,
  }) async {
    String url = _url;

    if (order.fulfilmentMethod == FulfilmentMethod.delivery) {
      url += '/MarkReadyForDelivery?businessId=$businessId&orderId=${order.id}';
    } else if (order.fulfilmentMethod == FulfilmentMethod.collection) {
      url +=
          '/MarkReadyForCollection?businessId=$businessId&orderId=${order.id}';
    }

    final response = await _restClient.put(url: url);

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to mark order as ready',
        fallbackDetail: 'Please verify order status and try again.',
        fallbackCode: 'ORDER_MARK_READY_FAILED',
      );
    }

    return Order.fromJson(response.data);
  }

  @override
  Future<Order> confirmDeliveryOrCollection({
    required String businessId,
    required Order order,
  }) async {
    String url = _url;

    if (order.fulfilmentMethod == FulfilmentMethod.delivery) {
      url += '/ConfirmDelivery?businessId=$businessId&orderId=${order.id}';
    } else if (order.fulfilmentMethod == FulfilmentMethod.collection) {
      url += '/ConfirmCollection?businessId=$businessId&orderId=${order.id}';
    }

    final response = await _restClient.put(url: url);

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to confirm delivery/collection',
        fallbackDetail: 'Please check order status and try again.',
        fallbackCode: 'ORDER_CONFIRM_DELIVERY_FAILED',
      );
    }

    return Order.fromJson(response.data);
  }

  @override
  Future<Order> markFailedDelivery({
    required String businessId,
    required Order order,
    required String reason,
  }) async {
    final url =
        '$_url/MarkFailedDelivery?businessId=$businessId&orderId=${order.id}&failedReason=$reason';

    final response = await _restClient.put(url: url);

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to mark delivery as failed',
        fallbackDetail: 'Please verify the reason and try again.',
        fallbackCode: 'ORDER_MARK_FAILED_DELIVERY',
      );
    }

    return Order.fromJson(response.data);
  }

  @override
  Future<List<OrderTransaction>> getOrderTransactions({
    required String businessId,
    int offset = 0,
    int limit = 20,
    OrderTransactionType? orderTransactionType,
    TransactionStatus? transactionStatus,
  }) async {
    var url =
        '$_url/GetTransactions?businessId=$businessId&offset=$offset&limit=$limit';

    if (orderTransactionType != null) {
      url +=
          '&transactionType=${OrderTransaction.orderTransactionTypeToJson(orderTransactionType)}';
    }

    if (transactionStatus != null) {
      url +=
          '&transactionStatus=${OrderTransaction.transactionStatusToJson(transactionStatus)}';
    }

    final response = await _restClient.get(url: url);

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to retrieve transactions',
        fallbackDetail: 'Please check your filters and try again.',
        fallbackCode: 'ORDER_TRANSACTIONS_FETCH_FAILED',
      );
    }

    return (response.data as List)
        .map((e) => OrderTransaction.fromJson(e))
        .toList();
  }

  @override
  Future<List<OrderTransaction>> getOrderTransactionsWithFilters({
    required String businessId,
    int offset = 0,
    int limit = 20,
    OrderTransactionFilterOptions? filterOptions,
  }) async {
    filterOptions ??= OrderTransactionFilterOptions();

    final response = await _restClient.post(
      url:
          '$_url/GetTransactionsWithFilters?businessId=$businessId&offset=$offset&limit=$limit',
      requestData: filterOptions.toJson(),
    );

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to retrieve transactions',
        fallbackDetail: 'Could not fetch transactions.',
        fallbackCode: 'ORDER_TRANSACTIONS_FILTER_FAILED',
      );
    }

    return (response.data as List)
        .map((e) => OrderTransaction.fromJson(e))
        .toList();
  }

  @override
  Future<List<Order>> getOrders({
    required String businessId,
    int offset = 0,
    int limit = 20,
    List<FinancialStatus>? financialStatuses,
    List<CapturedChannel>? capturedChannels,
    DateTime? startDate,
    DateTime? endDate,
    OrderStatus? orderStatus,
  }) async {
    var url =
        '$_url/GetOrders?businessId=$businessId&offset=$offset&limit=$limit';

    if (financialStatuses != null && financialStatuses.isNotEmpty) {
      for (final status in financialStatuses) {
        url += '&financialStatuses=${Order.financialStatusToJson(status)}';
      }
    }

    if (capturedChannels != null && capturedChannels.isNotEmpty) {
      for (final channel in capturedChannels) {
        url += '&capturedChannels=${Order.capturedChannelToJson(channel)}';
      }
    }

    if (startDate != null) {
      endDate ??= DateTime.now();
      url += '&startDate=${startDate.toIso8601String()}';
      url += '&endDate=${endDate.toIso8601String()}';
    }

    if (orderStatus != null) {
      url += '&orderStatus=${Order.orderStatusToJson(orderStatus)}';
    }

    final response = await _restClient.get(url: url);

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to retrieve orders',
        fallbackDetail: 'Please check your filters and try again.',
        fallbackCode: 'ORDER_LIST_FETCH_FAILED',
      );
    }

    final list = List.from(response.data as List);
    return list.map((e) => Order.fromJson(e)).toList();
  }

  @override
  Future<List<Order>> filterAndSearchOrders({
    required String businessId,
    int offset = 0,
    int limit = 20,
    String? searchText,
    List<FinancialStatus>? financialStatuses,
    List<CapturedChannel>? capturedChannels,
    FulfilmentMethod? fulfilmentMethod,
    DateTime? startDate,
    DateTime? endDate,
    OrderStatus? orderStatus,
    FulfillmentStatus? fulfillmentStatus,
  }) async {
    var url =
        '$_url/FilterAndSearchOrders?businessId=$businessId&offset=$offset&limit=$limit';

    if (searchText != null && searchText.isNotEmpty) {
      url += '&searchText=$searchText';
    }

    if (financialStatuses != null && financialStatuses.isNotEmpty) {
      for (final status in financialStatuses) {
        url += '&financialStatuses=${Order.financialStatusToJson(status)}';
      }
    }

    if (capturedChannels != null && capturedChannels.isNotEmpty) {
      for (final channel in capturedChannels) {
        url += '&capturedChannels=${Order.capturedChannelToJson(channel)}';
      }
    }

    if (fulfilmentMethod != null &&
        fulfilmentMethod != FulfilmentMethod.undefined) {
      url +=
          '&fulfilmentMethod=${Order.fulfilmentMethodToJson(fulfilmentMethod)}';
    }

    if (startDate != null) {
      endDate ??= DateTime.now();
      url += '&startDate=${startDate.toIso8601String()}';
      url += '&endDate=${endDate.toIso8601String()}';
    }

    if (orderStatus != null) {
      url += '&orderStatus=${Order.orderStatusToJson(orderStatus)}';
    }

    if (fulfillmentStatus != null) {
      url +=
          '&fulfillmentStatus=${Order.fulfillmentStatusToJson(fulfillmentStatus)}';
    }

    final response = await _restClient.get(url: url);

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to filter and search orders',
        fallbackDetail: 'Please verify your search criteria and try again.',
        fallbackCode: 'ORDER_FILTER_SEARCH_FAILED',
      );
    }

    return (response.data as List).map((e) => Order.fromJson(e)).toList();
  }

  @override
  Future<List<OrderTransaction>> getTransactionsByOrderId(String id) async {
    final response = await _restClient.get(
      url: '$_url/getTransactionsByOrderId?id=$id',
    );

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to fetch transactions',
        fallbackDetail: 'Something went wrong.',
        fallbackCode: 'ORDER_TRANSACTIONS_BY_ID_FAILED',
      );
    }

    return (response.data as List)
        .map((e) => OrderTransaction.fromJson(e))
        .toList();
  }

  Future<Order> _saveOrderInfo(String endpoint, Order order) async {
    final response = await _restClient.post(
      url: '$_url/$endpoint',
      requestData: order.toJson(),
    );

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to save order',
        fallbackDetail: 'Please verify the details and try again.',
        fallbackCode: 'ORDER_SAVE_FAILED',
      );
    }

    return Order.fromJson(response.data);
  }

  @override
  Future<Order> discardOrder(Order order) {
    return _saveOrderInfo('discardOrder', order);
  }

  @override
  Future<Order> createDraftOrder(Order order) {
    return _saveOrderInfo('createDraftOrder', order);
  }

  @override
  Future<Order> updateDraftOrder(Order order) {
    return _saveOrderInfo('updateDraftOrder', order);
  }

  @override
  Future<Order> saveNewOrder(Order order) {
    return _saveOrderInfo('createOrder', order);
  }

  @override
  Future<Order> updateOrder(Order order) {
    return _saveOrderInfo('updateOrder', order);
  }

  Future<Order> _saveOrderTransactionInfo(
    String endpoint,
    OrderTransaction transaction,
  ) async {
    final response = await _restClient.post(
      url: '$_url/$endpoint',
      requestData: transaction.toJson(),
    );

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to save transaction',
        fallbackDetail: 'Something went wrong.',
        fallbackCode: 'ORDER_TRANSACTION_SAVE_FAILED',
      );
    }

    return Order.fromJson(response.data);
  }

  @override
  Future<Order> saveFailedTransaction(OrderTransaction transaction) {
    return _saveOrderTransactionInfo('saveFailedTransaction', transaction);
  }

  @override
  Future<Order> savePartialPurchaseOrder(OrderTransaction transaction) {
    return _saveOrderTransactionInfo('savePartialPurchase', transaction);
  }

  @override
  Future<Order> savePurchase(OrderTransaction transaction) {
    return _saveOrderTransactionInfo('savePurchase', transaction);
  }

  @override
  Future<Order> saveWithdrawal(OrderTransaction transaction) {
    return _saveOrderTransactionInfo('saveWithdrawal', transaction);
  }

  @override
  Future<Order> voidOrder(OrderTransaction transaction) {
    return _saveOrderTransactionInfo('voidOrder', transaction);
  }

  @override
  Future<Order> savePartialRefundOrder(
    OrderTransaction purchase,
    OrderRefund refund,
  ) async {
    final requestBody = {
      'refund': refund.toJson(),
      'transaction': purchase.toJson(),
    };

    final response = await _restClient.post(
      url: '$_url/SavePartialRefund',
      requestData: requestBody,
    );

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to process partial refund',
        fallbackDetail: 'Please verify the refund details and try again.',
        fallbackCode: 'ORDER_PARTIAL_REFUND_FAILED',
      );
    }

    return Order.fromJson(response.data);
  }

  @override
  Future<Order> savePurchaseWithWithdrawal(
    OrderTransaction purchase,
    OrderTransaction withdrawal,
  ) async {
    final requestBody = {
      'withdrawal': withdrawal.toJson(),
      'transaction': purchase.toJson(),
    };

    final response = await _restClient.post(
      url: '$_url/SavePurchaseAndWithdrawal',
      requestData: requestBody,
    );

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to save purchase and withdrawal',
        fallbackDetail: 'Please verify the transaction details and try again.',
        fallbackCode: 'ORDER_SAVE_PURCHASE_WITHDRAWAL_FAILED',
      );
    }

    return Order.fromJson(response.data);
  }

  @override
  Future<Order> saveRefundOrder(
    OrderTransaction purchase,
    OrderRefund refund,
  ) async {
    final requestBody = {
      'refund': refund.toJson(),
      'transaction': purchase.toJson(),
    };

    final response = await _restClient.post(
      url: '$_url/refundOrder',
      requestData: requestBody,
    );

    if (response == null ||
        response.data == null ||
        response.statusCode != 200) {
      throw ApiErrorHelper.extractApiError(
        response,
        fallbackTitle: 'Unable to process refund',
        fallbackDetail: 'Please verify the refund details and try again.',
        fallbackCode: 'ORDER_REFUND_FAILED',
      );
    }

    return Order.fromJson(response.data);
  }

  @override
  Future<List<Order>> getDraftOrder() async {
    var itemList = const <Order>[
      Order(
        customerReference:
            '001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 001 ',
        notes:
            'note qwerty note qwerty note qwerty note qwerty note qwerty note qwerty ',
        orderLineItems: [OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '002',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '002',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '003',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '004',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '005',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '006',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '007',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '008',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '009',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '010',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '011',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '012',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '013',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '014',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '015',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '016',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
      Order(
        notes: 'note asdfg',
        customerReference: '017',
        orderLineItems: [OrderLineItem(), OrderLineItem()],
      ),
    ];
    await Future.delayed(const Duration(seconds: 3));
    return itemList;
  }
}
