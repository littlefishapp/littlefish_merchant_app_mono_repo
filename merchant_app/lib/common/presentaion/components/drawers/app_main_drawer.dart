import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_merchant/app/theme/app_bar_data_set.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/drawers/main_drawer_title.dart/domain/usecase/drawer_title.dart';
import 'package:littlefish_merchant/features/getapp/get_app_widget.dart';
import 'package:littlefish_merchant/features/store_switching/presentation/pages/list_of_stores_page.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/ui/security/login/login_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/environment/environment_actions.dart';
import 'package:littlefish_merchant/redux/user/user_actions.dart';
import 'package:littlefish_merchant/singletons/connection_status_singleton.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/ui/home/home_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/circle_gradient_avatar.dart';
import 'package:littlefish_merchant/common/presentaion/components/drawers/drawer_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';

import '../../../../app/custom_route.dart';
import '../../../../injector.dart';
import '../../../../tools/network_image/flutter_network_image.dart';
import '../custom_app_bar.dart';
import '../navbars.dart';

class AppMainDrawer extends StatefulWidget {
  final double? elevation;
  final List<NavbarItem>? options;

  const AppMainDrawer({Key? key, this.options, this.elevation})
    : super(key: key);

  @override
  State<AppMainDrawer> createState() => _AppMainDrawerState();
}

class _AppMainDrawerState extends State<AppMainDrawer> {
  Color expansionColor = Colors.grey.shade700;

