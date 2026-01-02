import 'dart:async';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart'
    as product_actions;
import 'package:redux/redux.dart';

class ProductBarcodeHelper {
  static Future<StockProduct?> getProductByBarcode({
    required String barcode,
    Store<AppState>? store,
  }) async {
    if (barcode.isEmpty) return null;

    var appStore = store ?? AppVariables.store;
    if (appStore == null) return null;

    Completer<StockProduct?> completer = Completer();
    appStore.dispatch(
      product_actions.getProductByBarcode(
        barcode: barcode,
        completer: completer,
      ),
    );
    return await completer.future;
  }
}
