import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/expenses/business_expense.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/tools/parsers.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/dropdown_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

class ExpenseForm extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final BusinessExpense? item;
  final bool allowEdit;

  const ExpenseForm({
    Key? key,
    required this.formKey,
    required this.item,
    this.allowEdit = false,
  }) : super(key: key);

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  GlobalKey<FormState>? formKey;

  BusinessExpense? item;

  BasicFormModel? formModel;

  List<Widget> formFields = [];

  late List<SourceOfFunds> allPaymentMethods;

  late List<ExpenseType> expenseTypes;

  late ExpenseType? selectedExpendeType;

  late SourceOfFunds? selectedSourceOfFunds;

  @override
  void initState() {
    if (widget.item != null) item = widget.item;

    selectedExpendeType = null;
    selectedSourceOfFunds = null;

    allPaymentMethods =
        AppVariables.store!.state.appSettingsState.allowedExpenseSources;

    expenseTypes =
        AppVariables.store!.state.appSettingsState.allowedExpenseCategories;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.formKey != null) formKey = widget.formKey;
    if (widget.item != null) item = widget.item;
    formFields = [];
    return form(context);
  }

  Form form(BuildContext context) {
    formModel ??= BasicFormModel(formKey);

    if (formFields.isEmpty) {
      final allowEdit = widget.allowEdit || (item?.isNew ?? false);
      formFields = <Widget>[
        if (allowEdit)
          CurrencyFormField(
            useOutlineStyling: true,
            hintText: 'Amount',
            isRequired: true,
            enabled: true,
            key: const Key('amount'),
            labelText: 'Amount',
            enableCustomKeypad: false,
            showExtra: false,
            focusNode: formModel!.setFocusNode('amount'),
            nextFocusNode: formModel!.setFocusNode('costPrice'),
            onFieldSubmitted: (value) {
              item!.amount = value;
            },
            inputAction: TextInputAction.next,
            initialValue: item!.amount,
            onSaveValue: (value) {
              item!.amount = value;
            },
          )
        else
          StringFormField(
            useOutlineStyling: true,
            onSaveValue: (value) {},
            hintText: 'Value',
            labelText: 'Amount',
            enabled: false,
            isRequired: true,
            initialValue: TextFormatter.toStringCurrency(item!.amount ?? 0.0),
          ),
        if (allowEdit)
          DropdownFormField(
            useOutlineStyling: true,
            isRequired: true,
            enabled: true,
            hintText: 'What are you paying for?',
            labelText: 'Expense Type',
            key: const Key('expenseType'),
            values: getExpenseTypesDropDownValues(expenseTypes),
            initialValue: selectedExpendeType,
            onSaveValue: (value) {
              item!.expenseType = value.value;
              selectedExpendeType = value.value;
            },
            onFieldSubmitted: (value) {
              item!.expenseType = value.value;
              selectedExpendeType = value.value;
            },
          )
        else
          StringFormField(
            useOutlineStyling: true,
            hintText: 'What are you paying for?',
            key: const Key('expenseType'),
            initialValue: enumToString(item!.expenseType),
            isRequired: true,
            enabled: false,
            labelText: 'Expense Type',
            focusNode: formModel!.setFocusNode('expenseType'),
            onSaveValue: (String? value) {},
            onFieldSubmitted: (String value) {},
          ),
        if (allowEdit)
          DropdownFormField(
            isRequired: true,
            useOutlineStyling: true,
            enabled: true,
            hintText: 'How did you pay for it?',
            labelText: 'Payment Method',
            key: const Key('paymentMethod'),
            initialValue: selectedSourceOfFunds,
            values: getPaymentMethodsDropDownValues(allPaymentMethods),
            onSaveValue: (value) {
              item?.sourceOfFunds = value.value;
              selectedSourceOfFunds = value.value;
            },
            onFieldSubmitted: (value) {
              item?.sourceOfFunds = value.value;
              selectedSourceOfFunds = value.value;
            },
          )
        else
          StringFormField(
            useOutlineStyling: true,
            hintText: 'How did you pay for it?',
            key: const Key('paymentMethod'),
            initialValue: enumToString(item!.sourceOfFunds),
            isRequired: true,
            enabled: false,
            labelText: 'Payment Method',
            focusNode: formModel!.setFocusNode('paymentMethod'),
            onSaveValue: (String? value) {},
            onFieldSubmitted: (String value) {},
          ),
        Visibility(
          visible: item!.sourceOfFunds == SourceOfFunds.credit,
          child: StringFormField(
            useOutlineStyling: true,
            hintText: 'Who borrowed you money?',
            key: const Key('creditor'),
            isRequired: true,
            enabled: allowEdit,
            labelText: 'Creditor',
            focusNode: formModel!.setFocusNode('creditor'),
            onSaveValue: (String? value) {
              item!.creditorName = value;
            },
            onFieldSubmitted: (String value) {
              item!.creditorName = value;
            },
          ),
        ),
        StringFormField(
          useOutlineStyling: true,
          hintText: 'Who did you pay?',
          key: const Key('beneficiaryText'),
          isRequired: true,
          labelText: 'Beneficiary',
          enabled: allowEdit,
          initialValue: item!.beneficiary,
          focusNode: formModel!.setFocusNode('beneficiary'),
          onSaveValue: (String? value) {
            item!.beneficiary = value;
          },
          onFieldSubmitted: (String value) {
            item!.beneficiary = value;
          },
        ),
        StringFormField(
          useOutlineStyling: true,
          hintText: 'Electricity december, rent? etc.',
          key: const Key('description'),
          isRequired: true,
          enabled: allowEdit,
          labelText: 'Description',
          initialValue: item!.description,
          focusNode: formModel!.setFocusNode('description'),
          onSaveValue: (String? value) {
            item!.description = value;
          },
          onFieldSubmitted: (String value) {
            item!.description = value;
          },
        ),
        StringFormField(
          useOutlineStyling: true,
          hintText: 'invoice number, bill number, employee number?',
          key: const Key('reference'),
          initialValue: item!.reference,
          enabled: allowEdit,
          isRequired: true,
          labelText: 'Reference',
          focusNode: formModel!.setFocusNode('reference'),
          onSaveValue: (String? value) {
            item!.reference = value;
          },
          onFieldSubmitted: (String value) {
            item!.reference = value;
          },
        ),
      ];
    }

    return Form(
      key: formKey,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: formFields.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => formFields[index],
        separatorBuilder: (context, index) => const SizedBox(height: 8),
      ),
    );
  }

  List<DropDownValue> getPaymentMethodsDropDownValues(
    List<SourceOfFunds> paymentMethods,
  ) {
    List<DropDownValue> paymentMethodsDropDownValues = [];

    for (int i = 0; i < paymentMethods.length; i++) {
      paymentMethodsDropDownValues.add(
        DropDownValue(
          index: i,
          displayValue: getCapitalizedEnumName(paymentMethods[i]),
          value: paymentMethods[i],
        ),
      );
    }

    return paymentMethodsDropDownValues;
  }

  List<DropDownValue> getExpenseTypesDropDownValues(
    List<ExpenseType> expenseTypes,
  ) {
    List<DropDownValue> expenseTypesDropDownValues = [];

    for (int i = 0; i < expenseTypes.length; i++) {
      expenseTypesDropDownValues.add(
        DropDownValue(
          index: i,
          displayValue: getCapitalizedEnumName(expenseTypes[i]),
          value: expenseTypes[i],
        ),
      );
    }

    return expenseTypesDropDownValues;
  }

  String getCapitalizedEnumName(Enum enumValue) {
    String enumString = enumValue.toString().split('.').last;
    return enumString.toUpperCase();
  }
}
