// remove ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, implementation_imports
// flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_informational.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';

// package imports
import 'package:redux/src/store.dart';
import 'package:quiver/strings.dart';

// project imports
import 'package:littlefish_merchant/ui/online_store/tools.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/domain_name_info_widget.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/models/online/subdomain_validator.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';

import '../../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../../common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';

class OnlineStoreDomainNamePage extends StatefulWidget {
  static const route = 'online-store/domain-name';

  const OnlineStoreDomainNamePage({Key? key}) : super(key: key);

  @override
  State<OnlineStoreDomainNamePage> createState() =>
      _OnlineStoreDomainNamePageState();
}

class _OnlineStoreDomainNamePageState extends State<OnlineStoreDomainNamePage> {
  String? _subDomain;
  late SubDomainValidator _subDomainValidator;
  late bool _isSubDomainValid;
  SubDomainValidatorResponse? _validationResult;
  String? _validationMessage;
  late bool _showValidationMessage;
  bool _hasUnsavedChanges = false;
  String? _subDomainCopyOnSubmit;

  @override
  void initState() {
    _isSubDomainValid = false;
    _showValidationMessage = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVMv2>(
      onInit: (store) async {
        var onlineStore = store.state.storeState.store;
        _subDomain = onlineStore?.uniqueSubdomain;
        if (isNotBlank(_subDomain)) {
          _subDomainCopyOnSubmit = String.fromCharCodes(_subDomain!.codeUnits);
        }
        _subDomainValidator = SubDomainValidator(
          storeId: onlineStore!.id!,
          appStore: store,
        );
      },
      converter: (store) => ManageStoreVMv2.fromStore(store),
      builder: (BuildContext context, ManageStoreVMv2 vm) {
        return scaffold(vm);
      },
    );
  }

