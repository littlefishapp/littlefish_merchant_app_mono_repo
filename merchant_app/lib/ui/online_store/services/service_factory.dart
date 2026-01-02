// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:littlefish_core/auth/models/auth_user.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/littlefish_firestore.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/littlefish_service.dart';
import 'package:littlefish_merchant/ui/online_store/shared/service_base.dart';

import '../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../features/ecommerce_shared/models/internationalization/country_codes.dart'
    as iso_models;
import '../../../features/ecommerce_shared/models/logon_result.dart';
import '../../../features/ecommerce_shared/models/order.dart';
import '../../../features/ecommerce_shared/models/payment_method.dart';
import '../../../features/ecommerce_shared/models/review.dart';
import '../../../features/ecommerce_shared/models/store/store.dart' as store_ui;
import '../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../features/ecommerce_shared/models/store/store_user.dart';
import '../../../features/ecommerce_shared/models/store/tracking_events.dart';
import '../../../features/ecommerce_shared/models/user/user.dart';

class ServiceFactory implements ServiceBase {
  static final ServiceFactory _instance = ServiceFactory._internal();

  factory ServiceFactory() => _instance;

  ServiceFactory._internal();

  late ServiceBase serviceApi;

  //config comes from the config.dart file
  configureFactory(store, config) {
    client = RestClient(store: store);
    serviceApi = LittleFishService.fromStore(this.store);
  }

  @override
  RestClient? client;

  @override
  Store<AppState>? store;

