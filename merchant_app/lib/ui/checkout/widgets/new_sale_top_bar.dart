import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/pages/camera/barcode_helper.dart';
import 'package:littlefish_merchant/features/multi_cart_item_infrared_barcode_scanner/data/multi_item_infrared_barcode_scanner.dart';
import 'package:littlefish_merchant/features/multi_cart_item_infrared_barcode_scanner/presentation/pages/infrared_multi_cart_item_barcode_scan_page.dart';
import 'package:littlefish_merchant/features/multi_cart_item_infrared_barcode_scanner/presentation/viewmodel/pos_multi_barcode_scanner_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/square_icon_button_secondary.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/shared/constants/semantics_constants.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_scan_page.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/new_quick_sale_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../common/presentaion/components/buttons/discard_sale_button.dart';
import '../viewmodels/checkout_viewmodels.dart';
import 'new_sales_search_product.dart';

class NewSaleTopBar extends StatefulWidget {
  final TextEditingController searchController;
  final void Function(String) onChanged;
  final CheckoutVM vm;

  const NewSaleTopBar({
    Key? key,
    required this.context,
    required this.searchController,
    required this.vm,
    required this.onChanged,
  }) : super(key: key);

  final BuildContext context;

  @override
  State<NewSaleTopBar> createState() => _NewSaleTopBarState();
}

class _NewSaleTopBarState extends State<NewSaleTopBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: NewSaleSearchProduct(
              onChanged: widget.onChanged,
              searchController: widget.searchController,
            ),
          ),
          if (userHasPermission(allowScanBarcode))
            Container(
              padding: const EdgeInsets.only(left: 4),
              child: SquareIconButtonSecondary(
                semanticsIdentifier: SemanticsConstants.kBarcodeScanner,
                semanticsLabel: SemanticsConstants.kBarcodeScanner,
                icon: MdiIcons.barcodeScan,
                onPressed: (ctx) => scanItems(context: ctx, vm: widget.vm),
              ),
            ),
          if (userHasPermission(allowDiscardBasket)) ...[
            Container(
              padding: const EdgeInsets.only(left: 4),
              child: DiscardSaleButton(
                checkoutVM: widget.vm,
                isIconButton: true,
                enabled: (widget.vm.itemCount ?? 0) > 0,
              ),
            ),
          ],
          if (userHasPermission(allowQuickSale)) ...[
            Container(
              padding: const EdgeInsets.only(left: 4),
              child: NewQuickSaleButton(vm: widget.vm),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> scanItems({
    required BuildContext context,
    required CheckoutVM vm,
  }) async {
    final poslaserScanningAvailable = await checkPosLaserScanningAvailable(
      vm.store,
    );
    final laserScannerRegistered = core
        .isRegistered<MultiCartItemInfraBarcodeScanner>();

    if (poslaserScanningAvailable &&
        cardPaymentRegistered == CardPaymentRegistered.pos &&
        laserScannerRegistered) {
      Navigator.push(
        // removed ignore: use_build_context_synchronously
        context,
        CustomRoute(
          builder: (context) => const InfraredMultiCartItemBarcodeScanPage(),
        ),
      );
    } else {
      final hasCameraAccess = await getCameraAccess();
      if (hasCameraAccess) {
        final scannedItems = await Navigator.of(context)
            .push<List<CheckoutCartItem>>(
              CustomRoute(
                maintainState: true,
                builder: (BuildContext context) => const CheckoutScanPage(),
              ),
            );
        if (scannedItems != null) {
          vm.addItemsToCart(scannedItems);
        }
      } else {
        await showMessageDialog(
          // removed ignore: use_build_context_synchronously
          context,
          'We require access to the camera to scan barcodes',
          Icons.camera,
        );
      }
    }
  }
}
