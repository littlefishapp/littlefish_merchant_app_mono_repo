import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_discount.dart';

class ApplyOrderDiscountButton extends StatelessWidget {
  final OrderDiscount discount;
  final bool hasTax;
  final Function(OrderDiscount) onDiscountApplied;

  const ApplyOrderDiscountButton({
    super.key,
    required this.discount,
    required this.onDiscountApplied,
    required this.hasTax,
  });

  @override
  Widget build(BuildContext context) {
    return applyDiscountButton(context);
  }

  Widget applyDiscountButton(BuildContext context) {
    var botHeight = 0.0;
    botHeight = discount.value != 0
        ? hasTax
              ? 4
              : 3
        : hasTax
        ? 3
        : 1;
    return Container(
      height: 46 + 24 * botHeight,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: EdgeInsets.only(top: 8, bottom: 24 * botHeight),
      child: ButtonPrimary(
        text: 'Apply Discount',
        buttonColor: Theme.of(context).colorScheme.primary,
        disabled: discount.value == 0,
        onTap: (context) async {
          await onDiscountApplied(discount);
        },
      ),
    );
  }
}
