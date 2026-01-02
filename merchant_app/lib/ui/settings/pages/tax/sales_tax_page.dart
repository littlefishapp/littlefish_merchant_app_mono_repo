import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/models/shared/data/address.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/settings/view_models/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/yes_no_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import '../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../../common/presentaion/components/form_fields/google_address_form_field.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../models/store/business_profile.dart';
import 'package:collection/collection.dart';

class SalesTaxPage extends StatefulWidget {
  static const String route = 'checkout/sales-tax';

  const SalesTaxPage({Key? key}) : super(key: key);

  @override
  State<SalesTaxPage> createState() => _SalesTaxPageState();
}

class _SalesTaxPageState extends State<SalesTaxPage> {
  GlobalKey<FormState>? formKey;
  late Address _address;
  SalesTaxViewModel? _vm;
  BusinessProfile? _businessProfile;
  LittleFishCore core = LittleFishCore.instance;
  late final ConfigService configService;

  @override
  void initState() {
    formKey = GlobalKey();
    _businessProfile = AppVariables.store?.state.businessState.profile;
    configService = core.get<ConfigService>();
    super.initState();
  }

  Address _initialiseAddress(Address? taxAddress, Address? businessVatAddress) {
    if (taxAddress != null && (taxAddress.isAddressEmpty == false)) {
      return taxAddress;
    }
    if (businessVatAddress != null &&
        (businessVatAddress.isAddressEmpty == false)) {
      return businessVatAddress;
    }
    return Address();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SalesTaxViewModel?>(
      onInit: (store) {
        final vm = SalesTaxViewModel.fromStore(store);
        vm.initialiseTax();
        _address = _initialiseAddress(
          vm.item?.address,
          _businessProfile?.vatBillingAddress,
        );
      },
      converter: (Store store) {
        _vm = SalesTaxViewModel.fromStore(
          store as Store<AppState>,
          form: _vm?.form ?? FormManager(formKey)
            ..key = formKey,
        );
        return _vm;
      },
      builder: (BuildContext context, SalesTaxViewModel? vm) {
        final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
        final showSideNav =
            isTablet ||
            (AppVariables.store!.state.enableSideNavDrawer ?? false);

        return AppScaffold(
          title: 'Tax Settings',
          enableProfileAction: !showSideNav,
          hasDrawer: false,
          displayNavDrawer: false,
          persistentFooterButtons: vm?.isLoading == true
              ? null
              : <Widget>[
                  ButtonPrimary(
                    text: 'Save',
                    upperCase: false,
                    onTap: (_) {
                      formKey?.currentState?.save();
                      vm!.onAdd(vm.item, context);
                    },
                  ),
                ],
          body: vm!.isLoading!
              ? const AppProgressIndicator()
              : form(context, vm),
        );
      },
    );
  }

