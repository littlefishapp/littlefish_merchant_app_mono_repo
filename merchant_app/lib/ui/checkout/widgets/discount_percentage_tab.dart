// flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/tools/extensions/extensions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/checkout/helpers/discount_helper.dart';

// package imports
// removed ignore: depend_on_referenced_packages, implementation_imports
import 'package:redux/src/store.dart';

// project imports
import 'package:littlefish_merchant/models/enums.dart' as enums;
import 'package:littlefish_merchant/common/presentaion/components/form_fields/decimal_form_field.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/selectable_box_grid.dart';

class DiscountPercentageTab extends StatefulWidget {
  final CheckoutDiscount discount;
  final double cartTotal;
  final Function(double?) onChanged;

  const DiscountPercentageTab({
    Key? key,
    required this.discount,
    required this.onChanged,
    required this.cartTotal,
  }) : super(key: key);

  @override
  State<DiscountPercentageTab> createState() => _DiscountPercentageTabState();
}

class _DiscountPercentageTabState extends State<DiscountPercentageTab> {
  late List<double> _predefinedPercentagesList;
  late double _discountPercentage;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _customPercentageFocusNode = FocusNode();
  final TextEditingController _customDiscountPercentageController =
      TextEditingController();

  @override
  void initState() {
    _predefinedPercentagesList =
        AppVariables.store!.state.presetDiscountPercentages ?? [];
    _initializeDiscount(widget.discount);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DiscountPercentageTab oldWidget) {
    if (widget.discount != oldWidget.discount) {
      _initializeDiscount(widget.discount);
    }
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
    double discountAmount = CheckoutDiscountValidator.getDiscountAmount(
      widget.cartTotal,
      widget.discount,
    );
    var chargeText = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        context.labelXSmall('Discount Amount'.toUpperCase()),
        Text(
          TextFormatter.toStringCurrency(
            discountAmount.truncateToDecimalPlaces(2),
          ),
          style: TextStyle(
            fontSize: AppVariables.appDefaultlistItemSize,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
          ),
        ),
      ],
    );

    return chargeText;
  }

  Form customPercentageFormField(BuildContext context, CheckoutVM vm) {
    return Form(
      key: _formKey,
      child: DecimalFormField(
        enabled: true,
        hintText: 'Custom %',
        key: const Key('percentage'),
        labelText: 'Custom %',
        focusNode: _customPercentageFocusNode,
        controller: _customDiscountPercentageController,
        onSaveValue: (value) {
          if (mounted) {
            setState(() {
              _discountPercentage = value;
              widget.onChanged(value);
              _customPercentageFocusNode.unfocus();
            });
          }
        },
        inputAction: TextInputAction.done,
        onFieldSubmitted: (value) {
          if (mounted) {
            setState(() {
              _discountPercentage = value;
              widget.onChanged(value);
              _customPercentageFocusNode.unfocus();
            });
          }
        },
        onChanged: (double value) {
          if (mounted) {
            setState(() {
              _discountPercentage = value;
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
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return SelectableBoxGrid<double>(
      onTap: (selectedPercentage) {
        if (mounted) {
          setState(() {
            _discountPercentage = selectedPercentage ?? 0;
            widget.onChanged(_discountPercentage);
            _customDiscountPercentageController.text = '';
          });
        }
      },
      items: _predefinedPercentagesList,
      numColumns: isTablet ? 8 : 3,
      suffix: ' %',

      itemFormat: enums.SelectableBoxItemFormat.percentageRemoveDecimalsIfZero,
      // if initiallySelectedItem not in list then none are selected
      initiallySelectedItem: _discountPercentage,
    );
  }

  void _initializeDiscount(CheckoutDiscount discount) {
    if (mounted) {
      setState(() {
        if (discount.type != DiscountType.percentage) {
          _discountPercentage = 0;
          _customDiscountPercentageController.text = '';
          return;
        }

        _discountPercentage = discount.value ?? 0;
        if (isDiscountCustom(discount)) {
          _customDiscountPercentageController.text = _discountPercentage != 0
              ? _discountPercentage.toString()
              : '';
        }
      });
    }
  }

  bool isDiscountCustom(CheckoutDiscount discount) {
    if (discount.value == 0) return false;
    bool isDiscountPredefined = _predefinedPercentagesList.contains(
      discount.value,
    );
    if (isDiscountPredefined == true ||
        discount.type != DiscountType.percentage) {
      return false;
    }
    return true;
  }
}
