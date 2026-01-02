// remove ignore_for_file: implementation_imports

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_core/hardware/scanners/littlefish_scanner.dart';
import 'package:littlefish_interfaces/scan_result_interface.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_controller.dart';
import 'package:littlefish_merchant/models/stock/stock_variance.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/helpers/product_barcode_helper.dart';
import 'package:quiver/strings.dart';
import 'package:redux/src/store.dart';
import '../../../../injector.dart';
import '../../../../models/sales/checkout/checkout_cart_item.dart';
import '../../../../models/stock/stock_product.dart';
import '../../../../redux/checkout/checkout_actions.dart';
import '../../../../redux/checkout/checkout_state.dart';
import '../../../../tools/network_image/flutter_network_image.dart';
import '../../../../tools/textformatter.dart';
import '../../../../ui/business/expenses/widgets/selectable_quantity_tile_new.dart';
import '../../../../ui/checkout/widgets/checkout_tile_helper.dart';
import '../../../pos/data/data_source/pos_service.dart';
import '../../data/multi_item_infrared_barcode_scanner.dart';
import '../components/infrared_multi_scan_message_dialogs.dart';

class PosMultiCartItemBarcodeScannerVM
    implements
        MultiCartItemInfraBarcodeScanner<
          StockProduct,
          CheckoutState,
          SelectableQuantityTile
        > {
  PosMultiCartItemBarcodeScannerVM();

  static const String executionTimeOutText = '(execution timeout)';
  static const String dismissText = 'dismiss';
  static const String _notFoundText = 'product not found';

  late PosService posScanService;

  List<CheckoutCartItem> cartItems = [];
  var _scannerActive = false;
  bool get isScannerActive => _scannerActive;

  @override
  ScanResultInterface scanResultInterface = ScanResultInterface();

  @override
  Future<void> Function(String value)? onItemScanned;

  @override
  List<StockProduct> scannedItems = [];

  @override
  late bool isLoading;

  @override
  late CheckoutState state;

  @override
  late Store<AppState> store;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    state = store.state.checkoutState;
    this.store = store;
    posScanService = PosService.fromStore(store: store);
    _scannerActive = true;
  }

  @override
  Future<ScanResultInterface> scan({BuildContext? context}) async {
    try {
      scanResultInterface = await posScanService.scanHW(
        scanMode: ScanMode.continousScan,
      );
    } on Exception catch (e) {
      logger.error(
        this,
        'An error occurred during scanning',
        error: e,
        stackTrace: StackTrace.current,
      );
    }

    var isTimedOut = scanResultInterface.resultString.toLowerCase().contains(
      executionTimeOutText,
    );

    var product = isTimedOut
        ? null
        : await _tryGetProduct(scanResultInterface.resultString);

    if (product == null && !isTimedOut) {
      return ScanResultInterface(resultString: _notFoundText, resultFormat: '');
    }

    if (product != null) {
      _addToProductList(product);
      _addToCartItemList(product);

      if (beepOnce != null) {
        beepOnce!();
      }
    }

    return scanResultInterface;
  }

  @override
  Future<void> addToCart({required BuildContext context}) async {
    if (cartItems.isEmpty) {
      dismissScanner!();
      return;
    }
    store.dispatch(CheckoutAddItemsToCart(cartItems));
    _scannerActive = false;
    _clearLists();
    dismissScanner!();
    // await Future.delayed(
    //   const Duration(seconds: 1),
    //   () {
    //     _clearLists();
    //     Navigator.of(context).pop();
    //   },
    // );
  }

  @override
  Future<void> cancelScan({required BuildContext context}) async {
    debugPrint('### Scanner PosMultiCartItemBarcodeScannerVM cancelScan');
    if (scannedItems.isEmpty) {
      _scannerActive = false;
      dismissScanner!();
      return;
    }
    var cancelScan = await InfraredMultiScanMessageDialogs.cancelScanDialog(
      context,
    );
    if (cancelScan ?? false) {
      _clearLists();
      _scannerActive = false;
      dismissScanner!();
    }
  }

  @override
  Future<void> clearButContinue({required BuildContext context}) async {
    if (scannedItems.isEmpty) {
      return;
    }
    var discardScan = await InfraredMultiScanMessageDialogs.clearItemsDialog(
      context,
    );
    if (discardScan ?? false) {
      _clearLists();
    }
  }

  @override
  void onScannedItemQuantityChange({
    required double difference,
    required String itemId,
  }) {
    var product = store.state.productState.getProductById(itemId);
    if (product != null) {
      _changeCartItemQuantity(difference, itemId);
    }
  }

  @override
  SelectableQuantityTile returnListItemWidget({
    required StockProduct item,
    BuildContext? context,
  }) {
    var cartItem = cartItems.firstWhereOrNull((e) => e.productId == item.id);
    return SelectableQuantityTile(
      initialQuantity: cartItem != null ? cartItem.quantity : 1,
      leading: isNotBlank(item.imageUri)
          ? getIt<FlutterNetworkImage>().asWidget(
              id: item.id!,
              category: 'products',
              legacyUrl: item.imageUri!,
              height: AppVariables.listImageHeight,
              width: AppVariables.listImageWidth,
            )
          : const Icon(Icons.inventory_2_outlined),
      enableQuantityField: true,
      trailing: CheckoutTileHelper.buildTrailText(
        context: context!,
        trailText: TextFormatter.toStringCurrency(
          cartItem != null
              ? item.regularSellingPrice! * cartItem.quantity
              : item.regularSellingPrice! ?? 0,
          currencyCode: '',
        ),
      ),
      title: CheckoutTileHelper.buildTitle(
        context: context,
        title: item.displayName ?? '',
      ),
      onTap: (quantity) {
        onScannedItemQuantityChange(difference: quantity, itemId: item.id!);
      },
      onFieldSubmitted: (quantity) {
        onScannedItemQuantityChange(difference: quantity, itemId: item.id!);
      },
    );
  }

  Future<StockProduct?> _tryGetProduct(String? barcode) async {
    return await ProductBarcodeHelper.getProductByBarcode(
      barcode: barcode ?? '',
      store: store,
    );
    // return store.state.productState.getProductByBarcode(barcode);
  }

  void _addToCartItemList(StockProduct product) {
    var index = CheckoutCartController.getItemIndexInCart(product, cartItems);
    if (index > -1) {
      cartItems[index].quantity++;
      return;
    }
    cartItems.add(
      CheckoutCartItem.fromProduct(
        product,
        product.variances?.first ?? StockVariance(),
      ),
    );
  }

  _addToProductList(StockProduct product) {
    if (scannedItems.where((element) => element.id == product.id).isEmpty) {
      scannedItems.add(product);
    }
  }

  _changeCartItemQuantity(double difference, String productId) {
    var index = CheckoutCartController.getItemIndexInCart(
      productId,
      cartItems,
      searchCondition: (cartItem) => cartItem.productId == productId,
    );
    if (index > -1) {
      if (difference == 0) {
        cartItems.removeAt(index);
        scannedItems.removeWhere((e) => e.id == productId);
        return;
      }
      cartItems[index].quantity = difference;
    }
  }

  _clearLists() {
    cartItems = [];
    scannedItems = [];
  }

  @override
  void Function()? refresUI;

  @override
  void Function()? beepOnce;

  @override
  void Function()? dismissScanner;

  @override
  String get notFoundText => _notFoundText;
}
