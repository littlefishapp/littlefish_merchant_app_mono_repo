// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/models/store/receipt_data.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/yes_no_form_field.dart';

import '../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../../common/presentaion/components/form_fields/string_form_field.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class BusinessReceiptForm extends StatefulWidget {
  final ReceiptData? receiptData;

  final GlobalKey? formKey;

  const BusinessReceiptForm({
    Key? key,
    required this.receiptData,
    required this.formKey,
  }) : super(key: key);

  @override
  State<BusinessReceiptForm> createState() => _BusinessReceiptFormState();
}

class _BusinessReceiptFormState extends State<BusinessReceiptForm> {
  final List<FocusNode> _nodes = [FocusNode(), FocusNode()];

  ReceiptData? _receiptData;

  @override
  Widget build(BuildContext context) {
    return form(context);
  }

  @override
  void initState() {
    _receiptData = widget.receiptData ?? ReceiptData();

    super.initState();
  }

  _rebuild() {
    if (mounted) setState(() {});
  }

  Widget form(BuildContext context) {
    final BasicFormModel formModel = BasicFormModel(
      widget.formKey as GlobalKey<FormState>?,
    );

    var formFields = <Widget>[
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: StringFormField(
          enforceMaxLength: true,
          maxLength: 255,
          maxLines: 3,
          hintText: 'Receipt Header',
          suffixIcon: Icons.receipt,
          key: const Key('receiptheader'),
          labelText: 'Receipt Header',
          focusNode: _nodes[0],
          nextFocusNode: _nodes[1],
          onFieldSubmitted: (value) {
            _receiptData!.header = value;
          },
          onChanged: (value) {
            _receiptData!.header = value;
          },
          inputAction: TextInputAction.next,
          initialValue: _receiptData!.header,
          isRequired: false,
          onSaveValue: (value) {
            _receiptData!.header = value;
          },
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: StringFormField(
          enforceMaxLength: false,
          maxLength: 255,
          maxLines: 3,
          hintText: 'Thanks please come again!',
          suffixIcon: Icons.receipt,
          key: const Key('receiptfooter'),
          labelText: 'Receipt Footer',
          focusNode: _nodes[1],
          onFieldSubmitted: (value) {
            _receiptData!.footer = value;
          },
          onChanged: (value) {
            _receiptData!.footer = value;
          },
          inputAction: TextInputAction.next,
          initialValue: _receiptData!.footer,
          isRequired: false,
          onSaveValue: (value) {
            _receiptData!.footer = value;
          },
        ),
      ),
      YesNoFormField(
        labelText: 'Print Customer Details',
        onSaved: (value) {
          if (value == null) return null;
          _receiptData!.displayCustomer = value;
          _rebuild();
        },
        initialValue: _receiptData!.displayCustomer,
      ),
      YesNoFormField(
        labelText: 'Print Cashier Details',
        onSaved: (value) {
          if (value == null) return null;
          _receiptData!.displaySeller = value;
          _rebuild();
        },
        initialValue: _receiptData!.displaySeller,
      ),
      YesNoFormField(
        labelText: 'Print Whatsapp Line',
        onSaved: (value) {
          if (value == null) return null;
          _receiptData!.displayWhatsappLine = value;
          _rebuild();
        },
        initialValue: _receiptData!.displayWhatsappLine,
      ),
      YesNoFormField(
        labelText: 'Print Instagram Handle',
        onSaved: (value) {
          if (value == null) return null;
          _receiptData!.displayInstagramHandle = value;
          _rebuild();
        },
        initialValue: _receiptData!.displayInstagramHandle,
      ),
      YesNoFormField(
        labelText: 'Print Address',
        onSaved: (value) {
          if (value == null) return null;
          _receiptData!.displayAddress = value;
          _rebuild();
        },
        initialValue: _receiptData!.displayAddress,
      ),
      YesNoFormField(
        labelText: 'Print Phone Number',
        onSaved: (value) {
          if (value == null) return null;
          _receiptData!.displayPhoneNumber = value;
          _rebuild();
        },
        initialValue: _receiptData!.displayPhoneNumber,
      ),
    ];

    return AppScaffold(
      title: 'Receipt Details',
      body: Form(
        key: formModel.formKey,
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: formFields,
          ),
        ),
      ),
      persistentFooterButtons: [
        SizedBox(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ButtonPrimary(
              onTap: (c) async {
                Navigator.pop(context, _receiptData);
              },
              text: 'Save',
              textColor: Colors.white,
              buttonColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
