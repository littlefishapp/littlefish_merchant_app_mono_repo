// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/models/suppliers/supplier_invoice.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/date_select_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/dropdown_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';

class InvoiceDetailsForm extends StatefulWidget {
  final SupplierInvoice? invoice;

  final GlobalKey? formKey;

  const InvoiceDetailsForm({Key? key, this.invoice, required this.formKey})
    : super(key: key);

  @override
  State<InvoiceDetailsForm> createState() => _InvoiceDetailsFormState();
}

class _InvoiceDetailsFormState extends State<InvoiceDetailsForm> {
  late BasicFormModel model;

  ScrollController? _controller;

  @override
  void initState() {
    model = BasicFormModel(widget.formKey as GlobalKey<FormState>?);
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return form(context);
  }

  Form form(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    var index = 0;

    if (widget.invoice!.supplier == null) {
      var suppliers = store.state.supplierState.suppliers;

      if (suppliers != null &&
          suppliers.any((s) => s!.id == widget.invoice!.supplierId)) {
        widget.invoice!.supplier = suppliers.firstWhere(
          (s) => s!.id == widget.invoice!.supplierId,
        );
      }
    }

    var formFields = <Widget>[
      Visibility(
        visible: widget.invoice!.isNew ?? false,
        child: DropdownFormField(
          hintText: 'Select a supplier',
          onSaveValue: (value) {
            widget.invoice!.supplierId = value?.value?.id;
            widget.invoice!.supplierName = value?.value?.displayName;
            widget.invoice!.supplier = value.value;
          },
          initialValue: widget.invoice?.supplier,
          onFieldSubmitted: (value) {
            widget.invoice!.supplierId = value?.value?.id;
            widget.invoice!.supplierName = value?.value?.displayName;
            widget.invoice!.supplier = value.value;
          },
          isRequired: true,
          values: store.state.supplierState.suppliers
              ?.map(
                (s) => DropDownValue(
                  displayValue: s!.displayName,
                  index: index++,
                  value: s,
                ),
              )
              .toList(),
          key: const Key('supplier'),
          labelText: 'Supplier',
        ),
      ),
      const SizedBox(height: 8),
      Visibility(
        visible: !widget.invoice!.isNew!,
        child: StringFormField(
          useOutlineStyling: true,
          enforceMaxLength: true,
          enabled: true,
          maxLength: 255,
          hintText: 'Supplier',
          // suffixIcon: Icons.person,
          key: const Key('supplier'),
          labelText: 'Supplier',
          focusNode: model.setFocusNode('supplier'),
          inputAction: TextInputAction.next,
          initialValue: widget.invoice!.supplierName,
          isRequired: false,
          onSaveValue: (value) {},
        ),
      ),
      const SizedBox(height: 8),
      StringFormField(
        useOutlineStyling: true,
        enforceMaxLength: true,
        maxLength: 255,
        hintText: 'INB550152155',
        enabled: widget.invoice!.isNew,
        // suffixIcon: Icons.person,
        key: const Key('reference'),
        labelText: 'Invoice Reference',
        focusNode: model.setFocusNode('reference'),
        nextFocusNode: model.setFocusNode('description'),
        onFieldSubmitted: (value) {
          widget.invoice!.reference = value;
        },
        inputAction: TextInputAction.next,
        initialValue: widget.invoice!.reference,
        isRequired: true,
        onSaveValue: (value) {
          widget.invoice!.reference = value;
        },
      ),
      const SizedBox(height: 8),
      DateSelectFormField(
        useOutlineStyling: true,
        hintText: 'When did you get the goods',
        key: const Key('invoiceDate'),
        labelText: 'Invoice Date',
        suffixIcon: Icons.calendar_today,
        lastDate: DateTime.now().toUtc().add(const Duration(days: 90)),
        firstDate: DateTime.now().toUtc().subtract(const Duration(days: 90)),
        initialValue: TextFormatter.toShortDate(
          dateTime: widget.invoice!.invoiceDate ?? DateTime.now().toUtc(),
        ),
        initialDate: widget.invoice!.invoiceDate ?? DateTime.now().toUtc(),
        isRequired: true,
        focusNode: model.setFocusNode('invoiceDate'),
        inputAction: TextInputAction.next,
        onSaveValue: (value) {
          widget.invoice!.invoiceDate = value;
          if (mounted) setState(() {});
        },
        onFieldSubmitted: (value) {
          widget.invoice!.invoiceDate = value;
          if (mounted) setState(() {});
        },
      ),
      const SizedBox(height: 8),
      DateSelectFormField(
        useOutlineStyling: true,
        hintText: 'When must you pay',
        key: const Key('duedate'),
        labelText: 'Due Date',
        suffixIcon: Icons.calendar_today,
        onSaveValue: (value) {
          widget.invoice!.dueDate = value;
          if (mounted) setState(() {});
        },
        onFieldSubmitted: (value) {
          widget.invoice!.dueDate = value;
          if (mounted) setState(() {});
        },
        initialValue: TextFormatter.toShortDate(
          dateTime:
              widget.invoice!.dueDate ??
              DateTime.now().toUtc().add(const Duration(days: 30)),
        ),
        lastDate: DateTime.now().toUtc().add(const Duration(days: 120)),
        firstDate: DateTime.now().toUtc().subtract(const Duration(days: 120)),
        initialDate:
            widget.invoice!.dueDate ??
            DateTime.now().toUtc().add(const Duration(days: 30)),
        isRequired: true,
        focusNode: model.setFocusNode('duedate'),
        inputAction: TextInputAction.next,
      ),
      const SizedBox(height: 8),
      SizedBox(
        height: 120,
        child: CurrencyFormField(
          // suffixIcon: Icons.person,
          hintText: 'How much does it cost?',
          key: const Key('invoiceAmount'),
          labelText: 'Amount',
          enabled: widget.invoice!.isNew,
          // controller: TextEditingController(text: widget.employee.lastName),
          focusNode: model.setFocusNode('invoiceAmount'),
          nextFocusNode: model.setFocusNode('taxAmount'),
          onFieldSubmitted: (value) {
            widget.invoice!.amount = value;
          },
          inputAction: TextInputAction.next,
          initialValue: widget.invoice!.amount,
          isRequired: true,
          onSaveValue: (value) {
            widget.invoice!.amount = value;
          },
        ),
      ),
      if (store.state.enableTax == true)
        CurrencyFormField(
          // suffixIcon: Icons.person,
          hintText: 'How much taxes?',
          key: const Key('taxAmount'),
          enabled: widget.invoice!.isNew,
          labelText: 'Tax Amount',
          // controller: TextEditingController(text: widget.employee.lastName),
          focusNode: model.setFocusNode('taxAmount'),
          onFieldSubmitted: (value) {
            widget.invoice!.taxAmount = value;
          },
          inputAction: TextInputAction.done,
          initialValue: widget.invoice!.taxAmount,
          isRequired: false,
          onSaveValue: (value) {
            widget.invoice!.taxAmount = value;
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
