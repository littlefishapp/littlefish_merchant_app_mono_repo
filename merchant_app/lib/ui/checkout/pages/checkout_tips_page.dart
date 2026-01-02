// removed ignore: depend_on_referenced_packages, implementation_imports

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/labels/info_summary_row.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/tools/extensions/extensions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:redux/src/store.dart' as store;
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_tip_amount_tab.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip_validator.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_tip_percentage_tab.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';

import '../../../common/presentaion/components/icons/delete_icon.dart';

class CheckoutTipsPage extends StatefulWidget {
  static const String route = 'checkout/apply-tip-page';

  const CheckoutTipsPage({Key? key}) : super(key: key);

  @override
  State<CheckoutTipsPage> createState() => _CheckoutTipsPageState();
}

class _CheckoutTipsPageState extends State<CheckoutTipsPage> {
  late CheckoutTip _tip;
  final GlobalKey _percentageTabKey = GlobalKey();
  final GlobalKey _amountTabKey = GlobalKey();
  final GlobalKey _discardTipButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CheckoutVM>(
      onInit: (store) {
        var state = store.state.checkoutState;

        _tip = CheckoutTip(
          isNew: state.tip?.isNew ?? true,
          value: state.tip?.value ?? 0,
          type: state.tip?.type,
          maxValue: null,
          minValue: 0,
        );
      },
      converter: (store.Store<AppState> store) {
        return CheckoutVM.fromStore(store);
      },
      builder: (BuildContext context, CheckoutVM vm) {
        return scaffold(context, vm);
      },
    );
  }

  Widget scaffold(BuildContext context, CheckoutVM vm) {
    _tip.value ??= 0;
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (AppVariables.store!.state.enableSideNavDrawer ?? false);
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        if (noTipChosen(_tip, vm.tip) || (_tip == vm.tip)) {
          Navigator.of(context).pop();
          return;
        }

        final ModalService modalService = getIt<ModalService>();

        bool? discardSelectedTip = await modalService.showActionModal(
          context: context,
          title: 'Discard Tip',
          description:
              'You have not applied the tip to your cart, are you sure you want to go back?',
          acceptText: 'Yes, Discard',
          cancelText: 'No, Cancel',
        );

        if (discardSelectedTip == true) {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
          return;
        }

        return;
      },
      child: AppScaffold(
        title: 'Add Tip',
        enableProfileAction: !showSideNav,
        hasDrawer: false,
        displayNavDrawer: false,
        body: tabs(vm),
        actions: [discardTipButton(context, vm)],
        persistentFooterButtons: [
          Column(
            children: [
              // if (vm.tipTabIndex == 1) checkoutCartInfo(vm, _tip),
              applyTipButton(context, vm, _tip),
            ],
          ),
        ],
      ),
    );
  }

  tabs(CheckoutVM vm) {
    return AppTabBar(
      physics: const BouncingScrollPhysics(),
      intialIndex: vm.tipTabIndex ?? 0,
      scrollable: false,
      resizeToAvoidBottomInset: false,
      onTabChanged: (int index) =>
          vm.store?.dispatch(CheckoutSetTipTabIndexAction(index)),
      tabs: [
        TabBarItem(
          key: _amountTabKey,
          content: CheckoutTipAmountTab(
            tip: _tip,
            cartTotal: (vm.totalValue ?? Decimal.zero).toDouble(),
            onChanged: (double? amount) {
              if (mounted) {
                setState(() {
                  _tip.type = TipType.fixedAmount;
                  _tip.value = amount ?? 0;
                  _tip.minValue = 0;
                  _tip.maxValue = null;
                  _tip.isNew = true;
                });
              }
            },
          ),
          text: 'Amount',
        ),
        TabBarItem(
          key: _percentageTabKey,
          content: CheckoutTipPercentageTab(
            tip: _tip,
            cartTotal: (vm.totalValue ?? Decimal.zero).toDouble(),
            onChanged: (double? percent) {
              if (mounted) {
                setState(() {
                  _tip.type = TipType.percentage;
                  _tip.value =
                      percent?.toDouble().truncateToDecimalPlaces(2) ?? 0;
                  _tip.minValue = 0;
                  _tip.maxValue = null;
                  _tip.isNew = true;
                });
              }
            },
          ),
          text: 'Percentage',
        ),
      ],
    );
  }

  Widget checkoutCartInfo(CheckoutVM vm, CheckoutTip tip) {
    double checkoutTotalWithoutTip = (vm.totalValue ?? Decimal.zero).toDouble();

    // double totalWithTip =
    //     CheckoutTipValidator.getFinalTotal(checkoutTotalWithoutTip, tip);
    double totalTip = CheckoutTipValidator.getTipAmount(
      checkoutTotalWithoutTip,
      tip,
    );

    // return _buildSummaryRow(
    //   title: 'Cart Total',
    //   amount: TextFormatter.toStringCurrency(
    //     checkoutTotalWithSelectedTip,
    //     currencyCode: '',
    //   ),
    //   margin: const EdgeInsets.all(8),
    // );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          InfoSummaryRow(
            leading: 'Tip Amount',
            trailing: TextFormatter.toStringCurrency(
              totalTip,
              currencyCode: '',
            ),
            // margin: const EdgeInsets.all(8),
          ),
          // InfoSummaryRow(
          //   leading: 'Cart Total',
          //   trailing: TextFormatter.toStringCurrency(
          //     totalWithTip,
          //     currencyCode: '',
          //   ),
          //   // margin: const EdgeInsets.all(8),
          // ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String title,
    required String amount,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    TextStyle? titleTextStyle,
    TextStyle? amountTextStyle,
  }) {
    return Container(
      margin: margin,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: titleTextStyle,
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              amount,
              style: amountTextStyle,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget applyTipButton(BuildContext context, CheckoutVM vm, CheckoutTip tip) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: ButtonPrimary(
        text: 'Add Tip',
        upperCase: false,
        disabled: isZeroOrNull(tip.value),
        buttonColor: Theme.of(context).colorScheme.secondary,
        onTap: (context) {
          double checkoutTotalWithoutTip =
              ((vm.checkoutTotal ?? Decimal.zero) -
                      (vm.tipAmount ?? Decimal.zero))
                  .toDouble();
          CheckoutTipValidationResults validationResult =
              CheckoutTipValidator.validateTip(
                totalBeforeTip: checkoutTotalWithoutTip,
                tip: tip,
              );

          if (validationResult != CheckoutTipValidationResults.success) {
            showMessageDialog(
              context,
              CheckoutTipValidator.getValidationMessage(validationResult),
              LittleFishIcons.error,
            );
            return;
          }

          tip.isNew = true;
          vm.setAmountTendered(vm.checkoutTotal);
          vm.store?.dispatch(CheckoutSetTipAction(tip));
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget discardTipButton(BuildContext context, CheckoutVM vm) {
    return Container(
      width: 32,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Semantics(
        identifier: 'Discard Button',
        label: 'Discard Button',
        child: IconButton(
          key: _discardTipButtonKey,
          icon: const DeleteIcon(),
          onPressed: () async {
            final ModalService modalService = getIt<ModalService>();

            bool? discardSelectedTip = await modalService.showActionModal(
              context: context,
              title: 'Discard Tip',
              description:
                  'Are you sure you want to remove the tip applied to your cart?',
              acceptText: 'Yes, Discard',
              cancelText: 'No, Cancel',
            );

            if (discardSelectedTip == false) return;

            if (mounted) {
              setState(() {
                vm.store?.dispatch(CheckoutClearTipAction());
                _tip = CheckoutTip(
                  isNew: false,
                  minValue: 0,
                  maxValue: null,
                  value: 0,
                  type: null,
                );
              });
            }
          },
        ),
      ),
    );
  }

  bool noTipChosen(CheckoutTip? localTip, CheckoutTip? stateTip) {
    if (localTip == null) return true;
    bool tipNotChosen = localTip.value == 0;
    bool tipNotAppliedToState = stateTip == null;
    return tipNotChosen && tipNotAppliedToState;
  }
}
