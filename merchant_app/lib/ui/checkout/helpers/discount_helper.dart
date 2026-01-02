import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';

class CheckoutDiscountValidator {
  static double getDiscountAmount(
    double totalBeforeTip,
    CheckoutDiscount? tip,
  ) {
    if (tip == null) return 0;
    tip.value ??= 0;

    if (tip.type == DiscountType.fixedAmount) {
      return tip.value!;
    } else {
      return totalBeforeTip * (tip.value! / 100);
    }
  }
}
