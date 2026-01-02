import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/email_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class ReceiptEmailContactForm extends StatefulWidget {
  final String? firstName;
  final String? email;
  final Function(String firstName, String contact) onSubmit;

  const ReceiptEmailContactForm({
    Key? key,
    required this.firstName,
    required this.email,
    required this.onSubmit,
  }) : super(key: key);
  @override
  State<ReceiptEmailContactForm> createState() =>
      _ReceiptEmailContactFormState();
}

class _ReceiptEmailContactFormState extends State<ReceiptEmailContactForm> {
  late String firstName;
  late String email;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    email = widget.email ?? '';
    firstName = widget.firstName ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 2),
          Center(
            child: context.headingXSmall(
              'Send Email',
              isSemiBold: true,
              color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
            ),
          ),
          const SizedBox(height: 8),
          context.paragraphMedium(
            'Please ask your customer for their email address and then enter it below.',
          ),
          const SizedBox(height: 8),
          StringFormField(
            useOutlineStyling: true,
            initialValue: firstName,
            hintText: 'John',
            key: const Key('firstname'),
            labelText: 'Customer Name',
            onSaveValue: (value) {
              if (value != null) {
                firstName = value;
              }
            },
            onChanged: (value) {
              firstName = value;
            },
            onFieldSubmitted: (value) {
              firstName = value;
            },
            isRequired: true,
          ),
          EmailFormField(
            useOutlineStyling: true,
            textColor: Theme.of(context).colorScheme.onBackground,
            iconColor: Theme.of(context).colorScheme.onBackground,
            hintColor: Theme.of(context).colorScheme.onBackground,
            initialValue: email,
            hintText: 'customer.email@gmail.com',
            key: const Key('contact'),
            labelText: 'Email Address',
            onSaveValue: (value) {
              if (value != null) {
                email = value;
              }
            },
            onFieldSubmitted: (value) {
              email = value;
            },
            onChanged: (value) {
              email = value;
            },
            isRequired: true,
          ),
          ButtonPrimary(
            text: 'Send',
            onTap: (ctx) async {
              if (!formKey.currentState!.validate()) return;
              formKey.currentState!.save();
              widget.onSubmit(firstName, email);
            },
          ),
        ],
      ),
    );
  }
}
