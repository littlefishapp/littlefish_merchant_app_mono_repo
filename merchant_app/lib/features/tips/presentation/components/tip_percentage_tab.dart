// flutter imports
import 'package:flutter/material.dart';

// package imports

// project imports
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/decimal_form_field.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/selectable_box_grid.dart';

class TipPercentageTab extends StatefulWidget {
  final CheckoutTip tip;
  final Function(double?) onChanged;

  const TipPercentageTab({Key? key, required this.tip, required this.onChanged})
    : super(key: key);

  @override
  State<TipPercentageTab> createState() => _TipPercentageTabState();
}

class _TipPercentageTabState extends State<TipPercentageTab> {
  late List<double> _predefinedPercentagesList;
  late double _tipPercentage;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _customPercentageFocusNode = FocusNode();
  final TextEditingController _customTipPercentageController =
      TextEditingController();

  @override
  void initState() {
    _predefinedPercentagesList =
        AppVariables.store!.state.presetCheckoutTipPercentages ?? [];
    _initializeTip(widget.tip);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TipPercentageTab oldWidget) {
    if (widget.tip != oldWidget.tip) _initializeTip(widget.tip);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: _layout(context),
    );
  }

  Widget _layout(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _customPercentageFormField(context),
          _predefinedPercentages(context),
        ],
      ),
    );
  }

  _customPercentageFormField(BuildContext context) {
    return Form(
      key: _formKey,
      child: DecimalFormField(
        enabled: true,
        hintText: 'Custom %',
        key: const Key('percentage'),
        labelText: 'Custom %',
        focusNode: _customPercentageFocusNode,
        controller: _customTipPercentageController,
        onSaveValue: (value) {
          if (mounted) {
            setState(() {
              _tipPercentage = value;
              widget.onChanged(value);
              _customPercentageFocusNode.unfocus();
            });
          }
        },
        inputAction: TextInputAction.done,
        onFieldSubmitted: (value) {
          if (mounted) {
            setState(() {
              _tipPercentage = value;
              widget.onChanged(value);
              _customPercentageFocusNode.unfocus();
            });
          }
        },
        onChanged: (double value) {
          if (mounted) {
            setState(() {
              _tipPercentage = value;
              widget.onChanged(value);
            });
          }
        },
        useOutlineStyling: true,
        isRequired: false,
      ),
    );
  }

  Widget _predefinedPercentages(BuildContext context) {
    return SelectableBoxGrid<double>(
      onTap: (selectedPercentage) {
        if (mounted) {
          setState(() {
            _tipPercentage = selectedPercentage ?? 0;
            widget.onChanged(_tipPercentage);
            _customTipPercentageController.text = '';
          });
        }
      },
      items: _predefinedPercentagesList,
      numColumns: 3,
      itemFormat: SelectableBoxItemFormat.percentageRemoveDecimalsIfZero,
      initiallySelectedItem: _tipPercentage,
    );
  }

  void _initializeTip(CheckoutTip tip) {
    if (mounted) {
      setState(() {
        if (tip.type != TipType.percentage) {
          _tipPercentage = 0;
          _customTipPercentageController.text = '';
          return;
        }

        _tipPercentage = tip.value?.toDouble() ?? 0;
        if (_isTipCustom(tip)) {
          _customTipPercentageController.text = _tipPercentage != 0
              ? _tipPercentage.toString()
              : '';
        }
      });
    }
  }

  bool _isTipCustom(CheckoutTip tip) {
    if (tip.value == 0) return false;
    bool isTipPredefined = _predefinedPercentagesList.contains(tip.value);
    if (isTipPredefined == true || tip.type != TipType.percentage) return false;
    return true;
  }
}
