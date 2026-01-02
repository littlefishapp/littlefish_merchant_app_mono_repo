import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:littlefish_core/auth/models/auth_user.dart';
// import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:uuid/uuid.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/tools/exceptions/common_exceptions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/event_code_constants.dart';
import '../../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../../features/ecommerce_shared/models/internationalization/country_codes.dart';
import '../../../../features/ecommerce_shared/models/online/order_search_params.dart';
import '../../../../features/ecommerce_shared/models/points/user_points.dart';
import '../../../../features/ecommerce_shared/models/store/store.dart';
import '../../../../features/ecommerce_shared/models/store/store_customer.dart';
import '../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../features/ecommerce_shared/models/store/store_user.dart';
import '../../../../features/ecommerce_shared/models/system/system_models.dart';
import '../../../../features/ecommerce_shared/models/user/user.dart';

class FirestoreService {
  bool isOnline = true;

  bool isConfigured = false;

  // GeoFlutterFire? _outletGeoStore;

  // GeoFlutterFire? get outletGeoStore {
  //   _outletGeoStore ??= GeoFlutterFire();

  //   return _outletGeoStore;
  // }

  FirebaseFirestore? _datastore;

  FirebaseFirestore? get dataStore {
    _datastore ??= FirebaseFirestore.instance;

    return _datastore;
  }

  configureService() async {
    try {
      isConfigured = false;

      FirebaseFirestore.instance.settings = const Settings(
        cacheSizeBytes: 1048576,
        persistenceEnabled: true,
      );

      isConfigured = true;
    } catch (e) {
      reportCheckedError(e);
    }
  }

  // goOffline() async {
  //   await realtimeDataStore.goOffline();
  //   isOnline = false;
  // }

  // goOnline() async {
  //   await realtimeDataStore.goOnline();
  //   isOnline = true;
  // }

  List<UserNotificationTopic> getDefaultTopics() => [
    UserNotificationTopic(
      allowed: true,
      topic: 'Tips',
      topicId: 'topics',
      description: 'Buying tips',
    ),
    UserNotificationTopic(
      allowed: true,
      topic: 'deals',
      topicId: 'deals',
      description: 'Deals and rewards',
    ),
    UserNotificationTopic(
      allowed: true,
      topic: 'orders',
      topicId: 'orders',
      description: 'Order Updates',
    ),
    UserNotificationTopic(
      allowed: true,
      topic: 'broadcasts',
      topicId: 'broadcasts',
      description: 'Latest news',
    ),
  ];

  Stream<List<DocumentSnapshot>> getStoreActivityFeed(
    String? storeId, {
    int limit = 50,
  }) {
    var documentRef = dataStore!.doc('stores/$storeId');

    var collection = documentRef.collection('activity');

    var query = collection.orderBy('activityDate', descending: true);
    query = query.limit(limit);

    return query.snapshots().map((event) => event.docs);
  }

  Future<User> saveUser(User user) async {
    var collection = dataStore!.collection('users');

    var batch = dataStore!.batch();

    var reference = collection.doc(user.id);

    var topicsCollection = reference.collection('notificationTopics');

    getDefaultTopics().forEach((element) {
      batch.set(topicsCollection.doc(element.topicId), element.toJson());
    });

    batch.set(reference, user.toJson());

    user.documentReference = reference;

    await batch.commit();

    return user;
  }

  Future<bool> updateUserNotificationTopic(
    String? userId,
    UserNotificationTopic topic,
  ) async {
    var userReference = dataStore!.doc(
      'users/$userId/notificationTopics/${topic.topicId}',
    );

    await userReference.set(topic.toJson(), SetOptions(merge: true));

    return true;
  }

  Future<User> saveBusinessUser(
    User user, {
    Store? store,
    StoreUser? storeUser,
    bool createBusiness = false,
  }) async {
    var batch = dataStore!.batch();

    var userC = dataStore!.collection('users');
    var u = userC.doc(user.id);

    if (createBusiness) {
      var storeC = dataStore!.collection('stores');

      //save all the linked accounts to the user object collection
      var usrLinkAccounts = u.collection('linkedAccounts');
      for (var element in user.linkedAccounts!) {
        var lref = usrLinkAccounts.doc(element.accountId);
        batch.set(lref, element.toJson());
      }

      var s = storeC.doc(store!.id);
      batch.set(s, store.toJson());

      var su = s.collection('users').doc(storeUser!.id);
      batch.set(su, storeUser.toJson());
    }

    batch.set(u, user.toJson());

    var topicsCollection = u.collection('notificationTopics');

    getDefaultTopics().forEach((element) {
      batch.set(topicsCollection.doc(element.topicId), element.toJson());
    });

    await batch.commit();

    user.documentReference = u;

    return user;
  }

  Future<User> createUser(
    String? userId,
    String? firstName,
    String lastName, {
    String? email,
    String? mobile,
    String? profileImage,
  }) async {
    var collection = dataStore!.collection('users');

    var existingUser = await collection
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    //we have an existing user here
    if (existingUser.docs.isNotEmpty) {
      var user = existingUser.docs.first;
      return User.fromDocumentSnapshot(
        user,
        reference: collection.doc(user.id),
      );
    } else {
      var profile = User(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
      );

      await collection.doc().set(profile.toJson());

      return profile;
    }
  }

