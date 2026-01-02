// flutter imports
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_discount.dart';

// project imports
import 'package:littlefish_merchant/models/enums.dart' as enums;
import 'package:littlefish_merchant/common/presentaion/components/form_fields/decimal_form_field.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/selectable_box_grid.dart';

class OrderDiscountPercentageTab extends StatefulWidget {
  final OrderDiscount discount;
  final Function(double?) onChanged;

  const OrderDiscountPercentageTab({
    Key? key,
    required this.discount,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<OrderDiscountPercentageTab> createState() =>
      _OrderDiscountPercentageTabState();
}

class _OrderDiscountPercentageTabState
    extends State<OrderDiscountPercentageTab> {
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
  void didUpdateWidget(covariant OrderDiscountPercentageTab oldWidget) {
    if (widget.discount != oldWidget.discount) {
      _initializeDiscount(widget.discount);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: percentageTabContent(context),
    );
  }

  Widget percentageTabContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          customPercentageFormField(context),
          predefinedPercentages(context),
        ],
      ),
    );
  }

  Form customPercentageFormField(BuildContext context) {
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
              if (value >= 100) {
                _discountPercentage = 100;
                _customDiscountPercentageController.text = '100';
              }
              widget.onChanged(_discountPercentage);
              _customPercentageFocusNode.unfocus();
            });
          }
        },
        inputAction: TextInputAction.done,
        onFieldSubmitted: (value) {
          if (mounted) {
            setState(() {
              _discountPercentage = value;
              if (value >= 100) {
                _discountPercentage = 100;
                _customDiscountPercentageController.text = '100';
              }
              widget.onChanged(_discountPercentage);
              _customPercentageFocusNode.unfocus();
            });
          }
        },
        useOutlineStyling: true,
        isRequired: false,
      ),
    );
  }

  Widget predefinedPercentages(BuildContext context) {
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
      numColumns: 3,
      suffix: ' %',
      itemFormat: enums.SelectableBoxItemFormat.percentageRemoveDecimalsIfZero,
      initiallySelectedItem: _discountPercentage,
    );
  }

  void _initializeDiscount(OrderDiscount discount) {
    if (mounted) {
      setState(() {
        if (discount.type != DiscountValueType.percentage) {
          _discountPercentage = 0;
          _customDiscountPercentageController.text = '';
          return;
        }

        _discountPercentage = discount.value;
        if (isDiscountCustom(discount)) {
          _customDiscountPercentageController.text = _discountPercentage != 0
              ? _discountPercentage.toString()
              : '';
        }
      });
    }
  }

  bool isDiscountCustom(OrderDiscount discount) {
    if (discount.value == 0) return false;
    bool isDiscountPredefined = _predefinedPercentagesList.contains(
      discount.value,
    );
    if (isDiscountPredefined == true ||
        discount.type != DiscountValueType.percentage) {
      return false;
    }
    return true;
  }
}
