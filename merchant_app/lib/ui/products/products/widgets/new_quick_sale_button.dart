import 'package:flutter/material.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/square_icon_button_primary.dart';
import 'package:littlefish_merchant/shared/constants/semantics_constants.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';

import '../../../checkout/pages/checkout_quick_sale_page.dart';

class NewQuickSaleButton extends StatelessWidget {
  final CheckoutVM vm;
  const NewQuickSaleButton({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: SemanticsConstants.kQuickSellTop,
      label: SemanticsConstants.kQuickSellTop,
      child: SizedBox(
        height: 48,
        width: 48,
        child: SquareIconButtonPrimary(
          onPressed: (ctx) async {
            vm.onClear();
            Navigator.of(ctx).pushNamed(CheckoutQuickSale.route);
          },
          icon: LittleFishIcons.quickSale,
        ),
      ),
    );
  }
}
