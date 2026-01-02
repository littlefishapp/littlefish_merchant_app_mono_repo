import 'package:littlefish_merchant/shared/exceptions/general_error.dart';

import '../../../../../order_common/data/model/order.dart';

class LoadPaymentLinksAction {}

class LoadMorePaymentLinksAction {
  final int offset;
  final int limit;

  LoadMorePaymentLinksAction({required this.offset, required this.limit});
}

class AppendPaymentLinksSuccessAction {
  final List<Order> paymentLinks;
  final int offset;
  final int totalRecords;

  AppendPaymentLinksSuccessAction(
    this.paymentLinks,
    this.offset,
    this.totalRecords,
  );
}

class ClearPaymentLinksAction {}

class ResetAndLoadPaymentLinksAction {}

class ResetPaymentLinksStateAction {}

class LoadPaymentLinksSuccessAction {
  final List<Order> paymentLinks;
  final int offset;
  final int totalRecords;

  LoadPaymentLinksSuccessAction(
    this.paymentLinks,
    this.offset,
    this.totalRecords,
  );
}

class LoadPaymentLinksFailureAction {
  final GeneralError error;
  LoadPaymentLinksFailureAction(this.error);
}

class SetPaymentLinksLoadingAction {
  final bool value;
  SetPaymentLinksLoadingAction(this.value);
}

class UpdatePaymentLinkStatusAction {
  final String linkId;
  final PaymentLinkStatus newStatus;

  UpdatePaymentLinkStatusAction({
    required this.linkId,
    required this.newStatus,
  });
}

class SendPaymentLinkViaSmsAction {
  final String businessId;
  final String linkId;

  SendPaymentLinkViaSmsAction(this.businessId, this.linkId);
}

class SendPaymentLinkViaEmailAction {
  final String businessId;
  final String linkId;

  SendPaymentLinkViaEmailAction(this.businessId, this.linkId);
}
