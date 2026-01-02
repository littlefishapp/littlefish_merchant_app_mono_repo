import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/sales/pages/transaction_page.dart';

class RefundSummaryCard extends StatelessWidget {
  final List<Refund> refunds;
  final CheckoutTransaction transaction;

  const RefundSummaryCard({
    super.key,
    required this.refunds,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return _layout(context);
  }

  Widget _layout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppVariables.appDefaultButtonRadius,
          ),
          side: BorderSide.none,
        ),
        elevation: 1,
        surfaceTintColor: Colors.white,
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppVariables.appDefaultButtonRadius,
            ),
            side: BorderSide.none,
          ),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          title: context.labelLarge(
            'Refund Details',
            isBold: true,
            alignLeft: true,
          ),
          children: [_refundList(context)],
        ),
      ),
    );
  }

  Widget _refundList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: refunds.length,
      itemBuilder: (context, index) {
        return _listItemTile(context, refunds[index]);
      },
    );
  }

  _listItemTile(BuildContext context, Refund item) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      dense: !EnvironmentProvider.instance.isLargeDisplay!,
      onTap: () {
        Navigator.of(context).push(
          CustomRoute(
            builder: (context) {
              return TransactionPage(
                transaction: item,
                printTransaction: transaction,
              );
            },
          ),
        );
      },
      leading: getLeadingWidget(context, item),
      title: context.labelSmall(
        '${TextFormatter.toShortDate(dateTime: item.dateCreated, format: 'HH:mm')} - #${item.transactionNumber?.toInt().toString()}',
      ),
      subtitle: context.labelXSmall(
        '${item.displayName}, ${item.transactionStatus}',
        alignLeft: true,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          context.labelSmall(
            TextFormatter.toStringCurrency(item.totalRefund),
            isSemiBold: true,
          ),
        ],
      ),
    );
  }

  Widget getLeadingWidget(BuildContext context, Refund item) {
    return ListLeadingIconTile(
      icon: item.paymentType?.iconData ?? Icons.payment,
    );
  }
}
