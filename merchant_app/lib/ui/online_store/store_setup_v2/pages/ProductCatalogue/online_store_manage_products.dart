//flutter imports
import 'package:flutter/material.dart';
//project imports
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/ProductCatalogue/online_store_publish_products_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';
import 'package:littlefish_merchant/ui/products/products/pages/product_page.dart';

class OnlineStoreManageProducts extends StatelessWidget {
  final ManageStoreVMv2 vm;

  const OnlineStoreManageProducts({Key? key, required this.vm})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      centreTitle: false,
      hasDrawer: false,
      displayNavDrawer: false,
      title: 'Manage Products',
      body: layout(context),
    );
  }

  layout(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        _tile(
          context: context,
          text: 'Add New Product',
          icon: Icons.add,
          route: CustomRoute(
            builder: (BuildContext context) =>
                const ProductPage(pageContext: ProductPageContext.onlineStore),
          ),
        ),
        const CommonDivider(),
        _tile(
          context: context,
          text: 'Manage Online Store Catalogue',
          icon: Icons.view_list_outlined,
          route: CustomRoute(
            builder: (BuildContext context) =>
                const OnlineStorePublishProductsPage(),
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
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: context.paragraphMedium(
        text,
        color: Theme.of(context).colorScheme.secondary,
        alignLeft: true,
        isSemiBold: true,
      ),
      onTap: () {
        Navigator.of(context).push(route);
      },
    ),
  );
}
