// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/models/permissions/business_role.dart';
import 'package:littlefish_merchant/shared/list/generate_list_tile.dart';
import 'package:littlefish_merchant/ui/business/roles/pages/roles_page.dart';
import 'package:littlefish_merchant/ui/business/roles/permission_vm.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class ManageRolesPage extends StatefulWidget {
  static const String route = 'business/system-roles';

  const ManageRolesPage({Key? key}) : super(key: key);

  @override
  State<ManageRolesPage> createState() => _ManageRolesPageState();
}

class _ManageRolesPageState extends State<ManageRolesPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PermissionVM>(
      converter: (Store store) =>
          PermissionVM.fromStore(store as Store<AppState>),
      builder: (BuildContext ctx, PermissionVM vm) => scaffold(context, vm),
    );
  }

  AppScaffold scaffold(BuildContext context, PermissionVM vm) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (vm.store?.state.enableSideNavDrawer ?? false);
    return AppScaffold(
      enableProfileAction: !showSideNav,
      hasDrawer: showSideNav,
      displayNavDrawer: showSideNav,
      title: 'Manage Roles',
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      persistentFooterButtons: [_footerButtons(vm)],
      body: !vm.isLoading! ? layout(context, vm) : const AppProgressIndicator(),
    );
  }

  layout(BuildContext context, PermissionVM vm) => SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      children: [
        const SizedBox(height: 16),
        GenerateListView(
          items: vm.businessRoles ?? [],
          context: context,
          trailingOnTap: (item, ctx) async {
            BusinessRole role = item as BusinessRole;

            bool? proceed = await getIt<ModalService>().showActionModal(
              context: context,
              title: 'Delete ${role.name} role?',
              description:
                  'Are you sure you want to delete this role?\nThis cannot be undone.',
              acceptText: 'Yes. Delete Role',
              cancelText: 'No, Cancel',
            );

            if (proceed == true) {
              await vm.deleteBusinessRole!(role);
              if (mounted) {
                setState(() {});
              }
            }
          },
          onTap: (item, ctx) async {
            BusinessRole role = item as BusinessRole;
            await vm.setCurrentBusinessRole!(role);
            await Future.delayed(Duration.zero, () {
              Navigator.of(context).push(
                CustomRoute(
                  maintainState: true,
                  builder: (BuildContext context) =>
                      const RolesPage(isNew: false),
                ),
              );
            });
          },
        ).getListView(vm: vm),
      ],
    ),
  );

  Widget _footerButtons(PermissionVM vm) {
    return FooterButtonsIconPrimary(
      primaryButtonText: 'Add New Role',
      onPrimaryButtonPressed: (ctx) {
        vm.setCurrentBusinessRole!(
          BusinessRole.create(
            businessId: vm.store!.state.businessId!,
            createdBy: vm.store!.state.userProfile!.userId!,
          ),
        );
        Navigator.of(context).push(
          CustomRoute(
            maintainState: true,
            builder: (BuildContext context) => const RolesPage(isNew: true),
          ),
        );
      },
      secondaryButtonIcon: Icons.refresh,
      onSecondaryButtonPressed: (context) => vm.fetchBusinessRoles(),
    );
  }
}
