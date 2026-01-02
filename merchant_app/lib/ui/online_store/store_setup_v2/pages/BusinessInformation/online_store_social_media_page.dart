//flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/number_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
//project imports
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/BusinessInformation/online_store_trading_hours_page.dart';
import 'package:littlefish_merchant/features/ecommerce_shared/models/store/store.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/text_widgets.dart';

import '../../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../../common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import '../../../../../common/presentaion/components/form_fields/mobile_number_form_field.dart';

class OnlineStoreSocialMediaPage extends StatefulWidget {
  static const route = 'online-store/business-details-social-media';

  final ContactInformation? contactInfo;
  final bool showPageNumber;
  final int pageNumber, totalNumPages;

  const OnlineStoreSocialMediaPage({
    Key? key,
    this.contactInfo,
    this.showPageNumber = true,
    this.pageNumber = 4,
    this.totalNumPages = 5,
  }) : super(key: key);

  @override
  State<OnlineStoreSocialMediaPage> createState() =>
      _OnlineStoreSocialMediaPageState();
}

class _OnlineStoreSocialMediaPageState
    extends State<OnlineStoreSocialMediaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  ContactInformation? _contactInfo;
  ContactInformation? _initialContactInfo;

  @override
  void initState() {
    if (widget.contactInfo != null) {
      _contactInfo = widget.contactInfo;
      _initialContactInfo = ContactInformation.copy(widget.contactInfo!);
    } else {
      _contactInfo = ContactInformation();
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
        title: 'Social Media',
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
                  ? navigateToTradingHoursPage(context, vm)
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
                if (_contactInfo == null) return;
                vm.store?.dispatch(
                  UpdateStoreContactInformationAction(_contactInfo!),
                );

                if (vm.item == null) return;

                if (isInfoChanged(_contactInfo)) {
                  await vm
                      .upsertStore(vm.item!)
                      .then(() => navigateToTradingHoursPage(context, vm));
                } else {
                  navigateToTradingHoursPage(context, vm);
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
              'Do you have any social media links?',
              color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
              isSemiBold: true,
            ),
            context.labelMedium(
              'Add your social media profiles so customers can easily '
              'connect with your business. These links will be '
              'displayed on your Contact Us page and in '
              'the footer of your store.',
              color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
              alignLeft: true,
            ),
            Padding(padding: const EdgeInsets.only(top: 16), child: form(vm)),
          ],
        ),
      ),
    );
  }

  Widget form(ManageStoreVMv2 vm) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 8),
          StringFormField(
            enforceMaxLength: false,
            maxLength: 255,
            hintText:
                'Enter your Facebook page name or handle (e.g., YourBusinessName).',
            key: const Key('facebook'),
            labelText: 'Facebook',
            useOutlineStyling: true,
            initialValue: _contactInfo?.facebook,
            onFieldSubmitted: (value) {
              if (mounted) {
                setState(() {
                  _contactInfo?.facebook = value;
                });
              }
            },
            inputAction: TextInputAction.done,
            isRequired: false,
            onSaveValue: (value) {
              if (mounted) {
                setState(() {
                  _contactInfo?.facebook = value;
                });
              }
            },
            onChanged: (value) => _contactInfo?.facebook = value,
          ),
          const SizedBox(height: 8),
          StringFormField(
            enforceMaxLength: false,
            maxLength: 255,
            hintText: 'Enter your Instagram handle (e.g., @YourBusinessName).',
            key: const Key('instahandle'),
            labelText: 'Instagram',
            useOutlineStyling: true,
            initialValue: _contactInfo?.instagram,
            onFieldSubmitted: (value) {
              if (mounted) {
                setState(() {
                  _contactInfo?.instagram = value;
                });
              }
            },
            inputAction: TextInputAction.done,
            isRequired: false,
            onSaveValue: (value) {
              if (mounted) {
                setState(() {
                  _contactInfo?.instagram = value;
                });
              }
            },
            onChanged: (value) => _contactInfo?.instagram = value,
          ),
          const SizedBox(height: 8),
          StringFormField(
            hintText: 'Provide your X handle (e.g., @YourHandle).',
            useOutlineStyling: true,
            key: const Key('twitter'),
            labelText: 'X (Twitter)',
            initialValue: _contactInfo?.twitter,
            onFieldSubmitted: (value) {
              if (mounted) {
                setState(() {
                  _contactInfo?.twitter = value;
                });
              }
            },
            inputAction: TextInputAction.done,
            isRequired: false,
            onSaveValue: (value) {
              if (mounted) {
                setState(() {
                  _contactInfo?.twitter = value;
                });
              }
            },
            onChanged: (value) => _contactInfo?.twitter = value,
          ),
          const SizedBox(height: 8),
          MobileNumberFormField(
            hintText: 'Enter your WhatsApp Phone Number (e.g., +27xxxx).',
            key: const Key('whatsappLine'),
            labelText: 'WhatsApp',
            useOutlineStyling: true,
            initialValue: _contactInfo?.whatsapp,
            onFieldSubmitted: (value) {
              if (mounted) {
                setState(() {
                  _contactInfo?.whatsapp = value.toString();
                });
              }
            },
            inputAction: TextInputAction.done,
            isRequired: false,
            onSaveValue: (value) {
              if (mounted) {
                setState(() {
                  _contactInfo?.whatsapp = value.toString();
                });
              }
            },
            onChanged: (value) => _contactInfo?.whatsapp = value.toString(),
          ),
          const SizedBox(height: 8),
          StringFormField(
            enforceMaxLength: true,
            maxLength: 50,
            hintText: 'Enter your website domain (e.g., www.yourbusiness.com).',
            key: const Key('website'),
            labelText: 'Website',
            useOutlineStyling: true,
            initialValue: _contactInfo?.website,
            onFieldSubmitted: (value) {
              if (mounted) {
                setState(() {
                  _contactInfo?.website = value;
                });
              }
            },
            inputAction: TextInputAction.done,
            isRequired: false,
            onSaveValue: (value) {
              if (mounted) {
                setState(() {
                  _contactInfo?.website = value;
                });
              }
            },
            onChanged: (value) {
              _contactInfo?.website = value;
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  bool isInfoChanged(ContactInformation? contactInfo) {
    if (contactInfo == null) return false;
    if (contactInfo == _initialContactInfo) return false;
    return true;
  }

  void navigateToTradingHoursPage(BuildContext context, ManageStoreVMv2 vm) {
    if (vm.store!.state.storeState.store?.isConfigured == true) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).push(
        CustomRoute(
          builder: (ctx) =>
              OnlineStoreTradingHoursPage(tradingHours: vm.item?.tradingHours),
        ),
      );
    }
  }
}
