import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/stock/goods_received_voucher.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/decimal_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/dropdown_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/yes_no_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class GRVItemPage extends StatefulWidget {
  final GoodsRecievedItem item;

  const GRVItemPage({Key? key, required this.item}) : super(key: key);

  @override
  GRVItemPageState createState() => GRVItemPageState();
}

class GRVItemPageState extends State<GRVItemPage> {
  late GoodsRecievedItem item;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController? _packQtyController;

  FocusNode quantitynode = FocusNode();

  FocusNode amountNode = FocusNode();

  @override
  void initState() {
    item = widget.item;
    _packQtyController = TextEditingController(
      text: (item.packQuantity ?? 1).toString(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _packQtyController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Item Receivable',
      // TODO(lampian): fix use of expanded -> Incorrect use of ParentDataWidget
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              children: [
                productDetails(context),
                const CommonDivider(),
                Expanded(
                  child: Container(
                    color: Colors.grey.shade50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: form(context),
                  ),
                ),
                const CommonDivider(),
                summaryRow(context),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
            child: (item.totalUnits) <= 0
                ? cancelButton(context)
                : acceptButton(context),
          ),
        ],
      ),
    );
  }

  Form form(context) {
    return Form(
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          YesNoFormField(
            labelText: 'Tax Included',
            onSaved: (value) {
              item.taxInclusive = value;

              if (value == true) {
                item.unitTax = 0;
              }

              if (mounted) setState(() {});
            },
            initialValue: item.taxInclusive ?? true,
          ),
          if (item.byUnit!)
            DropdownFormField(
              isRequired: true,
              hintText: 'Select a casing',
              key: const Key('packType'),
              labelText: 'Casing Type',
              initialValue: const ProductCasingTypeConverter().fromJson(
                (item.packUnitQuantity ?? 1).toInt(),
              ),
              onFieldSubmitted: (option) {
                //debugPrint(option.value.toString());
                item.byUnit = option.value == ProductCasingType.single;
                if (!item.byUnit!) {
                  item.packUnitQuantity = option.value.index * 6.0;
                  _packQtyController!.text = item.packUnitQuantity.toString();
                } else {
                  item.packUnitQuantity = 1.0;
                }

                //debugPrint(item.packUnitQuantity);
                if (mounted) setState(() {});
              },
              onSaveValue: (option) {
                //debugPrint(option.value.toString());
                item.byUnit = option.value == ProductCasingType.single;
                if (!item.byUnit!) {
                  item.packUnitQuantity = option.value.index * 6.0;
                  _packQtyController!.text = item.packUnitQuantity.toString();
                } else {
                  item.packUnitQuantity = 1.0;
                }

                //debugPrint(item.packUnitQuantity);
                if (mounted) setState(() {});
              },
              values: <DropDownValue>[
                DropDownValue(
                  displayValue: 'Single Unit',
                  index: 0,
                  value: ProductCasingType.single,
                ),
                DropDownValue(
                  displayValue: 'Half Dozen',
                  index: 1,
                  value: ProductCasingType.sixPack,
                ),
                DropDownValue(
                  displayValue: 'Dozen',
                  index: 2,
                  value: ProductCasingType.twelvePack,
                ),
                DropDownValue(
                  displayValue: 'One + Half Dozen',
                  index: 3,
                  value: ProductCasingType.eighteenPack,
                ),
                DropDownValue(
                  displayValue: 'Two Dozen',
                  index: 4,
                  value: ProductCasingType.twentyFourPack,
                ),
              ],
            ),
          SizedBox(
            height: 100,
            child: DecimalFormField(
              isRequired: true,
              hintText: 'How many packs did you receive?',
              key: const Key('packcount'),
              labelText: 'Pack Quantity',
              focusNode: quantitynode,
              nextFocusNode: amountNode,
              onSaveValue: (value) {
                item.packQuantity = value;
                if (mounted) setState(() {});
              },
              onFieldSubmitted: (value) {
                item.packQuantity = value;
                if (mounted) setState(() {});
              },
              inputAction: TextInputAction.next,
              initialValue: item.packQuantity ?? 0.0,
            ),
          ),
          SizedBox(
            height: 100,
            child: CurrencyFormField(
              focusNode: amountNode,
              hintText: 'How much per packaged unit',
              key: const Key('packCost'),
              labelText: 'Cost',
              onSaveValue: (double value) {
                item.packCost = value;
              },
              onFieldSubmitted: (value) {
                item.packCost = value;
              },
              initialValue: item.packCost,
              isRequired: true,
            ),
          ),
          Visibility(
            visible: !item.taxInclusive!,
            child: CurrencyFormField(
              hintText: 'How much tax has been applied per unit?',
              key: const Key('taxAmount'),
              labelText: 'Tax Amount',
              onSaveValue: (double value) {
                item.packTax = value;
              },
              onFieldSubmitted: (value) {
                item.packTax = value;
              },
              initialValue: item.packTax,
            ),
          ),
        ],
      ),
    );
  }

  SizedBox summaryRow(context) => SizedBox(
    height: 84,
    child: Row(
      children: <Widget>[
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: summaryTotalUnits(context),
          ),
        ),
        const VerticalDivider(width: 0.5),
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: summaryUnitCost(context),
          ),
        ),
      ],
    ),
  );

  SizedBox summaryTotalUnits(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          LongText(
            '${item.totalUnits}',
            fontSize: 36.0,
            textColor: Theme.of(context).colorScheme.primary,
            alignment: TextAlign.center,
          ),
          const LongText('total units', fontSize: null),
        ],
      ),
    );
  }

  SizedBox summaryUnitCost(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          LongText(
            TextFormatter.toStringCurrency(
              item.unitCost,
              displayCurrency: false,
              currencyCode: '',
            ),
            fontSize: 36.0,
            textColor: (item.unitCost) > (item.currentUnitCost ?? 0.0)
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
            alignment: TextAlign.center,
          ),
          const LongText('unit cost', fontSize: null),
        ],
      ),
    );
  }

  ExpansionTile productDetails(context) => ExpansionTile(
    title: Text(
      "${item.productName} - ${TextFormatter.toStringCurrency(item.currentUnitCost, currencyCode: '')}",
    ),
    children: <Widget>[
      productDetailTile(
        context,
        item.productName!,
        'Product Name',
        Icons.pregnant_woman,
      ),
      const CommonDivider(),
      productDetailTile(
        context,
        item.variantName!,
        'Variant',
        Icons.pregnant_woman,
      ),
      const CommonDivider(),
      productDetailTile(
        context,
        TextFormatter.toStringCurrency(item.currentUnitCost, currencyCode: ''),
        'Current Unit Cost',
        Icons.pregnant_woman,
      ),
      const CommonDivider(),
      productDetailTile(
        context,
        (item.currentUnitCount ?? 0).floor().toString(),
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

  ButtonPrimary acceptButton(context) => ButtonPrimary(
    onTap: (context) {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        if (item.packUnitQuantity == null && item.byUnit!) {
          item.packQuantity = 1.0;
        }

        Navigator.of(context).pop(item);
      }
    },
    text: 'accept',
    textColor: Colors.white,
    buttonColor: Theme.of(context).colorScheme.primary,
  );

  ButtonSecondary cancelButton(context) => ButtonSecondary(
    onTap: (context) => Navigator.of(context).pop(),
    text: 'CANCEL',
  );
}
