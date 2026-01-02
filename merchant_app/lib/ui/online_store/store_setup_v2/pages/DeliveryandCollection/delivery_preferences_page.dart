import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/chips/chip_selectable.dart';
import 'package:littlefish_merchant/common/presentaion/components/controls/control_check_box.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:quiver/strings.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/DeliveryandCollection/collection_preferences_page.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/google_address_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/numeric_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:littlefish_merchant/features/ecommerce_shared/models/store/store.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import '../../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../../common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import '../../../../../common/presentaion/components/dialogs/services/modal_service.dart';
import '../../../../../injector.dart';
import '../../redux/viewmodels/manage_store_vm_v2.dart';
import 'package:littlefish_merchant/common/presentaion/components/labels/section_header.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class DeliveryPreferencePage extends StatefulWidget {
  static const String route = '/delivery_preference_page';

  const DeliveryPreferencePage({Key? key}) : super(key: key);
  @override
  State<DeliveryPreferencePage> createState() => _DeliveryPreferencePageState();
}

class _DeliveryPreferencePageState extends State<DeliveryPreferencePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool? changed;
  bool _hasUnsavedChanges = false;

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
        if (vm.item!.deliverySettings == null) {
          vm.item!.deliverySettings = DeliverySettings(enabled: false);
        }
        return scaffold(context, vm);
      },
    );
  }

  scaffold(BuildContext context, ManageStoreVMv2 vm) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (AppVariables.store!.state.enableSideNavDrawer ?? false);
    return KeyboardDismissalUtility(
      content: AppScaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        centreTitle: false,
        title: 'Delivery Settings',
        enableProfileAction: false,
        hasDrawer: false,
        displayNavDrawer: false,
        body: vm.isLoading!
            ? const AppProgressIndicator()
            : layout(context, vm),
        actions: [
          if (vm.store!.state.storeState.store?.isConfigured == false)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('1/2'),
            ),
        ],
        persistentFooterButtons: [
          FooterButtonsSecondaryPrimary(
            secondaryButtonText:
                vm.store!.state.storeState.store?.isConfigured == true
                ? 'Cancel'
                : 'Back',
            onSecondaryButtonPressed: (ctx) async {
              if (_hasUnsavedChanges) {
                bool? discard = await getIt<ModalService>().showActionModal(
                  context: context,
                  title: 'Discard Changes?',
                  description:
                      'You have unsaved delivery settings. Are you sure you want to leave this page?',
                  acceptText: 'Yes, Discard & Leave',
                  cancelText: 'No, Stay',
                );

                if (discard != true) return;
              }

              Navigator.of(context).pop();
            },
            primaryButtonText:
                vm.store!.state.storeState.store?.isConfigured == true
                ? 'Update settings'
                : 'Next',
            onPrimaryButtonPressed: (ctx) async {
              bool verified = false;

              if (vm.item!.deliverySettings!.enabled) {
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

              if (!verified || vm.item == null) return;

              await vm.upsertStore(vm.item!).then((_) {
                navigateToPostPage(context, vm);
              });

              setState(() {
                _hasUnsavedChanges = false;
                changed = false;
              });
            },
          ),
        ],
      ),
    );
  }

  layout(BuildContext context, ManageStoreVMv2 vm) => SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SwitchListTile(
          activeColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
          contentPadding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          title: context.paragraphMedium(
            'Enable Delivery',
            alignLeft: true,
            isSemiBold: true,
          ),
          value: vm.item!.deliverySettings!.enabled,
          onChanged: (val) {
            if (mounted) {
              setState(() {
                vm.item!.deliverySettings!.enabled = val;
                _hasUnsavedChanges = true;
                changed = true;
              });
            }
          },
        ),
        if (vm.item!.deliverySettings!.enabled) form(context, vm),
      ],
    ),
  );

  form(BuildContext context, ManageStoreVMv2 vm) => Form(
    key: _formKey,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader('Delivery Depot', horizontalPadding: 16),
        ListTile(
          tileColor: Theme.of(context).colorScheme.background,
          // iconColor: Theme.of(context).colorScheme.primary,
          leading: ControlCheckBox(
            isSelected:
                (vm.item!.deliverySettings?.useBusinessAddress ?? false) &&
                haveBusinessAddress(vm),
            onChanged: (newValue) async {
              if (mounted) {
                setState(() {
                  _hasUnsavedChanges = true;
                  changed = true;
                  vm.item!.deliverySettings!.useBusinessAddress = newValue;
                  if (haveBusinessAddress(vm)) {
                    vm.item!.deliverySettings!.deliveryAddress =
                        getBusinessAddress(vm);
                  }
                });
              }
            },
          ),
          title: context.body02x14R(
            'Use your business address as the point from which deliveries are made',
            alignLeft: true,
            color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
          ),
        ),
        if (!haveBusinessAddress(vm))
          const Text(
            '*Please update business information, no business address found',
            style: TextStyle(color: Colors.red, fontSize: 12),
            textAlign: TextAlign.left,
          ),
        if (!((vm.item!.deliverySettings?.useBusinessAddress ?? false) &&
            haveBusinessAddress(vm)))
          Padding(
            padding: const EdgeInsets.all(16),
            child: GoogleAddressFormField(
              useOutlineStyling: true,
              isRequired: vm.item!.deliverySettings!.enabled ?? false,
              maxLines: 3,
              key: const Key('deliveryAddress'),
              initialValue: vm.item!.deliverySettings?.deliveryAddress,
              onFieldSubmitted: (addressText, address) {
                if (mounted) {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _hasUnsavedChanges = true;
                    changed = true;
                    vm.item!.deliverySettings!.deliveryAddress = addressText;
                  });
                  FocusScope.of(context).unfocus();
                }
              },
              onSaveValue: (value) {
                vm.item!.deliverySettings!.deliveryAddress = value;
              },
              hintText: 'Search for delivery depot address',
              labelText: 'Select Delivery Depot Location',
            ),
          ),
        const SectionHeader('Delivery Distance', horizontalPadding: 16),
        Padding(
          padding: const EdgeInsets.all(16),
          child: NumericFormField(
            validationErrorMessage: 'Maximum delivery distance cannot be 0km',
            useOutlineStyling: true,
            isRequired: true,
            hintText: '100km',
            key: const Key('delivery_distance'),
            labelText: 'Set maximum delivery distance',
            onFieldSubmitted: (value) {
              if (mounted) {
                setState(() {
                  vm.item!.deliverySettings!.deliveryRadius = value;
                  _hasUnsavedChanges = true;
                  changed = true;
                });
              }
            },
            onChanged: (value) {
              if (mounted) {
                setState(() {
                  _hasUnsavedChanges = true;
                  changed = true;
                });
              }
            },
            inputAction: TextInputAction.done,
            initialValue: vm.item!.deliverySettings?.deliveryRadius ?? 10,
            onSaveValue: (value) {
              vm.item!.deliverySettings!.deliveryRadius = value;
            },
          ),
        ),
        const SectionHeader('Delivery Fee', horizontalPadding: 16),
        SwitchListTile(
          activeColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: const Text('Charge Delivery Fee'),
          value: vm.item!.storePreferences!.onlineFee?.enabled ?? false,
          onChanged: (val) {
            if (mounted) {
              setState(() {
                final onLineFeeOk =
                    vm.item!.storePreferences!.onlineFee != null;
                if (onLineFeeOk) {
                  vm.item!.storePreferences!.onlineFee!.enabled = val;
                  _hasUnsavedChanges = true;
                  changed = true;
                }
              });
            }
          },
        ),
        if (vm.item!.storePreferences!.onlineFee?.enabled ?? false)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ChipSelectable(
                    onTap: (ctx) {
                      if (mounted) {
                        setState(() {
                          vm.setDeliveryCostToFixedAmount();
                        });
                      }
                    },
                    text: 'Fixed Amount',
                    selected:
                        vm.item!.storePreferences!.onlineFee!.isFixedAmount ==
                        true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ChipSelectable(
                    onTap: (ctx) {
                      if (mounted) {
                        setState(() {
                          vm.setDeliveryCostToVariableAmount();
                        });
                      }
                    },
                    text: 'Variable Amount',
                    selected:
                        vm
                            .item!
                            .storePreferences!
                            .onlineFee!
                            .isVariableAmount ==
                        true,
                  ),
                ),
              ],
            ),
          ),
        if (vm.item!.storePreferences!.onlineFee?.enabled ?? false)
          Container(
            padding: const EdgeInsets.all(16),
            height: 88,
            child: CurrencyFormField(
              useOutlineStyling: true,
              showExtra: false,
              hintText: '25',
              isRequired: true,
              key: const Key('deliveryCost'),
              labelText: vm.item!.storePreferences!.onlineFee!.isVariableAmount!
                  ? 'Cost Per km'
                  : 'Delivery Cost',
              initialValue: vm.item!.storePreferences!.onlineFee?.amount,
              onChanged: (value) {
                vm.item!.storePreferences!.onlineFee!.amount = value;
              },
              onSaveValue: (value) {
                vm.item!.storePreferences!.onlineFee!.amount = value;
              },
              onFieldSubmitted: (value) {
                if (mounted) {
                  setState(() {
                    _hasUnsavedChanges = true;
                    changed = true;
                    vm.item!.storePreferences!.onlineFee!.amount = value;
                  });
                }
              },
              enabled: true,
              inputAction: TextInputAction.done,
            ),
          ),
        SwitchListTile(
          activeColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: const Text('Enable free delivery'),
          value: vm.item!.storePreferences!.freeDelivery?.enabled ?? false,
          onChanged: (val) {
            if (mounted) {
              final freeDeliveryOk =
                  vm.item!.storePreferences!.freeDelivery != null;
              if (freeDeliveryOk) {
                setState(() {
                  vm.item!.storePreferences!.freeDelivery!.enabled = val;
                  _hasUnsavedChanges = true;
                  changed = true;
                });
              }
            }
          },
        ),
        if (vm.item!.storePreferences!.freeDelivery?.enabled ?? false)
          Container(
            padding: const EdgeInsets.all(16),
            height: 88,
            child: CurrencyFormField(
              useOutlineStyling: true,
              showExtra: false,
              hintText: '25',
              isRequired: false,
              key: const Key('minOrderValue'),
              labelText: 'Minimum order value for the free delivery',
              initialValue: vm.item!.storePreferences?.freeDelivery?.amount,
              onChanged: (value) {
                vm.item!.storePreferences!.freeDelivery?.amount = value;
              },
              onSaveValue: (value) {
                vm.item!.storePreferences!.freeDelivery?.amount = value;
              },
              onFieldSubmitted: (value) {
                if (mounted) {
                  setState(() {
                    _hasUnsavedChanges = true;
                    changed = true;
                    vm.item!.storePreferences!.freeDelivery?.amount = value;
                  });
                }
              },
              enabled: true,
              inputAction: TextInputAction.done,
            ),
          ),
        const SectionHeader('Delivery Instructions', horizontalPadding: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: StringFormField(
            minLines: 3,
            maxLines: 3,
            isRequired: false,
            useRegex: false,
            useOutlineStyling: true,
            key: const Key('deliveryInstructions'),
            initialValue: vm.item!.deliverySettings?.deliveryInstructions,
            onSaveValue: (value) {
              vm.item!.deliverySettings!.deliveryInstructions = value;
            },
            onFieldSubmitted: (value) {
              if (mounted) {
                setState(() {
                  _hasUnsavedChanges = true;
                  changed = true;

                  vm.item!.deliverySettings!.deliveryInstructions = value;
                  FocusScope.of(context).unfocus();
                });
              }
            },
            hintText: 'Add delivery instructions here',
            labelText: 'Delivery Instructions',
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
      ).push(CustomRoute(builder: (ctx) => const CollectionPreferencePage()));
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
