import 'package:flutter/widgets.dart';
import 'package:littlefish_interfaces/scan_result_interface.dart';

import '../../../redux/app/app_state.dart';
import 'package:redux/redux.dart';

abstract class MultiCartItemInfraBarcodeScanner<T, Y, Z> {
  MultiCartItemInfraBarcodeScanner();

  Future<void> Function(String value)? onItemScanned;
  void Function()? refresUI;
  void Function()? dismissScanner;
  void Function()? beepOnce;

  String get notFoundText;

  ScanResultInterface get scanResultInterface;

  List<T>? get scannedItems;

  bool get isLoading;

  Store<AppState> get store;

  Y get state;

  void loadFromStore(Store<AppState> store, {BuildContext? context});

  Future<ScanResultInterface> scan({BuildContext? context});

  Future<void> clearButContinue({required BuildContext context});

  Future<void> cancelScan({required BuildContext context});

  void addToCart({required BuildContext context});

  void onScannedItemQuantityChange({
    required double difference,
    required String itemId,
  });

  Z returnListItemWidget({required T item, BuildContext? context});
}
