import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/common/presentaion/components/bottom_sheet_indicator.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart'
    as checkout_discount;
import 'package:littlefish_merchant/shared/constants/semantics_constants.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_discount_page.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_cart_info.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_shopping_cart.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../../shared/constants/permission_name_constants.dart';

class ShoppingCartPanel extends StatelessWidget {
  final CheckoutVM vm;
  const ShoppingCartPanel({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BottomSheetIndicator(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: CheckoutCartInfo(
            itemCount: vm.itemCount ?? 0,
            checkoutTotal:
                ((vm.totalValue ?? Decimal.zero) -
                        (vm.discountAmount ?? Decimal.zero))
                    .toDouble(),
            enableDiscounts: discountEnabled(),
            discount: vm.discount?.value ?? 0,
            enableSubtotal: discountEnabled(),
            subtotal: (vm.totalValue ?? Decimal.zero).toDouble(),
            discountType:
                vm.discount?.type ?? checkout_discount.DiscountType.percentage,
          ),
        ),
        Visibility(
          visible:
              AppVariables.store!.state.enableDiscounts == true &&
              vm.discountsAllowed,
          child: Column(
            children: [
              if (userHasPermission(allowDiscountOnCart)) ...[
                ApplyDiscountButton(context: context, vm: vm),
              ],
              if (userHasPermission(allowDiscountOnCart) && vm.itemCount == 0)
                ...[],
            ],
          ),
        ),
        const Expanded(
          child: CheckoutShoppingCart(
            displaySummary: false,
            displayButtons: false,
            displayCurrentSale: false,
            displayCartItemsHeading: false,
            viewMode: CartViewMode.checkoutCartView,
          ),
        ),
      ],
    );
  }

  bool discountEnabled() {
    return AppVariables.store!.state.enableDiscounts == true &&
        vm.discountsAllowed &&
        isGreaterThanZero(vm.discount?.value);
  }
}

class ApplyDiscountButton extends StatelessWidget {
  const ApplyDiscountButton({
    super.key,
    required this.context,
    required this.vm,
  });

  final BuildContext context;
  final CheckoutVM vm;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: SemanticsConstants.kApplyDiscount,
      label: SemanticsConstants.kApplyDiscount,
      child: InkWell(
        onTap: (() {
          if (vm.itemCount == 0 || vm.totalValue == 0) {
            showMessageDialog(
              context,
              'Cart is empty. Please add items to the cart in '
              'order to apply a discount.',
              LittleFishIcons.info,
            );
            return;
          }
          Navigator.of(context).push(
            CustomRoute(builder: (context) => const CheckoutDiscountPage()),
          );
        }),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              context.paragraphMedium(
                isNotZeroOrNullDecimal(vm.discountAmount)
                    ? 'Edit Discount'
                    : 'Apply Discount',
                color: Theme.of(context).extension<AppliedTextIcon>()?.brand,
                isBold: true,
              ),
              const Icon(Icons.add),
            ],
          ),
        ),
      ),
    );
  }
}
