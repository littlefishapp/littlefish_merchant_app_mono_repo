// Flutter imports:
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

// Package imports
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/tools/extensions/extensions.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/discount_amount_tab.dart';
// removed ignore: depend_on_referenced_packages, implementation_imports
import 'package:redux/src/store.dart';

// Project imports
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/discount_percentage_tab.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/library/select_products_page.dart';
import 'package:littlefish_merchant/models/sales/checkout/cart_discount_validator.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_cart_info.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';

import '../../../common/presentaion/components/icons/delete_icon.dart';
import '../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class CheckoutDiscountPage extends StatefulWidget {
  static const String route = 'checkout/apply-discount';

  const CheckoutDiscountPage({Key? key}) : super(key: key);

  @override
  State<CheckoutDiscountPage> createState() => _CheckoutDiscountPageState();
}

class _CheckoutDiscountPageState extends State<CheckoutDiscountPage> {
  late CheckoutDiscount _discount;
  final GlobalKey _percentageTabKey = GlobalKey();
  final GlobalKey _amountTabKey = GlobalKey();
  final GlobalKey _discardDiscountButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CheckoutVM>(
      onInit: (store) {
        var state = store.state.checkoutState;

        _discount = CheckoutDiscount(
          isNew: state.discount?.isNew ?? true,
          value: state.discount?.value ?? 0,
          type: state.discount?.type,
          maxValue: state.discount?.type == DiscountType.percentage
              ? state.discount?.maxValue ?? 100
              : state.discount?.maxValue,
          minValue: state.discount?.minValue ?? 0,
        );
      },
      converter: (Store<AppState> store) {
        return CheckoutVM.fromStore(store);
      },
      builder: (BuildContext context, CheckoutVM vm) {
        return scaffold(context, vm);
      },
    );
  }

  Widget scaffold(BuildContext context, CheckoutVM vm) {
    _discount.value ??= 0;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        if (noDiscountChosen(_discount, vm.discount)) {
          Navigator.of(context).pop();
          return;
        }

        if (_discount == vm.discount) {
          Navigator.of(context).pop();
          return;
        }

        final ModalService modalService = getIt<ModalService>();

        bool? discardSelectedDiscount = await modalService.showActionModal(
          context: context,
          title: 'Discard Discount',
          description:
              'You have not applied the discount to your cart, are you sure you want to go back?',
          acceptText: 'Yes, Discard',
          cancelText: 'No, Cancel',
        );

        if (discardSelectedDiscount == true) {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
          return;
        }

        return;
      },
      child: AppScaffold(
        title: 'Discount',
        body: tabs(vm),
        actions: [discardDiscountButton(context, vm)],
        persistentFooterButtons: [
          Column(
            children: [
              // checkoutCartInfo(vm),
              applyDiscountButton(context, vm, _discount),
            ],
          ),
        ],
      ),
    );
  }

  AppTabBar tabs(CheckoutVM vm) {
    return AppTabBar(
      physics: const BouncingScrollPhysics(),
      intialIndex: vm.discountTabIndex ?? 0,
      scrollable: false,
      resizeToAvoidBottomInset: false,
      onTabChanged: (int index) =>
          vm.store?.dispatch(CheckoutSetDiscountTabIndexAction(index)),
      tabs: [
        TabBarItem(
          key: _percentageTabKey,
          content: DiscountPercentageTab(
            discount: _discount,
            cartTotal: (vm.totalValue ?? Decimal.zero).toDouble(),
            onChanged: (double? percent) {
              if (mounted) {
                setState(() {
                  _discount.type = DiscountType.percentage;
                  _discount.value =
                      percent?.toDouble().truncateToDecimalPlaces(2) ?? 0;
                  _discount.minValue = 0;
                  _discount.maxValue = 100;
                  _discount.isNew = true;
                });
              }
            },
          ),
          text: 'Percentage',
        ),
        TabBarItem(
          key: _amountTabKey,
          content: DiscountAmountTab(
            discount: _discount,
            cartTotal: (vm.totalValue ?? Decimal.zero).toDouble(),
            onChanged: (double? amount) {
              if (mounted) {
                setState(() {
                  _discount.type = DiscountType.fixedAmount;
                  _discount.value = amount ?? 0;
                  _discount.minValue = 0;
                  _discount.maxValue = null;
                  _discount.isNew = true;
                });
              }
            },
          ),
          text: 'Amount',
        ),
      ],
    );
  }

  Widget checkoutCartInfo(CheckoutVM vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CheckoutCartInfo(
        itemCount: vm.itemCount ?? 0,
        checkoutTotal: DiscountValidator.getFinalTotal(
          (vm.totalValue ?? Decimal.zero).toDouble(),
          _discount,
        ),
        enableDiscounts: _discount.value! > 0,
        discount: _discount.value!.toDouble(),
        enableSubtotal: _discount.value! > 0,
        subtotal: (vm.totalValue ?? Decimal.zero).toDouble(),
        discountType: _discount.type ?? DiscountType.fixedAmount,
      ),
    );
  }

  Widget applyDiscountButton(
    BuildContext context,
    CheckoutVM vm,
    CheckoutDiscount discount,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ButtonPrimary(
        text: 'Apply Discount',
        buttonColor: Theme.of(context).colorScheme.primary,
        disabled: _discount.value! == 0,
        onTap: (context) {
          DiscountValidationResults validationResult =
              DiscountValidator.validateDiscount(
                totalBeforeDiscount: (vm.totalValue ?? Decimal.zero).toDouble(),
                discount: discount,
              );

          if (validationResult != DiscountValidationResults.success) {
            showMessageDialog(
              context,
              DiscountValidator.getValidationMessage(validationResult),
              LittleFishIcons.error,
            );
            return;
          }

          discount.isNew = true;
          vm.store?.dispatch(CheckoutSetDiscountAction(discount));

          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(SelectProductsPage.route, (route) => false);
        },
      ),
    );
  }

  Widget discardDiscountButton(BuildContext context, CheckoutVM vm) {
    return Container(
      width: 32,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Semantics(
        identifier: 'Discard Button',
        label: 'Discard Button',
        child: IconButton(
          key: _discardDiscountButtonKey,
          icon: const DeleteIcon(),
          color: Theme.of(context).colorScheme.primary,
          onPressed: () async {
            final ModalService modalService = getIt<ModalService>();

            bool? discardSelectedDiscount = await modalService.showActionModal(
              context: context,
              title: 'Discard Discount',
              description:
                  'Are you sure you want to remove the discount applied to your cart?',
              acceptText: 'Yes, Discard',
              cancelText: 'No, Cancel',
            );

            if (discardSelectedDiscount == false) return;

            if (mounted) {
              setState(() {
                _discount = CheckoutDiscount(
                  isNew: false,
                  minValue: 0,
                  maxValue: 0,
                  value: 0,
                  type: null,
                );
                vm.store?.dispatch(CheckoutSetDiscountAction(_discount));
              });
            }
          },
        ),
      ),
    );
  }

  bool noDiscountChosen(
    CheckoutDiscount? localDiscount,
    CheckoutDiscount? stateDiscount,
  ) {
    if (localDiscount == null) return true;
    bool discountNotChosen = localDiscount.value == 0; // if zero true
    bool discountNotAppliedToState = stateDiscount == null; // state zero true
    return discountNotChosen && discountNotAppliedToState;
  }
}
