import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_discount.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

class OrderDiscountSummary extends StatefulWidget {
  final double cartSubTotal, cartTax, cartTotal, cartDiscount;
  final int cartQuantity;
  final DiscountValueType type;

  const OrderDiscountSummary({
    super.key,
    required this.cartSubTotal,
    required this.cartDiscount,
    required this.cartQuantity,
    required this.type,
    required this.cartTotal,
    required this.cartTax,
  });
  @override
  State<OrderDiscountSummary> createState() => _OrderDiscountSummaryState();
}

class _OrderDiscountSummaryState extends State<OrderDiscountSummary> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          subtotalTextAndAmount(context),
          if (widget.cartDiscount != 0) discountTextAndAmount(context),
          if (widget.cartTax != 0) taxTextAndAmount(context),
          if (widget.cartDiscount != 0 || widget.cartTax != 0)
            itemCountAndFinalTotal(context),
        ],
      ),
    );
  }

  Widget subtotalTextAndAmount(BuildContext context) {
    return _buildSummaryRow(
      title: 'Sub-total',
      amount: TextFormatter.toStringCurrency(widget.cartSubTotal),
      context: context,
    );
  }

  Widget discountTextAndAmount(BuildContext context) {
    return _buildSummaryRow(
      title: 'Discount',
      amount: getDiscountAsString(),
      context: context,
    );
  }

  Widget taxTextAndAmount(BuildContext context) {
    return _buildSummaryRow(
      title: 'Vat',
      amount: TextFormatter.toStringCurrency(widget.cartTax),
      context: context,
    );
  }

  Widget itemCountAndFinalTotal(BuildContext context) {
    return _buildSummaryRow(
      title: 'Total: ${widget.cartQuantity} item(s)',
      amount: TextFormatter.toStringCurrency(widget.cartTotal),
      context: context,
      useSemiBoldAmount: true,
    );
  }

  Widget _buildSummaryRow({
    required String title,
    required String amount,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    required BuildContext context,
    bool useSemiBoldAmount = false,
  }) {
    return Container(
      margin: margin,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          context.paragraphMedium(title),
          if (useSemiBoldAmount)
            context.paragraphMedium(amount, isSemiBold: true)
          else
            context.paragraphMedium(amount),
        ],
      ),
    );
  }

  String getDiscountAsString() {
    switch (widget.type) {
      case DiscountValueType.percentage:
        return '-${widget.cartDiscount.toInt()} %';
      case DiscountValueType.fixedAmount:
        return TextFormatter.toStringCurrency(widget.cartDiscount);
      default:
        return 'R 0';
    }
  }
}
