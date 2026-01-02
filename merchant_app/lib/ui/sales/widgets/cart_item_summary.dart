import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/text_tag.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:quiver/strings.dart';

class CartItemDisplaySection extends StatelessWidget {
  final CheckoutTransaction transaction;

  const CartItemDisplaySection({required this.transaction, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: context.labelMedium(
              'Items',
              color: Theme.of(context).colorScheme.secondary,
              isBold: true,
              alignLeft: true,
            ),
          ),
        ),
        cartItemList(context),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: context.labelMedium(
              'Payment Type',
              color: Theme.of(context).colorScheme.secondary,
              alignLeft: true,
              isBold: true,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('${transaction.paymentType!.name}'),
          ),
        ),
      ],
    );
  }

  String _getSubtitle(CheckoutCartItem lineItem) {
    String quantitySoldText = TextFormatter.toStringRemoveZeroDecimals(
      lineItem.quantity,
    );
    quantitySoldText = lineItem.quantity == 1
        ? '$quantitySoldText item'
        : '$quantitySoldText items';
    return quantitySoldText;
  }

  Widget cartItemList(context) {
    if (transaction.isQuickRefund) {
      return quickRefundDescriptionTile(context);
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        var item = transaction.items![index];
        return ListTile(
          tileColor: Theme.of(context).colorScheme.background,
          dense: true,
          leading: Container(
            width: AppVariables.appDefaultlistItemSize,
            height: AppVariables.appDefaultlistItemSize,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).extension<AppliedSurface>()?.brandSubTitle,
              border: Border.all(color: Colors.transparent, width: 1),
              borderRadius: BorderRadius.circular(
                AppVariables.appDefaultRadius,
              ),
            ),
            child: Center(
              child: context.labelLarge(
                (item.description ?? '??').substring(0, 2).toUpperCase(),
                isSemiBold: true,
              ),
            ),
          ),
          title: Text(item.description ?? 'No Description'),
          subtitle: Text(_getSubtitle(item)),
          trailing: Text(
            TextFormatter.toStringRemoveZeroDecimals(
              item.itemValue ?? 0.00,
              displayCurrency: true,
            ),
          ),
        );
      },
      itemCount: transaction.itemCount ?? 0,
    );
  }

  Widget quickRefundDescriptionTile(BuildContext context) {
    int quickRefundIndex = transaction.refunds!.indexWhere(
      (refund) => refund.isQuickRefund,
    );
    Refund refund = transaction.refunds![quickRefundIndex];
    String refundDescription = getQuickRefundDescription(refund);
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      dense: true,
      title: Text('1 x $refundDescription'),
      trailing: TextTag(
        displayText: TextFormatter.toStringCurrency(
          refund.totalRefund,
          currencyCode: '',
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
