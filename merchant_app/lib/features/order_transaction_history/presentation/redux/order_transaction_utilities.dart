import 'package:intl/intl.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_history_log.dart';

class OrderTransactionUtilities {
  static String getFinancialStatusText(
    FinancialStatus status, {
    bool toUpperCase = false,
  }) {
    String financialStatusText;
    switch (status) {
      case FinancialStatus.paid:
        financialStatusText = 'Paid';
        break;
      case FinancialStatus.partiallyPaid:
        financialStatusText = 'Part Paid';
        break;
      case FinancialStatus.$void:
        financialStatusText = 'Void';
        break;
      case FinancialStatus.error:
        financialStatusText = 'Error';
        break;
      case FinancialStatus.partiallyRefunded:
        financialStatusText = 'Part Refund';
        break;
      case FinancialStatus.refunded:
        financialStatusText = 'Refund';
        break;
      case FinancialStatus.pending:
        financialStatusText = 'Pending';
        break;
      case FinancialStatus.undefined:
        financialStatusText = 'Undefined';
        break;
      default:
        financialStatusText = 'Error';
        break;
    }

    return toUpperCase
        ? financialStatusText.toUpperCase()
        : financialStatusText;
  }

  static String getOrderTypeText(
    FulfilmentMethod status, {
    bool toUpperCase = false,
  }) {
    String fulfillmentMethodText;
    switch (status) {
      case FulfilmentMethod.undefined:
        fulfillmentMethodText = 'Undefined';
        break;
      case FulfilmentMethod.collection:
        fulfillmentMethodText = 'Collection';
        break;
      case FulfilmentMethod.delivery:
        fulfillmentMethodText = 'Delivery';
        break;
      default:
        fulfillmentMethodText = 'Undefined';
        break;
    }

    return toUpperCase
        ? fulfillmentMethodText.toUpperCase()
        : fulfillmentMethodText;
  }

  static String getOrderStatusText(
    OrderStatus status, {
    bool toUpperCase = false,
  }) {
    String orderStatusText;
    switch (status) {
      case OrderStatus.draft:
        orderStatusText = 'Draft';
        break;
      case OrderStatus.discarded:
        orderStatusText = 'Discarded';
        break;
      case OrderStatus.open:
        orderStatusText = 'Open';
        break;
      case OrderStatus.closed:
        orderStatusText = 'Complete';
        break;
      default:
        orderStatusText = 'Undefined';
        break;
    }

    return toUpperCase ? orderStatusText.toUpperCase() : orderStatusText;
  }

  static String getFulfillmentStatusTextForOrdersCount(String status) {
    String orderStatusText;
    switch (status) {
      case 'Received':
        orderStatusText =
            'Orders which have been placed by your customers and are waiting for your confirmation.';
        break;
      case 'Processing':
        orderStatusText =
            'Orders which you have confirmed and you are now preparing for delivery or collection.';
        break;
      case 'Dispatched':
        orderStatusText =
            'Orders that are now ready for collection or have been shipped out for delivery.';
        break;
      case 'Complete':
        orderStatusText =
            'Orders that have been successfully delivered or collected.';
        break;
      case 'Failed':
        orderStatusText =
            'Orders that could not be delivered or collected for various reasons and must be fully refunded.';
        break;
      case 'Cancelled':
        orderStatusText =
            'Orders that you have cancelled for various reasons and need to be partially or fully refunded.';
        break;
      default:
        orderStatusText = 'Undefined';
        break;
    }

    return orderStatusText;
  }

  static FulfillmentStatus getFulfillmentStatusForClickedOrdersCount(
    String status,
  ) {
    FulfillmentStatus fulfillmentStatus;
    switch (status) {
      case 'Received':
        fulfillmentStatus = FulfillmentStatus.received;
        break;
      case 'Processing':
        fulfillmentStatus = FulfillmentStatus.processing;
        break;
      case 'Dispatched':
        fulfillmentStatus = FulfillmentStatus.dispatched;
        break;
      case 'Complete':
        fulfillmentStatus = FulfillmentStatus.complete;
        break;
      case 'Failed':
        fulfillmentStatus = FulfillmentStatus.failed;
        break;
      case 'Cancelled':
        fulfillmentStatus = FulfillmentStatus.cancelled;
        break;
      default:
        fulfillmentStatus = FulfillmentStatus.undefined;
        break;
    }

    return fulfillmentStatus;
  }

