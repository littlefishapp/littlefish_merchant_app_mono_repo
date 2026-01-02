// removed ignore: depend_on_referenced_packages, implementation_imports

// flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip_validator.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/tools/extensions/extensions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

// package imports
import 'package:redux/src/store.dart';

// project imports
import 'package:littlefish_merchant/common/presentaion/components/form_fields/decimal_form_field.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_tip.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/selectable_box_grid.dart';

class CheckoutTipPercentageTab extends StatefulWidget {
  final CheckoutTip tip;
  final double cartTotal;
  final Function(double?) onChanged;

  const CheckoutTipPercentageTab({
    Key? key,
    required this.tip,
    required this.onChanged,
    required this.cartTotal,
  }) : super(key: key);

  @override
  State<CheckoutTipPercentageTab> createState() =>
      _CheckoutTipPercentageTabState();
}

class _CheckoutTipPercentageTabState extends State<CheckoutTipPercentageTab> {
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
  void didUpdateWidget(covariant CheckoutTipPercentageTab oldWidget) {
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
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: percentageTabContent(context, vm),
              );
      },
    );
  }

  Widget percentageTabContent(BuildContext context, CheckoutVM vm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.only(top: 16),
            alignment: Alignment.center,
            child: keypadDisplay(context),
          ),
        ),
        Expanded(
          flex: 4,
          child: SizedBox(
            child: Column(
              children: [
                customPercentageFormField(context, vm),
                predefinedPercentages(context, vm),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget keypadDisplay(BuildContext context) {
    double tipAmount = CheckoutTipValidator.getTipAmount(
      widget.cartTotal,
      widget.tip,
    );
    var chargeText = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        context.labelXSmall('Tip Amount'.toUpperCase()),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              TextFormatter.toStringCurrency(
                tipAmount.truncateToDecimalPlaces(2),
              ),
              style: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
              ),
            ),
          ),
        ),
      ],
    );

    return chargeText;
  }

  customPercentageFormField(BuildContext context, CheckoutVM vm) {
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

  Widget predefinedPercentages(BuildContext context, CheckoutVM vm) {
    final isLargeDisplay = EnvironmentProvider.instance.isLargeDisplay ?? false;
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
      numColumns: isLargeDisplay ? 6 : 3,
      itemFormat: SelectableBoxItemFormat.percentageRemoveDecimalsIfZero,
      // if initiallySelectedItem not in list then none are selected
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
        if (isTipCustom(tip)) {
          _customTipPercentageController.text = _tipPercentage != 0
              ? _tipPercentage.toString()
              : '';
        }
      });
    }
  }

  bool isTipCustom(CheckoutTip tip) {
    if (tip.value == 0) return false;
    bool isTipPredefined = _predefinedPercentagesList.contains(tip.value);
    if (isTipPredefined == true || tip.type != TipType.percentage) return false;
    return true;
  }
}
