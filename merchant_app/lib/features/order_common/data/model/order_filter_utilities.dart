// project imports
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';

class OrderFilterUtilities {
  static List<Order> filterByDateRange(
    List<Order> orders,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    DateTime today = DateTime.now();
    DateTime thirtyDaysPriorEndDate = (endDate ?? today).subtract(
      const Duration(days: 30),
    );
    return orders.where((order) {
      if (order.dateCreated == null) return false;
      return order.dateCreated!.isAfter(startDate ?? thirtyDaysPriorEndDate) &&
          order.dateCreated!.isBefore(endDate ?? today);
    }).toList();
  }

  static List<Order> filterByCapturedChannel(
    List<Order> orders,
    List<CapturedChannel> channels,
  ) {
    if (channels.isEmpty) return orders;

    return orders
        .where((order) => channels.contains(order.capturedChannel))
        .toList();
  }

  static List<Order> filterByFinancialStatus(
    List<Order> orders,
    List<FinancialStatus> statuses,
  ) {
    if (statuses.isEmpty) return orders;

    return orders
        .where((order) => statuses.contains(order.financialStatus))
        .toList();
  }

  static List<Order> filterByFulfilmentMethod(
    List<Order> orders,
    FulfilmentMethod fulfilmentMethod,
  ) {
    return orders
        .where((order) => order.fulfilmentMethod == fulfilmentMethod)
        .toList();
  }

  static List<Order> filterByOrderStatus(
    List<Order> orders,
    OrderStatus orderStatus,
  ) {
    return orders.where((order) => order.orderStatus == orderStatus).toList();
  }

  static List<Order> filterByFulfillmentStatus(
    List<Order> orders,
    FulfillmentStatus fulfillmentStatus,
  ) {
    return orders
        .where((order) => order.fulfillmentStatus == fulfillmentStatus)
        .toList();
  }

  static List<Order> filterByOrderSource(
    List<Order> orders,
    OrderSource orderSource,
  ) {
    return orders.where((order) => order.orderSource == orderSource).toList();
  }
}
