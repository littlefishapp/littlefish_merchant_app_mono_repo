import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/BusinessInformation/online_store_contact_info_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/BusinessInformation/online_store_details_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/BusinessInformation/online_store_location_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/BusinessInformation/online_store_social_media_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/BusinessInformation/online_store_trading_hours_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';

class OnlineStoreManageBusinessInformation extends StatelessWidget {
  final ManageStoreVMv2 vm;

  const OnlineStoreManageBusinessInformation({Key? key, required this.vm})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissalUtility(
      content: AppScaffold(
        centreTitle: false,
        hasDrawer: false,
        displayNavDrawer: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: 'Business Information',
        body: layout(context),
      ),
    );
  }

  layout(BuildContext context) => SingleChildScrollView(
    child: Column(
      children: [
        const SizedBox(height: 24),
        _tile(
          context: context,
          text: 'General Business Details',
          icon: Icons.local_shipping_outlined,
          route: CustomRoute(
            builder: (BuildContext context) => OnlineStoreDetailsPage(
              storeName: vm.item?.displayName,
              description: vm.item?.description,
              slogan: vm.item?.slogan,
              showPageNumber: false,
            ),
          ),
        ),
        const CommonDivider(),
        _tile(
          context: context,
          text: 'Contact Information',
          icon: Icons.contacts_outlined,
          route: CustomRoute(
            builder: (BuildContext context) => OnlineStoreContactInfoPage(
              phoneNumber: vm.item?.contactInformation?.mobileNumber,
              email: vm.item?.contactInformation?.email,
              showPageNumber: false,
            ),
          ),
        ),
        const CommonDivider(),
        _tile(
          context: context,
          text: 'Location Details',
          icon: Icons.my_location_outlined,
          route: CustomRoute(
            builder: (BuildContext context) => OnlineStoreLocationPage(
              showPageNumber: false,
              storeAddress: vm.item?.primaryAddress,
            ),
          ),
        ),
        const CommonDivider(),
        _tile(
          context: context,
          text: 'Operating Hours',
          icon: Icons.schedule_outlined,
          route: CustomRoute(
            builder: (BuildContext context) => OnlineStoreTradingHoursPage(
              tradingHours: vm.item?.tradingHours,
              showPageNumber: false,
            ),
          ),
        ),
        const CommonDivider(),
        _tile(
          context: context,
          text: 'Social Media Links',
          icon: Icons.link,
          route: CustomRoute(
            builder: (BuildContext context) => OnlineStoreSocialMediaPage(
              contactInfo: vm.item?.contactInformation,
              showPageNumber: false,
            ),
          ),
        ),
        const CommonDivider(),
      ],
    ),
  );

  _tile({
    required BuildContext context,
    required String text,
    required IconData icon,
    required CustomRoute route,
  }) => Container(
    color: Colors.white,
    child: ListTile(
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Icon(
          icon,
          color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
        ),
      ),
      title: context.paragraphMedium(
        text,
        color: Theme.of(context).extension<AppliedTextIcon>()?.emphasized,
        alignLeft: true,
        isSemiBold: true,
      ),
      onTap: () {
        Navigator.of(context).push(route);
      },
    ),
  );
}
