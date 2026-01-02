import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/avatars/avatar_medium.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/models/staff/employee.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/date_select_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/email_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/mobile_number_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';

class EmployeeDetailsForm extends StatefulWidget {
  const EmployeeDetailsForm({
    Key? key,
    required this.onSubmit,
    required this.employee,
    required this.formKey,
    this.onValidityChanged,
  }) : super(key: key);

  final Function(Employee employee) onSubmit;

  final Employee? employee;

  final GlobalKey<FormState>? formKey;

  final void Function(bool)? onValidityChanged;

  @override
  State<EmployeeDetailsForm> createState() => _EmployeeDetailsFormState();
}

class _EmployeeDetailsFormState extends State<EmployeeDetailsForm> {
  BasicFormModel? model;

  late Map<String, String> _currentValues;
  bool _isValid = false;

  final List<String> _requiredFields = [
    'firstname',
    'lastname',
    'jobTitle',
    'primaryMobile',
    'dateOfBirth',
    'dateOfEmployment',
  ];

  @override
  void initState() {
    super.initState();
    _initializeCurrentValues();
  }

  void _initializeCurrentValues() {
    _currentValues = {
      'firstname': widget.employee?.firstName ?? '',
      'lastname': widget.employee?.lastName ?? '',
      'jobTitle': widget.employee?.jobTitle ?? '',
      'primaryMobile': widget.employee?.primaryMobile ?? '',
      'dateOfBirth': TextFormatter.toShortDate(
        dateTime:
            widget.employee?.dateOfBirth ??
            DateTime.now().toUtc().subtract(const Duration(days: 13 * 365)),
      ),
      'dateOfEmployment': TextFormatter.toShortDate(
        dateTime:
            widget.employee?.dateOfEmployment ??
            DateTime.now().toUtc().subtract(const Duration(days: 3)),
      ),
    };
    _checkValidity();
  }

  @override
  Widget build(BuildContext context) {
    return form(context);
  }

