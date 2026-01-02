import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/tools/extensions/extensions.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/discount_amount_tab.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/discount_percentage_tab.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';
import 'package:littlefish_merchant/models/sales/checkout/cart_discount_validator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/icons/delete_icon.dart';

import '../../../../common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import '../redux/viewmodels/invoicing_view_model.dart';

class InvoiceDiscountPage extends StatefulWidget {
  static const String route = 'invoice/apply-discount';

  const InvoiceDiscountPage({Key? key}) : super(key: key);

  @override
  State<InvoiceDiscountPage> createState() => _InvoiceDiscountPageState();
}

class _InvoiceDiscountPageState extends State<InvoiceDiscountPage> {
  CheckoutDiscount _discount = CheckoutDiscount(value: 0);
  final GlobalKey _percentageTabKey = GlobalKey();
  final GlobalKey _amountTabKey = GlobalKey();
  final GlobalKey _discardDiscountButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InvoicingViewModel>(
      distinct: true,
      onInit: (store) {
        final vm = InvoicingViewModel.fromStore(store);
        final existingDiscount = vm.discount;

        if (existingDiscount != null) {
          _discount = CheckoutDiscount(
            isNew: true,
            value: existingDiscount.value ?? 0,
            type: existingDiscount.type,
            minValue: existingDiscount.minValue ?? 0,
            maxValue: existingDiscount.maxValue,
          );
        }
      },
      converter: (store) => InvoicingViewModel.fromStore(store),
      builder: (context, vm) => scaffold(context, vm),
    );
  }

  Widget scaffold(BuildContext context, InvoicingViewModel vm) {
    _discount.value ??= 0;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        if (_isNoDiscount(_discount, vm.discount)) {
          Navigator.of(context).pop();
          return;
        }

        if (_discount == vm.discount) {
          Navigator.of(context).pop();
          return;
        }

        final modalService = getIt<ModalService>();
        final discard = await modalService.showActionModal(
          context: context,
          title: 'Discard Discount',
          description:
              'You have not applied the discount to the invoice, discard it?',
          acceptText: 'Yes, Discard',
          cancelText: 'No, Cancel',
        );

        if (discard == true && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: AppScaffold(
        title: 'Discount',
        body: tabs(vm),
        actions: [discardDiscountButton(vm)],
        persistentFooterButtons: [applyDiscountButton(vm)],
      ),
    );
  }

  AppTabBar tabs(InvoicingViewModel vm) {
    return AppTabBar(
      intialIndex: 0,
      scrollable: false,
      resizeToAvoidBottomInset: false,
      onTabChanged: (_) {},
      tabs: [
        TabBarItem(
          key: _percentageTabKey,
          text: 'Percentage',
          content: DiscountPercentageTab(
            discount: _discount,
            cartTotal: vm.totalAmount ?? 0,
            onChanged: (percent) {
              setState(() {
                _discount
                  ..type = DiscountType.percentage
                  ..value = percent?.truncateToDecimalPlaces(2) ?? 0
                  ..minValue = 0
                  ..maxValue = 100
                  ..isNew = true;
              });
            },
          ),
        ),
        TabBarItem(
          key: _amountTabKey,
          text: 'Amount',
          content: DiscountAmountTab(
            discount: _discount,
            cartTotal: vm.totalAmount ?? 0,
            onChanged: (amount) {
              setState(() {
                _discount
                  ..type = DiscountType.fixedAmount
                  ..value = amount ?? 0
                  ..minValue = 0
                  ..maxValue = null
                  ..isNew = true;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget applyDiscountButton(InvoicingViewModel vm) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ButtonPrimary(
        text: 'Apply Discount',
        disabled: _discount.value == 0,
        onTap: (context) {
          final validationResult = DiscountValidator.validateDiscount(
            totalBeforeDiscount: vm.totalAmount ?? 0,
            discount: _discount,
          );

          if (validationResult != DiscountValidationResults.success) {
            showMessageDialog(
              context,
              DiscountValidator.getValidationMessage(validationResult),
              LittleFishIcons.error,
            );
            return;
          }

          _discount.isNew = true;
          vm.setDiscount(_discount);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget discardDiscountButton(InvoicingViewModel vm) {
    return IconButton(
      key: _discardDiscountButtonKey,
      icon: const DeleteIcon(),
      onPressed: () async {
        final modalService = getIt<ModalService>();
        final discard = await modalService.showActionModal(
          context: context,
          title: 'Discard Discount',
          description: 'Are you sure you want to remove this discount?',
          acceptText: 'Yes, Discard',
          cancelText: 'No, Cancel',
        );

        if (discard == true) {
          setState(() {
            _discount = CheckoutDiscount(value: 0);
          });
          vm.setDiscount(_discount);
        }
      },
    );
  }

  bool _isNoDiscount(CheckoutDiscount? local, CheckoutDiscount? state) {
    return (local?.value ?? 0) == 0 && (state?.value ?? 0) == 0;
  }
}
