// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_core/business/models/business_user.dart';

// Project imports:

import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/email_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/mobile_number_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';

class UserDetailsForm extends StatefulWidget {
  const UserDetailsForm({
    Key? key,
    required this.onSubmit,
    required this.user,
    required this.formKey,
  }) : super(key: key);

  final Function(BusinessUser employee) onSubmit;

  final BusinessUser? user;

  final GlobalKey<FormState>? formKey;

  @override
  State<UserDetailsForm> createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  BasicFormModel? model;

  @override
  Widget build(BuildContext context) {
    return form(context);
  }

  Form form(BuildContext context) {
    model ??= BasicFormModel(widget.formKey);

    bool isNew = !(widget.user!.uid == null || widget.user!.uid!.isEmpty);

    var formFields = <Widget>[
      avatar(context),
      StringFormField(
        enforceMaxLength: true,
        // enabled: !isNew,
        maxLength: 50,
        hintText: 'Enter First Name',
        suffixIcon: Icons.person,
        // controller: TextEditingController(text: widget.employee.firstName),
        key: const Key('firstname'),
        labelText: 'Name',
        focusNode: model!.setFocusNode('firstname'),
        nextFocusNode: model!.setFocusNode('lastname'),
        onFieldSubmitted: (value) {
          widget.user!.firstName = value;
        },
        inputAction: TextInputAction.next,
        initialValue: widget.user!.firstName,
        isRequired: true,
        onSaveValue: (value) {
          widget.user!.firstName = value;
        },
      ),
      StringFormField(
        enforceMaxLength: true,
        maxLength: 50,
        //  enabled: !isNew,
        suffixIcon: Icons.person,
        hintText: 'Enter Last Name',
        key: const Key('lastname'),
        labelText: 'Last Name',
        // controller: TextEditingController(text: widget.employee.lastName),
        focusNode: model!.setFocusNode('lastname'),
        nextFocusNode: model!.setFocusNode('mobilenumber'),
        onFieldSubmitted: (value) {
          widget.user!.lastName = value;
        },
        inputAction: TextInputAction.next,
        initialValue: widget.user!.lastName,
        isRequired: true,
        onSaveValue: (value) {
          widget.user!.lastName = value;
        },
      ),
      MobileNumberFormField(
        hintText: 'Mobile Number',
        key: const Key('mobilenumber'),
        // enabled: !isNew,
        labelText: 'Mobile Number',
        country: LocaleProvider.instance.currentLocale,
        focusNode: model!.setFocusNode('mobilenumber'),
        nextFocusNode: model!.setFocusNode('email'),
        initialValue: widget.user!.mobileNumber,
        onFieldSubmitted: (value) {
          widget.user!.mobileNumber = value;
        },
        inputAction: TextInputAction.next,
        isRequired: true,
        onSaveValue: (value) {
          widget.user!.mobileNumber = value;
        },
      ),
      EmailFormField(
        textColor: Theme.of(context).colorScheme.onBackground,
        iconColor: Theme.of(context).colorScheme.onBackground,
        hintColor: Theme.of(context).colorScheme.onBackground,
        enforceMaxLength: true,
        maxLength: 50,
        suffixIcon: Icons.email,
        enabled: !isNew,
        hintText: 'Email address',
        key: const Key('email'),
        labelText: 'Email Address',
        focusNode: model!.setFocusNode('email'),
        onFieldSubmitted: (value) {
          widget.user!.email = value;
        },
        inputAction: TextInputAction.done,
        initialValue: widget.user!.email,
        isRequired: true,
        onSaveValue: (value) {
          widget.user!.email = value;
        },
      ),
    ];

    return Form(
      key: model!.formKey,
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

  GestureDetector avatar(BuildContext context) => GestureDetector(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      child: CircleAvatar(
        radius: 50,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 48.0,
          child: Icon(Icons.person, color: Colors.grey.shade700, size: 48.0),
        ),
      ),
    ),
  );
}
