// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/models/suppliers/supplier.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/mobile_number_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';

class SupplierDetailsForm extends StatefulWidget {
  final Supplier? supplier;

  final GlobalKey? formKey;

  const SupplierDetailsForm({Key? key, this.supplier, required this.formKey})
    : super(key: key);

  @override
  State<SupplierDetailsForm> createState() => _SupplierDetailsFormState();
}

class _SupplierDetailsFormState extends State<SupplierDetailsForm> {
  late BasicFormModel model;

  @override
  void initState() {
    model = BasicFormModel(widget.formKey as GlobalKey<FormState>?);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return form(context);
  }

  Form form(BuildContext context) {
    var formFields = <Widget>[
      const SizedBox(height: 16),
      StringFormField(
        useOutlineStyling: true,
        enforceMaxLength: true,
        maxLength: 255,
        hintText: 'Supplier Name',
        // suffixIcon: Icons.person,
        key: const Key('supplierName'),
        labelText: 'Supplier Name',
        focusNode: model.setFocusNode('supplierName'),
        nextFocusNode: model.setFocusNode('description'),
        onFieldSubmitted: (value) {
          widget.supplier!.name = widget.supplier!.displayName = value;
        },
        inputAction: TextInputAction.next,
        initialValue: widget.supplier!.displayName,
        isRequired: true,
        onSaveValue: (value) {
          widget.supplier!.name = widget.supplier!.displayName = value;
        },
      ),
      const SizedBox(height: 8),
      StringFormField(
        useOutlineStyling: true,
        enforceMaxLength: true,
        maxLength: 255,
        maxLines: 3,
        // suffixIcon: Icons.person,
        hintText: 'Describe your supplier',
        key: const Key('description'),
        labelText: 'Description',
        // controller: TextEditingController(text: widget.employee.lastName),
        focusNode: model.setFocusNode('description'),
        nextFocusNode: model.setFocusNode('telnumber'),
        onFieldSubmitted: (value) {
          widget.supplier!.description = value;
        },
        inputAction: TextInputAction.next,
        initialValue: widget.supplier!.description,
        isRequired: false,
        onSaveValue: (value) {
          widget.supplier!.description = value;
        },
      ),
      const SizedBox(height: 8),
      MobileNumberFormField(
        useOutlineStyling: true,
        hintText: 'Primary Telephone Number',
        key: const Key('mobilenumber'),
        labelText: 'Telephone Number',
        country: LocaleProvider.instance.currentLocale,
        focusNode: model.setFocusNode('telnumber'),
        nextFocusNode: model.setFocusNode('taxnumber'),
        initialValue: widget.supplier!.contactDetails!.value,
        onFieldSubmitted: (value) {
          setState(() {
            model.formKey!.currentState!.validate();
          });
          widget.supplier!.contactDetails!.value = value;
        },
        inputAction: TextInputAction.next,
        isRequired: true,
        onSaveValue: (value) {
          setState(() {
            model.formKey!.currentState!.validate();
          });
          widget.supplier!.contactDetails!.value = value;
        },
      ),
      const SizedBox(height: 8),
      StringFormField(
        useOutlineStyling: true,
        enforceMaxLength: true,
        maxLength: 50,
        maxLines: 1,
        // suffixIcon: Icons.person,
        hintText: 'Tax / Vat Number',
        key: const Key('taxnumber'),
        labelText: 'Tax Number',
        // controller: TextEditingController(text: widget.employee.lastName),
        focusNode: model.setFocusNode('taxnumber'),
        nextFocusNode: model.setFocusNode('website'),
        onFieldSubmitted: (value) {
          widget.supplier!.taxNumber = value;
        },
        inputAction: TextInputAction.next,
        initialValue: widget.supplier!.taxNumber,
        isRequired: false,
        onSaveValue: (value) {
          widget.supplier!.taxNumber = value;
        },
      ),
      const SizedBox(height: 8),
      StringFormField(
        useOutlineStyling: true,
        enforceMaxLength: true,
        maxLength: 50,
        suffixIcon: Icons.web,
        // controller: TextEditingController(text: widget.employee.email),
        hintText: 'www.amazingsupplier.com',
        key: const Key('website'),
        labelText: 'Website',
        focusNode: model.setFocusNode('website'),
        onFieldSubmitted: (value) {
          widget.supplier!.website = value;
        },
        inputAction: TextInputAction.next,
        initialValue: widget.supplier!.website,
        isRequired: false,
        onSaveValue: (value) {
          widget.supplier!.website = value;
        },
      ),
    ];

    return Form(
      key: model.formKey,
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: formFields,
        ),
      ),
    );
  }
}
