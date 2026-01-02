// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/stock_variance.dart';
import 'package:littlefish_merchant/providers/permissions_provider.dart';

class CheckoutScanViewModel extends ChangeNotifier {
  CheckoutScanViewModel({required BuildContext context});

  Future<bool> get scanAllowed {
    var permissionStatus = PermissionsProvider.instance.hasPermission(
      Permission.camera,
    );
    return permissionStatus;
  }

  List<CheckoutCartItem>? _scannedItems;

  List<CheckoutCartItem> get scannedItems {
    return _scannedItems ?? <CheckoutCartItem>[];
  }

  int get itemCount {
    int total = 0;

    for (var i in scannedItems) {
      total += i.quantity.round();
    }

    return total;
  }

  int _itemCounter = 0;

  int get itemCounter {
    int total = 0;
    for (var i in scannedItems) {
      total += i.quantity.round();
    }
    _itemCounter = total;
    return _itemCounter;
  }

  set itemCounter(int count) {
    _itemCounter = count;
    notifyListeners();
  }

  double get totalValue {
    double sumValue = 0;

    for (var i in scannedItems) {
      sumValue += i.value!;
    }
    return sumValue;
  }

  CheckoutCartItem addItem(StockProduct product, StockVariance? variance) {
    _scannedItems ??= <CheckoutCartItem>[];

    bool hasItem = scannedItems.any(
      (i) => i.productId == product.id && i.barcode == variance!.barcode,
    );

    CheckoutCartItem item;

    if (hasItem) {
      var existingItemIndex = scannedItems.indexWhere(
        (i) => i.productId == product.id && i.barcode == variance!.barcode,
      );

      item = scannedItems[existingItemIndex];

      item.quantity += 1;

      scannedItems[existingItemIndex] = item;
      notifyListeners();
      return item;
    } else {
      var item = CheckoutCartItem.fromProduct(
        product,
        variance ?? product.regularVariance!,
      );

      scannedItems.add(item);
      notifyListeners();
      return item;
    }
  }

  void updateItemQuantity(CheckoutCartItem item, double quantity) {
    if (_scannedItems == null) return;

    var itemIndex = _scannedItems!.indexWhere(
      (c) => c.productId == item.productId && c.barcode == item.barcode,
    );

    if (itemIndex == -1) return;

    if (quantity <= 0) {
      removeItem(item);
      return;
    }

    _scannedItems![itemIndex].quantity = quantity;
    notifyListeners();
  }

  void removeItem(CheckoutCartItem item) {
    if (_scannedItems == null) return;
    _scannedItems!.removeWhere(
      (c) => c.productId == item.productId && c.barcode == item.barcode,
    );
    notifyListeners();
  }

  void clear() {
    if (_scannedItems == null) return;
    _scannedItems!.clear();
    notifyListeners();
  }

  Future<bool?> requestScanPermission() async {
    if (await scanAllowed) return true;

    var result = await (PermissionsProvider.instance.requestPermission(
      Permission.camera,
    ));

    return result?.isGranted;
  }
}
