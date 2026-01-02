// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/chips/chip_selectable.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/view_models/product_discount_vm.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/widgets/product_discount_selector_page_list.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/numeric_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:littlefish_merchant/common/presentaion/components/labels/section_header.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/products/product_discount.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class ProductDiscountPage extends StatefulWidget {
  static const String route = '/productDiscounts/productDiscount';

  final bool isEmbedded;

  const ProductDiscountPage({Key? key, this.isEmbedded = false})
    : super(key: key);

  @override
  State<ProductDiscountPage> createState() => _ProductDiscountPageState();
}

class _ProductDiscountPageState extends State<ProductDiscountPage> {
  GlobalKey<FormState>? formKey;
  ProductDiscount? _discount;

  final List<FocusNode> _nodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    formKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductDiscountVM>(
      converter: (store) => ProductDiscountVM.fromStore(store)..key = formKey,
      builder: (ctx, vm) {
        _discount ??= ProductDiscount.copy(vm.currentDiscount!);
        return vm.isLoading!
            ? const AppProgressIndicator(hasScaffold: true)
            : KeyboardDismissalUtility(content: scaffold(context, vm));
      },
    );
  }

  scaffold(context, ProductDiscountVM vm) => AppSimpleAppScaffold(
    title: _discount!.isNew! ? 'New Discount' : _discount!.displayName,
    isEmbedded: widget.isEmbedded,
    actions: <Widget>[
      Visibility(
        visible: !vm.isLoading!,
        child: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(
              Icons.save,
              color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
            ),
            onPressed: () async {
              await vm.onAdd(_discount, ctx);
            },
          ),
        ),
      ),
    ],
    body: layout(context, vm),
  );

  layout(BuildContext context, ProductDiscountVM vm) => SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        form(context, vm),
        Visibility(
          visible: !(_discount!.isNew ?? false),
          child: DiscountProductsList(
            vm: vm,
            discount: ProductDiscount.copy(_discount),
            onProductsSelected: (selectedProducts, discount) async {
              List<StockProduct> newProducts = [];
              List<StockProduct> removedProducts = [];

              for (StockProduct selectedProduct in selectedProducts!) {
                if ((_discount!.products ?? []).indexWhere(
                      (element) => element.id == selectedProduct.id,
                    ) ==
                    -1) {
                  newProducts.add(selectedProduct);
                }
              }
              for (StockProduct existingProduct in _discount!.products ?? []) {
                if (selectedProducts.indexWhere(
                      (element) => element.id == existingProduct.id,
                    ) ==
                    -1) {
                  existingProduct.discountId = '';
                  removedProducts.add(existingProduct);
                }
              }
              //Updates discounts
              await vm.updatesProductDiscounts!(
                selectedProducts,
                newProducts,
                ChangeType.added,
                ProductDiscount.copy(discount),
              );
              for (var element in newProducts) {
                element.discountId = _discount!.id;
              }
              List<StockProduct> products = [
                ...(removedProducts),
                ...(newProducts),
              ];
              //Updates products
              await vm.setStockProducts!(products);
            },
          ),
        ),
      ],
    ),
  );

  form(BuildContext context, ProductDiscountVM vm) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Form(
      key: vm.key,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SectionHeader('Details'),
          StringFormField(
            useOutlineStyling: true,
            isRequired: true,
            hintText: '',
            labelText: 'Discount Name',
            hintStyle: context.appThemeTextFormHint,
            labelStyle: context.appThemeTextFormLabel,
            textStyle: context.appThemeTextFormText,
            key: const Key('discname'),
            focusNode: _nodes[0],
            nextFocusNode: _nodes[1],
            initialValue: _discount!.displayName,
            onSaveValue: (value) {
              _discount!.displayName = _discount!.name = value;
            },
            onFieldSubmitted: (value) {
              if (mounted) {
                setState(() {
                  _discount!.displayName = _discount!.name = value;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          StringFormField(
            useOutlineStyling: true,
            isRequired: true,
            minLines: 2,
            maxLines: 5,
            hintText: '',
            labelText: 'Discount Description',
            hintStyle: context.appThemeTextFormHint,
            labelStyle: context.appThemeTextFormLabel,
            textStyle: context.appThemeTextFormText,
            key: const Key('discdescription'),
            focusNode: _nodes[1],
            nextFocusNode: _discount!.type == DiscountType.fixedDiscountAmount
                ? _nodes[2]
                : _nodes[3],
            initialValue: _discount!.description,
            onSaveValue: (value) {
              _discount!.description = value;
            },
            onFieldSubmitted: (value) {
              if (mounted) {
                setState(() {
                  _discount!.description = value;
                });
              }
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 1,
                child: ChipSelectable(
                  onTap: (_) {
                    if (mounted) {
                      setState(() {
                        _discount!.type = DiscountType.fixedDiscountAmount;
                      });
                    }
                  },
                  selected: _discount!.type == DiscountType.fixedDiscountAmount,
                  text: 'Fixed Amount',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: ChipSelectable(
                  onTap: (_) {
                    if (mounted) {
                      setState(() {
                        _discount!.type = DiscountType.percentage;
                      });
                    }
                  },
                  selected: _discount!.type == DiscountType.percentage,
                  text: 'Percentage',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Visibility(
            visible: _discount!.type == DiscountType.fixedDiscountAmount,
            child: CurrencyFormField(
              enableCustomKeypad: true,
              showExtra: false,
              useOutlineStyling: true,
              hintText: 'Discount amount',
              key: const Key('discAmt'),
              labelText: 'Discount Amount',
              inputStyle: context.appThemeTextFormText,
              labelStyle: context.appThemeTextFormLabel,
              focusNode: _nodes[2],
              initialValue: _discount!.value,
              onSaveValue: (value) {
                if (mounted) {
                  setState(() {
                    _discount!.value = value;
                  });
                }
              },
              onFieldSubmitted: (value) {
                _discount!.value = value;
              },
              enabled: true,
              isRequired: true,
            ),
          ),
          Visibility(
            visible: _discount!.type == DiscountType.percentage,
            child: NumericFormField(
              useOutlineStyling: true,
              hintText: '5%?',
              key: const Key('discPerc'),
              focusNode: _nodes[3],
              labelText: 'Discount Percentage',
              initialValue: _discount!.value?.toInt(),
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
                if (mounted) {
                  setState(() {
                    _discount!.value = value.toDouble();
                  });
                }
              },
              onFieldSubmitted: (value) {
                _discount!.value = value.toDouble();
              },
              enabled: true,
              isRequired: true,
            ),
          ),
        ],
      ),
    ),
  );
}