  static String getFulfillmentStatusText(
    FulfillmentStatus status, {
    bool toUpperCase = false,
  }) {
    String fulfillmentStatusText;
    switch (status) {
      case FulfillmentStatus.complete:
        fulfillmentStatusText = 'Complete';
        break;
      case FulfillmentStatus.cancelled:
        fulfillmentStatusText = 'Cancelled';
        break;
      case FulfillmentStatus.dispatched:
        fulfillmentStatusText = 'Dispatched';
        break;
      case FulfillmentStatus.failed:
        fulfillmentStatusText = 'Failed';
        break;
      case FulfillmentStatus.processing:
        fulfillmentStatusText = 'Processing';
        break;
      case FulfillmentStatus.received:
        fulfillmentStatusText = 'Received';
        break;
      case FulfillmentStatus.undefined:
        fulfillmentStatusText = 'Undefined';
        break;
      default:
        fulfillmentStatusText = 'Undefined';
        break;
    }

    return toUpperCase
        ? fulfillmentStatusText.toUpperCase()
        : fulfillmentStatusText;
  }

  static Map<String, String> getFulfillmentStatusButtonTextForCollection(
    FulfillmentStatus status, {
    bool toUpperCase = false,
  }) {
    String confirmButton;
    String cancelButton;

    switch (status) {
      case FulfillmentStatus.complete:
        confirmButton = '';
        cancelButton = '';
        break;
      case FulfillmentStatus.received:
      case FulfillmentStatus.undefined:
        confirmButton = 'Confirm Order';
        cancelButton = 'Cancel';
        break;
      case FulfillmentStatus.dispatched:
        confirmButton = 'Confirm Collection';
        cancelButton = 'Collection Failed';
        break;
      case FulfillmentStatus.processing:
        confirmButton = 'Mark as Ready';
        cancelButton = 'Cancel';
        break;
      case FulfillmentStatus.cancelled:
        confirmButton = '';
        cancelButton = '';
        break;
      case FulfillmentStatus.failed:
        confirmButton = '';
        cancelButton = '';
        break;
      default:
        confirmButton = 'Confirm Order';
        cancelButton = 'Cancel';
        break;
    }

    return {
      'confirmButton': toUpperCase
          ? confirmButton.toUpperCase()
          : confirmButton,
      'cancelButton': toUpperCase ? cancelButton.toUpperCase() : cancelButton,
    };
  }

  static Map<String, String> getFulfillmentStatusButtonTextForDelivery(
    FulfillmentStatus status, {
    bool toUpperCase = false,
  }) {
    String confirmButton;
    String cancelButton;

    switch (status) {
      case FulfillmentStatus.complete:
        confirmButton = '';
        cancelButton = '';
        break;
      case FulfillmentStatus.received:
      case FulfillmentStatus.undefined:
        confirmButton = 'Confirm Order';
        cancelButton = 'Cancel';
        break;
      case FulfillmentStatus.dispatched:
        confirmButton = 'Confirm Delivery';
        cancelButton = 'Delivery Failed';
        break;
      case FulfillmentStatus.processing:
        confirmButton = 'Mark as Ready';
        cancelButton = 'Cancel';
        break;
      case FulfillmentStatus.cancelled:
        confirmButton = '';
        cancelButton = '';
        break;
      case FulfillmentStatus.failed:
        confirmButton = '';
        cancelButton = '';
        break;
      default:
        confirmButton = 'Confirm Order';
        cancelButton = 'Cancel';
        break;
    }

    return {
      'confirmButton': toUpperCase
          ? confirmButton.toUpperCase()
          : confirmButton,
      'cancelButton': toUpperCase ? cancelButton.toUpperCase() : cancelButton,
    };
  }

