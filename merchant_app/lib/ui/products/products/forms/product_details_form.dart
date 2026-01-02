// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/ui/products/products/view_models/product_item_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/barcode_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/decimal_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/dropdown_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/numeric_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/yes_no_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

//
class ProductDetailsForm extends StatefulWidget {
  final Function? onSubmit;

  final ProductViewModelNew vm;

  const ProductDetailsForm({Key? key, this.onSubmit, required this.vm})
    : super(key: key);

  @override
  State<ProductDetailsForm> createState() => _ProductDetailsFormState();
}

class _ProductDetailsFormState extends State<ProductDetailsForm> {
  @override
  Widget build(BuildContext context) {
    return Container(child: form(context, widget.vm));
  }

  Form form(BuildContext context, ProductViewModelNew vm) {
    int categoryIndex = 0;

    var formFields = <Widget>[
      StringFormField(
        enforceMaxLength: true,
        maxLength: 255,
        hintText: 'Keloggs, Omo, Jik',
        maxLines: 3,
        // suffixIcon: FontAwesomeIcons.productHunt,
        key: const Key('productName'),
        labelText: 'Product Name',
        focusNode: vm.form!.setFocusNode('productName'),
        nextFocusNode: vm.form!.setFocusNode('description'),
        onFieldSubmitted: (value) {
          vm.item!.displayName = vm.item!.name = value;
        },
        inputAction: TextInputAction.next,
        initialValue: vm.item!.displayName ?? vm.item!.name,
        isRequired: true,
        onSaveValue: (value) {
          vm.item!.name = vm.item!.displayName = value;
        },
      ),
      CurrencyFormField(
        hintText: 'Selling Price',
        isRequired: false,
        key: const Key('sellingPrice'),
        labelText: 'Selling Price',
        focusNode: vm.form!.setFocusNode('sellingPrice'),
        onFieldSubmitted: (value) {
          vm.item!.regularPrice = value;
          FocusScope.of(context).requestFocus(FocusNode());
        },
        inputAction: TextInputAction.next,
        initialValue: vm.item!.regularPrice,
        onSaveValue: (value) {
          vm.item!.regularPrice = value;
        },
      ),
      CurrencyFormField(
        hintText: 'Cost Price',
        isRequired: true,
        key: const Key('costPrice'),
        labelText: 'Cost Price',
        focusNode: vm.form!.setFocusNode('costPrice'),
        nextFocusNode: vm.form!.setFocusNode('quantity'),
        onFieldSubmitted: (value) {
          vm.item!.regularCostPrice = value;
        },
        inputAction: TextInputAction.next,
        initialValue: vm.item!.regularCostPrice,
        onSaveValue: (value) {
          vm.item!.regularCostPrice = value;
        },
      ),
      //allow for the stock counts to be displayed for initial load
      Visibility(
        visible:
            vm.item!.unitType == StockUnitType.byFraction &&
            vm.item!.productType == ProductType.physical,
        child: DecimalFormField(
          // enabled: vm.isNew ?? false,
          hintText: 'How many do you have?',
          key: const Key('dStockCount'),
          labelText: 'Stock Count',
          onSaveValue: (value) {
            vm.item!.regularVariance!.quantity = value;
          },
          inputAction: TextInputAction.next,
          initialValue: vm.item!.regularVariance!.quantity,
          onFieldSubmitted: (value) {
            value < 0
                ? vm.item!.regularVariance!.quantity = 0
                : vm.item!.regularVariance!.quantity = value;
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
      Visibility(
        visible:
            vm.item!.unitType == StockUnitType.byUnit &&
            vm.item!.productType == ProductType.physical,
        child: NumericFormField(
          // enabled: vm.isNew ?? false,
          hintText: 'How many do you have?',
          key: const Key('quantity'),
          labelText: 'Stock Count',
          onSaveValue: (value) {
            value < 0
                ? vm.item!.regularVariance!.quantity = 0
                : vm.item!.regularVariance!.quantity = value.toDouble();
          },
          inputAction: TextInputAction.next,
          initialValue: vm.item!.regularVariance!.quantity?.floor(),
          onFieldSubmitted: (value) {
            value < 0
                ? vm.item!.regularVariance!.quantity = 0
                : vm.item!.regularVariance!.quantity = value.toDouble();
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
      DecimalFormField(
        // enabled: vm.isNew ?? false,
        hintText: 'What value counts as low stock for this item?',
        key: const Key('lowstock'),
        labelText: 'Low Stock Value',
        onSaveValue: (value) {
          vm.item!.regularVariance!.lowQuantityValue = value;
        },
        inputAction: TextInputAction.next,
        initialValue: vm.item!.regularVariance!.lowQuantityValue,
        onFieldSubmitted: (value) {
          vm.item!.regularVariance!.lowQuantityValue = value;
          FocusScope.of(context).requestFocus(FocusNode());
        },
      ),
      const SizedBox(height: 16),
      ExpansionTile(
        title: const Text('Details'),
        subtitle: const LongText('additional product settings'),
        children: <Widget>[
          StringFormField(
            enforceMaxLength: true,
            maxLines: 5,
            maxLength: 255,
            // suffixIcon: FontAwesomeIcons.productHunt,
            hintText: 'Describe your product',
            key: const Key('description'),
            labelText: 'Description',
            focusNode: vm.form!.setFocusNode('description'),
            nextFocusNode: vm.form!.setFocusNode('barcode'),
            onFieldSubmitted: (value) {
              vm.item!.description = value;
            },
            inputAction: TextInputAction.next,
            initialValue: vm.item!.description,
            isRequired: false,
            onSaveValue: (value) {
              vm.item!.description = value;
            },
          ),
          DropdownFormField(
            isRequired: true,
            hintText: 'Product or Service',
            key: const Key('productType'),
            focusNode: vm.form!.setFocusNode('productType'),
            initialValue: vm.item!.productType ?? ProductType.physical,
            labelText: 'Product Type',
            onSaveValue: (value) {
              vm.item!.productType = value.value;
              if (mounted) setState(() {});
            },
            onFieldSubmitted: (value) {
              vm.item!.productType = value.value;
              if (mounted) setState(() {});
            },
            values: <DropDownValue>[
              DropDownValue(
                index: 0,
                displayValue: 'Item - Something you sell',
                value: ProductType.physical,
              ),
              DropDownValue(
                index: 1,
                displayValue: 'Service - Something you do',
                value: ProductType.service,
              ),
            ],
          ),
          Visibility(
            visible:
                vm.state!.categories != null &&
                vm.state!.categories!.isNotEmpty,
            child: DropdownFormField(
              labelText: 'Category',
              hintText: 'Select a category',
              isRequired: false,
              key: const Key('category'),
              focusNode: vm.form!.setFocusNode('category'),
              onSaveValue: (value) {
                vm.item!.categoryId = value?.value;
              },
              onFieldSubmitted: (value) {
                vm.item!.categoryId = value?.value;
              },
              initialValue: vm
                  .item
                  ?.categoryId, //vm.state?.categories?.firstWhere((c) => c.id == vm.item?.categoryId, orElse: () => null),
              values: vm.state!.categories
                  ?.map(
                    (c) => DropDownValue(
                      displayValue: c.displayName,
                      index: categoryIndex += 1,
                      value: c.id,
                    ),
                  )
                  .toList(),
            ),
          ),
          Visibility(
            visible: vm.item!.productType == ProductType.physical,
            child: BarcodeFormField(
              hintText: 'Enter or Scan Barcode',
              key: const Key('barcode'),
              labelText: 'Item Barcode',
              focusNode: vm.form!.setFocusNode('barcode'),
              nextFocusNode: vm.form!.setFocusNode('sku'),
              onFieldSubmitted: (value) {
                vm.item!.regularBarCode = value;
              },
              inputAction: TextInputAction.next,
              initialValue: vm.item!.regularBarCode,
              isRequired: false,
              onSaveValue: (value) {
                vm.item!.regularBarCode = value;
              },
            ),
          ),
          Visibility(
            visible: vm.item!.productType == ProductType.physical,
            child: StringFormField(
              enforceMaxLength: true,
              maxLines: 5,
              maxLength: 255,
              suffixIcon: MdiIcons.codeArray,
              hintText: 'Product SKU',
              key: const Key('skuCode'),
              labelText: 'SKU',
              focusNode: vm.form!.setFocusNode('sku'),
              onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              initialValue: vm.item!.sku,
              isRequired: false,
              onSaveValue: (value) {
                vm.item!.sku = value;
              },
            ),
          ),
          Visibility(
            visible: vm.isStoreOnline,
            child: YesNoFormField(
              labelText: 'Is Product Online',
              initialValue: vm.item?.isOnline ?? false,
              onSaved: (value) {
                vm.item!.isOnline = value;
                if (mounted) setState(() {});
                // _rebuild();
              },
              description: 'Add product to your online store',
            ),
          ),
        ],
      ),
    ];

    if (vm.mode != CaptureMode.readOnly && widget.onSubmit != null) {
      formFields.add(
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            height: 45.0,
            child: ButtonPrimary(
              buttonColor: Theme.of(context).colorScheme.primary,
              text: 'save',
              onTap: (context) {
                if (vm.form!.key!.currentState!.validate()) {
                  vm.form!.key!.currentState!.save();

                  widget.onSubmit!();
                }
              },
            ),
          ),
        ),
      );
    }

    return Form(
      key: vm.form!.key,
      child: Column(children: formFields),
    );
  }
}
