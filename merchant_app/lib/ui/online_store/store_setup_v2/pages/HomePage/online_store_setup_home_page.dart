import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/app_colours.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/bottomNavBar/bottom_navbar.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/models/online/store_setup_helper.dart';
import 'package:littlefish_merchant/models/shared/image_representable.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/icon_constants.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/submit_for_review/submit_for_review_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/setup_progress_tile.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/setup_section_tile.dart';

class OnlineStoreSetupHomePage extends StatefulWidget {
  static const route = 'online-store/setup-home-page';

  const OnlineStoreSetupHomePage({Key? key}) : super(key: key);

  @override
  State<OnlineStoreSetupHomePage> createState() =>
      _OnlineStoreSetupHomePageState();
}

class _OnlineStoreSetupHomePageState extends State<OnlineStoreSetupHomePage> {
  late List<StoreSetupSection> _storeSetupSections;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // section might be newly completed (e.g. products)
      // trigger a rebuild
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('#### OnlineStoreSetupHomePage builder');
    return StoreConnector<AppState, ManageStoreVMv2>(
      onInit: (store) {
        if (store.state.storeState.store == null) {
          store.dispatch(CreateDefaultStoreAction());
        }

        store.dispatch(getAllOptionAttributesAction());
      },
      converter: (store) => ManageStoreVMv2.fromStore(store),
      builder: (BuildContext context, ManageStoreVMv2 vm) {
        debugPrint('#### OnlineStoreSetupHomePage state builder');

        _storeSetupSections = StoreSetupHelper().createSetupSectionList(
          context,
          vm,
        );

        if (EnvironmentProvider.instance.isLargeDisplay!) {
          return scaffoldLargeDisplay(vm);
        } else {
          return scaffold(vm);
        }
      },
    );
  }

  Widget scaffold(ManageStoreVMv2 vm) {
    return AppScaffold(
      title: 'Your Online Shop',
      centreTitle: false,
      body: vm.isLoading != true ? layout(vm) : const AppProgressIndicator(),
      displayNavBar: AppVariables.store!.state.enableBottomNavBar!,
      displayBackNavigation: vm.store!.state.enableSideNavDrawer!,
      hasDrawer: vm.store!.state.enableSideNavDrawer!,
      persistentFooterButtons: completeButton(vm),
      displayNavDrawer: AppVariables.store!.state.enableSideNavDrawer!,
      navBar: const BottomNavBar(page: PageType.eStore),
    );
  }

  Widget scaffoldLargeDisplay(ManageStoreVMv2 vm) {
    return AppScaffold(
      enableProfileAction: false,
      title: 'Your Online Shop',
      centreTitle: false,
      body: vm.isLoading != true ? layout(vm) : const AppProgressIndicator(),
      displayNavBar: false, //AppVariables.store!.state.enableBottomNavBar!,
      displayBackNavigation: vm.store!.state.enableSideNavDrawer!,
      hasDrawer: true, //vm.store!.state.enableSideNavDrawer!,
      persistentFooterButtons: completeButton(vm),
      displayNavDrawer: true, //AppVariables.store!.state.enableSideNavDrawer!,
      navBar: const BottomNavBar(page: PageType.eStore),
    );
  }

  Widget layout(ManageStoreVMv2 vm) {
    double percentageCompleted = _getPercentageCompleted(_storeSetupSections);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            SetupProgressTile(
              title: percentageCompleted < 100
                  ? "Let's set up your online store"
                  : 'Your store setup is complete!',
              description: percentageCompleted < 100
                  ? 'Follow this guide to get your business up and running online.'
                  : 'Your setup guide will still be available in the Manage section.',
              progress: percentageCompleted,
              percentageBarColour: Theme.of(
                context,
              ).extension<AppColours>()?.appSuccess,
              image: AssetImageRepresentable(IconConstants.shop),
            ),
            const SizedBox(height: 16),
            storeSetupSectionsColumn(),
          ],
        ),
      ),
    );
  }

  Widget storeSetupSectionsColumn() {
    return Column(
      children: _storeSetupSections.map((section) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SetupSectionTile(
            title: section.title,
            description: section.description,
            leadingIcon: section.icon,
            isSelected: section.isCompleted,
            onTap: (context) => section.onTap(),
            selectedColour: Theme.of(
              context,
            ).extension<AppliedTextIcon>()?.positiveAlt,
          ),
        );
      }).toList(),
    );
  }

  List<Widget>? completeButton(ManageStoreVMv2 vm) {
    double percentageCompleted = _getPercentageCompleted(_storeSetupSections);
    bool setupCompleteButNotPublished =
        percentageCompleted >= 100 && vm.item?.isConfigured != true;
    if (!setupCompleteButNotPublished) return null;
    return [
      ButtonPrimary(
        text: 'Complete Setup',
        upperCase: false,
        disabled: !setupCompleteButNotPublished,
        buttonColor: Theme.of(context).extension<AppColours>()?.appSuccess,
        onTap: (context) async {
          await vm.setConfigured(context, true);
          if (context.mounted) {
            Navigator.of(
              context,
            ).push(CustomRoute(builder: (ctx) => const SubmitForReviewPage()));
          }
        },
      ),
    ];
  }

  double _getPercentageCompleted(List<StoreSetupSection> sections) {
    return (_countCompletedSections(sections) / sections.length) * 100;
  }

  int _countCompletedSections(List<StoreSetupSection> sections) {
    return sections.where((section) => section.isCompleted).length;
  }
}