  scaffold(ManageStoreVMv2 vm) {
    return KeyboardDismissalUtility(
      content: AppScaffold(
        title: 'Add Domain',
        centreTitle: false,
        body: vm.isLoading != true
            ? layout(context, vm)
            : const AppProgressIndicator(),
        actions: [_reserveDomain(vm)],
        persistentFooterButtons: [
          FooterButtonsSecondaryPrimary(
            secondaryButtonText: 'Cancel',
            onSecondaryButtonPressed: (ctx) async {
              if (_hasUnsavedChanges) {
                bool? discard = await getIt<ModalService>().showActionModal(
                  context: context,
                  title: 'Discard Changes?',
                  description:
                      'Are you sure you want to leave? Your domain changes will be discarded.',
                  acceptText: 'Yes, Leave',
                  cancelText: 'No, Stay',
                );

                if (discard != true) return;
              }

              Navigator.of(context).pop();
            },
            primaryButtonText: 'Add Domain',
            onPrimaryButtonPressed: (ctx) async {
              _onSubdomainSubmitted(_subDomain, vm);
              if (!_isSubDomainValid) return;
              bool? isAccepted = await getIt<ModalService>().showActionModal(
                context: context,
                title: 'Add Domain?',
                description:
                    'Are you sure you want to save your domain? This cannot be changed.',
                acceptText: 'Yes, Add Domain',
                cancelText: 'No, Cancel',
              );

              if (isAccepted != true) return;

              vm.store?.dispatch(SetStoreLoadingAction(true));
              vm.store?.dispatch(SetStoreDomainIsLiveAction(true));
              vm.store?.dispatch(
                SetStoreSubDomainAction(_subDomain!.toLowerCase()),
              );
              vm.store?.dispatch(setStoreUrlWithSubdomain(_subDomain!));
              vm.upsertStore(vm.item!);
              vm.store?.dispatch(SetStoreLoadingAction(false));
              Navigator.of(
                context,
              ).pushNamed(getOnlineStoreRoute(vm.item?.isConfigured ?? false));
            },
          ),
        ],
        enableProfileAction: false,
      ),
      parentContext: context,
      onCloseKeyboard: (ctx) async {
        await _onSubdomainSubmitted(_subDomain, vm);
      },
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
            const SizedBox(height: 16),
            context.headingXSmall(
              'Please search for a domain name',
              isBold: true,
              color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
            ),
            DomainNameInfoWidget(domainExampleText: _subDomain),
            Visibility(
              visible: !_isSubDomainValid && isNotBlank(_validationMessage),
              child: _validationMessageWidget(context),
            ),
            const SizedBox(height: 16),
            _domainNameField(vm),
          ],
        ),
      ),
    );
  }

  Widget _domainNameField(ManageStoreVMv2 vm) {
    return StringFormField(
      hintText: 'domain-name',
      maxLength: 50,
      enabled: vm.item!.isDomainLive != true,
      enforceMaxLength: true,
      useOutlineStyling: true,
      autoValidate: false,
      key: const Key('domain-name'),
      labelText: 'Domain-Name',
      initialValue: _subDomainCopyOnSubmit,
      textCapitalization: TextCapitalization.none,
      onFieldSubmitted: (value) async => await _onSubdomainSubmitted(value, vm),
      asyncValidator: (value) async {
        await _validateSubDomain(value, vm.store);
        return _validationMessage;
      },
      onChanged: (value) {
        final current = value.trim().toLowerCase();
        final initial = _subDomainCopyOnSubmit?.trim().toLowerCase() ?? '';

        _subDomain = current;

        if (mounted) {
          setState(() {
            _hasUnsavedChanges = current != initial;
          });
        }
      },
      inputAction: TextInputAction.done,
      isRequired: false,
      onSaveValue: (value) {
        if (isBlank(value)) return;
        vm.store?.dispatch(SetStoreSubDomainAction(value!.toLowerCase()));
      },
    );
  }

  _onSubdomainSubmitted(String? value, ManageStoreVMv2 vm) async {
    await _validateSubDomain(value, vm.store);
    if (!_isSubDomainValid) {
      if (mounted) {
        setState(() {
          _showValidationMessage = true;
          _subDomainCopyOnSubmit = null;
          _isSubDomainValid = false;
        });
      }
      return;
    }
    if (mounted) {
      setState(() {
        _isSubDomainValid = true;
        _subDomain = value;
        _subDomainCopyOnSubmit = value;
      });
    }
  }

  _reserveDomain(ManageStoreVMv2 vm) {
    return Visibility(
      visible: isNotTrue(vm.item?.isDomainLive),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ButtonText(
            onTap: (_) async {
              await _onSubdomainSubmitted(_subDomain, vm);
              if (!_isSubDomainValid) return;

              bool? isAccepted = await getIt<ModalService>().showActionModal(
                context: context,
                title: 'Save Domain?',
                description: 'Are you sure you want to save your domain?',
                acceptText: 'Yes, Save Domain',
                cancelText: 'No, Cancel',
              );

              if (isAccepted != true) return;

              vm.store?.dispatch(
                SetStoreSubDomainAction(_subDomain!.toLowerCase()),
              );

              var completer = snackBarCompleter(
                context,
                'Domain saved and reserved successfully.',
                shouldPop: false,
                durationMilliseconds: 2000,
              );

              await vm.upsertStore(vm.item!, completer: completer);

              if (mounted) {
                setState(() {
                  _hasUnsavedChanges = false;
                  _subDomainCopyOnSubmit = _subDomain;
                });
              }
            },
            text: 'Save',
            isNeutral: _isSubDomainValid ? true : false,
          ),
        ),
      ),
    );
  }

  _validateSubDomain(String? subdomain, Store<AppState>? store) async {
    store?.dispatch(SetStoreLoadingAction(true));
    _validationResult = await _subDomainValidator.validate(subdomain);
    _validationMessage = _subDomainValidator.getValidationMessage(
      _validationResult!,
    );
    _isSubDomainValid = _validationResult == SubDomainValidatorResponse.success;
    _showValidationMessage = _isSubDomainValid == false;
    store?.dispatch(SetStoreLoadingAction(false));
  }

  _validationMessageWidget(BuildContext context) {
    if (_validationMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        _validationMessage!,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Theme.of(
            context,
          ).extension<AppliedInformational>()?.warningText,
        ),
      ),
    );
  }
}
