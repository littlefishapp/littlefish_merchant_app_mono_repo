//Flutter Imports
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund_item.dart';
//Project Imports
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:quiver/strings.dart';
import '../../../models/sales/checkout/checkout_refund.dart';
import '../../../providers/environment_provider.dart';
import '../../../common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import '../../../common/presentaion/components/long_text.dart';
import '../../../common/presentaion/components/list_leading_tile.dart';

class RefundItemsListPage extends StatefulWidget {
  final Refund refund;

  const RefundItemsListPage({Key? key, required this.refund}) : super(key: key);

  @override
  State<RefundItemsListPage> createState() => _RefundItemsListPageState();
}

class _RefundItemsListPageState extends State<RefundItemsListPage> {
  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(
      footerActions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Cost:'),
              Text(
                TextFormatter.toStringCurrency(
                  widget.refund.totalRefund,
                  currencyCode: '',
                ),
              ),
            ],
          ),
        ),
      ],
      title: 'Items',
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: refundItems(context),
      ),
    );
  }

  Widget refundItems(BuildContext context) {
    if (widget.refund.isQuickRefund) {
      return quickRefundDescriptionTile();
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: widget.refund.items!.length,
      itemBuilder: (BuildContext context, int index) {
        RefundItem refundItem = widget.refund.items![index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            tileColor: Theme.of(context).colorScheme.background,
            dense: !EnvironmentProvider.instance.isLargeDisplay!,
            onTap: () {},
            leading: const ListLeadingIconTile(
              icon: Icons.wallet_travel_outlined,
            ),
            title: LongText(
              '${refundItem.quantity} x ${refundItem.displayName}',
              fontSize: null,
              fontWeight: FontWeight.bold,
              textColor: Colors.grey.shade700,
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                LongText(
                  'Item Value: ${TextFormatter.toStringCurrency(refundItem.itemValue)}',
                ),
                LongText(
                  'Item Total: ${TextFormatter.toStringCurrency(refundItem.itemTotalValue)}',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  quickRefundDescriptionTile() {
    String refundDescription = getQuickRefundDescription(widget.refund);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.background,
        dense: !EnvironmentProvider.instance.isLargeDisplay!,
        onTap: () {},
        leading: const ListLeadingIconTile(icon: Icons.wallet_travel_outlined),
        title: LongText(
          '1 x $refundDescription',
          fontSize: null,
          fontWeight: FontWeight.bold,
          textColor: Colors.grey.shade700,
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            LongText('Item Value: ${widget.refund.totalRefund}'),
            LongText('Total Item value: ${widget.refund.totalRefund}'),
          ],
        ),
      ),
    );
  }

  String getQuickRefundDescription(Refund refund) {
    if (isNotBlank(refund.description)) return refund.description!;
    if (isNotBlank(refund.displayName)) return refund.displayName!;
    return 'Quick Refund';
  }
}
