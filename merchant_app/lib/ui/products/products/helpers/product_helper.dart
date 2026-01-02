import 'package:littlefish_merchant/app/app.dart';

class ProductHelper {
  static bool isBarcodeUnique(barcode) {
    if (barcode == null) return false;

    var product = AppVariables.store?.state.productState
        .getProductAndOptionsByBarcode(barcode);
    return product == null;
  }
}
