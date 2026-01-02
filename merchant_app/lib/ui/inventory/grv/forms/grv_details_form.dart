// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_informational.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/goods_received_voucher.dart';
import 'package:littlefish_merchant/models/suppliers/supplier_invoice.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/invoicing/invoice_select_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/circle_gradient_avatar.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/date_select_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/app/custom_route.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class GRVDetailsForm extends StatefulWidget {
  final GoodsRecievedVoucher? item;

  final GlobalKey<FormState>? formKey;

  const GRVDetailsForm({Key? key, required this.item, required this.formKey})
    : super(key: key);

  @override
  State<GRVDetailsForm> createState() => _GRVDetailsFormState();
}

class _GRVDetailsFormState extends State<GRVDetailsForm> {
  late GoodsRecievedVoucher? item;
  late GlobalKey<FormState>? formKey;

  @override
  void initState() {
    item = widget.item;
    formKey = widget.formKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Expanded(child: layout(context)),
      const CommonDivider(),
      SizedBox(child: summaryRow(context)),
    ],
  );

  Form layout(context) => Form(
    key: formKey,
    child: ListView(
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        invoiceCard(context),
        const CommonDivider(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              StringFormField(
                useOutlineStyling: true,
                enabled: true,
                isRequired: true,
                hintText: '',
                key: const Key('suppliername'),
                labelText: 'Supplier Name',
                initialValue: item!.supplierName,
                onSaveValue: (value) {},
              ),
              const SizedBox(height: 8),
              StringFormField(
                useOutlineStyling: true,
                enabled: true,
                isRequired: true,
                hintText: '',
                key: const Key('invoice'),
                labelText: 'Invoice Reference',
                initialValue: item!.invoiceReference,
                onSaveValue: (value) {},
              ),
              const SizedBox(height: 8),
              StringFormField(
                useOutlineStyling: true,
                enabled: true,
                isRequired: false,
                hintText: '',
                suffixIcon: Icons.person,
                key: const Key('receivedBy'),
                labelText: 'Received By',
                initialValue: StoreProvider.of<AppState>(
                  context,
                ).state.userProfile!.displayName,
                onSaveValue: (value) {},
              ),
              // DateFormField(
              //   hintText: "When did you recieve the order",
              //   key: Key("daterec"),
              //   labelText: "Date Received",
              //   isRequired: true,
              //   inputAction: TextInputAction.done,
              //   onSaveValue: (value) {
              //     item.dateReceived = value;
              //   },
              //   onFieldSubmitted: (value) {
              //     item.dateReceived = value;
              //   },
              //   endDate: DateTime.now().toUtc().add(Duration(days: 14)),
              //   startDate: DateTime.now().toUtc().subtract(Duration(days: 14)),
              //   initialValue: DateTime.now().toUtc(),
              // ),
              const SizedBox(height: 8),
              DateSelectFormField(
                useOutlineStyling: true,
                lastDate: DateTime.now().toUtc(),
                firstDate: DateTime(2000),
                initialValue: TextFormatter.toShortDate(
                  dateTime: item!.dateReceived == null
                      ? DateTime.now().toUtc()
                      : item!.dateReceived!,
                ),
                hintText: 'When did you recieve the order',
                key: const Key('daterec'),
                labelText: 'Date Received',
                isRequired: true,
                inputAction: TextInputAction.done,
                onSaveValue: (value) {
                  item!.dateReceived = value;
                  if (mounted) setState(() {});
                },
                onFieldSubmitted: (value) {
                  if (mounted) {
                    setState(() {
                      item!.dateReceived = value;
                    });
                  }
                },
                suffixIcon: Icons.calendar_today,
                initialDate: item!.dateReceived ?? DateTime.now().toUtc(),
                enabled: item!.isNew ?? true,
              ),
              const SizedBox(height: 8),
              StringFormField(
                useOutlineStyling: true,
                isRequired: false,
                hintText: '',
                suffixIcon: Icons.person,
                inputAction: TextInputAction.done,
                key: const Key('deliveredBy'),
                labelText: 'Delivered By',
                initialValue: item!.deliveredBy,
                onSaveValue: (value) {
                  item!.deliveredBy = value;
                },
                onFieldSubmitted: (value) {
                  item!.deliveredBy = value;
                },
                onChanged: (value) {
                  item!.deliveredBy = value;
                },
                enabled: item!.isNew ?? true,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  ListTile invoiceCard(BuildContext context) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    onTap: () => (item!.isNew ?? true) ? selectInvoice(context) : null,
    leading: CircleAvatar(
      backgroundColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
      child: Icon(
        item!.invoiceId == null ? Icons.search : Icons.receipt,
        color: Colors.white,
      ),
    ),
    trailing: (item!.isNew ?? true)
        ? const Icon(Icons.search)
        : const Icon(Icons.check),
    title: Text(
      item!.invoiceId == null
          ? 'Select Invoice'
          : item!.invoiceReference ?? 'no reference',
    ),
    subtitle: item!.invoiceId == null
        ? const LongText('tap to select an invoice')
        : LongText("provided by ${item!.supplierName ?? "No supplier name"}"),
  );

  selectInvoice(BuildContext context) async {
    await Navigator.of(context)
        .push<SupplierInvoice>(
          CustomRoute(
            maintainState: true,
            builder: (BuildContext context) => const InvoiceSelectPage(),
          ),
        )
        .then((invoice) {
          if (invoice != null) {
            item!.loadInvoiceData(invoice);
          }
        });
  }

  SizedBox summaryRow(context) => SizedBox(
    height: 84,
    child: Row(
      children: <Widget>[
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: summaryUnitCost(context),
          ),
        ),
      ],
    ),
  );

  SizedBox summaryUnitCost(context) {
    bool isShort = (item!.invoiceAmount ?? 0.0) > (item!.receivablesValue);
    bool isMatch = (item!.invoiceAmount ?? 0.0) == (item!.receivablesValue);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LongText(
                    TextFormatter.toStringCurrency(
                      item!.invoiceAmount,
                      displayCurrency: false,
                      currencyCode: '',
                    ),
                    fontSize: 22.0,
                    textColor: Theme.of(
                      context,
                    ).extension<AppliedTextIcon>()?.primary,
                    alignment: TextAlign.center,
                  ),
                ],
              ),
              LongText(
                'Invoice Amount',
                fontSize: null,
                textColor: isShort
                    ? Theme.of(
                        context,
                      ).extension<AppliedInformational>()?.errorText
                    : Theme.of(
                        context,
                      ).extension<AppliedInformational>()?.successText,
                fontWeight: isShort ? FontWeight.bold : null,
                alignment: TextAlign.center,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: OutlineGradientAvatar(
                      radius: 16,
                      colors: isShort
                          ? [Theme.of(context).colorScheme.error, Colors.orange]
                          : [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                      child: Icon(
                        isShort
                            ? Icons.arrow_downward
                            : (isMatch ? Icons.check : Icons.arrow_upward),
                        color: isShort
                            ? Theme.of(
                                context,
                              ).extension<AppliedInformational>()?.errorText
                            : Theme.of(
                                context,
                              ).extension<AppliedInformational>()?.successText,
                      ),
                    ),
                  ),
                  LongText(
                    TextFormatter.toStringCurrency(
                      item!.receivablesValue,
                      displayCurrency: false,
                      currencyCode: '',
                    ),
                    fontSize: 22.0,
                    textColor: Theme.of(
                      context,
                    ).extension<AppliedTextIcon>()?.primary,
                    alignment: TextAlign.center,
                  ),
                ],
              ),
              LongText(
                isShort
                    ? "${TextFormatter.toStringCurrency(item!.invoiceAmount! - item!.receivablesValue, currencyCode: '')} short"
                    : 'total item value',
                fontSize: null,
                textColor: isShort
                    ? Theme.of(
                        context,
                      ).extension<AppliedInformational>()?.errorText
                    : Theme.of(
                        context,
                      ).extension<AppliedInformational>()?.successText,
                fontWeight: isShort ? FontWeight.bold : null,
                alignment: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
