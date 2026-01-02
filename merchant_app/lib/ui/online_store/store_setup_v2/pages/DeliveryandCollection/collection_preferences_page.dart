//flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/controls/control_check_box.dart';
//package imports
import 'package:quiver/strings.dart';
//project imports
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/google_address_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:littlefish_merchant/features/ecommerce_shared/models/store/store.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';
import 'package:littlefish_merchant/common/presentaion/components/labels/section_header.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import '../../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../../common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';

class CollectionPreferencePage extends StatefulWidget {
  static const String route = '/collection-page';

  const CollectionPreferencePage({Key? key}) : super(key: key);

  @override
  State<CollectionPreferencePage> createState() =>
      _CollectionPreferencePageState();
}

class _CollectionPreferencePageState extends State<CollectionPreferencePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool? changed;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVMv2>(
      onInit: (store) {
        if (store.state.storeState.store == null) {
          store.dispatch(CreateDefaultStoreAction());
        }
      },
      converter: (store) => ManageStoreVMv2.fromStore(store),
      builder: (BuildContext context, ManageStoreVMv2 vm) {
        if (vm.item!.collectionSettings == null) {
          vm.item!.collectionSettings = CollectionSettings(enabled: false);
        }
        return scaffold(context, vm);
      },
    );
  }

  scaffold(BuildContext context, ManageStoreVMv2 vm) =>
      KeyboardDismissalUtility(
        content: AppSimpleAppScaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          noElevation: true,
          title: '',
          titleIsWidget: true,
          titleWidget: context.labelLarge('Collection Settings', isBold: true),
          centreTitle: false,
          body: vm.isLoading!
              ? const AppProgressIndicator()
              : layout(context, vm),
          actions: [
            if (vm.store!.state.storeState.store?.isConfigured == false)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('2/2'),
              ),
          ],
          footerActions: [
            FooterButtonsSecondaryPrimary(
              secondaryButtonText:
                  vm.store!.state.storeState.store?.isConfigured == true
                  ? 'Cancel'
                  : 'Back',
              onSecondaryButtonPressed: (ctx) async {
                Navigator.of(context).pop();
              },
              primaryButtonText: 'Update Settings',
              onPrimaryButtonPressed: (ctx) async {
                bool verified = false;
                if (vm.item!.collectionSettings!.enabled ?? false) {
                  if (_formKey.currentState == null) {
                    return;
                  } else {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      verified = true;
                    }
                  }
                } else {
                  verified = true;
                }
                if (verified) {
                  if (vm.item == null) return;

                  if (changed == true) {
                    await vm.upsertStore(vm.item!).then((_) {
                      navigateToPostPage(context, vm);
                    });
                  } else {
                    navigateToPostPage(context, vm);
                  }
                }
              },
            ),
          ],
        ),
      );

  layout(BuildContext context, ManageStoreVMv2 vm) => SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SwitchListTile(
          activeColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
          contentPadding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          title: context.paragraphMedium(
            'Allow Collection',
            alignLeft: true,
            isSemiBold: true,
          ),
          value: vm.item!.collectionSettings!.enabled ?? false,
          onChanged: (val) {
            if (mounted) {
              setState(() {
                vm.item!.collectionSettings!.enabled = val;
                changed = true;
              });
            }
          },
        ),
        if (vm.item!.collectionSettings!.enabled!) form(context, vm),
      ],
    ),
  );

  form(BuildContext context, ManageStoreVMv2 vm) => Form(
    key: _formKey,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader('Collection Address', horizontalPadding: 16),
        ListTile(
          tileColor: Theme.of(context).colorScheme.background,
          leading: ControlCheckBox(
            isSelected:
                (vm.item!.collectionSettings!.useBusinessAddress ?? false) &&
                haveBusinessAddress(vm),
            onChanged: (value) async {
              if (mounted) {
                setState(() {
                  changed = true;
                  vm.item!.collectionSettings!.useBusinessAddress = value;
                  if (haveBusinessAddress(vm)) {
                    vm.item!.collectionSettings!.collectionAddress =
                        getBusinessAddress(vm);
                  }
                });
              }
            },
          ),
          title: context.body02x14R(
            'Use your business address as the collection address',
          ),
        ),
        if (!haveBusinessAddress(vm))
          context.body02x14R(
            '*Please update business information, no business address found',
            color: Colors.red,
          ),
        if (!((vm.item!.collectionSettings!.useBusinessAddress ?? false) &&
            haveBusinessAddress(vm)))
          Padding(
            padding: const EdgeInsets.all(16),
            child: GoogleAddressFormField(
              useOutlineStyling: true,
              isRequired: vm.item!.collectionSettings!.enabled ?? false,
              maxLines: 3,
              key: const Key('collectionAddress'),
              initialValue: vm.item!.collectionSettings!.collectionAddress,
              onFieldSubmitted: (addressText, address) {
                if (mounted) {
                  FocusScope.of(context).unfocus();
                  vm.item!.collectionSettings!.collectionAddress = addressText;
                  setState(() {
                    changed = true;
                  });
                  FocusScope.of(context).unfocus();
                }
              },
              onSaveValue: (value) {
                vm.item!.collectionSettings!.collectionAddress = value;
              },
              hintText: 'Search for collection location..',
              labelText: 'Select Collection Location',
            ),
          ),
        const SectionHeader('Collection Instructions', horizontalPadding: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: StringFormField(
            minLines: 3,
            maxLines: 3,
            isRequired: false,
            useOutlineStyling: true,
            key: const Key('collectionInstructions'),
            initialValue: vm.item!.collectionSettings!.collectionInstructions,
            onSaveValue: (value) {
              vm.item!.collectionSettings!.collectionInstructions = value;
              changed = true;
            },
            onFieldSubmitted: (value) {
              if (mounted) {
                setState(() {
                  changed = true;
                  vm.item!.collectionSettings!.collectionInstructions = value;
                  FocusScope.of(context).unfocus();
                });
              }
            },
            hintText: 'Add collection instructions here',
            labelText: 'Collection Instructions',
          ),
        ),
      ],
    ),
  );

  navigateToPostPage(BuildContext context, ManageStoreVMv2 vm) {
    if (vm.store!.state.storeState.store?.isConfigured == true) {
      return Navigator.of(context).pop();
    } else {
      return Navigator.of(
        context,
      ).pushNamed(getOnlineStoreRoute(vm.item?.isConfigured ?? false));
    }
  }

  bool haveBusinessAddress(ManageStoreVMv2 vm) {
    StoreAddress? storeAddress = vm.item?.primaryAddress;
    return isNotBlank(storeAddress?.addressLine1);
  }

  String getBusinessAddress(ManageStoreVMv2 vm) {
    StoreAddress? storeAddress = vm.item?.primaryAddress;
    return (storeAddress?.addressLine1 ?? '') +
        (storeAddress?.addressLine2 ?? '');
  }
}
