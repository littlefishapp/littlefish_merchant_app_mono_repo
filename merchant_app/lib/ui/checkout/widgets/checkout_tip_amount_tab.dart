// flutter imports
// removed ignore: depend_on_referenced_packages, implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/custom_keypad.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip_validator.dart';
import 'package:redux/src/store.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/decimal_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class CheckoutTipAmountTab extends StatefulWidget {
  final CheckoutTip tip;
  final double cartTotal;
  final Function(double?) onChanged;

  const CheckoutTipAmountTab({
    Key? key,
    required this.tip,
    required this.cartTotal,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CheckoutTipAmountTab> createState() => _CheckoutTipAmountTabState();
}

class _CheckoutTipAmountTabState extends State<CheckoutTipAmountTab> {
  final GlobalKey<FormState> _tipAmountFormKey = GlobalKey();
  late double tipAmount;
  final TextEditingController _customTipAmountController =
      TextEditingController();
  final List<FocusNode> _nodes = [FocusNode()];
  @override
  void initState() {
    _initializeTip(widget.tip);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CheckoutTipAmountTab oldWidget) {
    if (widget.tip != oldWidget.tip) _initializeTip(widget.tip);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CheckoutVM>(
      converter: (Store<AppState> store) {
        return CheckoutVM.fromStore(store);
      },
      builder: (BuildContext context, CheckoutVM vm) {
        return vm.isLoading == true
            ? const AppProgressIndicator()
            : CustomKeyPad(
                initialValue: tipAmount,
                title: 'TIP AMOUNT',
                heading: 'TIP AMOUNT',
                enableAppBar: false,
                enableDescription: false,
                showConfirmButton: false,
                onValueChanged: (amount) {
                  if (mounted) {
                    setState(() {
                      tipAmount = amount;
                      widget.onChanged(tipAmount);
                    });
                  }
                },
                isFullPage: true,
                onSubmit: (double value, String? description) {
                  if (mounted) {
                    setState(() {
                      tipAmount = value;
                      widget.onChanged(tipAmount);
                    });
                  }
                },
                onDescriptionChanged: (String description) {},
              );
      },
    );
  }

  Widget layout() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: tipAmountTextField(),
    );
  }

  Widget tipAmountTextField() {
    return Form(
      key: _tipAmountFormKey,
      child: DecimalFormField(
        focusNode: _nodes[0],
        enabled: true,
        hintText: 'Tip Amount',
        key: const Key('amount'),
        labelText: 'Amount',
        onSaveValue: (value) {
          if (mounted) {
            setState(() {
              tipAmount = value;
              widget.onChanged(tipAmount);
            });
          }
        },
        onChanged: (value) {
          if (mounted) {
            setState(() {
              tipAmount = value;
              widget.onChanged(tipAmount);
            });
          }
        },
        controller: _customTipAmountController,
        inputAction: TextInputAction.done,
        useOutlineStyling: true,
        onFieldSubmitted: (value) {
          if (mounted) {
            setState(() {
              tipAmount = value;
              widget.onChanged(tipAmount);
            });
          }
        },
      ),
    );
  }

  void _initializeTip(CheckoutTip tip) {
    if (mounted) {
      setState(() {
        tipAmount = CheckoutTipValidator.getTipAmount(
          widget.cartTotal,
          widget.tip,
        );
        _customTipAmountController.text = tipAmount != 0
            ? tipAmount.toString()
            : '';
      });
    }
  }
}
