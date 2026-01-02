// flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/custom_keypad.dart';
import 'package:littlefish_merchant/ui/checkout/helpers/discount_helper.dart';

// package imports
// removed ignore: depend_on_referenced_packages, implementation_imports
import 'package:redux/src/store.dart';

// project imports
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/decimal_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class DiscountAmountTab extends StatefulWidget {
  final CheckoutDiscount discount;
  final double cartTotal;
  final Function(double?) onChanged;

  const DiscountAmountTab({
    Key? key,
    required this.discount,
    required this.onChanged,
    required this.cartTotal,
  }) : super(key: key);

  @override
  State<DiscountAmountTab> createState() => _DiscountAmountTabState();
}

class _DiscountAmountTabState extends State<DiscountAmountTab> {
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
  void didUpdateWidget(covariant DiscountAmountTab oldWidget) {
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
            : CustomKeyPad(
                initialValue: discountAmount,
                heading: 'DISCOUNT AMOUNT',
                enableAppBar: false,
                enableDescription: false,
                showConfirmButton: false,
                onValueChanged: (amount) {
                  if (mounted) {
                    setState(() {
                      discountAmount = amount;
                      widget.onChanged(discountAmount);
                    });
                  }
                },
                isFullPage: true,
                onSubmit: (double value, String? description) {
                  if (mounted) {
                    setState(() {
                      discountAmount = value;
                      widget.onChanged(discountAmount);
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
              widget.onChanged(discountAmount);
            });
          }
        },
        onChanged: (value) {
          if (mounted) {
            setState(() {
              discountAmount = value;
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
              widget.onChanged(discountAmount);
            });
          }
        },
      ),
    );
  }

  void _initializeDiscount(CheckoutDiscount discount) {
    if (mounted) {
      setState(() {
        discountAmount = CheckoutDiscountValidator.getDiscountAmount(
          widget.cartTotal ?? 0,
          discount,
        );
        _customDiscountAmountController.text = discountAmount != 0
            ? discountAmount.toString()
            : '';
      });
    }
  }
}
