// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

// Package imports:
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/app_colours.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_informational.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/helpers/product_barcode_helper.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_scan_viewmodel.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/camera/barcode_scanner_view.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_scan_item_tile.dart';

class CheckoutScan extends StatefulWidget {
  final CheckoutScanViewModel? vm;
  final Future<bool> Function() onClearTap;

  const CheckoutScan({Key? key, this.vm, required this.onClearTap})
    : super(key: key);

  @override
  State<CheckoutScan> createState() => _CheckoutScanState();
}

class _CheckoutScanState extends State<CheckoutScan> {
  late CheckoutScanViewModel? vm;
  bool showItemNotFound = false;
  Timer? _notFoundTimer; // Timer to reset showItemNotFound

  @override
  void initState() {
    vm = widget.vm;
    super.initState();
  }

  @override
  void dispose() {
    _notFoundTimer?.cancel(); // Cancel timer on dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('### CheckoutScan build entry');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        barcodeScanner(context: context),
        const CommonDivider(),
        Expanded(child: itemList(context, vm!)),
        const CommonDivider(),
        bottomControls(context, vm!),
        if (Platform.isIOS) const SizedBox(height: 32),
      ],
    );
  }

  bool reading = false;

  Widget barcodeScanner({required BuildContext context}) {
    debugPrint('### CheckoutScan _barcodeScannerView entry');
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      child: BarcodeScannerView(
        onItemScanned: (barcode) async {
          debugPrint('### CheckoutScan onItemScanned $barcode');
          await _onItemScanned(barcode ?? '');
        },
        customWidget: showItemNotFound ? itemNotFoundTile(context) : null,
      ),
    );
  }

  Future<void> _onItemScanned(String barcode) async {
    if (reading) return; // Prevent concurrent scans
    reading = true;

    try {
      var thisProduct = await ProductBarcodeHelper.getProductByBarcode(
        barcode: barcode,
        store: AppVariables.store,
      );
      if (thisProduct == null) {
        debugPrint('### CheckoutScan NO product found');
        FlutterRingtonePlayer().play(
          fromAsset: 'assets/sounds/beep_error.m4a',
          looping: false,
          volume: 0.5,
          asAlarm: false,
        );
        setState(() {
          showItemNotFound = true;
        });
        // Reset showItemNotFound after 2 seconds
        _notFoundTimer?.cancel();
        _notFoundTimer = Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              showItemNotFound = false;
            });
          }
        });
      } else {
        showItemNotFound = false;
        FlutterRingtonePlayer().play(
          fromAsset: 'assets/sounds/beep.m4a',
          looping: false,
          volume: 0.5,
          asAlarm: false,
        );
        debugPrint('### CheckoutScan product found ${thisProduct.description}');
        var variance = thisProduct.getProductVariance(barcode);
        vm!.addItem(thisProduct, variance);
      }
    } finally {
      reading = false; // Allow new scans
    }

    debugPrint('### CheckoutScan rebuild');
    if (mounted) setState(() {});
  }

  Future<StockProduct?> getProductByBarcode(
    BuildContext context,
    String barcode,
  ) async {
    var product = await ProductBarcodeHelper.getProductByBarcode(
      barcode: barcode,
      store: AppVariables.store,
    );
    return product;
  }

  Widget itemList(BuildContext context, CheckoutScanViewModel vm) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, child) {
        return vm.itemCount > 0
            ? Container(
                color: Colors.white,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: vm.scannedItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = vm.scannedItems[index];
                    return scannedItem(context, vm, item);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const CommonDivider(height: 0.5),
                ),
              )
            : Center(
                child: context.headingLarge(
                  'No items',
                  color: Theme.of(context).extension<AppColours>()?.appNeutral,
                ),
              );
      },
    );
  }

  Slidable scannedItem(
    BuildContext context,
    CheckoutScanViewModel vm,
    CheckoutCartItem item,
  ) => Slidable(
    key: ValueKey('${item.productId!}-${item.quantity}'),
    endActionPane: ActionPane(
      extentRatio: .25,
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (ctx) async {
            var result = await confirmDismissal(context, item);
            if (result == true) {
              vm.removeItem(item);
            }
          },
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ],
    ),
    child: ListenableBuilder(
      listenable: item,
      builder: (context, child) {
        return CheckoutScanItemTile(scannedItem: item, vm: vm);
      },
    ),
  );

  Container bottomControls(BuildContext context, CheckoutScanViewModel vm) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          clearScannedItems(vm),
          const SizedBox(width: 8.0),
          addToCartButtonTotalValue(vm),
        ],
      ),
    );
  }

  Widget clearScannedItems(CheckoutScanViewModel vm) {
    return Expanded(
      child: ButtonSecondary(
        text: 'Clear',
        onTap: (c) async {
          bool result = false;
          if (vm.scannedItems.isNotEmpty) {
            result = await widget.onClearTap();
          }
          if (result) {
            if (mounted) {
              setState(() {
                vm.clear();
              });
            } else {
              vm.clear();
            }
          }
        },
      ),
    );
  }

  Widget addToCartButtonTotalValue(CheckoutScanViewModel vm) {
    return Expanded(
      child: ListenableBuilder(
        listenable: vm,
        builder: (context, child) {
          // Only this part of the UI rebuilds
          return ButtonSecondary(
            text: vm.itemCounter > 0
                ? '${vm.itemCounter} Items = '
                      '${TextFormatter.toStringCurrency(vm.totalValue, currencyCode: '')}'
                : 'No Items',
            onTap: (context) => addToCart(context, vm),
          );
        },
      ),
    );
  }

  Future<void> addToCart(BuildContext context, CheckoutScanViewModel vm) async {
    Navigator.of(context).pop(vm.scannedItems);
  }

  Widget itemNotFoundTile(BuildContext context) {
    return Container(
      color: Theme.of(
        context,
      ).extension<AppliedInformational>()?.neutralSurface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Center(
          child: context.labelLarge(
            'Product not found in catalogue',
            color: Theme.of(
              context,
            ).extension<AppliedInformational>()?.neutralText,
          ),
        ),
      ),
    );
  }
}
