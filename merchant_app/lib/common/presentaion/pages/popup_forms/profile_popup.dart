// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/user/user_actions.dart';
import 'package:littlefish_merchant/redux/workspaces/workspace_actions.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';

import '../../../../app/custom_route.dart';
import '../../../../features/store_switching/presentation/pages/list_of_stores_page.dart';
import '../../../../injector.dart';
import '../../../../redux/app/app_state.dart';
import '../../../../tools/network_image/flutter_network_image.dart';
import '../../../../ui/business/users/view_models.dart';
import '../../../../ui/settings/pages/permissions/settings_device_permissions_page.dart';
import '../../../../app/theme/ui_state_data.dart';
import '../../components/bottomNavBar/models/config_classes.dart';
import '../../components/bottomNavBar/page_navigation.dart';

class ProfilePopup extends StatefulWidget {
  const ProfilePopup({Key? key}) : super(key: key);

  @override
  State<ProfilePopup> createState() => _ProfilePopupState();
}

class _ProfilePopupState extends State<ProfilePopup> {
  UserVM? vm;

  int selectedWorkspaceOption = 1;

  @override
  Widget build(BuildContext context) {
    final tileColor = Theme.of(context).extension<AppliedSurface>()?.primary;
    final iconColor = Theme.of(context).extension<AppliedTextIcon>()?.brand;
    final textColor = Theme.of(context).extension<AppliedTextIcon>()?.primary;
    return StoreConnector<AppState, UserVM>(
      converter: (store) => UserVM.fromStore(store),
      builder: (ctx, vm) {
        this.vm = vm;
        var userProfile = vm.store?.state.userProfile;
        var firstName = userProfile?.firstName ?? '';
        var businessName = vm.businessName;
        var workspaceList = vm.store?.state.workspaceState.workspaces ?? [];
        var selectedWorkspace =
            vm.store?.state.workspaceState.selectedWorkspace;

        var profileWidget =
            userProfile?.profileImageUri != null &&
                userProfile!.profileImageUri!.isNotEmpty
            ? ClipOval(
                // circular image inside OutlineGradientAvatar
                child: SizedBox(
                  width: 96, // Set the width and height to the same value
                  height: 96,
                  child: FadeInImage(
                    image: getIt<FlutterNetworkImage>().asImageProviderById(
                      id: userProfile.id!,
                      category: 'users',
                      legacyUrl: userProfile.profileImageUri!,
                      height: AppVariables.listImageHeight,
                      width: AppVariables.listImageWidth,
                    ),
                    placeholder: AssetImage(UIStateData().appLogo),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            // ? AvatarXSmall(
            //   imageUrl: userProfile.profileImageUri!,
            // )
            : firstName.isNotEmpty
            ? Text(firstName.characters.first.toString())
            : const Text('');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).extension<AppliedSurface>()?.brand,
                    child: profileWidget,
                  ),
                  const SizedBox(width: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      context.paragraphMedium(
                        '${userProfile?.firstName ?? 'Firstname'} '
                        '${userProfile?.lastName ?? 'Lastname'}',
                      ),
                      //const SizedBox(height: 6),
                      context.paragraphMedium(
                        '${businessName ?? userProfile?.name}',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // TODO: Commenting out code with button for user switching since it does nothing, keeping it here for reference
            // if (AppVariables.isPOSBuild)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            //     child: ButtonSecondary(
            //       text: 'Switch User',
            //       onTap: (ctx) {},
            //     ),
            //   ),

            // if (!AppVariables.isPOSBuild) ...[
            //   const SizedBox(height: 16),
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     child: FooterButtonsSecondaryPrimary(
            //       secondaryButtonText: 'Switch User',
            //       primaryButtonText: 'Switch Store',
            //       onSecondaryButtonPressed: (_) {},
            //       onPrimaryButtonPressed: (_) {
            //         Navigator.of(context).push(
            //           CustomRoute(
            //             builder: (ctx) => const ListOfStoresPage(),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ],
            if (!AppVariables.isPOSBuild)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                child: ButtonSecondary(
                  text: 'Switch Store',
                  onTap: (_) {
                    Navigator.of(context).push(
                      CustomRoute(builder: (ctx) => const ListOfStoresPage()),
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),
            const CommonDivider(),
            if (vm.store!.state.enableBottomNavBar! == true)
              Column(
                children: workspaceList
                    .map(
                      (workspaceItem) => InkWell(
                        onTap: () {
                          vm.store!.dispatch(
                            setActiveWorkspace(
                              workspace: workspaceItem,
                              completer: actionCompleter(ctx, () {
                                Navigator.of(context).pop();
                                var pageName = PageTypeHelper.getPageType(
                                  workspaceItem.navbarConfig[1].pageType,
                                );
                                navigateToPage(pageName, context);
                              }),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Radio(
                              activeColor: Theme.of(
                                context,
                              ).extension<AppliedTextIcon>()?.brand,
                              value: workspaceItem.name,
                              groupValue: selectedWorkspace?.name,
                              onChanged: (String? value) {
                                vm.store!.dispatch(
                                  setActiveWorkspace(workspace: workspaceItem),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            selectedWorkspace?.name == workspaceItem.name
                                ? context.labelLarge(
                                    '${workspaceItem.name} Workspace',
                                    isBold: true,
                                  )
                                : context.paragraphMedium(
                                    '${workspaceItem.name} Workspace',
                                  ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 8.0),
            const CommonDivider(),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    tileColor: tileColor,
                    leading: const Icon(Icons.person_search_outlined),
                    iconColor: iconColor,
                    title: context.paragraphMedium(
                      'User Details',
                      color: textColor,
                      alignLeft: true,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      StoreProvider.of<AppState>(
                        context,
                      ).dispatch(editUserProfile(context));
                    },
                  ),
                  const SizedBox(height: 6.0),
                  ListTile(
                    tileColor: tileColor,
                    leading: const Icon(Icons.perm_device_info),
                    iconColor: iconColor,
                    title: context.paragraphMedium(
                      'Device Permissions',
                      color: textColor,
                      alignLeft: true,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Handle Device Permissions tap
                      Navigator.of(
                        context,
                      ).pushNamed(SettingsDevicePermissionsPage.route);
                    },
                  ),
                  // TODO(lampian): complete feature
                  // const SizedBox(height: 6.0),
                  // ListTile(
                  //   tileColor: tileColor,
                  //   leading: const Icon(Icons.password),
                  //   iconColor: iconColor,
                  //   title: context.paragraphMedium(
                  //     'Change Password',
                  //     color: textColor,
                  //     alignLeft: true,
                  //   ),
                  //   trailing: const Icon(Icons.chevron_right),
                  //   onTap: () async {
                  //     await Navigator.of(context).push(
                  //       CustomRoute(
                  //         builder: (BuildContext context) =>
                  //             ChangePasswordPage(profile: userProfile!),
                  //       ),
                  //     );
                  //   },
                  // ),
                  const SizedBox(height: 6.0),
                  const CommonDivider(),
                  const SizedBox(height: 6.0),
                  ListTile(
                    tileColor: tileColor,
                    leading: const Icon(Icons.exit_to_app),
                    iconColor: iconColor,
                    title: context.paragraphMedium(
                      'Logout',
                      color: textColor,
                      alignLeft: true,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      bool? result = await getIt<ModalService>()
                          .showActionModal(
                            context: context,
                            title: 'Logout',
                            acceptText: 'Yes, Logout',
                            cancelText: 'No, Cancel',
                            description: 'Are you sure you want to go?',
                          );

                      if (result ?? false) {
                        StoreProvider.of<AppState>(
                          context,
                        ).dispatch(signOut(reason: 'user-signout'));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
