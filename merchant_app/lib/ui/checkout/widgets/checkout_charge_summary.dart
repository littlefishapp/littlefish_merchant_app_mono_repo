import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';

import '../../../app/theme/applied_system/applied_text_icon.dart';

class CheckoutChargeSummary extends StatelessWidget {
  final double checkoutTotal;

  final String? totalText;
  final double discount;
  final double subtotal;
  final double finalTotal;
  final bool enableDiscounts, enableSubtotal, enableCashback, enableWithdrawal;
  final bool enableTips;
  final double cashbackAmount, withdrawalAmount;
  final double tipAmount;
  final DiscountType discountType;
  final TipType tipType;

  const CheckoutChargeSummary({
    required this.checkoutTotal,
    Key? key,
    this.enableDiscounts = true,
    this.enableSubtotal = true,
    this.enableCashback = true,
    this.enableWithdrawal = false,
    this.enableTips = true,
    this.discount = 0.0,
    this.discountType = DiscountType.percentage,
    this.tipType = TipType.fixedAmount,
    this.finalTotal = 0,
    this.subtotal = 0,
    this.tipAmount = 0,
    this.cashbackAmount = 0,
    this.withdrawalAmount = 0,
    this.totalText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  layout(BuildContext context) {
    return Column(
      children: [
        totalTextAndAmount(context),
        if (enableSubtotal) subtotalTextAndAmount(context),
        if (enableDiscounts) discountTextAndAmount(context),
        if (enableCashback) cashbackTextAndAmount(context),
        if (enableTips) tipTextAndAmount(context),
        if (enableWithdrawal) withdrawalTextAndAmount(context),
      ],
    );
  }

  Widget totalTextAndAmount(BuildContext context) {
    return _buildSummaryRow(
      context: context,
      title: totalText ?? 'Amount Due',
      amount: TextFormatter.toStringCurrency(checkoutTotal, currencyCode: ''),
      padding: const EdgeInsets.symmetric(vertical: 4),
    );
  }

  Widget subtotalTextAndAmount(BuildContext context) {
    return _buildSubHeadingSummaryRow(
      context: context,
      title: 'Sub-total',
      amount: TextFormatter.toStringCurrency(subtotal, currencyCode: ''),
      padding: const EdgeInsets.symmetric(vertical: 4),
    );
  }

  Widget tipTextAndAmount(BuildContext context) {
    return _buildSubHeadingSummaryRow(
      context: context,
      title: tipType == TipType.percentage ? 'Tip ($tipAmount %)' : 'Tip',
      amount: tipType == TipType.percentage
          ? getPercentageAsAmount(tipAmount)
          : getTipAsString(tipAmount),
      padding: const EdgeInsets.symmetric(vertical: 4),
      showAmountAsIncrease: true,
    );
  }

  Widget cashbackTextAndAmount(BuildContext context) {
    return _buildSubHeadingSummaryRow(
      context: context,
      title: 'Cashback',
      amount: TextFormatter.toStringCurrency(cashbackAmount, currencyCode: ''),
      padding: const EdgeInsets.symmetric(vertical: 4),
    );
  }

  Widget withdrawalTextAndAmount(BuildContext context) {
    return _buildSubHeadingSummaryRow(
      context: context,
      title: 'Cash Withdrawal',
      amount: TextFormatter.toStringCurrency(
        withdrawalAmount,
        currencyCode: '',
      ),
      padding: const EdgeInsets.symmetric(vertical: 4),
    );
  }

  Widget discountTextAndAmount(BuildContext context) {
    return _buildSubHeadingSummaryRow(
      context: context,
      title: discountType == DiscountType.percentage
          ? 'Discount ($discount %)'
          : 'Discount',
      amount: discountType == DiscountType.percentage
          ? '- ${getPercentageAsAmount(discount)}'
          : getDiscountAsString(discount),
      padding: const EdgeInsets.symmetric(vertical: 4),
      showAmountAsDecrease: true,
    );
  }

  String getPercentageAsAmount(double percentage) {
    double amount = subtotal * (percentage / 100);
    return TextFormatter.toStringCurrency(amount, currencyCode: '');
  }

  Widget _buildSummaryRow({
    required BuildContext context,
    required String title,
    required String amount,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    final textTheme = Theme.of(context).extension<AppliedTextIcon>();
    return Container(
      margin: margin,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: context.headingMedium(
              title,
              color: textTheme?.emphasized,
              alignLeft: true,
              isBold: true,
            ),
          ),
          Expanded(
            child: context.headingMedium(
              amount,
              color: textTheme?.emphasized,
              alignRight: true,
              isSemiBold: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubHeadingSummaryRow({
    required BuildContext context,
    required String title,
    required String amount,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    bool showAmountAsIncrease = false,
    bool showAmountAsDecrease = false,
  }) {
    final textTheme = Theme.of(context).extension<AppliedTextIcon>();
    return Container(
      margin: margin,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: context.paragraphMedium(
              title,
              color: textTheme?.secondary,
              alignLeft: true,
            ),
          ),
          Expanded(
            child: context.paragraphMedium(
              amount,
              color: showAmountAsIncrease
                  ? textTheme?.success
                  : showAmountAsDecrease
                  ? textTheme?.error
                  : textTheme?.primary,
              alignRight: true,
            ),
          ),
        ],
      ),
    );
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

  String getTipAsString(double tip) {
    switch (tipType) {
      case TipType.percentage:
        return '${tip.toInt()} %';
      case TipType.fixedAmount:
        return TextFormatter.toStringCurrency(tip, currencyCode: '');
      default:
        return '${tip.toInt()} %';
    }
  }

  String getItemCountAsString(double itemCount) {
    bool isPlural = itemCount != 1;
    String itemCountString = isPlural == true
        ? 'Total: ${(itemCount).round()} items'
        : 'Total: ${(itemCount).round()} item';
    return itemCountString;
  }
}
