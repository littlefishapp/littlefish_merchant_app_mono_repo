// removed ignore: depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/pages/manage_product_discounts_page.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/products/categories/widgets/product_categories_page.dart';
import 'package:littlefish_merchant/ui/products/combos/product_combos_page.dart';
import 'package:littlefish_merchant/ui/products/products/products_page.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

class ProductsMenuPage extends StatelessWidget {
  static const String route = '/products/menu';

  const ProductsMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Manage Products',
      body: StoreBuilder<AppState>(
        builder: (BuildContext context, Store<AppState> vm) => Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  const CommonDivider(),
                  settingItem(
                    context,
                    'Products',
                    ProductsPage.route,
                    icon: Icons.list,
                    subtitle: 'view or edit your existing products',
                  ),
                  const CommonDivider(),
                  settingItem(
                    context,
                    'Categories',
                    ProductCategoriesPage.route,
                    icon: Icons.business,
                    subtitle: 'view or edit your existing categories',
                  ),
                  const CommonDivider(),
                  settingItem(
                    context,
                    'Combos',
                    ProductCombosPage.route,
                    icon: Icons.queue,
                    subtitle: 'view or edit your existing combos',
                  ),
                  // CommonDivider(),
                  // settingItem(
                  //   context,
                  //   "Modifiers",
                  //   ProductModifiersPage.route,
                  //   icon: Icons.queue,
                  //   subtitle: "view or edit your modifiers",
                  // ),
                  const CommonDivider(),
                  settingItem(
                    context,
                    'Discounts',
                    ManageProductDiscountsPage.route,
                    icon: Icons.disc_full,
                    subtitle: 'view or edit your discounts',
                  ),
                ],
              ),
            ),
            const CommonDivider(height: 0.5),
          ],
        ),
      ),
    );
  }

  ListTile settingItem(
    context,
    String title,
    String route, {
    IconData? icon,
    String? subtitle,
  }) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    // dense: true,
    // leading: icon == null
    //     ? null
    //     : OutlineGradientAvatar(
    //         child: Icon(
    //           icon,
    //           color: Colors.grey,
    //         ),
    //       ),
    title: Text(title),
    subtitle: subtitle == null || subtitle.isEmpty ? null : LongText(subtitle),
    trailing: Icon(
      Platform.isAndroid ? Icons.arrow_forward : Icons.arrow_forward_ios,
    ),
    onTap: () => Navigator.of(context).pushNamed(route),
  );
}
