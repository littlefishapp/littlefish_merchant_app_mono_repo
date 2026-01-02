// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/barcode_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';

class ProductShrinkagePage extends StatelessWidget {
  final ProductShrinkage shrinkage;

  const ProductShrinkagePage({Key? key, required this.shrinkage})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(
      isEmbedded: true,
      title: 'Shrinkage',
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                shrinkageTile(context, shrinkage.sixPackShrinkage!),
                const CommonDivider(),
                shrinkageTile(context, shrinkage.twelvePackShrinkage!),
                const CommonDivider(),
                shrinkageTile(context, shrinkage.eighteenPackShrinkage!),
                const CommonDivider(),
                shrinkageTile(context, shrinkage.caseShrinkage!),
              ],
            ),
          ),
          ButtonPrimary(
            text: 'accept',
            onTap: (c) => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  ExpansionTile shrinkageTile(
    context,
    StockProductCasing casing,
  ) => ExpansionTile(
    title: Text(
      "${casing.toString()} - ${TextFormatter.toStringCurrency(casing.amount, currencyCode: '')}",
    ),
    children: <Widget>[
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: BarcodeFormField(
          hintText: 'Barcode',
          key: const Key('barcode'),
          labelText: 'Barcode',
          onSaveValue: (value) {
            casing.barcode = value;
          },
          onFieldSubmitted: (value) {
            casing.barcode = value;
          },
          enabled: true,
          initialValue: casing.barcode,
          inputAction: TextInputAction.done,
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: CurrencyFormField(
          hintText: 'How much are you selling it for?',
          key: const Key('casingPrice'),
          labelText: 'Casing Price',
          onSaveValue: (value) {
            casing.amount = value;
          },
          onFieldSubmitted: (value) {
            casing.amount = value;
          },
          enabled: true,
          initialValue: casing.amount,
          inputAction: TextInputAction.done,
        ),
      ),
    ],
  );
}
