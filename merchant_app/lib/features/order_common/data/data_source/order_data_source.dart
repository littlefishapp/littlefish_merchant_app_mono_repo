import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction_filter_options.dart';

import '../model/order.dart';
import '../model/order_refund.dart';

abstract class OrderDataSource {
  Future<Order> getOrderById(String id);
  Future<List<OrderTransaction>> getTransactionsByOrderId(String id);

  Future<List<Order>> getOrders({
    required String businessId,
    int offset = 0,
    int limit = 20,
    List<FinancialStatus>? financialStatuses,
    List<CapturedChannel>? capturedChannels,
    DateTime? startDate,
    DateTime? endDate,
    OrderStatus? orderStatus,
  });

  Future<int> getOrdersCount({
    required String businessId,
    FulfillmentStatus? fulfillmentStatus,
    List<FinancialStatus>? financialStatuses,
    OrderStatus? orderStatus,
    List<CapturedChannel>? capturedChannels,
  });

  Future<Map<String, dynamic>> getAllFulfillmentOrdersCount({
    required String businessId,
    List<FinancialStatus>? financialStatuses,
    OrderStatus? orderStatus,
    List<CapturedChannel>? capturedChannels,
  });

  Future<Order> updateOrderShipperDetails({
    required String businessId,
    required Order order,
  });

  Future<Order> cancelOrder({
    required String businessId,
    required Order order,
    required String reason,
  });

  Future<Order> confirmOrder({
    required String businessId,
    required String orderId,
  });

  Future<Order> markReadyForDeliveryOrCollection({
    required String businessId,
    required Order order,
  });

  Future<Order> confirmDeliveryOrCollection({
    required String businessId,
    required Order order,
  });

  Future<Order> markFailedDelivery({
    required String businessId,
    required Order order,
    required String reason,
  });

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
  });

  Future<List<OrderTransaction>> getOrderTransactions({
    required String businessId,
    int offset = 0,
    int limit = 20,
    OrderTransactionType? orderTransactionType,
    TransactionStatus? transactionStatus,
  });

  Future<List<OrderTransaction>> getOrderTransactionsWithFilters({
    required String businessId,
    int offset = 0,
    int limit = 20,
    OrderTransactionFilterOptions? filterOptions,
  });

  Future<Order> saveNewOrder(Order order);
  Future<Order> updateOrder(Order order);
  Future<Order> discardOrder(Order order);
  Future<Order> createDraftOrder(Order order);
  Future<Order> updateDraftOrder(Order order);
  Future<Order> voidOrder(OrderTransaction transaction);
  Future<Order> savePurchase(OrderTransaction transaction);
  Future<Order> savePartialPurchaseOrder(OrderTransaction transaction);
  Future<Order> saveFailedTransaction(OrderTransaction transaction);
  Future<Order> saveWithdrawal(OrderTransaction transaction);
  Future<Order> savePurchaseWithWithdrawal(
    OrderTransaction purchase,
    OrderTransaction withdrawal,
  );
  Future<Order> saveRefundOrder(OrderTransaction purchase, OrderRefund refund);
  Future<Order> savePartialRefundOrder(
    OrderTransaction purchase,
    OrderRefund refund,
  );
  Future<List<Order>> getDraftOrder();
}
