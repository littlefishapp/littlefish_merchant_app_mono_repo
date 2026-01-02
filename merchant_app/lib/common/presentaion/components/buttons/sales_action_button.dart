import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';

import '../../../../ui/checkout/viewmodels/checkout_viewmodels.dart';
import '../../../../ui/checkout/widgets/checkout_more_sales_actions.dart';

class SalesActionButton extends StatefulWidget {
  final double width;
  final double height;
  final CheckoutVM vm;
  const SalesActionButton({
    Key? key,
    this.width = 56,
    this.height = 56,
    required this.vm,
  }) : super(key: key);

  @override
  State<SalesActionButton> createState() => _SalesActionButtonState();
}

class _SalesActionButtonState extends State<SalesActionButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 48,
      child: ButtonSecondary(
        text: '',
        icon: Icons.more_vert,
        onTap: (onTapContext) async {
          await CheckoutMoreSalesActions.showMoreActions(
            context: onTapContext,
            vm: widget.vm,
          );
          setState(() {});
        },
      ),
    );
  }
}
