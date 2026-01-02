// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/decimal_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/number_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';

import '../../../app/theme/applied_system/applied_text_icon.dart';

class CheckoutItemQuantityCapturePage extends StatefulWidget {
  final double? initialValue;
  final bool asInt;
  final CheckoutCartItem item;
  final bool isFraction;

  const CheckoutItemQuantityCapturePage({
    Key? key,
    required this.item,
    this.initialValue = 1.0,
    this.asInt = false,
    this.isFraction = false,
  }) : super(key: key);

  @override
  CheckoutItemQuantityCapturePageState createState() =>
      CheckoutItemQuantityCapturePageState();
}

class CheckoutItemQuantityCapturePageState
    extends State<CheckoutItemQuantityCapturePage> {
  CheckoutCartItem? item;
  bool perUnit = true;
  double quantity = 1;
  GlobalKey<FormState>? formKey;
  // final List<FocusNode> _nodes = [
  //   FocusNode(),
  //   FocusNode(),
  //   FocusNode(),
  //   FocusNode(),
  //   FocusNode(),
  // ];

  @override
  void initState() {
    item = widget.item;
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  // AppScaffold(
  //       //isEmbedded: true,
  //       hasDrawer: false,
  //       elevation: 0.0,
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
            Text(
              item!.description!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 50),
          ],
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            if (widget.isFraction == false)
              CheckoutItemExpansionTile(item: item),

            if (widget.isFraction == true) priceField(context),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('- OR -', style: TextStyle(color: Colors.grey))],
            ),
            SizedBox(child: quantityField(context)),
            // CommonDivider(),
            productValues(context),
            // Expanded(child: Container()),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
              child: Row(
                children: [
                  cancelButton(context),
                  const SizedBox(width: 8),
                  acceptButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView productValues(BuildContext context) => ListView(
    shrinkWrap: true,
    children: <Widget>[
      if (widget.isFraction)
        productDetailTile(
          context,
          TextFormatter.toOneDecimalPlace(quantity),
          'Quantity',
          Icons.pregnant_woman,
        ),
      const CommonDivider(),
      productDetailTile(
        context,
        TextFormatter.toStringCurrency(item!.itemValue, currencyCode: ''),
        'Unit Price',
        Icons.pregnant_woman,
      ),
      const CommonDivider(),
      productDetailTile(
        context,
        TextFormatter.toStringCurrency(
          (item!.value ?? 0) * (quantity),
          currencyCode: '',
        ),
        'Total Price',
        Icons.pregnant_woman,
      ),
      const CommonDivider(),
    ],
  );

  ListTile productDetailTile(
    context,
    String title,
    String description,
    IconData icon,
  ) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    dense: true,
    title: DecoratedText(
      description,
      fontSize: null,
      textColor: Theme.of(context).colorScheme.secondary,
    ),
    trailing: Text(
      title,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  SwitchListTile priceToggle(context) => SwitchListTile(
    contentPadding: const EdgeInsets.only(left: 16, right: 4),
    dense: true,
    value: perUnit,
    onChanged: (val) {
      perUnit = val;
      if (mounted) setState(() {});
    },
    activeColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
    title: DecoratedText(
      'Per Unit',
      fontSize: null,
      textColor: Theme.of(context).extension<AppliedTextIcon>()?.primary,
    ),
  );

  Center quantityField(context) => Center(
    child: widget.asInt == false
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: DecimalFormField(
              enabled: true,
              hintText: 'How many do you have?',
              key: const Key('quantityFrac'),
              labelText: 'Quantity',
              onSaveValue: (value) {
                quantity = value;
              },
              inputAction: TextInputAction.done,
              initialValue: (quantity),
              onFieldSubmitted: (value) {
                quantity = value;
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          )
        : NumberFormField(
            enabled: true,
            hintText: 'How many do you have?',
            key: const Key('quantityUnit'),
            labelText: '',
            onSaveValue: (value) {
              quantity = value.toDouble();
            },
            inputAction: TextInputAction.done,
            initialValue: (widget.initialValue?.toInt() ?? 0),
            onFieldSubmitted: (value) {
              if (value != null) {
                quantity = value.toDouble();
              }
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
  );

  Container priceField(context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    child: CurrencyFormField(
      enabled: true,
      hintText: 'How much to spend',
      key: const Key('currenc'),
      labelText: 'Amount',
      onSaveValue: (value) {
        quantity = value / item!.itemValue!;
      },
      inputAction: widget.isFraction
          ? TextInputAction.next
          : TextInputAction.done,
      initialValue: (item!.value ?? 0) * (quantity),
      onFieldSubmitted: (value) {
        quantity = value / item!.itemValue!;
        // FocusScope.of(context).requestFocus(FocusNode());
      },
    ),
  );

  SizedBox acceptButton(context) => SizedBox(
    width: MediaQuery.of(context).size.width / 2 - 32,
    child: ButtonPrimary(
      disabled: !(quantity > 0),
      onTap: (context) {
        formKey?.currentState?.save();
        Navigator.of(context).pop(quantity);
      },
      text: 'accept',
      textColor: Colors.white,
      buttonColor: Theme.of(context).colorScheme.primary,
    ),
  );

  SizedBox cancelButton(context) => SizedBox(
    width: MediaQuery.of(context).size.width / 2 - 32,
    child: ButtonSecondary(
      onTap: (context) => Navigator.of(context).pop(),
      text: 'CANCEL',
    ),
  );
}

class CheckoutItemExpansionTile extends StatelessWidget {
  final CheckoutCartItem? item;

  const CheckoutItemExpansionTile({Key? key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return productDetails(context);
  }

  ExpansionTile productDetails(context) => ExpansionTile(
    title: Text(
      "${item!.description} - ${TextFormatter.toStringCurrency(item!.value, currencyCode: '')}",
    ),
    children: <Widget>[
      productDetailTile(
        context,
        item!.description!,
        'Product Name',
        Icons.pregnant_woman,
      ),
      const CommonDivider(),
      productDetailTile(
        context,
        TextFormatter.toStringCurrency(item!.value, currencyCode: ''),
        'Current Unit Cost',
        Icons.pregnant_woman,
      ),
      const CommonDivider(),
      productDetailTile(
        context,
        (item!.quantity).floor().toString(),
        'Cost Unit Count',
        Icons.pregnant_woman,
      ),
      const CommonDivider(),
    ],
  );

  ListTile productDetailTile(
    context,
    String title,
    String description,
    IconData icon,
  ) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    dense: true,
    title: DecoratedText(
      description,
      fontSize: null,
      textColor: Theme.of(context).colorScheme.secondary,
    ),
    trailing: Text(
      title,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        // fontWeight: FontWeight.bold,
      ),
    ),
  );
}
