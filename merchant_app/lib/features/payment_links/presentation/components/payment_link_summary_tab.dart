import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import '../../../../common/presentaion/components/labels/info_summary_row.dart';
import '../../../order_common/data/model/order.dart';

class PaymentLinkSummaryTab extends StatelessWidget {
  final Order link;

  const PaymentLinkSummaryTab({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InfoSummaryRow(
              leadingTextStyle: context.styleParagraphMediumBold,
              trailingTextStyle: context.styleParagraphMediumBold,
              leading: 'Payment Link Status',
              trailing: TextFormatter.toCapitalize(
                value: link.financialStatus == FinancialStatus.paid
                    ? 'Paid'
                    : link.paymentLinkStatus.name,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: context.labelSmall('Link Details', isBold: true),
            ),
            const SizedBox(height: 12),
            InfoSummaryRow(
              leading: 'Link Name',
              trailing: link.orderLineItems[0].displayName,
            ),
            const SizedBox(height: 8),
            InfoSummaryRow(
              leading: 'Amount Due',
              trailing: 'R${link.totalPrice.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            const InfoSummaryRow(
              leading: 'Description',
              trailing: '', //link.description,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: context.labelSmall('Customer Details', isBold: true),
            ),
            const SizedBox(height: 8),
            InfoSummaryRow(
              leading: 'First Name',
              trailing: link.customer!.firstName,
            ),
            const SizedBox(height: 8),
            InfoSummaryRow(
              leading: 'Last Name',
              trailing: link.customer!.lastName,
            ),
            const SizedBox(height: 8),
            InfoSummaryRow(
              leading: 'Phone Number',
              trailing: link.customer!.mobileNumber,
            ),
            const SizedBox(height: 8),
            InfoSummaryRow(
              leading: 'Email Address',
              trailing: link.customer!.email,
            ),
            const SizedBox(height: 12),
            //const LinkSentByRow(sentBySms: true, sentByEmail: true), // This will still be implemented commented it out for temporary purpose
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: context.labelSmall('Advanced Settings', isBold: true),
            ),
            const SizedBox(height: 12),
            InfoSummaryRow(
              leading: 'Date Created',
              trailing: link.dateCreated != null
                  ? DateFormat('dd MMMM yyyy').format(link.dateCreated!)
                  : '-',
            ),
          ],
        ),
      ),
    );
  }
}
