import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/chips/chip_selectable.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/products/discounts/view_models/discount_item_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/numeric_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class DiscountPage extends StatefulWidget {
  static const String route = '/discounts/discount';

  final bool isEmbedded;

  const DiscountPage({Key? key, this.isEmbedded = false}) : super(key: key);

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  GlobalKey<FormState>? formKey;

  final List<FocusNode> _nodes = [FocusNode(), FocusNode(), FocusNode()];

  @override
  void initState() {
    formKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DiscountVM>(
      converter: (store) => DiscountVM.fromStore(store)..key = formKey,
      builder: (ctx, vm) => scaffold(context, vm),
    );
  }

  Widget scaffold(context, DiscountVM vm) {
    final isLargeDisplay = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return AppScaffold(
      title: vm.isNew! ? 'New Discount' : vm.item!.displayName ?? '',
      enableProfileAction: !isLargeDisplay,
      displayBackNavigation: !isLargeDisplay,
      actions: <Widget>[
        Visibility(
          visible: !vm.isLoading!,
          child: Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => vm.onAdd(vm.item, ctx),
            ),
          ),
        ),
      ],
      body: vm.isLoading!
          ? const AppProgressIndicator()
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Form(
                key: vm.key,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: <Widget>[
                    const SizedBox(height: 24),
                    _discountTypes(vm),
                    const SizedBox(height: 16),
                    StringFormField(
                      useOutlineStyling: true,
                      isRequired: true,
                      hintText: "a name you'll remember",
                      labelText: 'Name',
                      key: const Key('discname'),
                      focusNode: _nodes[0],
                      // nextFocusNode: vm.item!.type == DiscountType.fixedAmount
                      //     ? _nodes[1]
                      //     : _nodes[2],
                      initialValue: vm.item!.displayName,
                      onSaveValue: (value) {
                        vm.item!.displayName = vm.item!.name = value;
                      },
                      onFieldSubmitted: (value) {
                        vm.item!.displayName = vm.item!.name = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: vm.item!.type == DiscountType.fixedAmount,
                      child: SizedBox(
                        height: 100,
                        child: CurrencyFormField(
                          hintText: 'Discount amount',
                          key: const Key('discAmt'),
                          labelText: 'Discount Amount',
                          // focusNode: _nodes[1],
                          initialValue: vm.item!.value,
                          onSaveValue: (value) {
                            vm.item!.value = value;
                          },
                          onFieldSubmitted: (value) {
                            vm.item!.value = value;
                          },
                          enabled: true,
                          isRequired: true,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: vm.item!.type == DiscountType.percentage,
                      child: NumericFormField(
                        useOutlineStyling: true,
                        hintText: '5%?',
                        key: const Key('discPerc'),
                        //focusNode: _nodes[2],
                        labelText: 'Discount Percentage',
                        initialValue: vm.item!.value?.toInt(),
                        validator: (value) {
                          if ((value ?? 0) > 100) {
                            return 'Amount cannot be greater than 100';
                          } else if ((value ?? 0) <= 0) {
                            return 'Amount must be greater than 0';
                          } else {
                            return null;
                          }
                        },
                        onSaveValue: (value) {
                          vm.item!.value = value.toDouble();
                        },
                        onFieldSubmitted: (value) {
                          vm.item!.value = value.toDouble();
                        },
                        enabled: true,
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _discountTypes(DiscountVM vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: ChipSelectable(
            text: 'Fixed Amount',
            selected: vm.item!.type == DiscountType.fixedAmount,
            onTap: (context) {
              if (mounted) {
                setState(() {
                  vm.item!.type = DiscountType.fixedAmount;
                });
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ChipSelectable(
            text: 'Fixed Amount',
            selected: vm.item!.type == DiscountType.percentage,
            onTap: (context) {
              if (mounted) {
                setState(() {
                  vm.item!.type = DiscountType.percentage;
                });
              }
            },
          ),
        ),

        // SizedBox(
        //   width: MediaQuery.of(context).size.width / 2.25,
        //   child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(4),
        //       ),
        //       backgroundColor: vm.item!.type == DiscountType.fixedAmount
        //           ? Theme.of(context).colorScheme.primary
        //           : Theme.of(context).colorScheme.primary.withOpacity(0.6),
        //       foregroundColor:
        //           Theme.of(context).buttonTheme.colorScheme?.onInverseSurface,
        //       elevation: vm.item!.type == DiscountType.fixedAmount ? 4 : 0,
        //     ),
        //     child: Text(
        //       'Percentage',
        //       style: TextStyle(
        //         color: vm.item!.type == DiscountType.fixedAmount
        //             ? Colors.white
        //             : null,
        //       ),
        //     ),
        //     onPressed: () {
        //       vm.item!.type = DiscountType.fixedAmount;
        //       if (mounted) setState(() {});
        //     },
        //   ),
        // ),
        // SizedBox(
        //   width: MediaQuery.of(context).size.width / 2.25,
        //   child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(4),
        //       ),
        //       backgroundColor: vm.item!.type == DiscountType.percentage
        //           ? Theme.of(context).colorScheme.primary
        //           : Theme.of(context).colorScheme.primary.withOpacity(0.6),
        //       foregroundColor:
        //           Theme.of(context).buttonTheme.colorScheme?.onInverseSurface,
        //       elevation: vm.item!.type == DiscountType.percentage ? 4 : 0,
        //     ),
        //     child: Text(
        //       'Percentage',
        //       style: TextStyle(
        //         color: vm.item!.type == DiscountType.percentage
        //             ? Colors.white
        //             : null,
        //       ),
        //     ),
        //     onPressed: () {
        //       vm.item!.type = DiscountType.percentage;
        //       if (mounted) setState(() {});
        //     },
        //   ),
        // ),
      ],
    );
  }
}
