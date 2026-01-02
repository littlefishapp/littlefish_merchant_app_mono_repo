import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_button.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/password_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/viewer/resource_viewer.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/bloc/linkeddevices_bloc.dart';
import 'package:littlefish_merchant/models/security/access_management/module.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import '../../app/app.dart';
import '../../app/theme/applied_system/applied_surface.dart';
import '../../app/theme/applied_system/applied_text_icon.dart';
import '../../injector.dart';
import '../../models/security/access_management/manage_control_access_manger.dart';
import '../../redux/workspaces/workspace_actions.dart';
import '../../stores/stores.dart';
import '../../common/presentaion/components/bottomNavBar/bottom_navbar.dart';
import '../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../app/theme/ui_state_data.dart';

class MoreControlMenuPage extends StatefulWidget {
  const MoreControlMenuPage({Key? key}) : super(key: key);

  static const String route = '/more-settings';

  @override
  State<MoreControlMenuPage> createState() => _MoreControlMenuPageState();
}

class _MoreControlMenuPageState extends State<MoreControlMenuPage> {
  final ManageControlAccessManager accessManager =
      ManageControlAccessManager.fromPermissions(null);

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LinkedDevicesBloc>().add(GetLinkedDevices());
      context.read<LinkedDevicesBloc>().add(ScheduleDeviceManagement());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Manage',
      navBar: const BottomNavBar(page: PageType.more),
      displayNavBar: AppVariables.store!.state.enableBottomNavBar!,
      displayAppBar: true,
      displayBackNavigation: AppVariables.store!.state.enableSideNavDrawer!,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: generateMenuItems(context)),
      ),
    );
  }

  List<Widget> generateMenuItems(BuildContext context) {
    final fillColor = Theme.of(
      context,
    ).extension<AppliedSurface>()?.brandSubTitle;
    final iconColor = Theme.of(context).extension<AppliedTextIcon>()?.brand;
    final collapsedIconColor = Theme.of(
      context,
    ).extension<AppliedButton>()?.neutralDefault;
    final resetIconColor = Theme.of(
      context,
    ).extension<AppliedButton>()?.neutralActive;
    final titleColor = Theme.of(context).extension<AppliedTextIcon>()?.primary;
    final subTitleColor = Theme.of(
      context,
    ).extension<AppliedTextIcon>()?.secondary;
    var menuItems = accessManager.menus;

    List<Widget> menuTiles = [];

    // TODO(lampian): need to add the event here since ModuleMenuItem does
    // not have a onTap override that can be used for the event
    context.read<LinkedDevicesBloc>().add(GetLinkedDevices());
    context.read<LinkedDevicesBloc>().add(ScheduleDeviceManagement());

    for (var i = 0; i < menuItems.length; i++) {
      late Widget dropDownTile;

      if (menuItems[i].items != null && menuItems[i].items!.length == 1) {
        final item = menuItems[i].items?.first;

        dropDownTile = ListTile(
          leading: Icon(menuItems[i].icon, color: iconColor),
          key: Key(menuItems[i].name ?? ''),
          tileColor: fillColor,
          title: context.labelSmall(
            menuItems[i].name ?? '',
            alignLeft: true,
            isSemiBold: true,
            color: titleColor,
          ),
          trailing: Icon(
            Platform.isIOS ? Icons.arrow_forward_ios : Icons.arrow_forward,
          ),
          subtitle: context.labelXSmall(
            menuItems[i].description ?? '',
            overflow: TextOverflow.ellipsis,
            color: subTitleColor,
            alignLeft: true,
          ),
          onTap: () {
            if (item?.route != null) {
              Navigator.pushNamed(context, item?.route ?? '');
            }
          },
        );

        menuTiles.add(dropDownTile);
      } else {
        dropDownTile = ExpansionTile(
          key: Key(menuItems[i].name ?? ''),
          initiallyExpanded: _getMenuExpandedState(i),
          onExpansionChanged: (isOpen) {
            AppVariables.store?.dispatch(
              ManageControlExpandedStateAction(i, isOpen),
            );
          },
          backgroundColor: fillColor,
          collapsedBackgroundColor: fillColor,
          collapsedIconColor: collapsedIconColor,
          iconColor: resetIconColor,
          title: context.labelSmall(
            menuItems[i].name ?? '',
            alignLeft: true,
            isSemiBold: true,
            color: titleColor,
          ),
          subtitle: context.labelXSmall(
            menuItems[i].description ?? '',
            overflow: TextOverflow.ellipsis,
            color: subTitleColor,
            alignLeft: true,
          ),
          leading: Icon(menuItems[i].icon, color: iconColor),
          children:
              menuItems[i].items
                  ?.map((e) => listMenuItem(context, e))
                  .toList() ??
              [const SizedBox()],
        );
        menuTiles.add(dropDownTile);
      }
    }
    return menuTiles;
  }

  Widget listMenuItem(
    BuildContext context,
    ModuleMenuItem option, {
    bool? isOnline,
  }) => Padding(
    padding: const EdgeInsets.only(left: 8),
    child: ListTile(
      tileColor: Theme.of(context).extension<AppliedSurface>()?.primary,
      onTap: () async {
        if (option.route == null || option.route!.isEmpty) {
          return;
        }

        switch (option.route!.toLowerCase()) {
          case 'about':
            _showAboutDialog(context);
            break;
          case 'privacy-policy':
            _showPrivacyPolicy(context);
            break;
          case 't&cs':
            _showTermsAndConditionsPolicy(context);
            break;
          case 'clear-data':
            _clearLocalStoredData(context);
            break;
          case 'sandbox':
            final selectedTheme = await getSelectedSandBoxTheme();

            if (sandBoxEnabled) {
              if (context.mounted) {
                await showSandboxSelections(
                  context: context,
                  selectedTheme: selectedTheme,
                );
              }
            } else {
              var result = false;
              if (context.mounted) {
                result = await sandBoxPassword(context);
              }
              if (result) {
                setState(() {
                  sandBoxEnabled = true;
                });
                if (context.mounted) {
                  await showSandboxSelections(
                    context: context,
                    selectedTheme: selectedTheme,
                  );
                }
              }
            }

            break;
          default:
            Navigator.pushNamed(context, option.route!);
        }
      },
      trailing: Icon(
        Platform.isIOS ? Icons.arrow_forward_ios : Icons.arrow_forward,
      ),
      title: context.labelSmall(
        option.name ?? '',
        alignLeft: true,
        isSemiBold: true,
        color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
      ),
      dense: true,
    ),
  );

  var sandBoxEnabled = false;

  Future<bool> sandBoxPassword(BuildContext context) async {
    final result = await showCustomMessageDialog(
      context: context,
      title: 'Sandbox password',
      content: Column(
        children: [
          PasswordFormField(
            key: const Key('password'),
            onSaveValue: (_) {},
            onFieldSubmitted: (value) {
              if (value.contains('1qaz')) {
                Navigator.pop(context, true);
              } else {
                Navigator.pop(context, false);
              }
            },
            hintText: 'Enter password',
            labelText: 'Password',
            policies: PasswordPolicies()..policies = [],
          ),
        ],
      ),
      buttonText: 'Cancel',
    );
    return result ?? false;
  }

  Future<bool> showSandboxSelections({
    required BuildContext context,
    String selectedTheme = '',
  }) async {
    final result = await showCustomMessageDialog(
      context: context,
      title: 'Sandbox selection',
      content: Column(
        children: [
          sandBoxTile(
            context: context,
            title: 'Sandbox 1',
            onTap: () {
              Navigator.pop(context);
              storeSandBoxTheme('sandbox1');
            },
            enabled: sandBoxEnabled,
            selected: selectedTheme == 'sandbox1',
          ),
          sandBoxTile(
            context: context,
            title: 'Sandbox 2',
            onTap: () {
              Navigator.pop(context);
              storeSandBoxTheme('sandbox2');
            },
            enabled: sandBoxEnabled,
            selected: selectedTheme == 'sandbox2',
          ),
          sandBoxTile(
            context: context,
            title: 'Sandbox 3',
            onTap: () {
              Navigator.pop(context);
              storeSandBoxTheme('sandbox3');
            },
            enabled: sandBoxEnabled,
            selected: selectedTheme == 'sandbox3',
          ),
          sandBoxTile(
            context: context,
            title: 'Sandbox 4',
            onTap: () {
              Navigator.pop(context);
              storeSandBoxTheme('sandbox4');
            },
            enabled: sandBoxEnabled,
            selected: selectedTheme == 'sandbox4',
          ),
          sandBoxTile(
            context: context,
            title: 'Sandbox 5',
            onTap: () {
              Navigator.pop(context);
              storeSandBoxTheme('sandbox5');
            },
            enabled: sandBoxEnabled,
            selected: selectedTheme == 'sandbox5',
          ),
        ],
      ),
      buttonText: 'Cancel',
    );
    return result ?? false;
  }

  Widget sandBoxTile({
    required BuildContext context,
    required String title,
    required bool enabled,
    required bool selected,
    required void Function() onTap,
  }) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Column(
            children: [
              context.labelSmall(
                title,
                color: enabled && selected
                    ? Theme.of(context).extension<AppliedTextIcon>()?.primary
                    : enabled && !selected
                    ? Theme.of(context).extension<AppliedTextIcon>()?.secondary
                    : Theme.of(context).extension<AppliedTextIcon>()?.disabled,
                isSemiBold: true,
                alignLeft: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> storeSandBoxTheme(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sandbox_theme', value);
  }

  void _showAboutDialog(BuildContext context) {
    showCustomAboutDialog(
      context: context,
      applicationName: AppVariables.store?.state.appName ?? 'Not available',
      applicationVersion: 'Version: ${AppVariables.store?.state.version}, ',
      applicationBuild: 'Build: ${AppVariables.store?.state.builderNumber}',
      cohort: getCohort(),
      applicationIcon: SizedBox(
        height: 84,
        width: 84,
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Image(
            image: AssetImage(UIStateData().appLogo),
            fit: BoxFit.contain,
          ),
        ),
      ),
      viewCustom: '',
      onTapViewCustom: () {},
    );
  }

  void _showPrivacyPolicy(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute(
      builder: (ctx) => ResourceViewer(
        url: AppVariables.privacyPolicy,
        title: 'Privacy Policy',
        isAsset: isAsset(AppVariables.privacyPolicy),
      ),
    ),
  );

  void _showTermsAndConditionsPolicy(BuildContext context) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ResourceViewer(
            url: AppVariables.termsAndConditions,
            title: 'Terms and Conditions',
            isAsset: isAsset(AppVariables.termsAndConditions),
          ),
        ),
      );

  bool isAsset(String value) {
    return value.contains('asset');
  }

  void _clearLocalStoredData(BuildContext context) {
    showProgress(context: context);
    SalesStore()
        .clear()
        .then((_) {
          hideProgress(context);

          showMessageDialog(context, 'Local storage cleared', Icons.check);
        })
        .catchError((error) {
          hideProgress(context);
          showMessageDialog(
            context,
            'We are unable to clear local storage at this time, please try again later',
            LittleFishIcons.error,
          );
        });
  }

  bool _getMenuExpandedState(int index) {
    return AppVariables
            .store
            ?.state
            .workspaceState
            .manageControlMenuExpandedStates?[index] ??
        false;
  }
}
