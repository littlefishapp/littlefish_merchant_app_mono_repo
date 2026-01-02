// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/app_colours.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/bottomNavBar/bottom_navbar.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/StatusPage/online_store_status_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_quick_action.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/labels/section_header.dart';
import 'package:littlefish_merchant/models/shared/image_representable.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/manage_users/widgets/item_list_tile.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/icon_constants.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/setup_progress_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/models/online/store_helper.dart';

import '../../../../../app/theme/applied_system/applied_text_icon.dart';

class OnlineStoreMainHomePage extends StatefulWidget {
  static const route = 'online-store/main-home-page';

  const OnlineStoreMainHomePage({Key? key}) : super(key: key);

  @override
  State<OnlineStoreMainHomePage> createState() =>
      _OnlineStoreMainHomePageState();
}

class _OnlineStoreMainHomePageState extends State<OnlineStoreMainHomePage> {
  late List<StoreSection> _storeSections;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVMv2>(
      converter: (store) => ManageStoreVMv2.fromStore(store),
      onInit: (store) async {
        if (isTrue(ManageStoreVMv2.fromStore(store).item!.isPublic)) {
          ManageStoreVMv2.fromStore(store).isStoreReviewed(context);
        }
        store.dispatch(getAllOptionAttributesAction());
      },
      builder: (BuildContext context, ManageStoreVMv2 vm) {
        _storeSections = StoreHelper.createSectionList(context, vm);
        return scaffold(vm, context);
      },
    );
  }

  scaffold(ManageStoreVMv2 vm, BuildContext context) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final displayNavBar = isTablet
        ? false
        : vm.store!.state.enableBottomNavBar!;
    final hasDrawer = isTablet ? true : vm.store!.state.enableSideNavDrawer!;
    final displayNavDrawer = isTablet
        ? true
        : vm.store!.state.enableSideNavDrawer!;
    return AppScaffold(
      enableProfileAction: isTablet ? false : true,
      navBar: const BottomNavBar(page: PageType.eStore),
      backgroundColor: Theme.of(context).colorScheme.background,
      title: 'Online Store',
      displayNavBar: displayNavBar,
      hasDrawer: hasDrawer,
      displayNavDrawer: displayNavDrawer,
      centreTitle: false,
      body: vm.isLoading != true
          ? layout(vm, context)
          : const AppProgressIndicator(),
    );
  }

  layout(ManageStoreVMv2 vm, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            SetupProgressTile(
              title: 'Your store setup is complete!',
              description: 'You can revisit the setup section at any time',
              progress: 100,
              // TODO(lampian): adding color to icon affects whole icon - use svg?
              image: AssetImageRepresentable(IconConstants.shop),
              percentageBarColour: Theme.of(
                context,
              ).extension<AppColours>()?.appSuccess,
            ),
            storeManageSection(vm, context),
          ],
        ),
      ),
    );
  }

  storeManageSection(ManageStoreVMv2 vm, BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        if (isTrue(vm.item!.isPublic))
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8),
            color: isTrue(vm.item!.isOnline)
                ? Theme.of(context).extension<AppliedTextIcon>()?.positive
                : Theme.of(context).colorScheme.primary,
            child: context.paragraphMedium(
              isTrue(vm.item!.isOnline)
                  ? 'Your store has been approved and is now live.'
                  : 'Your E-commerce store is currently under review, please check-in again in 48 hours.',
              color: Theme.of(context).colorScheme.background,
              isSemiBold: false,
            ),
          ),
        const SectionHeader('Actions'),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (isNotTrue(vm.item!.isPublic)) ...[
                publishStoreButton(vm),
                const SizedBox(width: 16),
              ],
              if (isTrue(vm.item!.isPublic)) ...[
                if (!AppVariables.isPOSBuild) ...[
                  previewStoreButton(vm, context),
                  const SizedBox(width: 16),
                ],
                shareStoreButton(context, vm),
                const SizedBox(width: 16),
              ],
              if (isTrue(vm.item!.isPublic) && isTrue(vm.item!.isOnline)) ...[
                unpublishStoreButton(vm, context),
                const SizedBox(width: 16),
              ],
            ],
          ),
        ),
        const SectionHeader('Manage'),
        Column(
          children: _storeSections.map((section) {
            return ItemListTile(
              title: section.title,
              subtitle: section.description,
              leading: Icon(section.icon),
              onTap: () => section.onTap(),
            );
          }).toList(),
        ),
      ],
    );
  }

  publishStoreButton(ManageStoreVMv2 vm) {
    return ButtonQuickAction(
      icon: Icons.publish_outlined,
      title: 'Publish \nStore',
      onTap: () async {
        Navigator.of(
          context,
        ).push(CustomRoute(builder: (ctx) => const OnlineStoreStatusPage()));
      },
    );
  }

  previewStoreButton(ManageStoreVMv2 vm, BuildContext context) {
    return ButtonQuickAction(
      icon: Icons.remove_red_eye_outlined,
      title: 'Preview \nStore',
      onTap: () async {
        try {
          String rawUrl = getUrl(vm.item!.uniqueSubdomain!, vm.item!.storeUrl);

          String url = rawUrl.startsWith(RegExp(r'^https?://'))
              ? rawUrl
              : 'https://$rawUrl';

          Uri uri = Uri.parse(url);

          if (!await launchUrl(uri)) {
            throw Exception('Could not launch $url');
          }
        } catch (e) {
          urlErrorDialog(context, e);
        }
      },
    );
  }

  unpublishStoreButton(ManageStoreVMv2 vm, BuildContext context) {
    return ButtonQuickAction(
      icon: Icons.cancel_outlined,
      title: 'Unpublish \nStore',
      onTap: () async {
        var store = vm.item;
        store!.isPublic = false;
        await vm.upsertStore(store);
      },
    );
  }

  shareStoreButton(BuildContext context, ManageStoreVMv2 vm) {
    return ButtonQuickAction(
      icon: Icons.share_outlined,
      title: 'Share \nStore',
      onTap: () async {
        try {
          String url = getUrl(vm.item!.uniqueSubdomain!, vm.item!.storeUrl);
          await Share.share(url, subject: vm.item!.displayName!);
        } catch (e) {
          urlErrorDialog(context, e);
        }
      },
    );
  }

  String getUrl(String? domain, String? storeUrl) {
    if (domain == null) {
      throw Exception('Unique Subdomain not set');
    }
    String? url = storeUrl;

    if (url == null) {
      String hostSite =
          AppVariables
              .store
              ?.state
              .environmentSettings
              ?.onlineStoreSettings
              ?.baseUrl ??
          'littlefish.mobi';
      url = 'https://$domain.$hostSite';
    }
    return url;
  }

  urlErrorDialog(BuildContext context, Object e) {
    if (context.mounted) {
      showMessageDialog(
        context,
        'Could not find store url \n$e',
        LittleFishIcons.error,
      );
    }
  }
}