  static Map<String, dynamic> getFulfillmentStatusForTimeline(
    FulfillmentStatus status,
  ) {
    String fulfillmentStatusText;
    int index;

    switch (status) {
      case FulfillmentStatus.failed:
        fulfillmentStatusText = 'Order failure';
        index = 6;
        break;
      case FulfillmentStatus.cancelled:
        fulfillmentStatusText = 'Order cancelled';
        index = 5;
        break;
      case FulfillmentStatus.complete:
        fulfillmentStatusText = 'Delivery confirmed, order complete';
        index = 4;
        break;
      case FulfillmentStatus.dispatched:
        fulfillmentStatusText = 'Order processed, ready for dispatch';
        index = 3;
        break;
      case FulfillmentStatus.processing:
        fulfillmentStatusText = 'Order confirmed for processing';
        index = 2;
        break;
      case FulfillmentStatus.received:
        fulfillmentStatusText = 'Order received';
        index = 1;
        break;
      default:
        fulfillmentStatusText = 'Undefined';
        index = 0;
        break;
    }

    return {'index': index, 'fulfillmentStatusText': fulfillmentStatusText};
  }

  static String getFulfillmentDateForTimeline({
    List<OrderHistoryLog> orderHistory = const [],
    required FulfillmentStatus status,
    required bool isSelected,
  }) {
    String dateValue = 'Pending';
    if (!isSelected) {
      return dateValue;
    }

    if (orderHistory.isEmpty) {
      return '';
    }

    final formatter = DateFormat('d MMMM yyyy | HH:mm');
    final dateOnlyFormatter = DateFormat('d MMMM yyyy');
    final inputFormatter = DateFormat('MM/dd/yyyy');
    DateTime? changeDate;
    dateValue = '';
    switch (status) {
      case FulfillmentStatus.complete:
        for (var log in orderHistory) {
          if (log.reason.contains('complete')) {
            changeDate = DateTime.tryParse(log.changeDate);
            changeDate ??= inputFormatter.parse(log.changeDate);
            break;
          }
        }
        if (changeDate != null) {
          if (changeDate.hour == 0 && changeDate.minute == 0) {
            dateValue = dateOnlyFormatter.format(changeDate);
          } else {
            dateValue = formatter.format(changeDate);
          }
        }
        break;
      case FulfillmentStatus.dispatched:
        for (var log in orderHistory) {
          if (log.reason.contains('dispatched')) {
            changeDate = DateTime.tryParse(log.changeDate);
            changeDate ??= inputFormatter.parse(log.changeDate);
            break;
          }
        }
        if (changeDate != null) {
          if (changeDate.hour == 0 && changeDate.minute == 0) {
            dateValue = dateOnlyFormatter.format(changeDate);
          } else {
            dateValue = formatter.format(changeDate);
          }
        }
        break;
      case FulfillmentStatus.processing:
        for (var log in orderHistory) {
          if (log.reason.contains('processing')) {
            changeDate = DateTime.tryParse(log.changeDate);
            changeDate ??= inputFormatter.parse(log.changeDate);
            break;
          }
        }
        if (changeDate != null) {
          if (changeDate.hour == 0 && changeDate.minute == 0) {
            dateValue = dateOnlyFormatter.format(changeDate);
          } else {
            dateValue = formatter.format(changeDate);
          }
        }
        break;
      case FulfillmentStatus.received:
        for (var log in orderHistory) {
          if (log.reason.contains('Paid') ||
              log.reason.contains('Created') ||
              log.reason.contains('Confirmed')) {
            changeDate = DateTime.tryParse(log.changeDate);
            changeDate ??= inputFormatter.parse(log.changeDate);
            break;
          }
        }
        if (changeDate != null) {
          if (changeDate.hour == 0 && changeDate.minute == 0) {
            dateValue = dateOnlyFormatter.format(changeDate);
          } else {
            dateValue = formatter.format(changeDate);
          }
        }
        break;
      case FulfillmentStatus.cancelled:
        dateValue = '-';
        break;
      case FulfillmentStatus.failed:
        dateValue = '-';
        break;
      default:
        dateValue = 'Pending';
        break;
    }

    return dateValue;
  }
}
