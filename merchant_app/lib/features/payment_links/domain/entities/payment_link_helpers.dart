import 'package:flutter/material.dart';

import '../../../order_common/data/model/order.dart';

String paymentLinkStatusLabel(PaymentLinkStatus status) {
  switch (status) {
    case PaymentLinkStatus.notPaymentLink:
      return 'Other';
    case PaymentLinkStatus.created:
      return 'Created';
    case PaymentLinkStatus.sent:
      return 'Sent';
    case PaymentLinkStatus.paid:
      return 'Paid';
    case PaymentLinkStatus.disabled:
      return 'Disabled';
    case PaymentLinkStatus.expired:
      return 'Expired';
    default:
      return 'Unknown';
  }
}

Color paymentLinkStatusColor(BuildContext context, PaymentLinkStatus status) {
  final theme = Theme.of(context).colorScheme;

  switch (status) {
    case PaymentLinkStatus.notPaymentLink:
      return theme.secondary;
    case PaymentLinkStatus.created:
      return theme.secondary;
    case PaymentLinkStatus.sent:
      return theme.primary;
    case PaymentLinkStatus.paid:
      return theme.tertiary;
    case PaymentLinkStatus.disabled:
      return theme.outline;
    case PaymentLinkStatus.expired:
      return theme.error;
    default:
      return theme.onSurface.withOpacity(0.6);
  }
}

class PaymentLinkStatusHelper {
  static String getTitle(PaymentLinkStatus status) {
    switch (status) {
      case PaymentLinkStatus.sent:
        return 'Mark as Sent';
      case PaymentLinkStatus.disabled:
        return 'Disable Link';
      case PaymentLinkStatus.paid:
        return 'Resend Link';
      default:
        return 'Update Status';
    }
  }

  static String getMessage(Order link, PaymentLinkStatus status) {
    switch (status) {
      case PaymentLinkStatus.sent:
        return 'Are you sure you want to mark "${link.orderLineItems[0].displayName}" as sent?';
      case PaymentLinkStatus.disabled:
        return 'Are you sure you want to disable "${link.orderLineItems[0].displayName}"?';
      case PaymentLinkStatus.paid:
        return 'Resend link to ${link.customer?.email} or ${link.customer?.mobileNumber}?';
      default:
        return 'Are you sure you want to update the status of "${link.orderLineItems[0].displayName}"?';
    }
  }

  static String getConfirmLabel(PaymentLinkStatus status) {
    switch (status) {
      case PaymentLinkStatus.sent:
        return 'Confirm';
      case PaymentLinkStatus.disabled:
        return 'Disable';
      case PaymentLinkStatus.paid:
        return 'Resend';
      default:
        return 'OK';
    }
  }
}
