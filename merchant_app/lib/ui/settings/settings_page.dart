// removed ignore: depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/bottomNavBar/bottom_navbar.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/viewer/resource_viewer.dart';
import 'package:littlefish_merchant/features/delete_account/domain/usecase/get_delete_account_info.dart';
import 'package:littlefish_merchant/features/delete_account/presentation/pages/delete_account_page.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/bloc/linkeddevices_bloc.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/pages/linked_devices_page.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/stores/stores.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/linked_acounts_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/credit/store_credit_settings_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/payments/settings_payment_types.dart';
import 'package:littlefish_merchant/ui/settings/pages/permissions/settings_device_permissions_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/tax/sales_tax_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/tickets/ticket_settings_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';

import '../../injector.dart';

class SettingsPage extends StatelessWidget {
  static const String route = '/settings';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    var state = store.state;
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (AppVariables.store!.state.enableSideNavDrawer ?? false);
    return AppScaffold(
      navBar: const BottomNavBar(page: PageType.more),
      title: 'Settings',
      enableProfileAction: !showSideNav,
      hasDrawer: showSideNav,
      displayNavDrawer: showSideNav,
      body: StoreBuilder<AppState>(
        builder: (BuildContext context, Store<AppState> vm) => Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  const CommonDivider(),
                  if (userHasPermission(allowBusinessDetails))
                    settingItem(
                      context,
                      'Manage Business',
                      null,
                      icon: Icons.store,
                      subtitle: 'Manage your business information',
                      onTap: () => store.dispatch(editBusinessProfile(context)),
                    ),
                  if (userHasPermission(allowPaymentTypesAndLinkedAccounts))
                    settingItem(
                      context,
                      'Payment Types',
                      SettingPaymentTypes.route,
                      icon: Icons.payment,
                      subtitle: 'Manage your accepted payment types',
                    ),
                  if (AppVariables.store!.state.enableTax == true &&
                      userHasPermission(allowBusinessDetails))
                    settingItem(
                      context,
                      'Sales Tax',
                      SalesTaxPage.route,
                      icon: MdiIcons.walletMembership,
                      subtitle: 'Setup your taxes',
                    ),
                  if (userHasRole(administratorRoleName))
                    settingItem(
                      context,
                      'Parked Cart Preferences',
                      TicketSettingsPage.route,
                      icon: Icons.event,
                      subtitle: 'Manage parked cart creation on checkout',
                    ),
                  if (AppVariables.store!.state.enableStoreCredit == true &&
                      userHasPermission(allowStoreCredit))
                    settingItem(
                      context,
                      'Store Credit',
                      StoreCreditSettingsPage.route,
                      icon: Icons.payment,
                      subtitle: 'Enable store credit and more',
                    ),
                  if (userHasPermission(allowPaymentTypesAndLinkedAccounts))
                    settingItem(
                      context,
                      'Linked Accounts',
                      LinkedAccountsPage.route,
                      icon: Icons.account_balance_wallet,
                      subtitle: 'Manage Accounts',
                    ),
                  if ((AppVariables.store!.state.enableLinkedDevices ?? true) &&
                      (userHasPermission(allowViewCurrentTerminal) ||
                          userHasPermission(allowViewAllTerminals)))
                    settingItem(
                      context,
                      'Linked Devices',
                      LinkedDevicesPage.route,
                      icon: Icons.devices,
                      subtitle: 'Manage Merchant Terminals',
                      onTap: () async {
                        context.read<LinkedDevicesBloc>().add(
                          ScheduleDeviceManagement(),
                        );
                        await Navigator.of(
                          context,
                        ).pushNamed(LinkedDevicesPage.route);
                      },
                    ),
                  settingItem(
                    context,
                    'Device Permissions',
                    SettingsDevicePermissionsPage.route,
                    icon: Platform.isAndroid
                        ? Icons.android
                        : FontAwesomeIcons.apple,
                    subtitle: 'Setup permissions to the device',
                  ),
                  settingItem(
                    context,
                    'About',
                    null,
                    icon: LittleFishIcons.info,
                    subtitle: 'Details about ${state.appName}',
                    onTap: () => showCustomAboutDialog(
                      context: context,
                      applicationName: state.appName ?? '',
                      applicationVersion:
                          'Version: ${state.version}, Build: ${state.builderNumber}',
                      cohort: getCohort(),
                      applicationIcon: SizedBox(
                        height: 32,
                        width: 32,
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          child: Image(
                            image: AssetImage(UIStateData().appLogo),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      enableViewCustom: true,
                      viewCustom: 'View Terms and Conditions',
                      onTapViewCustom: () {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            CustomRoute(
                              builder: (ctx) => ResourceViewer(
                                url: AppVariables.termsAndConditions,
                                title: 'Terms and Conditions',
                                isAsset: _isAsset(
                                  AppVariables.termsAndConditions,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  settingItem(
                    context,
                    'Clear Cache',
                    null,
                    icon: Icons.delete,
                    subtitle: 'Clear all locally stored data',
                    onTap: () {
                      showProgress(context: context);
                      SalesStore()
                          .clear()
                          .then((_) {
                            hideProgress(context);

                            showMessageDialog(
                              context,
                              'Local storage cleared',
                              Icons.check,
                            );
                          })
                          .catchError((error) {
                            hideProgress(context);
                            showMessageDialog(
                              context,
                              'We are unable to clear local storage at this time, please try again later',
                              LittleFishIcons.error,
                            );

                            reportCheckedError(
                              error,
                              trace: StackTrace.current,
                            );
                          });
                    },
                  ),
                  settingItem(
                    context,
                    'Privacy Policy',
                    null,
                    icon: Platform.isAndroid
                        ? Icons.android
                        : FontAwesomeIcons.apple,
                    subtitle: 'Show privacy policy',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ResourceViewer(
                          url: AppVariables.privacyPolicy,
                          title: 'Privacy Policy',
                          isAsset: _isAsset(AppVariables.privacyPolicy),
                        ),
                      ),
                    ),
                  ),
                  if (state.enableDeleteAccountPage == true)
                    settingItem(
                      context,
                      'Delete Account',
                      null,
                      icon: Icons.do_not_disturb_alt,
                      subtitle:
                          'Delete all of your account information, '
                          'including your business if you are the owner',
                      color: Theme.of(context).colorScheme.error,
                      onTap: () async {
                        final deleteInfo = getDeleteAccountInfo();
                        if (deleteInfo.deleteAccountActionVisible) {
                          if (deleteInfo.deleteAccountAllowed) {
                            await getIt<ModalService>()
                                .showActionModal(
                                  context: context,
                                  title: 'Delete Account?',
                                  description:
                                      'Are you sure you want to delete your '
                                      'account?  This cannot be reversed!',
                                )
                                .then((response) {
                                  if (response ?? false) {
                                    store.dispatch(
                                      deleteAccount(
                                        uid: state.currentUser?.uid,
                                        completer: snackBarCompleter(
                                          context,
                                          'User was deleted',
                                        ),
                                        context: context,
                                      ),
                                    );
                                  }
                                });
                          } else {
                            Navigator.of(
                              context,
                            ).pushNamed(DeleteAccountPage.route);
                          }
                        }
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isAsset(String value) {
    return value.contains('asset');
  }

  SizedBox logoutButton(context) => SizedBox(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 60,
      alignment: Alignment.center,
      child: ButtonPrimary(
        elevation: 7.5,
        buttonColor: Theme.of(context).colorScheme.secondary,
        text: 'Logout',
        textColor: Colors.white,
        onTap: (context) {
          StoreProvider.of<AppState>(
            context,
          ).dispatch(signOut(reason: 'user-logout'));
        },
      ),
    ),
  );

  Widget settingItem(
    BuildContext context,
    String title,
    String? route, {
    Function? onTap,
    IconData? icon,
    String subtitle = '',
    Color? color,
  }) {
    return ListTile(
      leading: ListLeadingIconTile(icon: icon, color: color),
      title: context.labelSmall(title, alignLeft: true, isBold: true),
      subtitle: context.labelSmall(subtitle),
      trailing: Icon(
        Platform.isIOS ? Icons.arrow_forward_ios : Icons.arrow_forward,
      ),
      onTap: onTap == null
          ? () {
              if (route != null) {
                Navigator.of(context).pushNamed(route);
              }
            }
          : () {
              onTap();
            },
    );
  }
}
