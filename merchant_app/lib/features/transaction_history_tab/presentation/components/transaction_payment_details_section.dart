import 'package:flutter/cupertino.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_transaction.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/presentation/components/transaction_info_item.dart';

class TransactionPaymentDetailsSection extends StatelessWidget {
  final String paymentMethod, authCode, paymentRef;
  final AcceptanceType acceptanceType;
  final AcceptanceChannel acceptanceChannel;

  const TransactionPaymentDetailsSection({
    super.key,
    required this.paymentMethod,
    required this.acceptanceType,
    required this.acceptanceChannel,
    required this.authCode,
    required this.paymentRef,
  });

  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Padding _content(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 16),
          child: context.labelSmall(
            'Payment Details',
            alignLeft: true,
            isBold: true,
          ),
        ),
        TransactionInfoItem(title: 'Payment Method', value: paymentMethod),
        TransactionInfoItem(
          title: 'Acceptance Type',
          value: getAcceptanceType(acceptanceType),
        ),
        TransactionInfoItem(
          title: 'Acceptance Channel',
          value: getAcceptanceChannel(acceptanceChannel),
        ),
        TransactionInfoItem(title: 'Auth Code', value: authCode),
        TransactionInfoItem(title: 'Payment Reference', value: paymentRef),
        const SizedBox(height: 8),
      ],
    ),
  );

  String getAcceptanceChannel(AcceptanceChannel channel) {
    switch (channel) {
      case AcceptanceChannel.cash:
        return 'Cash';
      case AcceptanceChannel.card:
        return 'Card';
      case AcceptanceChannel.qrCode:
        return 'QR Code';
      case AcceptanceChannel.mobileWallet:
        return 'Mobile Wallet';
      case AcceptanceChannel.payByLink:
        return 'Pay By Link';
      case AcceptanceChannel.tapOnGlass:
        return 'Tap on Glass';
      case AcceptanceChannel.undefined:
        return 'N/A';
      default:
        return 'N/A';
    }
  }

  String getAcceptanceType(AcceptanceType type) {
    switch (type) {
      case AcceptanceType.inPerson:
        return 'In-Person';
      case AcceptanceType.online:
        return 'Online';
      default:
        return 'N/A';
    }
  }
}
