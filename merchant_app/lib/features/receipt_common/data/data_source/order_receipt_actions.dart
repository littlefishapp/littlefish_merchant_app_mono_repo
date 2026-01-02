import '../../../order_common/data/model/order.dart';

class SendEmailReceipt {
  final String email;
  final String firstName;
  final Order order;

  const SendEmailReceipt(this.order, this.email, this.firstName);
}

class SendEmailRefundReceipt {
  final String email;
  final String firstName;
  final Order order;

  const SendEmailRefundReceipt(this.order, this.email, this.firstName);
}

class SendSmsReceipt {
  final String mobileNumber;
  final Order order;

  const SendSmsReceipt(this.order, this.mobileNumber);
}