  Container form(BuildContext context, SalesTaxViewModel vm) {
    final formFields = <Widget>[
      YesNoFormField(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        labelText: 'Enable VAT',
        initialValue: vm.item?.enabled ?? false,
        onSaved: (bool? value) {
          setState(() {
            vm.item!.enabled = value ?? false;
          });
        },
      ),
      Offstage(
        offstage: !(vm.item?.enabled ?? false),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            StringFormField(
              useOutlineStyling: true,
              hintStyle: context.appThemeTextFormHint,
              labelStyle: context.appThemeTextFormLabel,
              textStyle: context.appThemeTextFormText,
              enforceMaxLength: true,
              maxLength: 10,
              textInputType: TextInputType.number,
              hintText: 'Vat Registration Number',
              key: const Key('vat_registration_number'),
              labelText: 'Vat Registration Number',
              onFieldSubmitted: (value) {
                vm.item!.vatRegistrationNumber = value;
              },
              inputAction: TextInputAction.next,
              initialValue:
                  AppVariables.store?.state.businessState.profile?.taxNumber,
              isRequired: true,
              onSaveValue: (value) {
                vm.item!.vatRegistrationNumber = value;
              },
              onChanged: (value) {
                vm.item!.vatRegistrationNumber = value;
              },
              validator: validateVatNumber,
            ),
            const SizedBox(height: 12),
            context.paragraphMedium(
              'VAT Billing Address',
              isBold: true,
              alignLeft: true,
            ),
            const SizedBox(height: 4),
            GoogleAddressFormField(
              key: const Key('address'),
              hintText: 'Search Location...',
              labelText: 'Address',
              isRequired: false,
              useOutlineStyling: true,
              initialValue: '',
              onFieldSubmitted: (addressText, address) {
                if (mounted) {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _address = Address(
                      address1: address.addressLine1,
                      address2: address.addressLine2,
                      city: address.city,
                      state: address.state,
                      postalCode: address.postalCode,
                      country: address.country,
                    );
                  });
                }
              },
              onSaveValue: (value) {
                if (mounted) {
                  setState(() {
                    vm.item!.address = _address;
                  });
                }
              },
            ),
            const SizedBox(height: 6),
            StringFormField(
              key: const Key('street_address_line_1'),
              hintText: 'Enter street address line 01',
              labelText: 'Street Address Line 01',
              initialValue: _address.address1,
              useOutlineStyling: true,
              textStyle: const TextStyle(color: Colors.black),
              isRequired: true,
              onSaveValue: (value) {
                _address.address1 = value;
                vm.item!.address = _address;
              },
              onChanged: (value) {
                _address.address1 = value;
              },
            ),
            const SizedBox(height: 4),
            StringFormField(
              key: const Key('street_address_line_2'),
              hintText: 'Enter street address line 02',
              labelText: 'Street Address Line 02',
              initialValue: _address.address2,
              useOutlineStyling: true,
              isRequired: false,
              onSaveValue: (value) {
                _address.address2 = value;
              },
              onChanged: (value) {
                _address.address2 = value;
              },
            ),
            const SizedBox(height: 4),
            StringFormField(
              key: const Key('city'),
              hintText: 'City',
              labelText: 'City',
              initialValue: _address.city,
              useOutlineStyling: true,
              isRequired: true,
              onSaveValue: (value) {
                _address.city = value;
              },
              onChanged: (value) {
                _address.city = value;
              },
            ),
            const SizedBox(height: 4),
            StringFormField(
              key: const Key('province'),
              hintText: 'Province',
              labelText: 'Province',
              initialValue: _address.state,
              useOutlineStyling: true,
              isRequired: true,
              onSaveValue: (value) {
                _address.state = value;
              },
              onChanged: (value) {
                _address.state = value;
              },
            ),
            const SizedBox(height: 4),
            StringFormField(
              key: const Key('postal_code'),
              hintText: 'Postal Code',
              labelText: 'Postal Code',
              initialValue: _address.postalCode,
              useOutlineStyling: true,
              isRequired: true,
              onSaveValue: (value) {
                _address.postalCode = value;
              },
              onChanged: (value) {
                _address.postalCode = value;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              key: const Key('default_vat_rate'),
              decoration: const InputDecoration(
                labelText: 'VAT Type',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              value: vm.vatLevels
                  ?.firstWhereOrNull(
                    (v) =>
                        v.name ==
                        AppVariables
                            .store
                            ?.state
                            .appSettingsState
                            .salesTax
                            ?.displayName,
                  )
                  ?.vatLevelId,
              items: vm.vatLevels?.map((vat) {
                return DropdownMenuItem<String>(
                  value: vat.vatLevelId,
                  child: context.labelSmall(
                    '${vat.name} (${((vat.rate ?? 0) * 100).toStringAsFixed(0)}%)',
                  ),
                );
              }).toList(),
              onChanged: (selectedId) {
                final selected = vm.vatLevels?.firstWhere(
                  (e) => e.vatLevelId == selectedId,
                );
                setState(() {
                  vm.selectedVatLevel = selected;
                  final vatRate = (selected!.rate! * 100);
                  if (vm.item != null) {
                    vm.item!
                      ..id = selected.vatLevelId
                      ..percentage = vatRate
                      ..name = selected.name
                      ..displayName = selected.name;
                  }
                });
              },
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select a VAT rate'
                  : null,
            ),
          ],
        ),
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Form(
        key: formKey,
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            shrinkWrap: false,
            physics: const BouncingScrollPhysics(),
            children: formFields,
          ),
        ),
      ),
    );
  }

  Address _mapToBasicAddress(String addressText, SalesTaxViewModel vm) {
    return Address(
      address1: vm.item?.address?.address1,
      address2: vm.item?.address?.address2,
      city: vm.item?.address?.city,
      country: vm.item?.address?.country,
      postalCode: vm.item?.address?.postalCode,
      state: vm.item?.address?.state,
    );
  }

  String? validateVatNumber(String? value) {
    const String vatRegex = r'^4[0-9]{9}$';

    final regexString = configService.getStringValue(
      key: 'vat_regex_expression',
      defaultValue: vatRegex,
    );

    final RegExp regex = RegExp(regexString);

    if (value == null || value.isEmpty) {
      return 'Please enter a VAT number';
    }

    if (!regex.hasMatch(value)) {
      return 'VAT number must be 10 digits and start with 4';
    }
    return null;
  }
}
