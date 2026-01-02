// flutter imports
import 'package:flutter/material.dart';

// project imports
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/decimal_form_field.dart';

class TipAmountTab extends StatefulWidget {
  final CheckoutTip tip;
  final Function(double?) onChanged;

  const TipAmountTab({Key? key, required this.tip, required this.onChanged})
    : super(key: key);

  @override
  State<TipAmountTab> createState() => _TipAmountTabState();
}

class _TipAmountTabState extends State<TipAmountTab> {
  final GlobalKey<FormState> _tipAmountFormKey = GlobalKey();
  late double tipAmount;
  final TextEditingController _customTipAmountController =
      TextEditingController();

  @override
  void initState() {
    _initializeTip(widget.tip);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TipAmountTab oldWidget) {
    if (widget.tip != oldWidget.tip) _initializeTip(widget.tip);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: _layout(),
    );
  }

  Widget _layout() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: _tipAmountTextField(),
    );
  }

  Widget _tipAmountTextField() {
    return Form(
      key: _tipAmountFormKey,
      child: DecimalFormField(
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
        if (tip.type != TipType.fixedAmount) {
          tipAmount = 0;
          _customTipAmountController.text = '';
          return;
        }

        tipAmount = tip.value ?? 0;
        _customTipAmountController.text = tipAmount != 0
            ? tipAmount.toString()
            : '';
      });
    }
  }
}
