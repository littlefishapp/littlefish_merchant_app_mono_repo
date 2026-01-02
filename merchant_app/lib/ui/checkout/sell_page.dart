import 'package:flutter/material.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/library/select_products_page.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/dashboard_page.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_quick_sale_page.dart';

class SellPage extends StatelessWidget {
  static const route = 'checkout/sell';

  const SellPage({super.key});

  @override
  Widget build(BuildContext context) {
    LittleFishCore core = LittleFishCore.instance;
    final ConfigService configService = core.get<ConfigService>();

    final layout = configService.getStringValue(
      key: 'config_sell_layout',
      defaultValue: 'default',
    );
    debugPrint('### SellPage layout: $layout');
    final isInGuestMode = AppVariables.isInGuestMode;

    switch (layout) {
      case 'default':
        return const SelectProductsPage();
      case 'library':
        return const SelectProductsPage();
      case 'dashboard':
        return const DashboardPage();
      case 'quick-sale':
        return const CheckoutQuickSale();
      case 'guest-only-dashboard':
        return isInGuestMode
            ? const DashboardPage()
            : const SelectProductsPage();
      default:
        return const SelectProductsPage();
    }
  }
}
