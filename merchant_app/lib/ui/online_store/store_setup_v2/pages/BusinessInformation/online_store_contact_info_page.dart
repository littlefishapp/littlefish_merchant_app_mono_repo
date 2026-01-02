import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:quiver/strings.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/text_widgets.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/email_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/mobile_number_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/BusinessInformation/online_store_location_page.dart';

import '../../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../../common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';

class OnlineStoreContactInfoPage extends StatefulWidget {
  static const route = 'online-store/business-details-contact-info';

  final String? phoneNumber;
  final String? email;
  final bool showPageNumber;
  final int pageNumber, totalNumPages;

  const OnlineStoreContactInfoPage({
    Key? key,
    this.phoneNumber,
    this.email,
    this.showPageNumber = true,
    this.pageNumber = 2,
    this.totalNumPages = 5,
  }) : super(key: key);

  @override
  State<OnlineStoreContactInfoPage> createState() =>
      _OnlineStoreContactInfoPageState();
}

class _OnlineStoreContactInfoPageState
    extends State<OnlineStoreContactInfoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _phoneNumber;
  String? _email;
  String? _initialNumber;
  String? _initialEmail;

  @override
  void initState() {
    if (isNotBlank(widget.phoneNumber)) {
      _phoneNumber = widget.phoneNumber;
      _initialNumber = widget.phoneNumber;
    }
    if (isNotBlank(widget.email)) {
      _email = widget.email;
      _initialEmail = widget.email;
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
        title: 'Contact Information',
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
                  ? navigateToLocationPage(context, vm)
                  : Navigator.of(context).pop();
            },
            primaryButtonText:
                vm.store!.state.storeState.store?.isConfigured == true
                ? 'Save'
                : 'Next',
            onPrimaryButtonPressed: (ctx) async {
              if (_formKey.currentState == null) return;

              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (vm.item == null) return;

                if (isInfoChanged(_phoneNumber!, _email!)) {
                  final completer = Completer<void>();
                  await vm.upsertStore(vm.item!, completer: completer);
                  await completer.future;
                }

                if (mounted) {
                  navigateToLocationPage(context, vm);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget layout(BuildContext context, ManageStoreVMv2 vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            context.labelLarge(
              'Contact Details',
              color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
              isSemiBold: true,
            ),
            context.labelMedium(
              'Provide your contact details so customers can easily reach you. This will be displayed on your \'Contact Us\' page.',
              color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
              alignLeft: true,
            ),
            Padding(padding: const EdgeInsets.only(top: 16), child: form(vm)),
          ],
        ),
      ),
    );
  }

  form(ManageStoreVMv2 vm) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: MobileNumberFormField(
              key: const Key('phone_number'),
              initialValue: _initialNumber,
              country: LocaleProvider.instance.currentLocale,
              onSaveValue: (value) {
                if (isNotBlank(value)) {
                  if (mounted) {
                    setState(() {
                      _phoneNumber = value;
                      vm.store?.dispatch(SetStoreMobileNumberAction(value!));
                    });
                  }
                }
              },
              hintText: 'Enter a valid phone number for customer inquiries.',
              labelText: 'Phone Number',
              useOutlineStyling: true,
              isRequired: true,
              onFieldSubmitted: (value) {
                if (mounted) {
                  setState(() {
                    _phoneNumber = value;
                  });
                }
              },
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    _phoneNumber = value;
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: EmailFormField(
              textColor: Theme.of(context).colorScheme.onBackground,
              iconColor: Theme.of(context).colorScheme.onBackground,
              hintColor: Theme.of(context).colorScheme.onBackground,
              key: const Key('online_store_email'),
              initialValue: _initialEmail,
              onSaveValue: (value) {
                if (isNotBlank(value)) {
                  if (mounted) {
                    setState(() {
                      _email = value;
                      vm.store?.dispatch(SetStoreEmailAddressAction(value!));
                    });
                  }
                }
              },
              hintText:
                  'Enter a valid email for customer inquiries and support.',
              labelText: 'Email Address',
              useOutlineStyling: true,
              isRequired: true,
              onFieldSubmitted: (value) {
                if (mounted) {
                  setState(() {
                    _email = value;
                  });
                }
              },
              onChanged: (value) {
                if (mounted) {
                  setState(() {
                    _email = value;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isInfoChanged(String phoneNumber, String email) {
    if (isBlank(phoneNumber) || isBlank(email)) return false;
    if (phoneNumber != _initialNumber || email != _initialEmail) return true;
    return false;
  }

  void navigateToLocationPage(BuildContext context, ManageStoreVMv2 vm) {
    if (vm.store!.state.storeState.store?.isConfigured == true) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).push(
        CustomRoute(
          builder: (ctx) =>
              OnlineStoreLocationPage(storeAddress: vm.item?.primaryAddress),
        ),
      );
    }
  }
}
