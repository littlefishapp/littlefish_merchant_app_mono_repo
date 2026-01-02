// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';

// Package imports:

// Project imports:
import 'package:littlefish_merchant/ui/checkout/layouts/library/select_products_page.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_quick_sale_page.dart';
import 'package:littlefish_merchant/ui/home/home_page.dart';

class NewSaleFAB extends StatefulWidget {
  const NewSaleFAB({Key? key}) : super(key: key);

  @override
  State<NewSaleFAB> createState() => _NewSaleFABState();
}

class _NewSaleFABState extends State<NewSaleFAB> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (isExpanded)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isExpanded ? 1.0 : 0.0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FloatingActionButton.extended(
                heroTag: 'quick_sale',
                onPressed: () {
                  // TODO(lampian) confirm navigation
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    CheckoutQuickSale.route,
                    ModalRoute.withName(HomePage.route),
                    arguments: 1,
                  );
                },
                icon: const Icon(Icons.bolt),
                label: const Text('Purchase'),
              ),
            ),
          ),
        if (isExpanded)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 160),
            opacity: isExpanded ? 1.0 : 0.0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FloatingActionButton.extended(
                heroTag: 'sell_products',
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    SelectProductsPage.route,
                    ModalRoute.withName(HomePage.route),
                  );
                },
                icon: const Icon(Icons.local_mall),
                label: const Text('Sell Products'),
              ),
            ),
          ),

        // Circular FAB
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: isExpanded
              ? FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = false;
                    });
                  },
                  backgroundColor: Theme.of(
                    context,
                  ).extension<AppliedSurface>()?.brand,
                  child: const Icon(Icons.close),
                )
              : FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = true;
                    });
                  },
                  backgroundColor: Theme.of(
                    context,
                  ).extension<AppliedSurface>()?.brand,
                  child: Icon(isExpanded ? Icons.close : Icons.shopping_cart),
                ),
        ),
      ],
    );
  }
}
