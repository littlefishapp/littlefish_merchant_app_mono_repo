// import 'package:built_value/serializer.dart';
// import 'package:built_value/standard_json_plugin.dart';
// import 'package:littlefish_merchant/environment/environment_config.dart';
// import 'package:littlefish_merchant/models/customers/customer.dart';
// import 'package:littlefish_merchant/models/stock/stock_category.dart';
// import 'package:littlefish_merchant/models/stock/stock_product.dart';
// import 'package:littlefish_merchant/redux/app/app_state.dart';
// import 'package:littlefish_merchant/redux/auth/auth_state.dart';
// import 'package:littlefish_merchant/redux/business/business_state.dart';
// import 'package:littlefish_merchant/redux/checkout/checkout_state.dart';
// import 'package:littlefish_merchant/redux/customer/customer_state.dart';
// import 'package:littlefish_merchant/redux/environment/environment_state.dart';
// import 'package:littlefish_merchant/redux/inventory/inventory_state.dart';
// import 'package:littlefish_merchant/redux/locale/locale_state.dart';
// import 'package:littlefish_merchant/redux/product/product_state.dart';
// import 'package:littlefish_merchant/redux/settings/settings_state.dart';
// import 'package:littlefish_merchant/redux/tax/tax_state.dart';
// import 'package:littlefish_merchant/redux/user/user_state.dart';

// part 'serializers.g.dart';

// //add all of the built value types that require serialization
// @SerializersFor([
//   AppState,
//   AuthState,
//   CustomerState,
//   InventoryState,
//   ProductState,
//   EnvironmentState,
//   EnvironmentConfig,
//   Customer,
//   StockProduct,
//   StockCategory,
//   CheckoutState,
//   TaxState,
//   BusinessState,
//   LocaleState,
//   UserState,
// ])
// final Serializers serializers =
//     (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