  Form form(BuildContext context) {
    model ??= BasicFormModel(widget.formKey);

    //debugPrint('rebuilding form');

    var formFields = <Widget>[
      AvatarMedium(context: context),
      StringFormField(
        useOutlineStyling: true,
        enforceMaxLength: true,
        maxLength: 50,
        hintText: 'Enter First Name',
        suffixIcon: Icons.person,
        key: const Key('firstname'),
        labelText: 'Name',
        focusNode: model!.setFocusNode('firstname'),
        nextFocusNode: model!.setFocusNode('lastname'),
        onFieldSubmitted: (value) {
          widget.employee!.firstName = value;
        },
        onChanged: (value) {
          _updateAndCheckValidity('firstname', value);
        },
        inputAction: TextInputAction.next,
        initialValue: widget.employee!.firstName,
        isRequired: true,
        onSaveValue: (value) {
          widget.employee!.firstName = value;
        },
      ),
      const SizedBox(height: 8),
      StringFormField(
        useOutlineStyling: true,
        enforceMaxLength: true,
        maxLength: 125,
        suffixIcon: Icons.person,
        hintText: 'Enter Last Name',
        key: const Key('lastname'),
        labelText: 'Last Name',
        focusNode: model!.setFocusNode('lastname'),
        nextFocusNode: model!.setFocusNode('jobTitle'),
        onFieldSubmitted: (value) {
          widget.employee!.lastName = value;
        },
        onChanged: (value) {
          _updateAndCheckValidity('lastname', value);
        },
        inputAction: TextInputAction.next,
        initialValue: widget.employee!.lastName,
        isRequired: true,
        onSaveValue: (value) {
          widget.employee!.lastName = value;
        },
      ),
      const SizedBox(height: 8),
      StringFormField(
        useOutlineStyling: true,
        enforceMaxLength: true,
        maxLength: 100,
        suffixIcon: Icons.person,
        hintText: 'What do they do here? i.e. Cashier',
        key: const Key('jobTitle'),
        labelText: 'Job Title',
        focusNode: model!.setFocusNode('jobTitle'),
        nextFocusNode: model!.setFocusNode('mobilenumber'),
        onFieldSubmitted: (value) {
          widget.employee!.jobTitle = value;
        },
        onChanged: (value) {
          _updateAndCheckValidity('jobTitle', value);
        },
        inputAction: TextInputAction.next,
        initialValue: widget.employee!.jobTitle,
        isRequired: true,
        onSaveValue: (value) {
          widget.employee!.jobTitle = value;
        },
      ),
      const SizedBox(height: 8),
      MobileNumberFormField(
        useOutlineStyling: true,
        hintText: 'Mobile Number',
        key: const Key('mobilenumber'),
        labelText: 'Mobile Number',
        country: LocaleProvider.instance.currentLocale,
        focusNode: model!.setFocusNode('mobilenumber'),
        nextFocusNode: model!.setFocusNode('email'),
        initialValue: widget.employee!.primaryMobile,
        onFieldSubmitted: (value) {
          widget.employee!.primaryMobile = value;
        },
        onChanged: (value) {
          _updateAndCheckValidity('primaryMobile', value);
        },
        inputAction: TextInputAction.next,
        isRequired: true,
        onSaveValue: (value) {
          widget.employee!.primaryMobile = value;
        },
      ),
      const SizedBox(height: 8),
      EmailFormField(
        useOutlineStyling: true,
        textColor: Theme.of(context).colorScheme.onBackground,
        iconColor: Theme.of(context).colorScheme.onBackground,
        hintColor: Theme.of(context).colorScheme.onBackground,
        enforceMaxLength: true,
        maxLength: 50,
        suffixIcon: Icons.email,
        hintText: 'Email address',
        key: const Key('email'),
        labelText: 'Email Address',
        focusNode: model!.setFocusNode('email'),
        nextFocusNode: model!.setFocusNode('dob'),
        // borderUnderLineColour: Colors.white,
        onFieldSubmitted: (value) {
          widget.employee!.email = value;
        },
        inputAction: TextInputAction.next,
        initialValue: widget.employee!.email,
        isRequired: false,
        onSaveValue: (value) {
          widget.employee!.email = value;
        },
      ),
      const SizedBox(height: 8),
      DateSelectFormField(
        useOutlineStyling: true,
        initialDate:
            widget.employee!.dateOfBirth ??
            DateTime.now().toUtc().subtract(const Duration(days: 13 * 365)),
        hintText: 'When the employee was born',
        suffixIcon: Icons.calendar_today,
        key: const Key('dob'),
        labelText: 'Date of Birth',
        focusNode: model!.setFocusNode('dob'),
        nextFocusNode: model!.setFocusNode('doe'),
        onFieldSubmitted: (value) {
          widget.employee!.dateOfBirth = value;
        },
        // onChanged: (value) {
        //   _updateAndCheckValidity('dateOfBirth', value ?? '');
        // },
        inputAction: TextInputAction.next,
        initialValue: TextFormatter.toShortDate(
          dateTime:
              widget.employee!.dateOfBirth ??
              DateTime.now().toUtc().subtract(const Duration(days: 13 * 365)),
        ),
        firstDate: DateTime.now().toUtc().subtract(
          const Duration(days: 80 * 365),
        ),
        lastDate: DateTime.now().toUtc().subtract(
          const Duration(days: 12 * 365),
        ),
        isRequired: true,
        onSaveValue: (value) {
          widget.employee!.dateOfBirth = value;
        },
      ),
      const SizedBox(height: 8),
      DateSelectFormField(
        useOutlineStyling: true,
        initialDate:
            widget.employee!.dateOfEmployment ??
            DateTime.now().toUtc().subtract(const Duration(days: 3)),
        hintText: 'When the employee was hired',
        suffixIcon: Icons.calendar_today,
        key: const Key('doe'),
        labelText: 'Date of Employment',
        focusNode: model!.setFocusNode('doe'),
        onFieldSubmitted: (value) {
          widget.employee!.dateOfEmployment = value;
        },
        // onChanged: (value) {
        //   _updateAndCheckValidity('dateOfEmployment', value ?? '');
        // },
        inputAction: TextInputAction.next,
        initialValue: TextFormatter.toShortDate(
          dateTime:
              widget.employee!.dateOfEmployment ??
              DateTime.now().toUtc().subtract(const Duration(days: 3)),
        ),
        firstDate: DateTime.now().toUtc().subtract(
          const Duration(days: 80 * 365),
        ),
        lastDate: DateTime.now().toUtc().subtract(const Duration(days: 1)),
        isRequired: true,
        onSaveValue: (value) {
          widget.employee!.dateOfEmployment = value;
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

  void _updateAndCheckValidity(String fieldName, String value) {
    _currentValues[fieldName] = value;
    _checkValidity();
  }

  void _checkValidity() {
    final bool valid = _requiredFields.every(
      (field) => _currentValues[field]!.trim().isNotEmpty,
    );
    if (valid != _isValid) {
      _isValid = valid;
      widget.onValidityChanged?.call(valid);
    }
  }
}
