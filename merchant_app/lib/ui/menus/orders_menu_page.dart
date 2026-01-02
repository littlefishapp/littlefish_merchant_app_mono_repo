// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/business/expenses/pages/expenses_page.dart';
import 'package:littlefish_merchant/ui/invoicing/invoices_page.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/ui/suppliers/suppliers_page.dart';

class SuppliersMenuPage extends StatelessWidget {
  static const String route = '/suppliers/menu';

  const SuppliersMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Manage Suppliers',
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
                    'Suppliers',
                    SuppliersPage.route,
                    icon: Icons.list,
                    subtitle: 'view and manage your suppliers',
                  ),
                  const CommonDivider(),
                  settingItem(
                    context,
                    'Supplier Invoices',
                    InvoicesPage.route,
                    icon: Icons.business,
                    subtitle: 'view and manage your invoices',
                  ),
                  const CommonDivider(),
                  settingItem(
                    context,
                    'Expenses',
                    ExpensesPage.route,
                    icon: Icons.business,
                    subtitle: 'view and manage your expenses',
                  ),
                  const CommonDivider(),
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
