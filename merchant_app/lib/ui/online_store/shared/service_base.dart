// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/auth/models/auth_user.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';

import '../../../features/ecommerce_shared/models/internationalization/country_codes.dart'
    as iso_models;
import '../../../features/ecommerce_shared/models/logon_result.dart';
import '../../../features/ecommerce_shared/models/order.dart';
import '../../../features/ecommerce_shared/models/payment_method.dart';
import '../../../features/ecommerce_shared/models/review.dart';
import '../../../features/ecommerce_shared/models/store/store.dart' as store_ui;
import '../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../features/ecommerce_shared/models/store/tracking_events.dart';
import '../../../features/ecommerce_shared/models/user/user.dart';

abstract class ServiceBase {
  ServiceBase.fromStore(
    Store<AppState>? storeValue, {
    bool enableMonitoring = true,
  }) {
    store = storeValue;
    client = RestClient(store: storeValue, monitor: enableMonitoring);
  }

  //load the store from the current context
  ServiceBase.fromContext(
    BuildContext context, {
    bool enableMonitoring = true,
  }) {
    store = StoreProvider.of<AppState>(context);
    client = RestClient(store: store, monitor: enableMonitoring);
  }

  Store<AppState>? store;

  RestClient? client;

  // Future<List<storeUI.Store>> searchStores(
  //   double longitude,
  //   double latitude,
  //   double kmRadius,
  // );

  Future<List<store_ui.StoreCategory>> getCategories({lang});

  Future<List<StoreProduct>?>? getProducts();

  Future<List<StoreProduct>?>? fetchProductsLayout({config, lang});

  Future<List<StoreProduct>?>? fetchProductsByCategory({
    categoryId,
    tagId,
    page,
    minPrice,
    maxPrice,
    orderBy,
    lang,
    order,
    featured,
    onSale,
    attribute,
    attributeTerm,
  });

  Future<CachedLogonResult?> logonFromCache();

  Future<LogonResult?>? loginFacebook({String? token});

  Future<LogonResult?>? loginSMS({String? token});

  Future<LogonResult?>? loginApple({String? email, String? fullName});

  Future<LogonResult> loginGoogle({String? token});

  Future<User> createUserProfile({
    required String firstName,
    required String lastName,
    required String emailAddress, //email address
    required String mobileNumber,
    required String profileUri,
    required AuthUser authUser,
    required iso_models.CountryCode? countryCode,
  });

  Future<LogonResult> createUser({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String emailAddress,
    required String mobileNumber,
    required iso_models.CountryCode countryCode,
    String? businessName,
    UserAccountType? accountType = UserAccountType.individual,
    bool googleExists = false,
  });

  Future<List<Review>?>? getReviews(productId);

  Future<List<ShippingMethod>?>? getShippingMethods({
    UserLocation? address,
    String? token,
  });

  Future<List<PaymentMethod>?>? getPaymentMethods({
    UserLocation? address,
    ShippingMethod? shippingMethod,
    String? token,
  });

  // Future<Order> createOrder({CartModel cartModel, User user, bool paid});

  // Future<List<Order>> getMyOrders({User user, int page});

  Future? updateOrder(orderId, {status, token});

  Future<List<StoreProduct>?>? searchProducts({
    name,
    categoryId,
    tag,
    attribute,
    attributeId,
    page,
    lang,
  });

  Future<User?>? getUserProfileInfo(cookie);

  Future<Map<String, dynamic>?>? updateUserProfileInfo(
    Map<String, dynamic> json,
    String token,
  );

  Future<LogonResult> login({required username, required password});

  Future<LogonResult> loginLinked({
    required username,
    required password,
    businessName,
    emailAddress,
    firstName,
    lastName,
    countryCode,
  });

  Future<StoreProduct>? getProduct(id);

  // Future<Coupons> getCoupons();

  Future<TrackingEvents?>? getAllTracking();

  Future<List<OrderNote>?>? getOrderNote({User? user, int? orderId});

  Future<Null>? createReview({int? productId, Map<String, dynamic>? data});

  Future<User?>? getUserProfileInfor({int? id});

  Future<Map<String, dynamic>?>? getHomeCache();

  Future? getCategoryWithCache();

  Future<String?>? getCheckoutUrl(Map<String, dynamic> params);
}