  @override
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
  }) async {
    return serviceApi.createUser(
      emailAddress: emailAddress,
      firstName: firstName,
      lastName: lastName,
      mobileNumber: mobileNumber,
      password: password,
      username: username,
      accountType: accountType,
      businessName: businessName,
      countryCode: countryCode,
      googleExists: googleExists,
    );
  }

  @override
  Future<LogonResult> login({required username, required password}) async {
    return serviceApi.login(username: username, password: password);
  }

  @override
  Future<LogonResult> loginLinked({
    required username,
    required password,
    businessName,
    emailAddress,
    firstName,
    lastName,
    countryCode,
  }) async {
    return serviceApi.loginLinked(
      username: username,
      password: password,
      businessName: businessName,
      emailAddress: emailAddress,
      firstName: firstName,
      lastName: lastName,
      countryCode: countryCode,
    );
  }

  @override
  Future<LogonResult> loginGoogle({String? token}) async {
    return serviceApi.loginGoogle(token: token);
  }

  @override
  Future<User> createUserProfile({
    required String firstName,
    required String lastName,
    required String emailAddress, //email address
    required String mobileNumber,
    required String profileUri,
    required AuthUser authUser,
    required iso_models.CountryCode? countryCode,
  }) async {
    return serviceApi.createUserProfile(
      emailAddress: emailAddress,
      firstName: firstName,
      lastName: lastName,
      mobileNumber: mobileNumber,
      countryCode: countryCode,
      authUser: authUser,
      profileUri: profileUri,
    );
  }

  @override
  Future<CachedLogonResult?> logonFromCache() async {
    return serviceApi.logonFromCache();
  }

  @override
  Future<Null>? createReview({int? productId, Map<String, dynamic>? data}) {
    // TODO: implement createReview
    return null;
  }

  @override
  Future<List<StoreProduct>>? fetchProductsByCategory({
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
  }) {
    // TODO: implement fetchProductsByCategory
    return null;
  }

  @override
  Future<List<StoreProduct>>? fetchProductsLayout({config, lang}) {
    // TODO: implement fetchProductsLayout
    return null;
  }

  @override
  Future<TrackingEvents>? getAllTracking() {
    // TODO: implement getAllTracking
    return null;
  }

  @override
  Future<List<store_ui.StoreCategory>> getCategories({lang}) async {
    return serviceApi.getCategories(lang: lang);
  }

  @override
  Future? getCategoryWithCache() {
    // TODO: implement getCategoryWithCache
    return null;
  }

  @override
  Future<String>? getCheckoutUrl(Map<String, dynamic> params) {
    // TODO: implement getCheckoutUrl
    return null;
  }

  @override
  Future<Map<String, dynamic>>? getHomeCache() {
    // TODO: implement getHomeCache
    return null;
  }

  @override
  Future<List<OrderNote>>? getOrderNote({User? user, int? orderId}) {
    // TODO: implement getOrderNote
    return null;
  }

  Future<List<store_ui.Store>>? getOutlets() {
    // TODO: implement getOutlets
    return null;
  }

  @override
  Future<List<PaymentMethod>>? getPaymentMethods({
    UserLocation? address,
    ShippingMethod? shippingMethod,
    String? token,
  }) {
    // TODO: implement getPaymentMethods
    return null;
  }

  @override
  Future<StoreProduct>? getProduct(id) {
    // TODO: implement getProduct
    return null;
  }

  @override
  Future<List<StoreProduct>>? getProducts() {
    // TODO: implement getProducts
    return null;
  }

  @override
  Future<List<Review>>? getReviews(productId) {
    // TODO: implement getReviews
    return null;
  }

  @override
  Future<List<ShippingMethod>>? getShippingMethods({
    UserLocation? address,
    String? token,
  }) {
    // TODO: implement getShippingMethods
    return null;
  }

  @override
  Future<User>? getUserProfileInfo(cookie) {
    // TODO: implement getUserProfileInfo
    return null;
  }

  @override
  Future<User>? getUserProfileInfor({int? id}) {
    // TODO: implement getUserProfileInfor
    return null;
  }

  @override
  Future<LogonResult>? loginApple({String? email, String? fullName}) {
    // TODO: implement loginApple
    return null;
  }

  @override
  Future<LogonResult>? loginFacebook({String? token}) {
    // TODO: implement loginFacebook
    return null;
  }

  @override
  Future<LogonResult>? loginSMS({String? token}) {
    // TODO: implement loginSMS
    return null;
  }

  @override
  Future<List<StoreProduct>>? searchProducts({
    name,
    categoryId,
    tag,
    attribute,
    attributeId,
    page,
    lang,
  }) {
    // TODO: implement searchProducts
    return null;
  }

  @override
  Future? updateOrder(orderId, {status, token}) {
    // TODO: implement updateOrder
    return null;
  }

  @override
  Future<Map<String, dynamic>>? updateUserProfileInfo(
    Map<String, dynamic> json,
    String token,
  ) {
    // TODO: implement updateUserProfileInfo
    return null;
  }

  // @override
  // Future<List<AdvertisingBanner>> getFeaturedBannerAds() async {
  //   return serviceApi.getFeaturedBannerAds();
  // }

  // @override
  // Future<List<AdvertisingBanner>?> getStoreBannerAds(String storeId) {
  //   return serviceApi.getStoreBannerAds(storeId);
  // }

  // @override
  // Future<List<storeUI.Store>> searchStores(
  //     double longitude, double latitude, double kmRadius) {
  //   return serviceApi.searchStores(
  //     longitude,
  //     latitude,
  //     kmRadius,
  //   );
  // }

  Future<List<StoreUser>> getStoreTeam(store_ui.Store thisStore) async {
    var fireService = FirestoreService();

    return (await fireService.getStoreTeam(thisStore))
        .map((su) => StoreUser.fromJson(su.data() as Map<String, dynamic>))
        .toList();
  }

  Future<int> unpublishStoreProduct(
    String storeId,
    StoreProduct product,
  ) async {
    var fireService = FirestoreService();

    int? remainingDocs = await fireService.unpublishStoreProduct(
      storeId,
      product,
    );

    return remainingDocs;
  }

  Future<int> getOnlineProductCount(String storeId) async {
    var fireService = FirestoreService();

    int? remainingDocs = await fireService.getOnlineProductCount(storeId);

    return remainingDocs;
  }

  void updateStoreCategory(
    String storeId,
    StoreProductCategory category,
  ) async {
    var fireService = FirestoreService();

    fireService.updateStoreCategory(storeId, category);
  }

  Future<List<StoreProductCategory>> getProductCategories(
    store_ui.Store thisStore,
  ) async {
    var fireService = FirestoreService();

    var result = (await fireService.getProductCategories(thisStore))
        .map(
          (su) =>
              StoreProductCategory.fromDocumentSnapshot(su)
                ..populateSubCategories(),
        )
        .toList();

    return result;
  }

  Future<StoreProductCategory> upsertProductCategory(
    StoreProductCategory category,
    store_ui.Store thisStore,
  ) async {
    var ref = thisStore.categoryCollection!.doc(category.id);

    await ref.set(category.toJson());

    var result = StoreProductCategory.fromDocumentSnapshot(await ref.get());

    return result;
  }

  Future<List<CheckoutOrder>> getOrders(store_ui.Store thisStore) async {
    var fireService = FirestoreService();

    return (await fireService.getOrders(thisStore))
        .map((su) => CheckoutOrder.fromJson(su.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<OrderStatus>> getOrderStatuses(store_ui.Store thisStore) async {
    var fireService = FirestoreService();

    return (await fireService.getOrdersStatuses(thisStore))
        .map((su) => OrderStatus.fromJson(su.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<QuerySnapshot> getOrdersStatusesStream(store_ui.Store thisStore) {
    var fireService = FirestoreService();

    return fireService.getOrdersStatusesStream(thisStore);
  }

  // Stream<QuerySnapshot> getOrdersStatusesStreamFiltered(
  //     storeUI.Store thisStore) {
  //   var _fireService = FirestoreService();

  //   return _fireService.getOrdersStreamFiltered(
  //       thisStore, store!.state.searchState.orderSearchParams!);
  // }

  Stream<QuerySnapshot> getOrdersStream(store_ui.Store thisStore) {
    var fireService = FirestoreService();

    return fireService.getOrdersStream(thisStore);
  }

  Future<List<StoreProduct>> getStoreProducts(store_ui.Store thisStore) async {
    var fireService = FirestoreService();

    return (await fireService.getProducts(thisStore))
        .map((su) => StoreProduct.fromJson(su.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<StoreProduct>> getStoreProductsByCategory(
    store_ui.Store thisStore,
    String categoryId,
  ) async {
    var fireService = FirestoreService();

    return (await fireService.getProductsPerCategory(thisStore, categoryId))
        .map((su) => StoreProduct.fromJson(su.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<StoreProduct>> getStoreFeaturedProducts(
    store_ui.Store thisStore,
  ) async {
    var fireService = FirestoreService();

    return (await fireService.getFeaturedProducts(thisStore))
        .map((su) => StoreProduct.fromJson(su.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<StoreProduct>> getStoreSaleProducts(
    store_ui.Store thisStore,
  ) async {
    var fireService = FirestoreService();

    return (await fireService.getOnSaleProducts(thisStore))
        .map((su) => StoreProduct.fromJson(su.data() as Map<String, dynamic>))
        .toList();
  }

  Future<store_ui.Store?> getStore(String storeId) async {
    var fireService = FirestoreService();

    var s = await fireService.getStore(storeId);
    var data = await s.get();

    if (data.exists == false) return null;

    return store_ui.Store.fromDocumentSnapshot(data, reference: s);
  }

  Future<List<UserLocation>> getUserLocations(User user) async {
    var fireService = FirestoreService();

    var data = await fireService.getUserLocations(user);

    return data.docs
        .map(
          (doc) => UserLocation.fromDocumentSnapshot(
            doc,
            reference: user.locationsCollection!.doc(doc.id),
          ),
        )
        .toList();
  }

  Future<bool> saveUserLocation(User user, UserLocation location) async {
    var fireService = FirestoreService();

    await fireService.saveUserLocation(user, location);

    return true;
  }
}
