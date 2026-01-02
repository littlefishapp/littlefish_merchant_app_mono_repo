import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';

import '../../../../common/presentaion/components/custom_keypad.dart';
import '../../../../common/presentaion/components/form_fields/mobile_number_form_field.dart';
import '../view_models/payment_links/viewmodels/payment_links_vm.dart';

class CreatePaymentLinkTab extends StatefulWidget {
  final PaymentLinksViewModel vm;
  final TextEditingController linkNameController;
  final TextEditingController descriptionController;
  final TextEditingController amountDueController;
  final TextEditingController customerFirstNameController;
  final TextEditingController customerLastNameController;
  final TextEditingController customerPhoneNumberController;
  final TextEditingController customerEmailController;

  const CreatePaymentLinkTab({
    super.key,
    required this.vm,
    required this.linkNameController,
    required this.descriptionController,
    required this.amountDueController,
    required this.customerFirstNameController,
    required this.customerLastNameController,
    required this.customerPhoneNumberController,
    required this.customerEmailController,
  });

  @override
  State<CreatePaymentLinkTab> createState() => _CreatePaymentLinkTabState();
}

class _CreatePaymentLinkTabState extends State<CreatePaymentLinkTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: context.labelSmall('Link Details', isBold: true),
                ),
                const SizedBox(height: 16),
                StringFormField(
                  key: const Key('link_name'),
                  controller: widget.linkNameController,
                  onSaveValue: (_) {},
                  hintText: 'Please enter the link name',
                  labelText: 'Link Name',
                  textCapitalization: TextCapitalization.words,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  useOutlineStyling: true,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    cashTender(widget.vm);
                  },
                  child: AbsorbPointer(
                    absorbing: true,
                    child: StringFormField(
                      controller: widget.amountDueController,
                      onSaveValue: (_) {},
                      hintText: 'R Please enter the amount due',
                      labelText: 'Amount Due',
                      textInputType: TextInputType.number,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      useOutlineStyling: true,
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                StringFormField(
                  key: const Key('description'),
                  controller: widget.descriptionController,
                  onSaveValue: (_) {},
                  hintText: 'Enter Link Description',
                  labelText: 'Description',
                  isRequired: false,
                  minLines: 4,
                  maxLines: 6,
                  maxLength: 500,
                  minLength: 1,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  useOutlineStyling: true,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: context.labelSmall('Customer Details', isBold: true),
                ),
                const SizedBox(height: 16),
                StringFormField(
                  key: const Key('first_name'),
                  controller: widget.customerFirstNameController,
                  onSaveValue: (e) {},
                  hintText: 'Add Customer\'s First Name',
                  labelText: 'First Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  isRequired: false,
                  useOutlineStyling: true,
                ),
                const SizedBox(height: 12),
                StringFormField(
                  key: const Key('lastname'),
                  controller: widget.customerLastNameController,
                  onSaveValue: (e) {},
                  hintText: 'Add Customer\'s Last Name',
                  labelText: 'Last Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  isRequired: false,
                  useOutlineStyling: true,
                ),
                const SizedBox(height: 12),
                MobileNumberFormField(
                  key: const Key('phone_number'),
                  controller: widget.customerPhoneNumberController,
                  labelText: 'Enter Customer Phone Number',
                  onSaveValue: (value) {},
                  hintText: 'Enter Customer Phone Number',
                  enabled: true,
                  useOutlineStyling: true,
                  isRequired: false,
                  autoValidate: false,
                ),
                const SizedBox(height: 12),
                StringFormField(
                  key: const Key('email_address'),
                  controller: widget.customerEmailController,
                  onSaveValue: (e) {},
                  hintText: 'Enter Customer Email Address',
                  labelText: 'Email Address',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  useOutlineStyling: true,
                  isRequired: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  cashTender(vm) async => showModalBottomSheet<double>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (ctx) => SizedBox(
      height: 480,
      child: CustomKeyPad(
        isLoading: vm.isLoading,
        enableAppBar: false,
        title: 'Amount',
        onValueChanged: (double amount) {},
        enableChange: true,
        minChargeAmount: 0,
        confirmButtonText: 'Confirm Amount',
        confirmErrorMessage:
            'Please enter the cash amount to be paid by the customer.',
        onDescriptionChanged: (String description) {},
        onSubmit: (double value, String? description) async {
          widget.amountDueController.text = value.toStringAsFixed(2);
          Navigator.of(ctx).pop();
        },
        initialValue: 0,
        parentContext: ctx,
      ),
    ),
  );
}
