//flutter imports
// remove ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
//package imports
import 'package:quiver/strings.dart';
//project imports
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/google_address_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/BusinessInformation/online_store_social_media_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/features/ecommerce_shared/models/store/store.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/text_widgets.dart';

import '../../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../../common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';

class OnlineStoreLocationPage extends StatefulWidget {
  static const route = 'online-store/business-details-location';

  final StoreAddress? storeAddress;
  final bool showPageNumber;
  final int pageNumber, totalNumPages;

  const OnlineStoreLocationPage({
    Key? key,
    this.storeAddress,
    this.showPageNumber = true,
    this.pageNumber = 3,
    this.totalNumPages = 5,
  }) : super(key: key);

  @override
  State<OnlineStoreLocationPage> createState() =>
      _OnlineStoreContactInfoPageState();
}

class _OnlineStoreContactInfoPageState extends State<OnlineStoreLocationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  StoreAddress? _storeAddress;
  StoreAddress? _initialAddress;

  @override
  void initState() {
    if (widget.storeAddress != null) {
      _storeAddress = widget.storeAddress;
      _initialAddress = StoreAddress.copy(widget.storeAddress!);
    } else {
      _storeAddress = StoreAddress();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVMv2>(
      converter: (store) => ManageStoreVMv2.fromStore(store),
      builder: (BuildContext context, ManageStoreVMv2 vm) {
        return scaffold(vm);
      },
    );
  }

  scaffold(ManageStoreVMv2 vm) {
    return KeyboardDismissalUtility(
      content: AppScaffold(
        title: 'Location Information',
        centreTitle: false,
        body: vm.isLoading != true
            ? layout(context, vm)
            : const AppProgressIndicator(),
        enableProfileAction: false,
        actions: [
          Visibility(
            visible: widget.showPageNumber,
            child: PageNumberText(
              pageNumber: widget.pageNumber,
              totalNumPages: widget.totalNumPages,
            ),
          ),
        ],
        persistentFooterButtons: [
          FooterButtonsSecondaryPrimary(
            secondaryButtonText:
                !(vm.store!.state.storeState.store?.isConfigured ?? false)
                ? 'Skip'
                : 'Cancel',
            onSecondaryButtonPressed: (ctx) async {
              !(vm.store!.state.storeState.store?.isConfigured ?? false)
                  ? navigateToSocialMediaPage(context, vm)
                  : Navigator.of(context).pop();
            },
            primaryButtonText:
                vm.store!.state.storeState.store?.isConfigured == true
                ? 'Save'
                : 'Next',
            onPrimaryButtonPressed: (ctx) async {
              if (_formKey.currentState == null) return;

              if (_formKey.currentState!.validate() &&
                  areRequiredFieldFilled(_storeAddress)) {
                _formKey.currentState!.save();

                vm.store?.dispatch(SetStoreAddressAction(_storeAddress!));
                if (await vm.doesStoreExist() == false) {
                  vm.store?.dispatch(addOnlineStoreToAccount(vm.item!));
                  return;
                }

                vm.store?.dispatch(saveStoreAddress(_storeAddress));
                if (isInfoChanged(_storeAddress)) {
                  await vm
                      .upsertStore(vm.item!)
                      .then(() => navigateToSocialMediaPage(context, vm));
                } else {
                  navigateToSocialMediaPage(context, vm);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  layout(BuildContext context, ManageStoreVMv2 vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            context.labelLarge(
              'Business Address',
              color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
              isSemiBold: true,
            ),
            context.labelMedium(
              'Add your business address so customers know where to find you, This will be displayed on your \'Contact Us\' page.',
              color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
              alignLeft: true,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: form(context: context, vm: vm),
            ),
          ],
        ),
      ),
    );
  }

  form({required BuildContext context, required ManageStoreVMv2 vm}) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GoogleAddressFormField(
              key: const Key('address'),
              hintText: 'Search Location...',
              labelText: 'Address',
              isRequired: false,
              useOutlineStyling: true,
              initialValue: _storeAddress?.friendlyName ?? '',
              onFieldSubmitted: (addressText, address) {
                if (mounted) {
                  setState(() {
                    _storeAddress = StoreAddress.copy(address);
                    _initialAddress = StoreAddress.copy(address);
                  });
                }
              },
              onSaveValue: (value) {
                _storeAddress!.friendlyName = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: StringFormField(
              key: const Key('street_address_line_1'),
              hintText: 'Enter street address line 01',
              labelText: 'Street Address Line 01',
              initialValue: _initialAddress?.addressLine1,
              useOutlineStyling: true,
              textStyle: const TextStyle(color: Colors.black),
              isRequired: true,
              onSaveValue: (value) {
                if (mounted) {
                  setState(() {
                    _storeAddress?.addressLine1 = value;
                    _initialAddress?.addressLine1 = isNotBlank(value)
                        ? String.fromCharCodes(value!.codeUnits)
                        : '';
                  });
                }
              },
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    _storeAddress?.addressLine1 = value;
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: StringFormField(
              key: const Key('street_address_line_2'),
              hintText: 'Enter street address line 02',
              initialValue: _initialAddress?.addressLine2,
              labelText: 'Street Address Line 02',
              useOutlineStyling: true,
              isRequired: false,
              onSaveValue: (value) {
                if (mounted) {
                  setState(() {
                    _storeAddress?.addressLine2 = value;
                    _initialAddress?.addressLine2 = isNotBlank(value)
                        ? String.fromCharCodes(value!.codeUnits)
                        : '';
                  });
                }
              },
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    _storeAddress?.addressLine2 = value;
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: StringFormField(
              key: const Key('city'),
              hintText: 'City',
              labelText: 'City',
              initialValue: _initialAddress?.city,
              useOutlineStyling: true,
              isRequired: true,
              onSaveValue: (value) {
                if (mounted) {
                  setState(() {
                    _storeAddress?.city = value;
                  });
                }
              },
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    _storeAddress?.city = value;
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: StringFormField(
              key: const Key('province'),
              hintText: 'Province',
              labelText: 'Province',
              initialValue: _initialAddress?.state,
              useOutlineStyling: true,
              isRequired: true,
              onSaveValue: (value) {
                if (mounted) {
                  setState(() {
                    _storeAddress?.state = value;
                  });
                }
              },
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    _storeAddress?.state = value;
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: StringFormField(
              key: const Key('postal_code'),
              hintText: 'Postal Code',
              labelText: 'Postal Code',
              initialValue: _initialAddress?.postalCode,
              useOutlineStyling: true,
              isRequired: true,
              onSaveValue: (value) {
                if (mounted) {
                  setState(() {
                    _storeAddress?.postalCode = value;
                  });
                }
              },
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    _storeAddress?.postalCode = value;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  bool areRequiredFieldFilled(StoreAddress? address) {
    if (address == null) return false;
    if (address.addressLine1 == null) return false;
    if (address.city == null) return false;
    if (address.state == null) return false;
    if (address.postalCode == null) return false;
    return true;
  }

  bool isInfoChanged(StoreAddress? address) {
    if (address == null) return false;
    if (address == _initialAddress) return false;
    return true;
  }

  void navigateToSocialMediaPage(BuildContext context, ManageStoreVMv2 vm) {
    if (vm.store!.state.storeState.store?.isConfigured == true) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).push(
        CustomRoute(
          builder: (ctx) => OnlineStoreSocialMediaPage(
            contactInfo: vm.item?.contactInformation,
          ),
        ),
      );
    }
  }
}
