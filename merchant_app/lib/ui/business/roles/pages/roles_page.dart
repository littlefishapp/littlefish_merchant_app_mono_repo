import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_discard.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:littlefish_merchant/models/permissions/business_role.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/ui/business/roles/permission_vm.dart';
import 'package:littlefish_merchant/ui/business/roles/widgets/permission_group_list_view.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class RolesPage extends StatefulWidget {
  static const String route = 'business/system-roles-page';

  final BusinessRole? role;

  final bool isNew;

  const RolesPage({Key? key, this.role, required this.isNew}) : super(key: key);

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  FormManager? _form;

  TextStyle formTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
    );
  }

  @override
  void initState() {
    _form = FormManager(formKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PermissionVM>(
      converter: (Store store) =>
          PermissionVM.fromStore(store as Store<AppState>),
      builder: (BuildContext ctx, PermissionVM vm) {
        return scaffold(context, vm);
      },
    );
  }

  Widget scaffold(BuildContext context, PermissionVM vm) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (AppVariables.store!.state.enableSideNavDrawer ?? false);
    return KeyboardDismissalUtility(
      content: AppScaffold(
        actions: [
          if (!widget.isNew && vm.currentBusinessRole?.systemRole != true)
            _deleteRoleButton(vm.currentBusinessRole!, vm),
        ],
        title: vm.currentBusinessRole?.name ?? 'Create New Role',
        enableProfileAction: !showSideNav,
        hasDrawer: showSideNav,
        displayNavDrawer: showSideNav,
        persistentFooterButtons: [
          vm.currentBusinessRole?.systemRole == true
              ? ButtonSecondary(
                  text: 'Back',
                  onTap: (_) {
                    Navigator.of(context).pop();
                  },
                )
              : FooterButtonsSecondaryPrimary(
                  primaryButtonText: 'Save',
                  onSecondaryButtonPressed: (ctx) {
                    Navigator.of(context).pop();
                  },
                  secondaryButtonText: 'Cancel',
                  onPrimaryButtonPressed: _isButtonDisabled(vm)
                      ? null
                      : (ctx) async {
                          if (vm.currentBusinessRole?.systemRole == false) {
                            if (formKey.currentState?.validate() ?? false) {
                              formKey.currentState!.save();
                              await vm.upsertBusinessRole!(
                                vm.currentBusinessRole!,
                              );
                            }
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                ),
        ],
        body: vm.isLoading!
            ? const AppProgressIndicator()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _roleDetails(context, vm),
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: Theme.of(context)
                          .extension<AppliedTextIcon>()
                          ?.secondary
                          .withOpacity(0.05),
                    ),
                    PermissionGroupListView(vm: vm),
                  ],
                ),
              ),
      ),
      parentContext: context,
    );
  }

  _roleDetails(BuildContext context, PermissionVM vm) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    color: Colors.white,
    child: Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: context.labelMediumBold('Role Details'),
        ),
        Form(
          key: _form!.key,
          child: Column(
            children: [
              StringFormField(
                useOutlineStyling: true,
                enabled: vm.currentBusinessRole?.systemRole == false,
                initialValue: vm.currentBusinessRole?.name ?? '',
                hintText: 'Enter Role Name',
                hintStyle: formTextStyle(context),
                labelStyle: formTextStyle(context),
                textStyle: context.styleParagraphSmallSemiBold,
                outLineInputBorderStyle: context.inputBorderEnabled(),
                focusOutLineInputBorderStyle: context.inputBorderEnabled(),
                key: const Key('name'),
                labelText: 'Name',
                onSaveValue: (value) {
                  if (mounted) {
                    setState(() {
                      vm.currentBusinessRole!.name = value;
                    });
                  }
                },
                onFieldSubmitted: (value) {
                  if (mounted) {
                    setState(() {
                      vm.currentBusinessRole!.name = value;
                    });
                  }
                },
                isRequired: vm.currentBusinessRole?.systemRole == false,
              ),
              const SizedBox(height: 16),
              StringFormField(
                useOutlineStyling: true,
                initialValue: vm.currentBusinessRole?.description ?? '',
                enabled: vm.currentBusinessRole?.systemRole == false,
                minLines: 4,
                maxLines: 8,
                hintStyle: formTextStyle(context),
                labelStyle: formTextStyle(context),
                textStyle: context.styleParagraphSmallSemiBold!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                outLineInputBorderStyle: context.inputBorderEnabled(),
                focusOutLineInputBorderStyle: context.inputBorderEnabled(),
                hintText: 'What does this role do?',
                key: const Key('description'),
                labelText: 'Description',
                onSaveValue: (value) {
                  if (mounted) {
                    setState(() {
                      vm.currentBusinessRole!.description = value;
                    });
                  }
                },
                onFieldSubmitted: (value) {
                  if (mounted) {
                    setState(() {
                      vm.currentBusinessRole?.description = value;
                    });
                  }
                },
                isRequired: vm.currentBusinessRole?.systemRole == false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    ),
  );

  Widget _deleteRoleButton(BusinessRole role, PermissionVM vm) {
    return ButtonDiscard(
      isIconButton: true,
      enablePopPage: true,
      backgroundColor: Colors.transparent,
      borderColor: Colors.transparent,
      modalTitle: 'Delete ${role.name} role?',
      modalDescription:
          'Are you sure you want to delete this role?\nThis cannot be undone.',
      modalAcceptText: 'Yes. Delete Role',
      modalCancelText: 'No, Cancel',
      onDiscard: (ctx) async {
        Navigator.of(context).pop();
        if (mounted) {
          await vm.deleteBusinessRole!(role);
        }
      },
    );
  }

  bool _isButtonDisabled(PermissionVM vm) {
    return isBlank(vm.currentBusinessRole?.name ?? '') ||
        isBlank(vm.currentBusinessRole?.description ?? '') ||
        (vm.currentBusinessRole?.permissions ?? []).isEmpty;
  }
}
