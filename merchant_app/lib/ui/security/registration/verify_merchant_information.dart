import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/mobile_number_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/models/activation/verify_activation_response.dart';
import 'package:littlefish_merchant/models/security/authentication/bank_merchant.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/security/login/viewmodels/login_viewmodel.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';
import 'package:quiver/strings.dart';

class VerifyMerchantInfoPage extends StatefulWidget {
  static const route = '/verify_merchant_info';

  final VerifyActivationResponse activationData;
  final bool isActivation;

  const VerifyMerchantInfoPage({
    Key? key,
    required this.activationData,
    required this.isActivation,
  }) : super(key: key);

  @override
  State<VerifyMerchantInfoPage> createState() => _VerifyMerchantInfoPageState();
}

class _VerifyMerchantInfoPageState extends State<VerifyMerchantInfoPage> {
  final _formKey = GlobalKey<FormState>();

  late String? _tradingName;
  late String? _firstName;
  late String? _surname;
  late String? _city;
  late String? _province;
  late String? _country;
  late BankMerchant _merchant;
  late String? _fullAddress;

  @override
  void initState() {
    _merchant = widget.activationData.merchantInfo;

    _tradingName = _merchant.businessName;
    _firstName = _merchant.firstName;
    _surname = _merchant.surname;
    _city = _merchant.city;
    _province = _merchant.state;
    _country = _merchant.country;
    _fullAddress = _getFullAddress();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RegisterVM>(
      converter: (store) => RegisterVM.fromStore(store)..key = _formKey,
      builder: (c, vm) {
        return AppSimpleAppScaffold(
          footerActions: [
            ButtonPrimary(
              text: 'Register',
              onTap: (context) {
                _formKey.currentState!.save();

                vm.activateBusinessRequest!(
                  widget.activationData.activationId,
                  widget.isActivation,
                );
              },
            ),
          ],
          centreTitle: false,
          title: 'Confirm Your Details',
          body: vm.isLoading == true
              ? const AppProgressIndicator()
              : SafeArea(child: layout(vm)),
        );
      },
    );
  }

  Widget layout(RegisterVM vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 72),
              context.paragraphMedium(
                'Please confirm the details below are correct. '
                'If you see an error, please contact '
                'support${_supportText()}',
              ),
              const SizedBox(height: 16),
              context.labelSmall('Merchant Details', isBold: true),
              const SizedBox(height: 32),
              StringFormField(
                initialValue: _merchant.merchantId,
                labelText: 'Merchant Id',
                onSaveValue: (String? value) {},
                hintText: '',
                enabled: false,
                useOutlineStyling: true,
                isRequired: false,
              ),
              const SizedBox(height: 8),
              StringFormField(
                initialValue: _merchant.businessName,
                labelText: 'Business Name',
                onSaveValue: (String? value) {},
                hintText: '',
                enabled: false,
                useOutlineStyling: true,
                isRequired: false,
              ),
              const SizedBox(height: 8),
              StringFormField(
                initialValue:
                    '${_merchant.firstName ?? ''} ${_merchant.surname ?? ''}',
                labelText: 'Client Name',
                onSaveValue: (String? value) {},
                hintText: '',
                enabled: false,
                useOutlineStyling: true,
                isRequired: false,
              ),
              const SizedBox(height: 8),
              MobileNumberFormField(
                initialValue: _merchant.mobileNumber,
                labelText: 'Mobile Number',
                onSaveValue: (value) {},
                hintText: '',
                enabled: false,
                useOutlineStyling: true,
                isRequired: false,
                key: Key('mobile_number_business'),
              ),
              const SizedBox(height: 8),
              StringFormField(
                initialValue: _merchant.emailAddress,
                labelText: 'Email Address',
                onSaveValue: (String? value) {},
                hintText: '',
                enabled: false,
                useOutlineStyling: true,
                isRequired: false,
              ),
              const SizedBox(height: 8),
              StringFormField(
                initialValue: _merchant.mcc,
                labelText: 'MCC Code',
                onSaveValue: (String? value) {},
                hintText: '',
                enabled: false,
                useOutlineStyling: true,
                isRequired: false,
              ),
              const SizedBox(height: 8),
              StringFormField(
                initialValue: _fullAddress,
                labelText: 'Physical Address',
                onSaveValue: (String? value) {},
                hintText: '',
                enabled: false,
                useOutlineStyling: true,
                isRequired: false,
              ),
              const SizedBox(height: 16),
              context.labelSmall('Owner Details', isBold: true),
              const SizedBox(height: 32),
              StringFormField(
                initialValue: _merchant.firstName,
                labelText: 'First Name',
                onSaveValue: (String? value) {},
                hintText: '',
                enabled: false,
                useOutlineStyling: true,
                isRequired: false,
              ),
              const SizedBox(height: 8),
              StringFormField(
                initialValue: _merchant.surname,
                labelText: 'Surname',
                onSaveValue: (String? value) {},
                hintText: '',
                enabled: false,
                useOutlineStyling: true,
                isRequired: false,
              ),
              const SizedBox(height: 8),
              MobileNumberFormField(
                initialValue: _merchant.mobileNumber,
                labelText: 'Mobile Number',
                onSaveValue: (value) {},
                hintText: '',
                enabled: false,
                useOutlineStyling: true,
                isRequired: false,
                autoValidate: false,
                key: const Key('mobile_number_owner'),
              ),
              const SizedBox(height: 8),
              StringFormField(
                initialValue: _merchant.emailAddress,
                labelText: 'Email Address',
                onSaveValue: (String? value) {},
                hintText: '',
                enabled: false,
                useOutlineStyling: true,
                isRequired: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container logo() => Container(
    margin: const EdgeInsets.only(bottom: 20),
    alignment: Alignment.center,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 40, top: 40),
          alignment: Alignment.center,
          height: 100,
          child: Image.asset(UIStateData().appLogo, fit: BoxFit.fitHeight),
        ),
      ],
    ),
  );

  String _supportText() {
    String supportText = '.';
    if (isBlank(AppVariables.store!.state.clientSupportEmail) &&
        isBlank(AppVariables.store!.state.clientSupportMobileNumber)) {
      return supportText;
    }
    if (isBlank(AppVariables.store!.state.clientSupportEmail)) {
      if (!isBlank(AppVariables.store!.state.clientSupportMobileNumber)) {
        supportText =
            'at ${AppVariables.store!.state.clientSupportMobileNumber}';
      }
      return supportText;
    }
    supportText = 'at ${AppVariables.store!.state.clientSupportEmail}';
    if (!isBlank(AppVariables.store!.state.clientSupportMobileNumber)) {
      supportText +=
          ' or ${AppVariables.store!.state.clientSupportMobileNumber}';
    }
    return supportText;
  }

  String _getFullAddress() {
    final parts = [
      _merchant.addressLine1,
      _merchant.addressLine2,
      _merchant.city,
      _merchant.country,
    ].where((part) => !isBlank(part)).toList();
    return parts.join(', ');
  }
}
