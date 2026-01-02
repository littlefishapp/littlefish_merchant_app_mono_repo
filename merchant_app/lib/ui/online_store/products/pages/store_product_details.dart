import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../common/presentaion/components/form_fields/alphanumeric_form_field.dart';
import '../../../../common/presentaion/components/form_fields/currency_form_field.dart';
import '../../../../common/presentaion/components/form_fields/string_form_field.dart';

class StoreProductDetails extends StatefulWidget {
  final GlobalKey<FormState>? formKey;

  final StoreProduct? item;

  const StoreProductDetails({
    Key? key,
    required this.formKey,
    required this.item,
  }) : super(key: key);
  @override
  State<StoreProductDetails> createState() => _StoreProductDetailsState();
}

class _StoreProductDetailsState extends State<StoreProductDetails> {
  StoreProduct? item;
  final List<FocusNode> _nodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    item = widget.item;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: details(context));
  }

  Container details(BuildContext context) => Container(child: form(context));

  Form form(BuildContext context) {
    var formFields = <Widget>[
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: const Text(
          "Let's Start with the Basics",
          style: TextStyle(fontSize: 16),
        ),
      ),
      const SizedBox(height: 8),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: StringFormField(
          enforceMaxLength: true,
          maxLength: 255,
          hintText: 'Keloggs, Omo, Jik',
          maxLines: 3,
          key: const Key('productName'),
          focusNode: _nodes[0],
          nextFocusNode: _nodes[1],
          labelText: 'Product Name',
          onFieldSubmitted: (value) {
            item!.displayName = value;
          },
          onSaveValue: (value) {
            item!.displayName = value;
          },
          onChanged: (value) {
            item!.displayName = value;
          },
          inputAction: TextInputAction.next,
          initialValue: item!.displayName ?? '',
          isRequired: true,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: StringFormField(
          enforceMaxLength: true,
          maxLines: 5,
          maxLength: 255,
          hintText: 'Description',
          key: const Key('description'),
          labelText: 'Description',
          focusNode: _nodes[1],
          nextFocusNode: _nodes[2],
          onFieldSubmitted: (value) {
            item!.description = value;
          },
          onChanged: (value) {
            item!.description = value;
          },
          inputAction: TextInputAction.next,
          initialValue: item!.description,
          isRequired: false,
          onSaveValue: (value) {
            item!.description = value;
          },
        ),
      ),
      const SizedBox(height: 8),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: CurrencyFormField(
          hintText: 'Selling Price',
          isRequired: true,
          focusNode: _nodes[2],
          nextFocusNode: _nodes[3],
          key: const Key('sellingPrice'),
          labelText: 'Selling Price',
          // TODO(lampian): fix next
          // currencySymbol: LocaleProvider.instance.currencyCode!,
          onFieldSubmitted: (value) {
            item!.sellingPrice = value;
          },
          onSaveValue: (value) {
            item!.sellingPrice = value;
          },
          inputAction: TextInputAction.next,
          initialValue: item!.sellingPrice,
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: CurrencyFormField(
          hintText: 'Cost Price',
          isRequired: true,
          focusNode: _nodes[3],
          key: const Key('costPrice'),
          labelText: 'Cost Price',
          // TODO(lampian): fix next
          // currencySymbol: LocaleProvider.instance.currencyCode!,
          onFieldSubmitted: (value) {
            item!.costPrice = value;

            FocusScope.of(context).requestFocus(FocusNode());
          },
          onSaveValue: (value) {
            item!.costPrice = value;
          },
          inputAction: TextInputAction.done,
          initialValue: item!.costPrice,
        ),
      ),
      const SizedBox(height: 16),
      ExpansionTile(
        childrenPadding: const EdgeInsets.symmetric(horizontal: 0),
        title: const Text('Sale Information'),
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              top: 4,
              bottom: 4,
              right: 10,
            ),
            child: CheckboxListTile(
              contentPadding: const EdgeInsets.all(0),
              value: item!.onSale,
              title: const Text('On Sale'),
              onChanged: (bool? value) {
                if (mounted) {
                  setState(() {
                    item!.onSale = value;
                  });
                } else {
                  item!.onSale = value;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: CurrencyFormField(
              hintText: 'Compare Price',
              isRequired: false,
              key: const Key('compareAtPrice'),
              // TODO(lampian): fix next
              // currencySymbol: LocaleProvider.instance.currencyCode!,
              labelText: 'Compare Price',
              onFieldSubmitted: (value) {
                item!.compareAtPrice = value;

                FocusScope.of(context).requestFocus(FocusNode());
              },
              onSaveValue: (value) {
                item!.compareAtPrice = value;
              },
              inputAction: TextInputAction.done,
              initialValue: item!.compareAtPrice,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
      const SizedBox(height: 8),
      ExpansionTile(
        childrenPadding: const EdgeInsets.symmetric(horizontal: 0),
        title: const Text('Additional Info'),
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: StringFormField(
              hintText: 'Barcode Label',
              key: const Key('barcode'),
              labelText: 'Barcode Label',
              focusNode: _nodes[4],
              nextFocusNode: _nodes[5],
              onFieldSubmitted: (value) {
                item!.barcode = value;
              },
              onChanged: (value) {
                item!.barcode = value;
              },
              inputAction: TextInputAction.next,
              initialValue: item!.barcode,
              isRequired: false,
              onSaveValue: (value) {
                item!.barcode = value;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: AlphaNumericFormField(
              enforceMaxLength: true,
              maxLines: 5,
              maxLength: 255,
              suffixIcon: MdiIcons.codeArray,
              focusNode: _nodes[5],
              hintText: 'SKU',
              key: const Key('skuCode'),
              labelText: 'SKU',
              onChanged: (value) {
                item!.sku = value;
              },
              onSaveValue: (value) {
                item!.sku = value;
              },
              onFieldSubmitted: (value) {
                item!.sku = value;
                FocusScope.of(context).requestFocus(FocusNode());
              },
              inputAction: TextInputAction.done,
              initialValue: item!.sku,
              isRequired: false,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
    ];

    return Form(
      key: widget.formKey,
      child: ListView(children: formFields),
    );
  }
}
