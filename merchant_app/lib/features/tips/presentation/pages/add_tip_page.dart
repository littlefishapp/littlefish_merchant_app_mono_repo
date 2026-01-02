// flutter imports
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';

// package imports

// project imports
import 'package:littlefish_merchant/common/presentaion/components/labels/info_summary_row.dart';
import 'package:littlefish_merchant/features/tips/presentation/components/add_tip_button.dart';
import 'package:littlefish_merchant/features/tips/presentation/components/tip_amount_tab.dart';
import 'package:littlefish_merchant/features/tips/presentation/components/tip_percentage_tab.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip_validator.dart';
import 'package:littlefish_merchant/tools/extensions/extensions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';

import '../../../../common/presentaion/components/icons/delete_icon.dart';

class AddTipPage extends StatefulWidget {
  static const String route = 'sale/add-tip-page';

  final CheckoutTip? tip;
  final double totalBeforeTip;
  final int tabIndex;
  final void Function(int tabIndex)? onTabChanged;
  final void Function()? onDiscardTip;

  const AddTipPage({
    Key? key,
    this.tip,
    this.totalBeforeTip = 0,
    this.tabIndex = 0,
    this.onTabChanged,
    this.onDiscardTip,
  }) : super(key: key);

  @override
  State<AddTipPage> createState() => _AddTipPageState();
}

class _AddTipPageState extends State<AddTipPage> {
  late CheckoutTip _tip;
  final GlobalKey _percentageTabKey = GlobalKey();
  final GlobalKey _amountTabKey = GlobalKey();
  final GlobalKey _discardTipButtonKey = GlobalKey();

  @override
  void initState() {
    _tip = _createTip(widget.tip);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: scaffold(context));
  }

  Widget scaffold(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async =>
          _onPopInvoked(context: context, didPop: didPop),
      child: AppScaffold(
        title: 'Add Tip',
        body: tabs(),
        actions: [discardTipButton(context)],
        persistentFooterButtons: [
          Column(
            children: [
              checkoutCartInfo(_tip),
              AddTipButton(totalBeforeTip: widget.totalBeforeTip, tip: _tip),
            ],
          ),
        ],
        onBackPressed: () => _onPopInvoked(context: context),
      ),
    );
  }

  tabs() {
    //TODO(Michael): AppTabBar introduces nested scaffolds, either refactor AppTabBar to not nest or refactor this code
    return AppTabBar(
      physics: const BouncingScrollPhysics(),
      intialIndex: widget.tabIndex,
      scrollable: false,
      resizeToAvoidBottomInset: false,
      onTabChanged: (int index) =>
          widget.onTabChanged != null ? widget.onTabChanged!(index) : null,
      tabs: [
        TabBarItem(
          key: _percentageTabKey,
          content: TipPercentageTab(
            tip: _tip,
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
        TabBarItem(
          key: _amountTabKey,
          content: TipAmountTab(
            tip: _tip,
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
      ],
    );
  }

  Widget checkoutCartInfo(CheckoutTip tip) {
    double totalWithTip = CheckoutTipValidator.getFinalTotal(
      widget.totalBeforeTip,
      tip,
    );
    double totalTip = CheckoutTipValidator.getTipAmount(
      widget.totalBeforeTip,
      tip,
    );

    return Column(
      children: [
        InfoSummaryRow(
          leading: 'Tip',
          trailing: TextFormatter.toStringCurrency(totalTip, currencyCode: ''),
          margin: const EdgeInsets.all(8),
        ),
        InfoSummaryRow(
          leading: 'Cart Total',
          trailing: TextFormatter.toStringCurrency(
            totalWithTip,
            currencyCode: '',
          ),
          margin: const EdgeInsets.all(8),
        ),
      ],
    );
  }

  Widget discardTipButton(BuildContext context) {
    return Container(
      width: 32,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: IconButton(
        key: _discardTipButtonKey,
        icon: const DeleteIcon(),
        color: Theme.of(context).colorScheme.onBackground,
        onPressed: () async => _discardTip(
          context: context,
          popAfterDiscard: true,
          callDiscardMethod: true,
        ),
      ),
    );
  }

  bool noTipChosen(CheckoutTip? newTip, CheckoutTip? previousTip) {
    return newTip?.value == previousTip?.value &&
            newTip?.type == previousTip?.type ||
        newTip?.value == 0;
  }

  void _onPopInvoked({
    required BuildContext context,
    bool didPop = false,
  }) async {
    if (didPop) return;
    if (noTipChosen(_tip, widget.tip) || (_tip == widget.tip)) {
      Navigator.of(context).pop();
      return;
    }

    _discardTip(
      context: context,
      popAfterDiscard: true,
      callDiscardMethod: false,
    );
  }

  Future<void> _discardTip({
    required BuildContext context,
    required bool popAfterDiscard,
    required bool callDiscardMethod,
  }) async {
    final ModalService modalService = getIt<ModalService>();

    bool? discardSelectedTip = await modalService.showActionModal(
      context: context,
      title: 'Discard Tip',
      description:
          'Are you sure you want to remove the tip applied to your cart?',
      acceptText: 'Yes, Discard',
      cancelText: 'No, Cancel',
      status: StatusType.destructive,
    );

    if (discardSelectedTip != true) return;

    if (mounted) {
      setState(() {
        _tip = CheckoutTip(
          isNew: false,
          minValue: 0,
          maxValue: null,
          value: 0,
          type: null,
        );
      });
    }

    if (widget.onDiscardTip != null && callDiscardMethod) {
      if (mounted) {
        setState(() {
          widget.onDiscardTip!();
        });
      }
    }

    if (context.mounted && popAfterDiscard) {
      Navigator.of(context).pop();
    }
  }

  CheckoutTip _createTip(CheckoutTip? tip) => CheckoutTip(
    isNew: tip?.isNew ?? true,
    value: tip?.value ?? 0,
    type: tip?.type,
    maxValue: null,
    minValue: 0,
  );
}
