import 'package:flutter/material.dart';

import '../../order_common/data/model/order.dart';

String invoicesStatusLabel(OrderStatus status) {
  switch (status) {
    case OrderStatus.undefined:
      return 'Undefined';
    case OrderStatus.draft:
      return 'Draft';
    case OrderStatus.discarded:
      return 'Discarded';
    case OrderStatus.open:
      return 'Open';
    case OrderStatus.closed:
      return 'Closed';
    default:
      return 'Unknown';
  }
}

Color invoiceStatusColor(BuildContext context, OrderStatus status) {
  final theme = Theme.of(context).colorScheme;

  switch (status) {
    case OrderStatus.undefined:
      return theme.secondary;
    case OrderStatus.draft:
      return theme.secondary;
    case OrderStatus.discarded:
      return theme.primary;
    case OrderStatus.open:
      return theme.tertiary;
    case OrderStatus.closed:
      return theme.outline;
    default:
      return theme.onSurface.withOpacity(0.6);
  }
}

class InvoiceStatusHelper {
  static String getTitle(OrderStatus status) {
    switch (status) {
      case OrderStatus.draft:
        return 'Resend Invoice';
      case OrderStatus.discarded:
        return 'Discard Invoice';
      case OrderStatus.open:
        return 'Open Invoice';
      default:
        return 'Update Status';
    }
  }

  static String getMessage(Order link, OrderStatus status) {
    switch (status) {
      case OrderStatus.draft:
        return 'Are you sure you want to resend Invoice?';
      case OrderStatus.discarded:
        return 'Are you sure you want to discard Invoice?';
      case OrderStatus.open:
        return 'Resend link to ${link.customer?.email} or ${link.customer?.mobileNumber}?';
      default:
        return 'Are you sure you want to update the status of "${link.orderLineItems[0].displayName}"?';
    }
  }

  static String getConfirmLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.draft:
        return 'Confirm';
      case OrderStatus.discarded:
        return 'Discard';
      case OrderStatus.open:
        return 'Resend';
      default:
        return 'OK';
    }
  }
}
