// flutter imports
import 'package:flutter/material.dart';

// project imports
import 'package:littlefish_merchant/common/presentaion/components/form_fields/decimal_form_field.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_discount.dart';

class OrderDiscountAmountTab extends StatefulWidget {
  final OrderDiscount discount;
  final double orderTotal;
  final Function(double?) onChanged;

  const OrderDiscountAmountTab({
    Key? key,
    required this.orderTotal,
    required this.discount,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<OrderDiscountAmountTab> createState() => _OrderDiscountAmountTabState();
}

class _OrderDiscountAmountTabState extends State<OrderDiscountAmountTab> {
  final GlobalKey<FormState> _discountAmountFormKey = GlobalKey();
  late double discountAmount;
  final TextEditingController _customDiscountAmountController =
      TextEditingController();

  @override
  void initState() {
    _initializeDiscount(widget.discount);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant OrderDiscountAmountTab oldWidget) {
    if (widget.discount != oldWidget.discount) {
      _initializeDiscount(widget.discount);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: layout(),
    );
  }

  Widget layout() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: discountAmountTextField(),
    );
  }

  Widget discountAmountTextField() {
    return Form(
      key: _discountAmountFormKey,
      child: DecimalFormField(
        enabled: true,
        hintText: 'Discount Amount',
        key: const Key('amount'),
        labelText: 'Amount',
        onSaveValue: (value) {
          if (mounted) {
            setState(() {
              discountAmount = value;
              if (value > widget.orderTotal) {
                discountAmount = widget.orderTotal;
                _customDiscountAmountController.text = widget.orderTotal
                    .toString();
              }
              widget.onChanged(discountAmount);
            });
          }
        },
        controller: _customDiscountAmountController,
        inputAction: TextInputAction.done,
        useOutlineStyling: true,
        onFieldSubmitted: (value) {
          if (mounted) {
            setState(() {
              discountAmount = value;
              if (value > widget.orderTotal) {
                discountAmount = widget.orderTotal;
                _customDiscountAmountController.text = widget.orderTotal
                    .toString();
              }
              widget.onChanged(discountAmount);
            });
          }
        },
      ),
    );
  }

  void _initializeDiscount(OrderDiscount discount) {
    if (mounted) {
      setState(() {
        if (discount.type != DiscountValueType.fixedAmount) {
          discountAmount = 0;
          _customDiscountAmountController.text = '';
          return;
        }

        discountAmount = discount.value;
        _customDiscountAmountController.text = discountAmount != 0
            ? discountAmount.toString()
            : '';
      });
    }
  }
}
