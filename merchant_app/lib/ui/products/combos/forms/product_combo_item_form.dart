// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_expansion_tile_widget.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/number_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';

class ProductComboItemForm extends StatefulWidget {
  final StockProduct? product;

  final ProductComboItem item;

  const ProductComboItemForm({
    Key? key,
    required this.product,
    required this.item,
  }) : super(key: key);

  @override
  State<ProductComboItemForm> createState() => _ProductComboItemFormState();
}

class _ProductComboItemFormState extends State<ProductComboItemForm> {
  late StockProduct? product;
  late ProductComboItem combo;
  GlobalKey<FormState>? formKey;

  @override
  void initState() {
    product = widget.product;
    combo = widget.item;
    formKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(
      isEmbedded: EnvironmentProvider.instance.isLargeDisplay,
      title: 'Combo Item',
      body: Column(
        children: <Widget>[
          SizedBox(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: ProductExpansionTile(item: product),
            ),
          ),
          const CommonDivider(width: 0.5),
          Expanded(child: comboItemForm(context)),
          SizedBox(child: buttonRow(context)),
        ],
      ),
    );
  }

  Form productDetails(context) => Form(
    child: ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        StringFormField(
          enforceMaxLength: true,
          enabled: false,
          maxLength: 255,
          hintText: 'Product Name',
          key: const Key('productName'),
          labelText: 'Product Name',
          inputAction: TextInputAction.next,
          initialValue: product!.displayName,
          onSaveValue: (value) {},
        ),
      ],
    ),
  );

  Form comboItemForm(context) => Form(
    key: formKey,
    child: ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: CurrencyFormField(
            hintText: 'Combo Selling Price',
            isRequired: true,
            key: const Key('sellingPrice'),
            labelText: 'Combo Selling Price',
            onFieldSubmitted: (value) {
              combo.comboPrice = value;
              FocusScope.of(context).requestFocus(FocusNode());
            },
            inputAction: TextInputAction.next,
            initialValue: combo.comboPrice ?? 0.0,
            onSaveValue: (value) {
              combo.comboPrice = value;
            },
          ),
        ),
        NumberFormField(
          enabled: true,
          hintText: 'How many do you have?',
          key: const Key('quantity'),
          labelText: '',
          onSaveValue: (value) {
            combo.quantity = (value).toDouble();
          },
          inputAction: TextInputAction.next,
          initialValue: combo.quantity!.toInt(),
          onFieldSubmitted: (value) {
            if (value != null) {
              combo.quantity = (value).toDouble();
            }
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ],
    ),
  );

  Container buttonRow(context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      children: <Widget>[
        Expanded(
          child: ButtonPrimary(
            buttonColor: Theme.of(context).colorScheme.secondary,
            text: 'cancel',
            onTap: (context) {
              Navigator.of(context).pop(null);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ButtonPrimary(
            buttonColor: Theme.of(context).colorScheme.primary,
            text: 'accept',
            onTap: (context) {
              if (formKey!.currentState!.validate()) {
                formKey!.currentState!.save();
                Navigator.of(context).pop(combo);
              }
            },
          ),
        ),
      ],
    ),
  );
}