  Future<User?> getUser(
    String? userId, {
    bool? throwError,
    bool createUser = true,
    required AuthUser? user,
  }) async {
    var collection = dataStore!.collection('users');

    try {
      var existingUser = await collection.doc(userId).get();

      //we have an existing user here
      if (existingUser.exists == true) {
        var thisUser = User.fromDocumentSnapshot(
          existingUser,
          reference: existingUser.reference,
        );

        if (thisUser.accountType == UserAccountType.business) {
          var accounts = (await thisUser.linkedAccountsCollection!.get()).docs
              .map(
                (e) => UserLinkedAccount.fromJson(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList();

          thisUser.linkedAccounts = accounts;
        }

        //populate these notification topics, mainly to ensure that the user is not spammed when they are not interested
        try {
          var notificationTopics =
              (await thisUser.notificationTopicsCollection!.get()).docs
                  .map(
                    (e) => UserNotificationTopic.fromJson(
                      e.data() as Map<String, dynamic>,
                    ),
                  )
                  .toList();

          thisUser.notificationTopics = notificationTopics;
        } catch (error) {
          reportCheckedError(error, trace: StackTrace.current);
        }

        try {
          var thirdPartyAccounts =
              (await thisUser.accountsCollection!
                      .where('deleted', isEqualTo: false)
                      .get())
                  .docs
                  .map(
                    (e) => UserThirdPartyAccount.fromJson(
                      e.data() as Map<String, dynamic>,
                    ),
                  )
                  .toList();

          thisUser.thirdPartyAccounts = thirdPartyAccounts;
        } catch (error) {
          reportCheckedError(error, trace: StackTrace.current);
        }

        //set the user preferences from the source, no delay
        thisUser.userPreferences = await thisUser.getPreferences();

        return thisUser;
      } else {
        if (throwError!) {
          throw ManagedException(message: 'UserId provided does not exist');
        } else {
          if (createUser) {
            return await this.createUser(
              userId,
              user?.displayName,
              '',
              email: user?.email,
              mobile: user?.mobileNumber,
              profileImage: user?.profileImageUri,
            );
          } else {
            return null;
          }
        }
      }
    } catch (error) {
      reportCheckedError(error);
      rethrow;
    }
  }

  // Future<List<AdvertisingBanner>> getFeaturedBanners() async {
  //   var collection = this.dataStore!.collection('ads_featured_banners');

  //   var bannerAds = await collection
  //       .where('enabled', isEqualTo: true)
  //       .where(
  //         'startDate', //2020/04/16
  //         isGreaterThanOrEqualTo: DateTime.now(),
  //       )
  //       .where(
  //         'endDate', //2020/05/01
  //         isLessThanOrEqualTo: DateTime.now(),
  //       )
  //       .get();

  //   if (bannerAds != null &&
  //       bannerAds.docs != null &&
  //       bannerAds.docs.isNotEmpty) {
  //     return bannerAds.docs.map((doc) => AdvertisingBanner())
  //         as FutureOr<List<AdvertisingBanner>>;
  //   } else {
  //     var defaultBannerCollection =
  //         this.dataStore!.collection('default_featured_banners');

  //     var defaultBannerAds = await defaultBannerCollection
  //         .where('enabled', isEqualTo: true)
  //         .where(
  //           'startDate', //2020/04/16
  //           isGreaterThanOrEqualTo: DateTime.now(),
  //         )
  //         .where(
  //           'endDate', //2020/05/01
  //           isLessThanOrEqualTo: DateTime.now(),
  //         )
  //         .get();

  //     return defaultBannerAds.docs.map((doc) => AdvertisingBanner())
  //         as FutureOr<List<AdvertisingBanner>>;
  //   }
  // }

  // Future<List<AdvertisingBanner>?> getOutletBanners(String outletId) async {
  //   var collection = this.dataStore!.collection('outlet_banners');

  //   var bannerAds = await collection
  //       .where('enabled', isEqualTo: true)
  //       .where(
  //         'startDate', //2020/04/16
  //         isGreaterThanOrEqualTo: DateTime.now(),
  //       )
  //       .where(
  //         'endDate', //2020/05/01
  //         isLessThanOrEqualTo: DateTime.now(),
  //       )
  //       .get();

  //   if (bannerAds != null &&
  //       bannerAds.docs != null &&
  //       bannerAds.docs.isNotEmpty) {
  //     return bannerAds.docs.map((doc) => AdvertisingBanner())
  //         as FutureOr<List<AdvertisingBanner>?>;
  //   } else
  //     return null;
  // }

  Future<int> getFollowerCount(String? storeId) async {
    var collection = dataStore!.collection('store_links');

    var followers = await collection
        .where('storeId', isEqualTo: storeId)
        .where('isFollowing', isEqualTo: true)
        .get();

    return followers.docs.length;
  }

  // searchOutlets(
  //   double longitude,
  //   double latitude,
  //   double radiusKm, {
  //   StoreSearchParams? searchParams,
  // }) async {
  //   var query;

  //   var collection = dataStore!.collection('stores');

  //   //below here we will need to chain the various where statements...
  //   // if (filters != null && filters.isNotEmpty) {
  //   //   filters.forEach((filter) {
  //   //     if (query == null)
  //   //       query = collection
  //   //           .where(filter.field, isEqualTo: filter.value)
  //   //           .startAt(filter.value)
  //   //           .endAt(filter.value + '\uf8ff');
  //   //     else
  //   //       query = query
  //   //           .where(filter.field, isEqualTo: filter.value)
  //   //           .startAt(filter.value)
  //   //           .endAt(filter.value + '\uf8ff');
  //   //   });
  //   // }

  //   var geocollection = outletGeoStore!.collection(
  //     collectionRef: query ?? collection,
  //   );

  //   var point = outletGeoStore!.point(
  //     latitude: latitude,
  //     longitude: longitude,
  //   );

  //   point.data;

  //   return geocollection.within(
  //     center: outletGeoStore!.point(
  //       latitude: latitude,
  //       longitude: longitude,
  //     ),
  //     radius: radiusKm,
  //     field: 'address.location',
  //     strictMode: true,
  //   );
  // }

  //just a base load
  Future<List<DocumentSnapshot>> getCategories() async {
    var collection = dataStore!.collection('store_categories');

    return (await collection.get()).docs;
  }

  Future<DocumentReference> getStore(String? storeId) async {
    var collection = dataStore!.collection('stores');

    return collection.doc(storeId);
  }

  Future<List<DocumentSnapshot>> getProductCategories(Store store) async {
    var collection = store.categoryCollection!;

    // TODO(who): replace for pagination and remove the limit
    var categories = await collection
        .where('deleted', isEqualTo: false)
        .limit(24)
        .get();

    return categories.docs;
  }

  Future<List<DocumentSnapshot>> getOrdersStatuses(Store store) async {
    var collection = store.orderStatusCollection!;

    // TODO(who): replace for pagination and remove the limit
    var statuses = await collection
        .where('deleted', isEqualTo: false)
        .limit(24)
        .get();

    return statuses.docs;
  }

  Stream<QuerySnapshot> getOrdersStatusesStream(Store store) {
    var collection = store.orderStatusCollection!;

    // TODO(who): replace for pagination and remove the limit
    return collection.where('deleted', isEqualTo: false).limit(24).snapshots();
  }

  Stream<QuerySnapshot> getOrdersStream(Store store) {
    var collection = dataStore!.collection('store_orders');

    // TODO(who): replace for pagination and remove the limit
    return collection
        .where('businessId', isEqualTo: store.businessId)
        .limit(24)
        .snapshots();
  }

  Stream<QuerySnapshot> getOrdersStreamFiltered(
    Store store,
    OrderSearchParams searchParams,
  ) {
    var collection = dataStore!.collection('store_orders');

    var query = collection
        .where('businessId', isEqualTo: store.businessId)
        .orderBy('orderDate', descending: true);

    // searchParams.customerName = 'Brandon, Roberts';
    // searchParams.endDate = DateTime.now().add(Duration(days: -1));
    // if (isNotBlank(searchParams.customerName)) {
    // query =
    //     query.where('customerName', isGreaterThanOrEqualTo: 'Brandon, Roberts');
    // }

    // if (searchParams.endDate != null) {
    //   query = query.where('orderDate',
    //       isGreaterThanOrEqualTo: searchParams.endDate.toIso8601String());
    // }

    // if (searchParams.startDate != null) {
    //   query = query.where('orderDate',
    //       isLessThanOrEqualTo: searchParams.startDate.toIso8601String());
    // }

    if (searchParams.statusFilters != null &&
        searchParams.statusFilters!.isNotEmpty) {
      query = query.where('status', whereIn: searchParams.statusFilters);
    }

    return query.limit(24).snapshots();
  }

  Future<List<DocumentSnapshot>> getOrders(Store store) async {
    var collection = dataStore!.collection('store_orders');

    // TODO(who): replace for pagination and remove the limit
    var orders = await collection
        .where('businessId', isEqualTo: store.businessId)
        .limit(24)
        .get();

    return orders.docs;
  }

  Future<List<DocumentSnapshot>> getProducts(Store thisStore) async {
    var collection = thisStore.productCollection!;

    // TODO(who): replace for pagination and remove the limit
    var products = await collection
        .where('deleted', isEqualTo: false)
        // .limit(24)
        .get();

    return products.docs;
  }

  Future<List<DocumentSnapshot>> getProductByBusinessId(
    String businessId, {
    int limit = 20,
    DocumentSnapshot? startAfterDocument,
  }) async {
    var collection = dataStore!.collection('/stores/$businessId/products');

    // TODO(who): replace for pagination and remove the limit
    var query = collection
        .where('deleted', isEqualTo: false)
        .where('onSale', isEqualTo: false)
        .where('isFeatured', isEqualTo: false)
        .limit(limit);

    if (startAfterDocument != null) {
      query.startAfterDocument(startAfterDocument);
    }

    var result = await query.get();

    return result.docs;
  }

  Future<Stream<List<StoreProduct>>> getProductsByCategoryStream(
    String storeId,
    String categoryId,
  ) async {
    var collection = dataStore!.collection('/stores/$storeId/products');

    // TODO(who): replace for pagination and remove the limit
    return (collection
            .where('businessId', isEqualTo: storeId)
            .where('baseCategoryId', isEqualTo: categoryId)
            .where('deleted', isEqualTo: false)
            .snapshots())
        .map(
          (event) => event.docs
              .map(
                (e) => StoreProduct.fromDocumentSnapshot(
                  e,
                  reference: collection.doc(e.id),
                ),
              )
              .toList(),
        );
  }

  Future<List<DocumentSnapshot>> getProductsByCategory(
    String? storeId,
    String? categoryId, {
    int limit = 20,
    DocumentSnapshot? startAfterDocument,
  }) async {
    var collection = dataStore!.collection('/stores/$storeId/products');

    // TODO(who): replace for pagination and remove the limit
    var query = collection
        .where('businessId', isEqualTo: storeId)
        .where('baseCategoryId', isEqualTo: categoryId)
        .where('deleted', isEqualTo: false)
        .limit(limit);

    if (startAfterDocument != null) {
      query.startAfterDocument(startAfterDocument);
    }

    var result = await query.get();

    return result.docs;
  }

  Future<int> unpublishStoreProduct(
    String? storeId,
    StoreProduct product,
  ) async {
    var doc = dataStore!.doc('/stores/$storeId/products/${product.productId}');

    await doc.update(product.toJson());

    int remainingDocs = await getOnlineProductCount(storeId!);

    return remainingDocs;
  }

  Future<int> getOnlineProductCount(String storeId) async {
    int remainingDocs = 0;

    await dataStore!
        .collection('/stores/$storeId/products/')
        .where('deleted', isEqualTo: false)
        .get()
        .then((value) => remainingDocs = value.docs.toList().length);

    return remainingDocs;
  }

  void updateStoreCategory(
    String? storeId,
    StoreProductCategory category,
  ) async {
    try {
      var doc = dataStore!.doc(
        '/stores/$storeId/categories/${category.categoryId}',
      );

      await doc.update(category.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DocumentSnapshot>> getOnSaleProducts(Store thisStore) async {
    var store = await thisStore.productCollection!
        .limit(24)
        .where('deleted', isEqualTo: false)
        .where('onSale', isEqualTo: true)
        .get();

    return store.docs;
  }

  Future<List<DocumentSnapshot>> getFeaturedProducts(Store thisStore) async {
    var store = await thisStore.productCollection!
        .limit(24)
        .where('isFeatured', isEqualTo: true)
        .where('deleted', isEqualTo: false)
        .get();

    return store.docs;
  }

  Future<List<DocumentSnapshot>> getFeaturedProductByBusinessId(
    String businessId,
  ) async {
    var collection = dataStore!.collection('/stores/$businessId/products');

    var result = await collection
        .where('isFeatured', isEqualTo: true)
        .where('deleted', isEqualTo: false)
        .get();

    return result.docs;
  }

  Future<List<DocumentSnapshot>> getOnSaleProductsByBusinessId(
    String businessId,
  ) async {
    var collection = dataStore!.collection('/stores/$businessId/products');

    var result = await collection
        .where('onSale', isEqualTo: true)
        .where('deleted', isEqualTo: false)
        .get();

    return result.docs;
  }

  Future<List<DocumentSnapshot>> getStoreTeam(Store thisStore) async {
    var store = await thisStore.usersCollection!.limit(6).get();

    return store.docs;
  }

  Future<DocumentSnapshot?> getProductById(
    Store store,
    String productId, {
    bool checkCache = true,
  }) async {
    DocumentSnapshot? product;

    //restrict the result as there should only be one product with said ID and storeId
    var query = store.productCollection!
        .where('productId', isEqualTo: productId)
        .where('deleted', isEqualTo: false)
        .limit(1);

    if (checkCache) {
      var r = (await query.get(const GetOptions(source: Source.cache)));
      if (r.docs.isNotEmpty) {
        printLog('loaded product from server');
        product = r.docs.first;
      }
    }

    if (product == null) {
      var r = (await query.get(const GetOptions(source: Source.server)));
      if (r.docs.isNotEmpty) {
        printLog('loaded product from server');
        product = r.docs.first;
      }
    }

    return product;
  }

  // // (who): need a flat map between productId and storeId to extract details later
  // Future<DocumentSnapshot> getProductByIdOnly(
  //   String productId, {
  //   bool checkCache = true,
  // }) async {
  //   DocumentSnapshot product;

  //   //restrict the result as there should only be one product with said ID and storeId
  //   var query = this
  //       .dataStore
  //       .collection('store_products')
  //       .where('productId', isEqualTo: productId)
  //       .where('deleted', isEqualTo: false)
  //       .limit(1);

  //   if (checkCache) {
  //     var r = (await query.get(source: Source.cache));
  //     if (r != null && r.docs != null && r.docs.isNotEmpty) {
  //       printLog('loaded product from server');
  //       product = r.docs.first;
  //     }
  //   }

  //   if (product == null) {
  //     var r = (await query.get(source: Source.server));
  //     if (r != null && r.docs != null && r.docs.isNotEmpty) {
  //       printLog('loaded product from server');
  //       product = r.docs.first;
  //     }
  //   }

  //   return product;
  // }

  Future<double?> getCategoryItemCount(String categoryId) async {
    return null;
  }

  Future<void> updateStoreFollowing(UserStoreLink storeLink) async {
    var collection = dataStore!.collection('store_links');

    //here we need to save and save the store link accordingly
    return await collection.doc(storeLink.id).set(storeLink.toJson());
  }

  Future<void> updateRecentlyViewStore(UserStoreView storeView) async {
    var collection = dataStore!.collection('store_views');

    //here we need to save and save the store link accordingly
    return await collection.doc(storeView.id).set(storeView.toJson());
  }

  Future<List<UserStoreLink>> getUserStoreFollowing(String? userId) async {
    var collection = dataStore!.collection('store_links');

    var docs = await collection.where('userId', isEqualTo: userId).get();

    return docs.docs
        .map((link) => UserStoreLink.fromJson(link.data()))
        .toList();
  }

  Future<List<DocumentSnapshot>> getProductsPerCategory(
    Store thisStore,
    String? categoryId,
  ) async {
    var collection = thisStore.productCollection!;

    // TODO(who): replace for pagination and remove the limit
    var result = await collection
        .where('baseCategoryId', isEqualTo: categoryId)
        .where('deleted', isEqualTo: false)
        .limit(256)
        .get();

    return result.docs;
  }

  Future<void> saveUserNotificationToken(UserNotificationToken token) async {
    var collection = FirebaseFirestore.instance.collection(
      'user_notification_tokens',
    );

    //if token the same, it will consistently update accordingly on the same item
    //if changed a new one will be added
    await collection
        .doc(
          '${token.userId}:${token.deviceInfo?.deviceId ?? token.deviceInfo?.device}:${token.appName}',
        )
        .set(token.toJson());
  }

  //store for record keeping and potentially alerts to the store owners
  void trackLostSale(
    Store store,
    String? productName,
    String? productId,
    double? quantity, {
    String? userId,
  }) {
    store.lostSalesCollection!.doc(const Uuid().v4()).set({
      'productName': productName,
      'productId': productId,
      'quantity': quantity ?? 1.0,
      'userId': userId,
      'timeLost': DateTime.now(),
    });
  }

  void recordViewedProduct({
    String? storeId,
    String? productName,
    String? productId,
    String? userId,
  }) {
    var collection = dataStore!.collection(
      '/stores/$storeId/products/$productId/product_views',
    );

    var id = const Uuid().v4();

    collection.doc(id).set({
      'id': id,
      'productName': productName,
      'productId': productId,
      'userId': userId,
      'storeId': storeId,
      'timeViewed': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<QuerySnapshot> getUserLocations(User user) async {
    var result = await user.locationsCollection!.get();

    return result;
  }

  Future<void> saveUserLocation(User user, UserLocation location) async {
    await user.locationsCollection!.doc(location.id).set(location.toJson());
  }

  // Future<QuerySnapshot> getUserGoals(User user) async {
  //   //we just want to get all the goals for the current user, no need to complicate life
  //   var result = await user.goalsCollection!.get();

  //   //this user was created before goals etc. was added
  //   if (result == null || result.docs.isEmpty) {
  //     await _setDefaultScorecard(user);

  //     //try one last time to get the goals after the user has been setup
  //     return await user.goalsCollection!.get();
  //   }

  //   return result;
  // }

  // Future<void> _setDefaultScorecard(User user) async {
  //   var data =
  //       await (readFileAsJson(filePath: 'assets/data/user_scorecard.json'));

  //   var scoreCard = UserScoreCard.fromJson(data!);

  //   var level = scoreCard.levels!.firstWhereOrNull((l) => l.level == 1);

  //   //use this level field to align with the next steps of this user
  //   user.userScoreCard = level;

  //   scoreCard.goals!.forEach((g) {
  //     user.goalsCollection!.doc(g.goalId).set(
  //           UserGoal(
  //             currentCount:
  //                 g.goalId == EventCodeConstants.registerEvent ? 1 : 0,
  //             dateCreated: DateTime.now(),
  //             description: g.description,
  //             eventId: g.eventId,
  //             eventQty: g.qty!.toDouble(),
  //             goalId: g.goalId,
  //             id: g.goalId,
  //             name: g.name,
  //           ).toJson(),
  //         );
  //   });

  //   var e = scoreCard.events!
  //       .firstWhereOrNull((e) => e.eventId == EventCodeConstants.registerEvent);

  //   if (e != null) {
  //     var point = UserPointEvent(
  //         description: e.description,
  //         eventDate: DateTime.now(),
  //         eventType: e.eventId,
  //         id: Uuid().v4(),
  //         points: e.value,
  //         userId: user.id);

  //     user.scoreEventsCollection!
  //         .doc("${e.eventId}:${point.id}")
  //         .set(point.toJson());
  //   }
  // }

  // claimGoal(User user, UserGoal goal, UserScoreCard? scoreCard) async {
  //   if (user == null || goal == null) return;

  //   var event = scoreCard!.events!.firstWhereOrNull(
  //     (e) => e.eventId == goal.eventId,
  //   );

  //   if (event == null) return;

  //   var goalReference = goal.documentReference ??
  //       user.goalsCollection!.doc(
  //         goal.goalId,
  //       );

  //   if (goal.eventId != EventCodeConstants.registerEvent) {
  //     goal.eventQty = (goal.eventQty ?? 0) + 10;
  //     goalReference.update({
  //       "eventQty": FieldValue.increment(10),
  //     });
  //   } else {
  //     goal.claimed = true;
  //     goalReference.update({
  //       "claimed": true,
  //     });
  //   }

  //   var estScore = user.score! + event.value! * goal.eventQty!;

  //   var nextLevel = scoreCard.levels!.firstWhere(
  //       (lvl) => lvl.level == (user.userScoreCard!.level! + 1),
  //       orElse: () => scoreCard.levels!.last);

  //   if (estScore >= nextLevel.start!.toDouble()) {
  //     user.score = estScore;
  //     user.level = nextLevel.level;
  //     user.userScoreCard = nextLevel;

  //     user.documentReference!.update({
  //       "score": FieldValue.increment(event.value! * goal.eventQty!),
  //       "level": nextLevel.level,
  //       "userScoreCard": nextLevel.toJson(),
  //     });
  //   } else {
  //     user.score = estScore;
  //     user.documentReference!.update({
  //       "score": FieldValue.increment(event.value! * goal.eventQty!),
  //     });
  //   }
  // }

  trackEvent(User user, String eventId, UserScoreCard scoreCard) async {
    var event = scoreCard.events!.firstWhereOrNull((e) => e.eventId == eventId);

    //we need to write the point event and also update the goal

    if (eventId == EventCodeConstants.userUnfollowstoreEvent) {
      var goals = scoreCard.goals!.where(
        (g) => g.eventId == EventCodeConstants.userFollowStoreEvent,
      );

      for (final goal in goals) {
        //set the goal found's increment up by one
        var reference = user.goalsCollection!.doc(goal.goalId);

        await reference.update({'currentCount': FieldValue.increment(-1)});
      }
    } else {
      var goals = scoreCard.goals!.where((g) => g.eventId == eventId);

      for (final goal in goals) {
        var reference = user.goalsCollection!.doc(goal.goalId);
        await reference.update({'currentCount': FieldValue.increment(1)});
      }
      // goals.forEach((goal) async {
      //   //set the goal found's increment up by one
      //   var reference = user.goalsCollection!.doc(goal.goalId);

      //   await reference.update(
      //     {'currentCount': FieldValue.increment(1)},
      //   );
      // });
    }

    if (event != null) {
      var point = UserPointEvent(
        description: event.description,
        eventDate: DateTime.now(),
        eventType: event.eventId,
        id: const Uuid().v4(),
        points: event.value,
        userId: user.id,
      );

      await user.scoreEventsCollection!
          .doc('${event.eventId}:${point.id}')
          .set(point.toJson());
    }
  }

  Future<List<StoreCoupon>> getStoreRewards(int? level) async {
    var collection = dataStore!.collection('coupons');

    var query = collection.where('restrictToLevel', isEqualTo: true);
    query = query.where('expiryDate', isLessThan: DateTime.now());
    query = query.orderBy('expiryDate');

    query = query.orderBy('level');

    var result = await query.get();

    return result.docs
        .map(
          (d) => StoreCoupon.fromJson(d.data())
            ..documentReference = collection.doc(d.id)
            ..documentSnapshot = d,
        )
        .toList();
  }

  Future<StoreFollowingData?> getFollowedStoresData(
    User user,
    List<UserStoreLink> stores,
  ) async {
    //there are no stores followed
    if (stores.isEmpty) return null;

    StoreFollowingData result = StoreFollowingData();

    var storeIds = stores.map((s) => s.storeId).toList();

    var storesCollection = dataStore!.collection('stores');

    var query = storesCollection.where('businessId', whereIn: storeIds);

    query = query.where('isPublic', isEqualTo: true);

    try {
      var storesData = (await query.get()).docs
          .map(
            (d) => Store.fromDocumentSnapshot(
              d,
              reference: storesCollection.doc(d.id),
            ),
          )
          .toList();

      result.stores = storesData;
    } catch (e) {
      reportCheckedError(e);
      printLog(e);

      rethrow;
    }

    return result;
  }

  Future<List<StoreCoupon>> getFollowedStoreCoupons(
    List<UserStoreLink> stores,
  ) async {
    var couponsCollection = dataStore!.collection('coupons');

    var storeIds = stores.map((s) => s.storeId).toList();

    var query = couponsCollection.where('businessId', whereIn: storeIds);

    query = query.where('expiryDate', isGreaterThan: DateTime.now());
    query = query.where('deleted', isEqualTo: false);
    query = query.orderBy('expiryDate');

    if (stores.isEmpty) return [];
    var result = (await query.get()).docs
        .map(
          (d) => StoreCoupon.fromJson(d.data())
            ..documentReference = couponsCollection.doc(d.id)
            ..documentSnapshot = d,
        )
        .toList();

    return result;
  }

  Future<List<StoreCoupon>> getRewardCoupons() async {
    var collection = dataStore!.collection('coupons');

    var query = collection.where('restrictToLevel', isEqualTo: true);

    query = query.where('expiryDate', isGreaterThan: DateTime.now());
    query = query.where('deleted', isEqualTo: false);
    query = query.orderBy('expiryDate');

    var couponData = (await query.get()).docs
        .map(
          (d) => StoreCoupon.fromJson(d.data())
            ..documentReference = collection.doc(d.id)
            ..documentSnapshot = d,
        )
        .toList();

    var result = couponData;

    return result;
  }

  Future<List<Store>?> getManagedStores(User user) async {
    //there are no stores followed
    if (user.linkedAccounts == null || user.linkedAccounts!.isEmpty) {
      return null;
    }

    var storeIds = user.linkedAccounts!.map((s) => s.accountId).toList();

    var storesCollection = dataStore!.collection('stores');

    var query = storesCollection.where('businessId', whereIn: storeIds);

    try {
      var storesData = (await query.get()).docs
          .map(
            (d) => Store.fromDocumentSnapshot(
              d,
              reference: storesCollection.doc(d.id),
            ),
          )
          .toList();

      return storesData;
    } catch (e) {
      reportCheckedError(e);
      printLog(e);

      rethrow;
    }
  }

  Future<List<Store>> getRecentlyPublishedStores([limit = 12]) async {
    var storesCollection = dataStore!.collection('stores');

    var query = storesCollection.where('isPublic', isEqualTo: true);
    query = query.limit(limit ?? 12);
    query = query.orderBy('businessNo', descending: true);

    try {
      var storesData = (await query.get()).docs
          .map((d) => Store.fromDocumentSnapshot(d, reference: d.reference))
          .toList();

      return storesData;
    } catch (e) {
      reportCheckedError(e);
      printLog(e);

      rethrow;
    }
  }

  Future<void> writeError(dynamic error, dynamic stackTrace) async {
    try {
      // var collection = dataStore!.collection('system_errors');

      // var id = const Uuid().v4();

      // var state = AppVariables.store!.state;

      // var user = state.userProfile;

      // var environment = state.environmentState;

      // collection.doc(id).set({
      //   "dateOccurred": DateTime.now(),
      //   "userId": user?.userId,
      //   "version": environment.appVersion,
      //   "appName": environment.appName,
      //   "error": error.toString(),
      //   "trace": stackTrace.toString(),
      //   "userName": user?.username,
      // });
    } catch (e) {
      // reportCheckedError(
      //   e,
      //   logToDb: false,
      //   trace: StackTrace.current,
      // );
    }
  }

  Future<void> saveRefferal(StoreReferral referral) async {
    var collection = dataStore!.collection('store_refferals');

    collection.doc(referral.id).set(referral.toJson());
  }

  Future<List<StoreTrendData>> getStoreTrendData({
    String? businessId,
    int days = 30,
  }) async {
    var collection = dataStore!.collection('store_trends_data');

    var query = collection.where('storeId', isEqualTo: businessId);

    query = query.where(
      'trendDate',
      isLessThanOrEqualTo: Timestamp.fromDate(
        DateTime.now().add(Duration(days: days)), // ?? 30)),
      ),
    );

    query = query.orderBy('trendDate');

    var result = await query.get();

    return result.docs.map((e) => StoreTrendData.fromJson(e.data())).toList();
  }

  void addToProductWishList(UserWishListProduct value) async {
    var collection = dataStore!.collection(
      '/stores/${value.businessId}/products/${value.productId}/wishlist',
    );

    var userCollection = dataStore!.collection(
      '/users/${value.userId}/wishlist',
    );

    // TODO(who): add wishlist counter addition / increment
    // TODO(who): notify shop keeper of wish list item
    await collection.doc(value.id).set(value.toJson());

    await userCollection.doc(value.id).set(value.toJson());
  }

  void removeProductFromWishList(UserWishListProduct value) async {
    var collection = dataStore!.collection(
      '/stores/${value.businessId}/products/${value.productId}/wishlist',
    );

    var userCollection = dataStore!.collection(
      '/users/${value.userId}/wishlist',
    );

    // TODO(who): add wishlist counter subtract
    // TODO(who): notify shop keeper of wish list item not wanted
    await collection.doc(value.id).delete();

    await userCollection.doc(value.id).delete();
  }

  Future<List<StoreProductRating>> getProductRatings(
    String? businessId,
    String? productId, {
    int limit = 5,
  }) async {
    var collection = dataStore!.collection(
      '/stores/$businessId/products/$productId/reviews',
    );

    var query = collection.orderBy('reviewDate', descending: true);

    query.limit(limit); // ?? 15);

    return (await query.get()).docs
        .map((e) => StoreProductRating.fromJson(e.data()))
        .toList();
  }

  Future<bool> removeReview(
    String businessId,
    String productId,
    String reviewId,
  ) async {
    var collection = dataStore!.collection(
      '/stores/$businessId/products/$productId/reviews',
    );

    var document = collection.doc(reviewId);

    await document.delete();

    return true;
  }

  Future<StoreProductRating?> getProductRatingByUser(
    String? userId,
    String? productId,
  ) async {
    var reference = dataStore!
        .collection('/users/$userId/reviews')
        .doc(productId);

    StoreProductRating? result;

    await reference.get().then((value) {
      if (value.exists) {
        result = StoreProductRating.fromJson(value.data()!);
      } else {
        result = null;
      }
    });

    return result;
  }

  Future<void> saveProductRating(StoreProductRating rating) async {
    var userReference = dataStore!
        .collection('/users/${rating.userId}/reviews')
        .doc(rating.productId);

    var productReference = dataStore!
        .collection(
          '/stores/${rating.businessId}/products/${rating.productId}/reviews',
        )
        .doc(rating.productId);

    var batch = dataStore!.batch();

    batch.set(userReference, rating.toJson());

    batch.set(productReference, rating.toJson());

    await batch.commit();
  }

  Future<List<UserNotificationTopic>> setDefaultTopics(String? userId) async {
    var collection = dataStore!.collection('users/$userId/notificationTopics');

    var batch = dataStore!.batch();

    var topics = getDefaultTopics();
    for (var element in topics) {
      batch.set(collection.doc(element.topicId), element.toJson());
    }

    await batch.commit();

    return topics;
  }

  //here we will get the required voucher
  Future<StoreCoupon?> getVoucher(String voucherId) async {
    var collection = dataStore!.collection('coupons');

    var doc = collection.doc(voucherId);

    var result = await doc.get();

    if (result.exists) {
      return StoreCoupon.fromJson(result.data()!)..documentReference = doc;
    } else {
      return null;
    }
  }

  Future<bool> updateUserProfileImage(String? userId, String? imageUrl) async {
    var userDoc = dataStore!.doc('users/$userId');

    //an error will be thrown and bubbled up to the call stack
    await userDoc.update({'profileImageUri': imageUrl});

    return true;
  }

  //here we will get the required voucher
  Future addBusinessToAccount(
    User user,
    String businessName,
    String description,
    String businessId,
  ) async {
    var store = Store.defaults()
      ..displayName = businessName
      ..name = cleanString(businessName)
      ..searchName = cleanString(businessName)
      ..description = description
      ..countryData = CountryCode.fromIsoCode(
        LocaleProvider.instance.countryCode!,
      );

    store.id = store.storeId = store.businessId = businessId;

    var linkedAccount = UserLinkedAccount(
      accountId: store.id,
      description: store.description,
      featureImageUrl: store.logoUrl,
      name: store.displayName,
      type: 'business',
    );

    var storeC = dataStore!.collection('stores');
    var s = storeC.doc(store.id);

    var batch = dataStore!.batch();

    var storeJson = store.toJson();

    batch.set(s, storeJson);

    var storeUser = StoreUser.fromUser(user)
      ..userName = user.email
      ..businessId = store.businessId;

    var su = s.collection('users').doc(storeUser.id);
    var storeUserJson = storeUser.toJson();
    batch.set(su, storeUserJson);

    var userReference = dataStore!.collection('users').doc(user.id);

    var linkedAccountReference = userReference
        .collection('linkedAccounts')
        .doc(linkedAccount.accountId);
    // var linkedAccountReference = user.linkedAccountsCollection!.doc(
    //   linkedAccount.accountId,
    // );

    batch.set(userReference, {
      'accountType': 'business',
      'businessCount': FieldValue.increment(1),
    }, SetOptions(merge: true));

    //merge in case the record exists
    batch.set(
      linkedAccountReference,
      linkedAccount.toJson(),
      SetOptions(merge: true),
    );

    await batch.commit();

    user.accountType = UserAccountType.business;

    //let's add this linked account
    user.linkedAccounts ??= [];

    user.linkedAccounts!.add(linkedAccount);

    return store.id;
  }

  Future addBusinessStoreToAccount(
    User user,
    Store businessStore,
    String businessId,
  ) async {
    var store = businessStore;
    store.name = cleanString(store.name);
    store.searchName = cleanString(store.name);
    store.countryData ??= CountryCode.fromIsoCode(
      LocaleProvider.instance.countryCode!,
    );

    store.id = store.storeId = store.businessId = businessId;

    var linkedAccount = UserLinkedAccount(
      accountId: store.id,
      description: store.description,
      featureImageUrl: store.logoUrl,
      name: store.displayName,
      type: 'business',
    );

    var storeC = dataStore!.collection('stores');
    var s = storeC.doc(store.id);

    var batch = dataStore!.batch();

    var storeJson = store.toJson();

    batch.set(s, storeJson);

    var storeUser = StoreUser.fromUser(user)
      ..userName = user.email
      ..businessId = store.businessId;

    var su = s.collection('users').doc(storeUser.id);
    var storeUserJson = storeUser.toJson();
    batch.set(su, storeUserJson);

    var userReference = dataStore!.collection('users').doc(user.id);

    var linkedAccountReference = userReference
        .collection('linkedAccounts')
        .doc(linkedAccount.accountId);

    batch.set(userReference, {
      'accountType': 'business',
      'businessCount': FieldValue.increment(1),
    }, SetOptions(merge: true));

    //merge in case the record exists
    batch.set(
      linkedAccountReference,
      linkedAccount.toJson(),
      SetOptions(merge: true),
    );

    await batch.commit();

    user.accountType = UserAccountType.business;

    //let's add this linked account
    user.linkedAccounts ??= [];

    user.linkedAccounts!.add(linkedAccount);

    return store.id;
  }

  Future<bool> doesStoreExistForUser(String userId, String businessId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot storeQuery = await firestore
        .collection('stores')
        .where('businessId', isEqualTo: businessId)
        .limit(1)
        .get();

    if (storeQuery.docs.isEmpty) {
      return false;
    }

    // check if there's a user document for the given userId.
    DocumentSnapshot storeDoc = storeQuery.docs.first;
    DocumentSnapshot userDoc = await firestore
        .collection('stores')
        .doc(storeDoc.id)
        .collection('users')
        .doc(userId)
        .get();

    return userDoc.exists;
  }

  Future<List<CheckoutOrder>> getUserOrdersByIds(List<String?> orderIds) async {
    if (orderIds.isEmpty) return [];

    var collection = dataStore!.collection('store_orders');

    var query = collection.where(
      'orderId',
      whereIn: orderIds.take(10).toList(),
    );

    var result = await query.get();

    return result.docs
        .map(
          (e) => CheckoutOrder.fromDocumentSnapshot(e, reference: e.reference),
        )
        .toList();
  }

  Future<SystemCountryConfig?> getCountryConfiguration({
    required String? countryCode,
  }) async {
    var document = dataStore!.doc('system_country_settings/$countryCode');

    var result = await document.get();

    if (!result.exists) return null;

    return SystemCountryConfig.fromJson(result.data()!)
      ..documentReference = result.reference
      ..documentSnapshot = result;
  }

  Future<void> importContactsToCustomers(
    Store store,
    List<Contact> selectedContacts,
  ) async {
    var collection = store.customersCollection;

    var batch = dataStore!.batch();

    for (var contact in selectedContacts) {
      var customerRecord = StoreCustomer.fromContact(contact);

      var reference = collection!.doc(customerRecord.customerId);

      batch.set(reference, customerRecord.toJson());
    }

    await batch.commit();
  }

  // Future<void> getProductFilterableAttributes({@required String storeId, String categoryId}) async {
  //   var s = this.dataStore.collectionGroup('stores/$storeId/products/*/attributes');

  // }
}

class StoreFollowingData {
  StoreFollowingData({
    this.coupons,
    this.newArrivals,
    this.stores,
    this.topTenProducts,
  });

  List<Store>? stores;

  List<StoreCoupon>? coupons;

  List<StoreProduct>? newArrivals;

  List<StoreProduct>? topTenProducts;
}
