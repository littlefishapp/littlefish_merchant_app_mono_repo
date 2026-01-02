import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/DeliveryandCollection/collection_preferences_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/DeliveryandCollection/delivery_preferences_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';

class OnlineStoreManageDeliveryAndCollection extends StatelessWidget {
  final ManageStoreVMv2 vm;

  const OnlineStoreManageDeliveryAndCollection({Key? key, required this.vm})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissalUtility(
      content: AppScaffold(
        centreTitle: false,
        hasDrawer: false,
        displayNavDrawer: false,
        title: 'Delivery and Collections',
        body: layout(context),
      ),
    );
  }

  layout(BuildContext context) => SingleChildScrollView(
    child: Column(
      children: [
        const SizedBox(height: 24),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.local_shipping_outlined),
            ),
            title: context.paragraphMedium(
              'Delivery Settings',
              color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
              alignLeft: true,
              isSemiBold: true,
            ),
            onTap: () {
              Navigator.of(context).push(
                CustomRoute(
                  builder: (BuildContext context) =>
                      const DeliveryPreferencePage(),
                ),
              );
            },
          ),
        ),
        const CommonDivider(),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.unarchive_outlined),
            ),
            title: context.paragraphMedium(
              'Collection Settings',
              color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
              alignLeft: true,
              isSemiBold: true,
            ),
            onTap: () {
              Navigator.of(context).push(
                CustomRoute(
                  builder: (BuildContext context) =>
                      const CollectionPreferencePage(),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
