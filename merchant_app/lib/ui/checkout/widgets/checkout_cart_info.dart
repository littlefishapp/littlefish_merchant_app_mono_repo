import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';

class CheckoutCartInfo extends StatelessWidget {
  final double itemCount;
  final double checkoutTotal;

  final double discount;
  final double subtotal;
  final double finalTotal;
  final bool enableDiscounts, enableSubtotal;
  final DiscountType discountType;

  const CheckoutCartInfo({
    required this.itemCount,
    required this.checkoutTotal,
    Key? key,
    this.enableDiscounts = true,
    this.enableSubtotal = true,
    this.discount = 0.0,
    this.discountType = DiscountType.percentage,
    this.finalTotal = 0,
    this.subtotal = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  layout(BuildContext context) {
    return Column(
      children: [
        itemCountAndFinalTotal(context),
        Visibility(
          visible: enableDiscounts,
          child: subtotalTextAndAmount(context),
        ),
        Visibility(
          visible: enableDiscounts,
          child: discountTextAndAmount(context),
        ),
      ],
    );
  }

  Widget subtotalTextAndAmount(BuildContext context) {
    return _buildSummaryRow(
      title: 'Sub-total',
      value: TextFormatter.toStringCurrency(subtotal, currencyCode: ''),
      context: context,
    );
  }

  Widget itemCountAndFinalTotal(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildCartSummaryHeader(
            title: 'Cart Summary',
            value:
                '${getItemCountAsString(itemCount)} = ${TextFormatter.toStringCurrency(checkoutTotal, currencyCode: '')}',
            context: context,
          ),
        ),
      ],
    );
  }

  Widget discountTextAndAmount(BuildContext context) {
    return _buildSummaryRow(
      title: discountType == DiscountType.percentage
          ? 'Discount ($discount %)'
          : 'Discount',
      value: discountType == DiscountType.percentage
          ? getDiscountPercentageAsAmount(discount)
          : getDiscountAsString(discount),
      padding: const EdgeInsets.symmetric(vertical: 4),
      margin: const EdgeInsets.only(bottom: 12),
      context: context,
      usePrimaryColor: true,
    );
  }

  Widget _buildCartSummaryHeader({
    required String title,
    required String value,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    required BuildContext context,
    bool usePrimaryColor = false,
    bool isLarger = false,
  }) {
    final textTheme = Theme.of(context).extension<AppliedTextIcon>();
    return Container(
      margin: margin,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          context.labelXSmall(title, isBold: itemCount > 0 ? true : false),
          if (usePrimaryColor)
            context.labelXSmall(
              value,
              color: textTheme?.brand,
              isBold: itemCount > 0 ? true : false,
            )
          else
            context.labelXSmall(
              value,
              color: textTheme?.secondary,
              isBold: itemCount > 0 ? true : false,
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String title,
    required String value,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    required BuildContext context,
    bool usePrimaryColor = false,
  }) {
    final textTheme = Theme.of(context).extension<AppliedTextIcon>();
    return Container(
      margin: margin,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          context.labelXSmall(title),
          if (usePrimaryColor)
            context.labelXSmall(value, color: textTheme?.brand)
          else
            context.labelXSmall(value, color: textTheme?.secondary),
        ],
      ),
    );
  }

  String getDiscountPercentageAsAmount(double percentage) {
    double discountAsAmount = subtotal * (percentage / 100);
    String amountAsString = TextFormatter.toStringCurrency(
      discountAsAmount,
      currencyCode: '',
    );
    return '- $amountAsString';
  }

  String getDiscountAsString(double discount) {
    switch (discountType) {
      case DiscountType.percentage:
        return '-${discount.toInt()} %';
      case DiscountType.fixedAmount:
        return '-${TextFormatter.toStringCurrency(discount, currencyCode: '')}';
      default:
        return '-${discount.toInt()} %';
    }
  }

  String getItemCountAsString(double itemCount) {
    bool isPlural = itemCount != 1;
    String itemCountString = isPlural == true
        ? '${(itemCount).round()} Items'
        : '${(itemCount).round()} Item';
    return itemCountString;
  }
}
