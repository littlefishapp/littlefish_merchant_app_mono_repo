// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

List<CheckoutDiscount>? discountsSelector(AppState state) =>
    state.discountState.discounts;