  final selectedColor = getIt.get<AppBarDataSet>().appBarGradientEnd;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DrawerVM>(
      converter: (store) => DrawerVM.fromStore(store),
      builder: (ctx, vm) {
        var navOptions = navigationOptions(context, vm);

        var profile = vm.state!.businessState.profile!;
        var userProfile = vm.state!.userState.profile;
        var getAppEnabled = AppVariables.store!.state.enableGetApp ?? true;

        return Drawer(
          surfaceTintColor: Colors.transparent,
          elevation: 0.0,
          child: Scaffold(
            backgroundColor: Theme.of(
              context,
            ).extension<AppliedSurface>()?.primary,
            appBar: CustomAppBar(
              surfaceTintColor: Colors.transparent,
              shadowColor: Theme.of(
                context,
              ).extension<AppliedSurface>()?.secondary.withOpacity(0.3),
              automaticallyImplyLeading: false,
              primary: true,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.transparent),
              title: drawerTitle(),
              centerTitle: false,
            ),
            body: Column(
              children: <Widget>[
                vm.isOnline!
                    ? vm.store!.state.userState.isGuestUser == true
                          ? Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  context.paragraphSmall(
                                    'Sign in to unlock all the ${AppVariables.store?.state.appName ?? ''} features',
                                    isBold: false,
                                  ),
                                ],
                              ),
                            )
                          : ListTile(
                              contentPadding: const EdgeInsets.only(
                                left: 16,
                                right: 12,
                              ),
                              trailing: ClipOval(
                                child: SizedBox(
                                  height: 48,
                                  width: 48,
                                  child: ClipOval(
                                    child: Material(
                                      color: selectedColor,
                                      child: Container(
                                        color: Colors.white,
                                        child: Center(
                                          child: context.labelSmall(
                                            (userProfile?.firstName?.padRight(
                                                      2,
                                                    ) ??
                                                    'UU')
                                                .toUpperCase()
                                                .characters
                                                .take(2)
                                                .toString(),
                                            color: selectedColor,
                                            alignLeft: false,
                                            isBold: true,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              title: context.labelSmall(
                                profile.name ?? 'store-name',
                                alignLeft: true,
                                overflow: TextOverflow.ellipsis,
                                isBold: true,
                              ),
                              subtitle: context.labelXSmall(
                                '${userProfile?.firstName ?? ''} ${userProfile?.lastName ?? ''}\n${AppVariables.merchantId.isEmpty ? 'MID Unavailable' : AppVariables.merchantId}',
                                alignLeft: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              // trailing: Icon(MdiIcons.account),
                              onTap: () {
                                StoreProvider.of<AppState>(
                                  context,
                                ).dispatch(editUserProfile(context));
                              },
                            )
                    : PreferredSize(
                        preferredSize: const Size.fromHeight(84),
                        child: SafeArea(
                          child: InkWell(
                            onTap: () async {
                              showProgress(context: context);
                              var instance =
                                  ConnectionStatusSingleton.getInstance();

                              var isOnline = await instance.checkConnection();

                              vm.store!.dispatch(
                                SetInternetStatusAction(isOnline),
                              );

                              // removed ignore: use_build_context_synchronously
                              hideProgress(context);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: OutlineGradientAvatar(
                                    colors: const [Colors.red, Colors.orange],
                                    radius: 48,
                                    child: Icon(
                                      MdiIcons.wifiOff,
                                      size: 48,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                const LongText(
                                  'You are offline',
                                  fontSize: null,
                                  fontWeight: FontWeight.bold,
                                  textColor: Colors.red,
                                ),
                                const SizedBox(height: 8),
                                const CommonDivider(),
                              ],
                            ),
                          ),
                        ),
                      ),
                if (vm.store!.state.userState.isGuestUser == false &&
                    platformType != PlatformType.pos) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ButtonSecondary(
                      text: 'Switch Store',
                      onTap: (c) {
                        Navigator.of(context).push(
                          CustomRoute(
                            builder: (BuildContext context) =>
                                const ListOfStoresPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const CommonDivider(thickness: 0.2),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) =>
                          navOptions[index],
                      itemCount: navOptions.length,
                    ),
                  ),
                ),
                const CommonDivider(thickness: 0.2),
                if (!AppVariables.isPOSBuild)
                  ListTile(
                    tileColor: Theme.of(
                      context,
                    ).extension<AppliedSurface>()?.primary,
                    onTap: () async {
                      if (isNotPremium('contact_us')) {
                        showPopupDialog(
                          defaultPadding: false,
                          context: context,
                          content: billingNavigationHelper(isModal: true),
                        );
                      } else {
                        var uri =
                            'mailto:${AppVariables.store!.state.environmentSettings!.contactUsEmail}?subject=Customer Support &body=';
                        final launcUri = Uri.parse(uri);
                        if (await canLaunchUrl(launcUri)) {
                          await launchUrl(launcUri);
                        } else {
                          throw 'Could not launch $uri';
                        }
                      }
                    },
                    title: context.labelSmall(
                      'Help - Contact Us',
                      alignLeft: true,
                    ),
                    subtitle: context.labelXSmall(
                      '${AppVariables.store!.state.environmentSettings!.contactUsEmail}',
                      alignLeft: true,
                    ),
                    trailing: const Icon(Icons.mail_outline),
                  ),
                if (AppVariables.isPOSBuild && getAppEnabled)
                  ListTile(
                    dense: true,
                    tileColor: Theme.of(
                      context,
                    ).extension<AppliedSurface>()?.primary,
                    onTap: () async {
                      showPopupDialog(
                        defaultPadding: false,
                        context: context,
                        useNewModal: true,
                        content: Container(
                          alignment: Alignment.center,
                          child: const GetAppWidget(),
                        ),
                      );
                    },
                    title: context.labelSmall('Get The App', alignLeft: true),
                    subtitle: context.labelXSmall(
                      'Tap to download',
                      alignLeft: true,
                      autoSize: false,
                      maxLines: 2,
                    ),
                    trailing: Icon(MdiIcons.download),
                  ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.bottomLeft,
                  child: context.labelXSmall(
                    'Version: ${AppVariables.store!.state.version}',
                    alignLeft: true,
                    autoSize: false,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ButtonSecondary(
                    text: AppVariables.isInGuestMode ? 'SIGN IN' : 'LOGOUT',
                    onTap: (c) async {
                      if (AppVariables.isInGuestMode) {
                        /// No concept of logout in Guest Mode, user can only sign in
                        StoreProvider.of<AppState>(
                          context,
                        ).dispatch(signOut(reason: 'user-signout'));
                        Navigator.pushNamed(context, LoginPage.route);
                        return;
                      }

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
                          c,
                        ).dispatch(signOut(reason: 'user-signout'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  GestureDetector _avatar(BuildContext context, UserProfile? profile) =>
      GestureDetector(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(48)),
          alignment: Alignment.center,
          child: OutlineGradientAvatar(
            radius: 48,
            child:
                profile?.profileImageUri != null &&
                    profile!.profileImageUri!.isNotEmpty
                ? ClipOval(
                    // circular image inside OutlineGradientAvatar
                    child: SizedBox(
                      width: 96, // Set the width and height to the same value
                      height: 96,
                      child: FadeInImage(
                        image: getIt<FlutterNetworkImage>().asImageProviderById(
                          id: profile.id ?? '',
                          category: 'users',
                          legacyUrl: profile.profileImageUri ?? '',
                          height: AppVariables.listImageHeight,
                          width: AppVariables.listImageWidth,
                        ),
                        placeholder: AssetImage(UIStateData().appLogo),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Icon(
                    MdiIcons.badgeAccount,
                    color: Colors.grey.shade700,
                    size: 48.0,
                  ),
          ),
        ),
      );

  List<Widget> navigationOptions(BuildContext context, DrawerVM vm) {
    var result = <Widget>[];

    var accessManager = vm.accessManager!;

    var options = accessManager.getAllMenuOptions().map((m) {
      return NavbarItem(
        key: m.key,
        route: m.route,
        icon: m.icon,
        text: m.name,
        allowOffline: m.allowOffline,
        specialDisplay: m.specialItem,
        subItems: m.items
            ?.map(
              (moduleMenuItem) => NavbarItem(
                route: moduleMenuItem.route,
                icon: moduleMenuItem.icon,
                text: moduleMenuItem.name,
                allowOffline: moduleMenuItem.allowOffline,
                specialDisplay: moduleMenuItem.specialItem,
              ),
            )
            .toList(),
      );
    }).toList();

    result.addAll(
      options
          .map(
            (navBarItem) => navBarItem.subItems == null
                ? navigationTile(context: context, option: navBarItem, vm: vm)
                : expansionTile(context: context, option: navBarItem, vm: vm),
          )
          .toList(),
    );
    if (AppVariables.store!.state.environmentSettings!.enableUserGuide ==
        true) {
      result.addAll([
        ListTile(
          tileColor: Theme.of(context).extension<AppliedSurface>()?.primary,
          onTap: () async {
            var userGuideUrl =
                AppVariables.store!.state.environmentSettings!.userGuide;
            if (userGuideUrl != null && userGuideUrl.isNotEmpty) {
              var uri = Uri.parse(userGuideUrl);
              launchUrl(uri);
            } else {
              throw 'Could not launch User Guide';
            }
          },
          title: DecoratedText(
            'View User Guide',
            fontSize: 16.0,
            textColor: Colors.grey.shade700,
            alignment: Alignment.centerLeft,
          ),
          trailing: const Icon(FontAwesomeIcons.book, size: 22),
        ),
      ]);
    }

    return result;
  }

  Widget expansionTile({
    required BuildContext context,
    required NavbarItem option,
    required DrawerVM vm,
  }) {
    return ExpansionTile(
      key: option.key,
      iconColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
      title: context.labelMedium(option.text ?? '', alignLeft: true),
      onExpansionChanged: (val) {
        if (val) {
          expansionColor =
              Theme.of(context).extension<AppliedTextIcon>()?.secondary ??
              Colors.red;
          if (mounted) setState(() {});
        } else {
          expansionColor =
              Theme.of(context).extension<AppliedTextIcon>()?.brand ??
              Colors.red;
          if (mounted) setState(() {});
        }
      },
      children: option.subItems!
          .map(
            (navBarItem) => navigationTile(
              context: context,
              option: navBarItem,
              vm: vm,
              subItem: true,
            ),
          )
          .toList(),
    );
  }

  Widget navigationTile({
    required BuildContext context,
    required NavbarItem option,
    required DrawerVM vm,
    bool subItem = false,
  }) {
    final name = ModalRoute.of(context)!.settings.name;
    final selected = name == option.route;

    // Note that this was changed from using the gradient color of the
    // app bar to secondary. It resolves the white on white back ground
    // displayed if the app bar has white gradient
    final selectedColor = Theme.of(
      context,
    ).extension<AppliedSurface>()?.inverse;

    return selected
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppVariables.appDefaultButtonRadius,
              ),
            ),
            child: Material(
              borderRadius: BorderRadius.circular(
                AppVariables.appDefaultButtonRadius,
              ),
              child: Container(
                // padding: const EdgeInsets.symmetric(vertical: 8),
                height: AppVariables.appDefaultlistItemSize,

                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(
                    AppVariables.appDefaultButtonRadius,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: context.labelMedium(
                        option.text ?? '',
                        isBold: true,
                        color: Theme.of(
                          context,
                        ).extension<AppliedTextIcon>()?.inverseEmphasized,
                        alignLeft: true,
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Icon(
                        option.icon,
                        color: Theme.of(
                          context,
                        ).extension<AppliedTextIcon>()?.inverseEmphasized,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : ListTile(
            tileColor: Theme.of(context).extension<AppliedSurface>()?.primary,
            key: option.key,
            selected: selected,
            selectedColor: Theme.of(
              context,
            ).extension<AppliedTextIcon>()?.brand,
            selectedTileColor: Theme.of(
              context,
            ).extension<AppliedTextIcon>()?.brand.withAlpha(30),
            trailing: Icon(option.icon),
            title: context.labelMedium(option.text ?? '', alignLeft: true),
            onTap: (vm.isOnline! || option.allowOffline)
                ? () {
                    if (ModalRoute.of(context)!.settings.name == option.route) {
                      return;
                    }

                    if (option.route == HomePage.route) {
                      Navigator.of(context).pushNamed(
                        option.route!,
                        arguments: ModalRoute.withName(option.route!),
                      );
                    } else if (option.route != null &&
                        option.route!.isNotEmpty) {
                      Navigator.of(context).pushNamed(option.route!);
                    }
                  }
                : () {
                    showMessageDialog(
                      context,
                      'this feature is only available when you are online',
                      MdiIcons.wifi,
                    );
                  },
          );
  }
}
