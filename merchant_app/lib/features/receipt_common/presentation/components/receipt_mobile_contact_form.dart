import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/mobile_number_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class ReceiptMobileContactForm extends StatefulWidget {
  final String? firstName;
  final String? mobileNumber;
  final Function(String firstName, String contact) onSubmit;

  const ReceiptMobileContactForm({
    Key? key,
    required this.firstName,
    required this.mobileNumber,
    required this.onSubmit,
  }) : super(key: key);
  @override
  State<ReceiptMobileContactForm> createState() =>
      _ReceiptMobileContactFormState();
}

class _ReceiptMobileContactFormState extends State<ReceiptMobileContactForm> {
  late String firstName;
  late String mobileNumber;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    mobileNumber = widget.mobileNumber ?? '';
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
          Center(
            child: context.headingXSmall(
              'Send SMS',
              isSemiBold: true,
              color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
            ),
          ),
          const SizedBox(height: 8),
          context.paragraphMedium(
            'Please ask your customer for their mobile number and then enter it below.',
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
          MobileNumberFormField(
            useOutlineStyling: true,
            initialValue: mobileNumber,
            hintText: '82555555',
            key: const Key('mobile'),
            labelText: 'Mobile Number',
            country: CountryStub(
              countryCode: LocaleProvider.instance.currentLocale!.countryCode,
              diallingCode: LocaleProvider.instance.currentLocale!.diallingCode,
            ),
            onSaveValue: (value) {
              if (value != null) {
                mobileNumber = value;
              }
            },
            onFieldSubmitted: (value) {
              if (value != null) {
                mobileNumber = value;
              }
            },
            onChanged: (value) {
              mobileNumber = value;
            },
            isRequired: true,
          ),
          ButtonPrimary(
            text: 'Send',
            onTap: (ctx) {
              if (!formKey.currentState!.validate()) return;
              formKey.currentState!.save();
              widget.onSubmit(firstName, mobileNumber);
            },
          ),
        ],
      ),
    );
  }
}
