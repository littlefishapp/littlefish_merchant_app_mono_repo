//Flutter Imports
import 'package:flutter/material.dart';
//Project Imports
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/sales/pages/refund_items_list.dart';
import '../../../models/sales/checkout/checkout_refund.dart';
import '../../../providers/environment_provider.dart';
import '../../../common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import '../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../common/presentaion/components/long_text.dart';
import '../../../common/presentaion/components/list_leading_tile.dart';

class RefundListPage extends StatefulWidget {
  final List<Refund> refunds;

  const RefundListPage({Key? key, required this.refunds}) : super(key: key);

  @override
  State<RefundListPage> createState() => _RefundListPageState();
}

class _RefundListPageState extends State<RefundListPage> {
  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(
      footerActions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Refunds:'),
              Text(
                TextFormatter.toStringCurrency(
                  widget.refunds.fold(
                    0,
                    (sum, refund) => sum! + refund.totalRefund!,
                  ),
                  currencyCode: '',
                ),
              ),
            ],
          ),
        ),
      ],
      title: 'Refunds',
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: refundList(context),
      ),
    );
  }

  ListView refundList(BuildContext context) => ListView.builder(
    physics: const BouncingScrollPhysics(),
    itemCount: widget.refunds.length,
    itemBuilder: (BuildContext context, int index) {
      Refund refund = widget.refunds[index];
      return ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        dense: !EnvironmentProvider.instance.isLargeDisplay!,
        onTap: () {
          showPopupDialog(
            context: context,
            content: RefundItemsListPage(refund: refund),
            height: MediaQuery.of(context).size.height / 2,
          );
        },
        leading: const ListLeadingIconTile(icon: Icons.payment),
        title: LongText(
          TextFormatter.toStringCurrency(refund.totalRefund, currencyCode: ''),
          fontSize: null,
          fontWeight: FontWeight.bold,
          textColor: Colors.grey.shade700,
        ),
        subtitle: LongText(
          refund.isQuickRefund
              ? '1.0 item'
              : "${refund.totalItems} ${refund.totalItems == 1 ? "item" : "items"}",
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            LongText('#${(refund.transactionNumber ?? 0).floor()}'),
            LongText(
              TextFormatter.toShortDate(dateTime: refund.dateCreated),
              fontWeight: FontWeight.bold,
            ),
            LongText(
              TextFormatter.toShortDate(
                dateTime: refund.dateCreated,
                format: 'HH:mm',
              ),
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      );
    },
  );
}
