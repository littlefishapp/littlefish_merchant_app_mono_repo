import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/security/verification.dart';
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/add_linked_account_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/linked_account_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/utils/linked_account_utils.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/widgets/provider_image_display.dart';
import 'package:quiver/strings.dart';

import '../../../../common/presentaion/components/icons/delete_icon.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../redux/app/app_state.dart';

class LinkedAccountsPage extends StatelessWidget {
  static const route = 'business/linked-accounts';

  const LinkedAccountsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LinkedAccountVM>(
      converter: (store) => LinkedAccountVM.fromStore(store),
      builder: (BuildContext context, LinkedAccountVM vm) {
        final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
        final showSideNav =
            isTablet ||
            (AppVariables.store!.state.enableSideNavDrawer ?? false);
        return AppScaffold(
          enableProfileAction: !showSideNav,
          hasDrawer: false,
          displayNavDrawer: false,
          displayFloat: true,
          floatLocation: FloatingActionButtonLocation.miniEndFloat,
          title: 'Linked Accounts',
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: vm.isLoading!
                ? const AppProgressIndicator()
                : vm.linkedAccounts == null || vm.linkedAccounts!.isEmpty
                ? Center(child: context.labelMedium('No linked accounts'))
                : _layout(context, vm),
          ),
          persistentFooterButtons: [
            ButtonPrimary(
              text: 'Add Linked Account',
              onTap: (ctx) {
                Navigator.of(context).push(
                  CustomRoute(builder: (ctx) => AddLinkedAccountPage(vm: vm)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _layout(context, LinkedAccountVM vm) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: (vm.linkedAccounts?.length ?? 0),
      itemBuilder: (BuildContext context, int index) {
        var item = vm.linkedAccounts![index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            tileColor: Theme.of(context).extension<AppliedSurface>()?.primary,
            leading:
                isNotBlank(
                  LinkedAccountUtils.getProviderDisplayImage(
                    providerName: item.providerName ?? '',
                    imageURI: item.imageURI ?? '',
                  ),
                )
                ? ProviderImageDisplay(
                    imagePath: item.imageURI ?? '',
                    providerName: item.providerName ?? '',
                  )
                : const Icon(Icons.label),
            title: context.labelMedium(
              LinkedAccountUtils.cleanUpProviderName(item.providerName ?? ''),
              isBold: true,
            ),
            trailing: PopupMenuButton(
              color: Theme.of(context).colorScheme.onPrimary,
              elevation: 1,
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      context.body02x14R('View/Edit'),
                      const Icon(Icons.edit),
                    ],
                  ),
                ),
                if (item.providerType != ProviderType.wizzitTapToPay)
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        context.body02x14R('Delete'),
                        const DeleteIcon(),
                      ],
                    ),
                  ),
              ],
              onSelected: (dynamic value) async {
                if (value == 'edit') {
                  await Navigator.of(context).push(
                    CustomRoute(
                      builder: (ctx) => LinkedAccountUtils.buildProviderPage(
                        context,
                        item.providerType!,
                        vm,
                        item,
                      ),
                    ),
                  );
                } else {
                  await getIt<ModalService>()
                      .showActionModal(
                        context: context,
                        title: 'Delete Account?',
                        description:
                            'Are you sure you want to delink this account?',
                      )
                      .then((value) {
                        if (value!) {
                          item.deleted = true;
                          item.enabled = false;
                          vm.setAccount(item);
                          vm.runUpsert(context);
                          if (item.providerType == ProviderType.cRDB ||
                              item.providerType == ProviderType.kYC) {
                            vm.setVerificationStatus(
                              context,
                              VerificationStatus.notStarted,
                            );
                          }
                        }
                      });
                }
              },
            ),
            onTap: () async {
              await Navigator.of(context).push(
                CustomRoute(
                  builder: (ctx) => LinkedAccountUtils.buildProviderPage(
                    context,
                    item.providerType!,
                    vm,
                    item,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
