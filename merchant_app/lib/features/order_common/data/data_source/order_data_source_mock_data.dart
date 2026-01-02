import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction_filter_options.dart';

import '../model/order.dart';
import '../model/order_refund.dart';

import 'order_data_source.dart';

class OrderDataSourceMockData implements OrderDataSource {
  @override
  Future<Order> createDraftOrder(Order order) {
    // TODO: implement createDraftOrder
    throw UnimplementedError();
  }

  @override
  Future<Order> discardOrder(Order order) {
    // TODO: implement discardOrder
    throw UnimplementedError();
  }

  @override
  Future<Order> getOrderById(String id) {
    // TODO: implement getOrderById
    throw UnimplementedError();
  }

  @override
  Future<List<OrderTransaction>> getOrderTransactions({
    required String businessId,
    int offset = 0,
    int limit = 20,
    OrderTransactionType? orderTransactionType,
    TransactionStatus? transactionStatus,
  }) {
    // TODO: implement getOrderTransactions
    throw UnimplementedError();
  }

  @override
  Future<List<OrderTransaction>> getOrderTransactionsWithFilters({
    required String businessId,
    int offset = 0,
    int limit = 20,
    OrderTransactionFilterOptions? filterOptions,
  }) {
    // TODO: implement getOrderTransactions
    throw UnimplementedError();
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
    String? searchText,
  }) {
    // TODO: implement getOrders
    throw UnimplementedError();
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
  }) {
    // TODO: implement filterAndSearchOrders
    throw UnimplementedError();
  }

  @override
  Future<List<OrderTransaction>> getTransactionsByOrderId(String id) {
    // TODO: implement getTransactionsByOrderId
    throw UnimplementedError();
  }

  @override
  Future<Order> saveFailedTransaction(OrderTransaction transaction) {
    // TODO: implement saveFailedTransaction
    throw UnimplementedError();
  }

  @override
  Future<Order> saveNewOrder(Order order) {
    // TODO: implement saveNewOrder
    throw UnimplementedError();
  }

  @override
  Future<Order> savePartialPurchaseOrder(OrderTransaction transaction) {
    // TODO: implement savePartialPurchaseOrder
    throw UnimplementedError();
  }

  @override
  Future<Order> savePartialRefundOrder(
    OrderTransaction purchase,
    OrderRefund refund,
  ) {
    // TODO: implement savePartialRefundOrder
    throw UnimplementedError();
  }

  @override
  Future<Order> savePurchase(OrderTransaction transaction) {
    // TODO: implement savePurchase
    throw UnimplementedError();
  }

  @override
  Future<Order> savePurchaseWithWithdrawal(
    OrderTransaction purchase,
    OrderTransaction withdrawal,
  ) {
    // TODO: implement savePurchaseWithWithdrawal
    throw UnimplementedError();
  }

  @override
  Future<Order> saveRefundOrder(OrderTransaction purchase, OrderRefund refund) {
    // TODO: implement saveRefundOrder
    throw UnimplementedError();
  }

  @override
  Future<Order> saveWithdrawal(OrderTransaction transaction) {
    // TODO: implement saveWithdrawal
    throw UnimplementedError();
  }

  @override
  Future<Order> updateDraftOrder(Order order) {
    // TODO: implement updateDraftOrder
    throw UnimplementedError();
  }

  @override
  Future<Order> updateOrder(Order order) {
    // TODO: implement updateOrder
    throw UnimplementedError();
  }

  @override
  Future<Order> voidOrder(OrderTransaction transaction) {
    // TODO: implement voidOrder
    throw UnimplementedError();
  }

  @override
  Future<List<Order>> getDraftOrder() {
    // TODO: implement getDraftOrder
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getAllFulfillmentOrdersCount({
    required String businessId,
    List<FinancialStatus>? financialStatuses,
    OrderStatus? orderStatus,
    List<CapturedChannel>? capturedChannels,
  }) {
    // TODO: implement getAllFulfillmentOrdersCount
    throw UnimplementedError();
  }

  @override
  Future<int> getOrdersCount({
    required String businessId,
    FulfillmentStatus? fulfillmentStatus,
    List<FinancialStatus>? financialStatuses,
    OrderStatus? orderStatus,
    List<CapturedChannel>? capturedChannels,
  }) {
    // TODO: implement getOrdersCount
    throw UnimplementedError();
  }

  @override
  Future<Order> updateOrderShipperDetails({
    required String businessId,
    required Order order,
  }) {
    // TODO: implement updateOrderShipperDetails
    throw UnimplementedError();
  }

  @override
  Future<Order> cancelOrder({
    required String businessId,
    required Order order,
    required String reason,
  }) {
    // TODO: implement markDeliveryFailed
    throw UnimplementedError();
  }

  @override
  Future<Order> confirmOrder({
    required String businessId,
    required String orderId,
  }) {
    // TODO: implement confirmOrder
    throw UnimplementedError();
  }

  @override
  Future<Order> markReadyForDeliveryOrCollection({
    required String businessId,
    required Order order,
  }) {
    // TODO: implement markReadyForDeliveryOrCollection
    throw UnimplementedError();
  }

  @override
  Future<Order> confirmDeliveryOrCollection({
    required String businessId,
    required Order order,
  }) {
    // TODO: implement confirmDeliveryOrCollection
    throw UnimplementedError();
  }

  @override
  Future<Order> markFailedDelivery({
    required String businessId,
    required Order order,
    required String reason,
  }) {
    // TODO: implement markFailedDelivery
    throw UnimplementedError();
  }
}
