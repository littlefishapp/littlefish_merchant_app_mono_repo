// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:littlefish_auth/littlefish_auth_manager.dart';
import 'package:littlefish_core/auth/models/auth_user.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:quiver/strings.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/tools/exceptions/common_exceptions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/littlefish_firestore.dart';
import 'package:littlefish_merchant/ui/online_store/shared/service_base.dart';

import '../../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../../features/ecommerce_shared/models/internationalization/country_codes.dart'
    as iso_models;
import '../../../../features/ecommerce_shared/models/logon_result.dart';
import '../../../../features/ecommerce_shared/models/order.dart';
import '../../../../features/ecommerce_shared/models/payment_method.dart';
import '../../../../features/ecommerce_shared/models/review.dart';
import '../../../../features/ecommerce_shared/models/store/broadcast.dart';
import '../../../../features/ecommerce_shared/models/store/promotion.dart';
import '../../../../features/ecommerce_shared/models/store/store.dart';
import '../../../../features/ecommerce_shared/models/store/store_customer.dart';
import '../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../features/ecommerce_shared/models/store/store_user.dart';
import '../../../../features/ecommerce_shared/models/store/tracking_events.dart';
import '../../../../features/ecommerce_shared/models/user/user.dart';

class LittleFishService extends ServiceBase {
  LittleFishService.fromContext(BuildContext context)
    : super.fromContext(context) {
    //store should've been created by the base;
    _initialize(store);
  }

  LittleFishService.fromStore(store) : super.fromStore(store) {
    _initialize(store);
  }

  _initialize(store) {
    _firestoreService = FirestoreService();
  }

  LittlefishAuthManager authManager = LittlefishAuthManager.instance;

  late FirestoreService _firestoreService;

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
    var currentUser = authManager.user;

    late AuthUser authUser;
    if (googleExists == false) {
      //we need to logout the current user session - this should not happen but just in case
      if (currentUser != null) {
        await authManager.signOut();
      }

      authUser = await authManager.signUpWithEmailAndPassword(
        email: username,
        password: password,
      );

      currentUser = authUser;
    }

    if (accountType == UserAccountType.business) {
      //create a business profile
      try {
        var user = await createBusinessUser(
          businessName: businessName,
          emailAddress: emailAddress,
          authUser: currentUser!,
          firstName: firstName,
          lastName: lastName,
          mobileNumber: mobileNumber,
          countryCode: countryCode,
        );

        var followedStores = await _firestoreService.getUserStoreFollowing(
          user.userId,
        );

        return LogonResult(
          authenticationResult: authUser,
          profile: user,
          followedStores: followedStores,
        );
      } catch (error) {
        //something went wrong, the firebase user should be deleted
        reportCheckedError(error, trace: StackTrace.current);

        await currentUser!.delete().catchError((e) {
          reportCheckedError(e);
        });

        rethrow;
      }
    } else {
      try {
        var profile = await createUserProfile(
          firstName: firstName,
          emailAddress: emailAddress,
          lastName: lastName,
          mobileNumber: mobileNumber,
          // TODO(lampian): verify logic
          profileUri: authUser != null && authUser.profileImageUri != null
              ? authUser.profileImageUri
              : currentUser != null && currentUser.profileImageUri != null
              ? currentUser.profileImageUri
              : '',
          authUser: currentUser!,
          countryCode: countryCode,
        );

        var followedStores = await _firestoreService.getUserStoreFollowing(
          profile.userId,
        );

        return LogonResult(
          authenticationResult: authUser,
          profile: profile,
          followedStores: followedStores,
        );
      } catch (error) {
        //something went wrong, the firebase user should be deleted
        reportCheckedError(error, trace: StackTrace.current);

        if (googleExists == false) {
          await currentUser!.delete().catchError((e) {
            reportCheckedError(e);
          });
        }
        rethrow;
      }
    }
  }

  Future<LogonResult> linkUser({
    String? firstName,
    String? lastName,
    String? username,
    String? emailAddress,
    String? businessName,
    required iso_models.CountryCode countryCode,
  }) async {
    var currentUser = authManager.user;

    //create a business profile
    try {
      var user = await createBusinessUser(
        businessName: businessName,
        emailAddress: emailAddress,
        authUser: currentUser!,
        firstName: firstName,
        lastName: lastName,
        countryCode: countryCode,
      );

      var followedStores = await _firestoreService.getUserStoreFollowing(
        user.userId,
      );

      return LogonResult(profile: user, followedStores: followedStores);
    } catch (error) {
      //something went wrong, the firebase user should be deleted
      reportCheckedError(error, trace: StackTrace.current);

      await currentUser?.delete().catchError((e) {
        reportCheckedError(e);
      });

      rethrow;
    }
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
    var currentUser = authManager.user;

    if (currentUser == null) {
      throw ManagedException(message: 'Please login to create profile');
    }

    //this is the user profile
    var user = User.fromAuthUser(authUser)
      ..countryCode = countryCode?.countryCode
      ..countryData = countryCode;

    user.firstName = firstName;
    user.mobileNumber = mobileNumber;
    user.lastName = lastName;

    if (isBlank(user.username)) {
      user.username = authUser.email;
    }

    user.accountType = UserAccountType.individual;
    user.profileImageUri = profileUri;
    user.linkedAccounts = [];
    user.gallery = [];

    // var data = await (readFileAsJson(
    //   filePath: 'assets/data/user_scorecard.json',
    // ));

    // var scoreCard = UserScoreCard.fromJson(data!);

    // user.userScoreCard = scoreCard.levels!.first;
    // user.level = 1;
    // user.score = 0;

    await _firestoreService.saveUser(user);

    // await setupUserGoals(user);

    return user;
  }

  Future<User> createBusinessUser({
    required String? firstName,
    required String? lastName,
    required String? emailAddress, //email address
    String? mobileNumber,
    String? profileUri,
    required String? businessName,
    required AuthUser authUser,
    required iso_models.CountryCode countryCode,
    bool createBusiness = false,
  }) async {
    var currentUser = authManager.user;

    if (currentUser == null) {
      throw ManagedException(message: 'Please login to create profile');
    } else {}

    late Store store;
    //this is the user profile
    var user = User.fromAuthUser(authUser)
      ..gender = Gender.notSpecified
      ..accountType = UserAccountType.business
      ..countryData = countryCode
      ..countryCode = countryCode.countryCode
      ..firstName = firstName
      ..lastName = lastName
      ..profileImageUri = profileUri ?? currentUser.profileImageUri
      ..gallery = []
      ..businessCount = 0
      ..username = emailAddress
      ..mobileNumber = mobileNumber
      ..businessCount = 0;

    // var data =
    //     await (readFileAsJson(filePath: 'assets/data/user_scorecard.json'));

    // var scoreCard = UserScoreCard.fromJson(data!);

    // user.userScoreCard = scoreCard.levels!.first;
    // user.level = 1;
    // user.score = 0;

    var storeUser = StoreUser.fromUser(user)..userName = emailAddress;

    if (createBusiness) {
      store = Store.defaults()
        ..displayName = businessName
        ..name = cleanString(businessName)
        ..searchName = cleanString(businessName)
        ..countryData = iso_models.CountryCode.fromIsoCode(
          LocaleProvider.instance.currencyCode!,
        );

      user.company = businessName;

      user.linkedAccounts = [
        UserLinkedAccount(
          accountId: store.id,
          description: store.description,
          featureImageUrl: store.logoUrl,
          name: store.displayName,
          type: 'business',
        ),
      ];
    }

    await _firestoreService.saveBusinessUser(
      user,
      store: store,
      storeUser: storeUser,
      createBusiness: createBusiness,
    );

    // user.firstName = firstName;
    // user.lastName = lastName;
    // user.profileImageUri = profileUri ?? currentUser.photoUrl;

    //this is the initial user, need to make sure that the value is 1
    // user.businessCount = 1;

    // user.gallery = [];
    // user.company = businessName;
    // user.username = emailAddress;

    //set the base user object with the goals required
    // await setupUserGoals(user);

    return user;
  }

  // Future<void> setupUserGoals(User user) async {
  //   var data = await (readFileAsJson(
  //     filePath: 'assets/data/user_scorecard.json',
  //   ));

  //   var scoreCard = UserScoreCard.fromJson(data!);

  //   scoreCard.goals!.forEach((g) async {
  //     await user.goalsCollection!.doc(g.goalId).set(
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

  //     await user.scoreEventsCollection!
  //         .doc("${e.eventId}:${point.id}")
  //         .set(point.toJson());
  //   }
  // }

  @override
  Future<CachedLogonResult?> logonFromCache() async {
    var credential = authManager.user;
    if (credential == null) return null;

    //make sure that the token etc. is valid
    var tokenData = await credential.getAuthTokenResult(forceRefresh: true);

    var profile = await (_firestoreService.getUser(
      credential.uid,
      throwError: false,
      user: credential,
    ));

    profile?.authData = tokenData;

    var stores = await _firestoreService.getManagedStores(profile!);

    return CachedLogonResult(
      profile: profile,
      tokenResult: tokenData,
      user: credential,
      managedStores: stores,
    );
  }

  @override
  Future<LogonResult> login({required username, required password}) async {
    var authUser = await authManager.signInWithEmailAndPassword(
      email: username,
      password: password,
    );

    var user = await _firestoreService.getUser(
      authUser.uid,
      throwError: false,
      createUser: false,
      user: authUser,
    );

    if (user != null) {
      var stores = await _firestoreService.getManagedStores(user);

      user.authData = authUser;

      return LogonResult(
        authenticationResult: authUser,
        profile: user,
        managedStores: stores,
      );
    } else {
      return LogonResult(
        authenticationResult: authUser,
        followedStores: null,
        profile: null,
      );
    }
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
    var authUser = await authManager.signInWithEmailAndPassword(
      email: username,
      password: password,
    );

    //ToDo: check this out
    try {
      await _firestoreService.getUser(
        authUser.uid,
        throwError: true,
        user: authUser,
      );
    } catch (e) {
      await createBusinessUser(
        businessName: businessName,
        emailAddress: emailAddress,
        authUser: authUser,
        firstName: firstName,
        lastName: lastName,
        countryCode: countryCode,
      );
    }

    var user = await (_firestoreService.getUser(
      authUser.uid,
      throwError: false,
      user: authUser,
    ));

    user?.authData = authUser;

    var followedStores = await _firestoreService.getUserStoreFollowing(
      user!.userId,
    );

    return LogonResult(
      authenticationResult: authUser,
      profile: user,
      followedStores: followedStores,
    );
  }

  @override
  Future<LogonResult> loginGoogle({String? token}) async {
    var authUser = await (authManager.signInWithGoogle());

    var user = await _firestoreService.getUser(
      authUser.uid,
      throwError: false,
      createUser: false,
      user: authUser,
    );

    if (user != null) {
      var followedStores = await _firestoreService.getUserStoreFollowing(
        user.userId,
      );

      user.authData = authUser;

      return LogonResult(
        authenticationResult: authUser,
        profile: user,
        followedStores: followedStores,
      );
    } else {
      return LogonResult(
        authenticationResult: authUser,
        followedStores: null,
        profile: null,
      );
    }
  }

  @override
  Future<Null> createReview({
    int? productId,
    Map<String, dynamic>? data,
  }) async {
    // TODO: implement createReview
    return null;
  }

  @override
  Future<List<StoreProduct>?> fetchProductsByCategory({
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
  }) async {
    // TODO: implement fetchProductsByCategory
    return null;
  }

  @override
  Future<List<StoreProduct>?> fetchProductsLayout({config, lang}) async {
    // TODO: implement fetchProductsLayout
    return null;
  }

  @override
  Future<TrackingEvents?> getAllTracking() async {
    // TODO: implement getAllTracking
    return null;
  }

  @override
  Future<List<StoreCategory>> getCategories({lang}) async {
    var fireService = FirestoreService();
    var result = (await fireService.getCategories()).map((d) {
      var c = StoreCategory.fromJson(d.data() as Map<String, dynamic>)
        ..documentSnapshot = d
        ..documentReference = d.reference;

      return c;
    }).toList();

    if (isNotBlank(lang) && lang != 'en') {
      await Future.wait(result.map((e) => e.addLocale(languageCode: lang)));

      // for (var i = 0; i < result.length; i++) {
      //   var c = result[i];

      //   await c.addLocale(languageCode: lang);
      // }
    }

    return result;
  }

  @override
  Future getCategoryWithCache() async {
    // TODO: implement getCategoryWithCache
    return null;
  }

  @override
  Future<String?> getCheckoutUrl(Map<String, dynamic> params) async {
    // TODO: implement getCheckoutUrl
    return null;
  }

  @override
  Future<Map<String, dynamic>?> getHomeCache() async {
    // TODO: implement getHomeCache
    return null;
  }

  @override
  Future<List<OrderNote>?> getOrderNote({User? user, int? orderId}) async {
    // TODO: implement getOrderNote
    return null;
  }

  @override
  Future<List<PaymentMethod>?> getPaymentMethods({
    UserLocation? address,
    ShippingMethod? shippingMethod,
    String? token,
  }) async {
    // TODO: implement getPaymentMethods
    return null;
  }

  @override
  Future<StoreProduct>? getProduct(id) {
    // TODO: implement getProduct
    return null;
  }

  @override
  Future<List<StoreProduct>?> getProducts() async {
    // TODO: implement getProducts
    return null;
  }

  @override
  Future<List<Review>?> getReviews(productId) async {
    // TODO: implement getReviews
    return null;
  }

  @override
  Future<List<ShippingMethod>?> getShippingMethods({
    UserLocation? address,
    String? token,
  }) async {
    // TODO: implement getShippingMethods
    return null;
  }

  @override
  Future<User?> getUserProfileInfo(cookie) async {
    // TODO: implement getUserProfileInfo
    return null;
  }

  @override
  Future<User?> getUserProfileInfor({int? id}) async {
    // TODO: implement getUserProfileInfor
    return null;
  }

  @override
  Future<LogonResult?> loginSMS({String? token}) async {
    // TODO: implement loginSMS
    return null;
  }

  @override
  Future<LogonResult?> loginApple({String? email, String? fullName}) async {
    // TODO: implement loginApple
    return null;
  }

  @override
  Future<LogonResult?> loginFacebook({String? token}) async {
    // TODO: implement loginFacebook
    return null;
  }

  @override
  Future<List<StoreProduct>?> searchProducts({
    name,
    categoryId,
    tag,
    attribute,
    attributeId,
    page,
    lang,
  }) async {
    // TODO: implement searchProducts
    return null;
  }

  @override
  Future updateOrder(orderId, {status, token}) async {
    // TODO: implement updateOrder
    return null;
  }

  @override
  Future<Map<String, dynamic>?> updateUserProfileInfo(
    Map<String, dynamic> json,
    String token,
  ) async {
    // TODO: implement updateUserProfileInfo
    return null;
  }

  Future<List<Store>?> getStores() async {
    return null;
  }

  // @override
  // Future<List<Store>> searchStores(
  //   double longitude,
  //   double latitude,
  //   double kmRadius,
  // ) async {
  //   return _firestoreService.searchOutlets(
  //     longitude,
  //     latitude,
  //     kmRadius,
  //   );
  // }

  Future<void> updateStoreFollowing(UserStoreLink storeLink) async {
    return _firestoreService.updateStoreFollowing(storeLink);
  }

  Future<List<StoreProduct>> getProductsByCategory(
    Store thisStore,
    String? categoryId,
  ) async {
    return (await _firestoreService.getProductsByCategory(
          thisStore.businessId,
          categoryId,
        ))
        .map(
          (d) => StoreProduct.fromDocumentSnapshot(
            d,
            reference: thisStore.productCollection!.doc(d.id),
          ),
        )
        .toList();
  }

  // Future<List<UserGoal>> getUserGoals(User user) async {
  //   if (user == null) return [];

  //   var data = await _firestoreService.getUserGoals(user);

  //   return data.docs
  //       .map(
  //         (g) => UserGoal.fromDocumentSnapshot(
  //           g,
  //           reference: user.goalsCollection!.doc(g.id),
  //         ),
  //       )
  //       .toList();
  // }

  Future<ProductVariant> getProductWithVariants(
    Store thisStore,
    String variantId,
  ) async {
    var prodVariant = ProductVariant.fromJson(
      (await thisStore.productVariantsCollection!.doc(variantId).get()).data()
          as Map<String, dynamic>,
    );

    var prodIds = prodVariant.products!.map((e) => e.productId).toList();

    prodVariant.fullProducts =
        (await thisStore.productCollection!.where('id', whereIn: prodIds).get())
            .docs
            .map((e) => StoreProduct.fromDocumentSnapshot(e))
            .toList();

    return prodVariant;
  }

  // claimGoal(User? user, UserGoal? goal, UserScoreCard? scoreCard) async {
  //   if (user == null || goal == null) return;

  //   await _firestoreService.claimGoal(user, goal, scoreCard);
  // }

  Future<List<StoreCustomer>> getStoreCustomers(Store? thisStore) async {
    if (thisStore == null) return [];

    return (await thisStore.customersCollection!.get()).docs
        .map(
          (c) =>
              StoreCustomer.fromJson(c.data() as Map<String, dynamic>)
                ..documentReference = thisStore.customersCollection!.doc(c.id),
        )
        .toList();
  }

  Future<List<Promotion>> getPromotionsByStoreId(String? storeId) async {
    if (storeId == null) return [];

    var collection = _firestoreService.dataStore!.collection('promotions');

    return (await collection
            .where('storeInfo.storeId', isEqualTo: storeId)
            .where('deleted', isEqualTo: false)
            .orderBy('endDate', descending: true)
            .get())
        .docs
        .map(
          (c) =>
              Promotion.fromJson(c.data())
                ..documentReference = collection.doc(c.id),
        )
        .toList();
  }

  Future<List<Promotion>> getPromotions() async {
    var collection = _firestoreService.dataStore!.collection('promotions');

    return (await collection
            // .where('isCancelled', isEqualTo: false)
            .orderBy('startDate', descending: true)
            .get())
        .docs
        .map(
          (c) =>
              Promotion.fromJson(c.data())
                ..documentReference = collection.doc(c.id),
        )
        .toList();
  }

  Future<List<TrackedOrder>> getTrackedOrders(User userProfile) async {
    var collection = userProfile.trackedOrdersCollection!;

    var result =
        (await collection.orderBy('dateUpdated', descending: true).get()).docs
            .map((c) => TrackedOrder.fromJson(c.data() as Map<String, dynamic>))
            .toList();

    return result;
  }

  Future<CheckoutOrder> getOrder(String id) async {
    var collection = _firestoreService.dataStore!.collection('store_orders');

    return CheckoutOrder.fromJson((await collection.doc(id).get()).data()!);
  }

  Future<List<Promotion>> getPromotionsPaged({
    Promotion? lastPromotion,
    String? storeId,
    int limit = 15,
    bool wholesaler = false,
  }) async {
    var collection = _firestoreService.dataStore!.collection('promotions');

    var query = collection.where('deleted', isEqualTo: false);

    if (isNotBlank(storeId)) {
      query = query.where('storeInfo.storeId', isEqualTo: storeId);
    }

    query = query.orderBy('startDate', descending: true);
    if (lastPromotion != null) query = query.startAt([lastPromotion.endDate]);

    query = query.where('isWholesaler', isEqualTo: wholesaler);

    query = query.limit(limit);
    return (await query.get()).docs
        .map(
          (c) =>
              Promotion.fromJson(c.data())
                ..documentReference = collection.doc(c.id),
        )
        .toList();
  }

  Future<List<UserWishListProduct>> getWishlist(User profile) async {
    var collection = profile.wishlistCollection!.orderBy(
      'dateAdded',
      descending: true,
    );

    return (await collection.get()).docs
        .map(
          (e) => UserWishListProduct.fromJson(e.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<StoreCoupon>> getVouchers(User profile) async {
    var collection = profile.voucherCollection!.orderBy(
      'expiryDate',
      descending: true,
    );

    return (await collection.get()).docs
        .map((e) => StoreCoupon.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }

  Future<DocumentSnapshot> getAnalytics(
    Store store,
    String? year, {
    String? month,
    String? day,
  }) async {
    var collection = store.orderAnalyticsCollection!;

    var query = collection.doc(year);

    // if(isNotBlank(month) && isNotBlank(day)) {
    //   query = query.collection('daily').doc('$year$month:$day');

    // } else if(isNotBlank(month)) {
    //   query = query.collection('monthly').doc(month);
    // }

    return (await query.get());
  }

  Future<QuerySnapshot> getAnalyticsMonth(
    Store store,
    String? year, {
    String? month,
  }) async {
    var collection = store.orderAnalyticsCollection!;

    var query = collection.doc(year).collection('monthly');

    return await query.get();
  }

  Future<DocumentSnapshot> getAnalyticsMonthDoc(
    Store store,
    String? year,
    String? month,
  ) async {
    var collection = store.orderAnalyticsCollection!;

    var query = collection.doc(year).collection('monthly').doc(month);

    return await query.get();
  }

  Future<QuerySnapshot> getAnalyticsDaily(
    Store store,
    String? year,
    String? month,
  ) async {
    var collection = store.orderAnalyticsCollection!;

    var query = collection
        .doc(year)
        .collection('monthly')
        .doc(month)
        .collection('daily');

    return await query.get();
  }

  Future<List<Broadcast>> getBroadcastsByStoreId(Store? thisStore) async {
    if (thisStore == null) return [];

    var collection = _firestoreService.dataStore!.collection('broadcasts');

    return (await collection
            .where('storeId', isEqualTo: thisStore.businessId)
            .orderBy('dateCreated', descending: true)
            .get())
        .docs
        .map(
          (c) =>
              Broadcast.fromJson(c.data())
                ..documentReference = collection.doc(c.id),
        )
        .toList();
  }

  Future<List<CustomerList>> getStoreCustomerLists(Store? thisStore) async {
    if (thisStore == null) return [];

    return (await thisStore.customerListsCollection!
            .where('deleted', isEqualTo: false)
            .get())
        .docs
        .map(
          (c) => CustomerList.fromJson(c.data() as Map<String, dynamic>)
            ..documentReference = thisStore.customerListsCollection!.doc(c.id),
        )
        .toList();
  }

  Future<List<StoreUserInvite>> getStoreUserInvites() async {
    return (await _firestoreService.dataStore!.collection('user_invites').get())
        .docs
        .map((c) => StoreUserInvite.fromJson(c.data()))
        .toList();
  }

  Future<List<StoreUser>> getStoreUsers(Store? thisStore) async {
    if (thisStore == null) return [];

    return (await thisStore.usersCollection!.get()).docs
        .map((c) => StoreUser.fromDocumentSnapshot(c))
        .toList();
  }

  Future<List<PriceList>> getStorePriceLists(Store? thisStore) async {
    if (thisStore == null) return [];

    return (await thisStore.priceListsCollection!
            .where('deleted', isEqualTo: false)
            .get())
        .docs
        .map(
          (c) =>
              PriceList.fromJson(c.data() as Map<String, dynamic>)
                ..documentReference = thisStore.priceListsCollection!.doc(c.id),
        )
        .toList();
  }

  Future<List<StoreProduct>> getStoreProductVariants(Store? thisStore) async {
    if (thisStore == null) return [];

    var variantType = StoreProductVariantType.variant
        .toString()
        .split('.')
        .last;

    var result =
        (await thisStore.productCollection!
                .where('deleted', isEqualTo: false)
                .where('storeProductVariantType', isEqualTo: variantType)
                .get())
            .docs
            .map((c) => StoreProduct.fromDocumentSnapshot(c))
            .toList();

    return result;
  }

  Future<int> getFollowerCount(Store thisStore) async {
    return await _firestoreService.getFollowerCount(thisStore.id);
  }

  Future<void> saveCustomer(Store thisStore, StoreCustomer customer) async {
    return await thisStore.customersCollection!
        .doc(customer.customerId)
        .set(customer.toJson());
  }

  Future<void> savePromotionReport(PromotionReport report) async {
    return await _firestoreService.dataStore!
        .collection('promotion_reports')
        .doc(report.id)
        .set(report.toJson());
  }

  Future<void> savePriceList(
    Store thisStore,
    PriceList priceList, {
    List<PriceListLink>? removedProducts,
  }) async {
    var batch = _firestoreService.dataStore!.batch();

    try {
      await thisStore.priceListsCollection!
          .doc(priceList.id)
          .set(priceList.toJson());

      for (final element in priceList.selectedProducts) {
        batch.set(
          thisStore.priceListsCollection!
              .doc(priceList.id)
              .collection('product_links')
              .doc(element.productId),
          element.toJson(),
        );
      }

      if (removedProducts != null && removedProducts.isNotEmpty) {
        for (final e in removedProducts) {
          batch.delete(
            thisStore.priceListsCollection!
                .doc(priceList.id)
                .collection('product_links')
                .doc(e.productId),
          );
        }
      }

      await batch.commit();
    } catch (e) {
      Exception(e);
    }
  }

  Future<void> saveCustomerList(
    Store thisStore,
    CustomerList customerList, {
    List<CustomerListLink>? removedCustomers,
  }) async {
    var batch = _firestoreService.dataStore!.batch();

    await thisStore.customerListsCollection!
        .doc(customerList.id)
        .set(customerList.toJson());

    if (customerList.selectedCustomers != null) {
      for (final e in customerList.selectedCustomers!) {
        batch.set(
          thisStore.customerListsCollection!
              .doc(customerList.id)
              .collection('customer_links')
              .doc(e.customerId),
          e.toJson(),
        );
      }
    }

    if (removedCustomers != null) {
      for (final e in removedCustomers) {
        batch.delete(
          thisStore.customerListsCollection!
              .doc(customerList.id)
              .collection('customer_links')
              .doc(e.customerId),
        );
      }
    }

    await batch.commit();
  }

  Future<void> deletePriceList(Store thisStore, PriceList priceList) async {
    priceList.deleted = true;
    // var batch = _firestoreService.dataStore.batch();

    await thisStore.priceListsCollection!
        .doc(priceList.id)
        .set(priceList.toJson());

    // priceList.selectedProducts.forEach((element) {
    //   batch.delete(
    //       priceList.productListLinkCollection.doc(element.productId));
    // });

    // await batch.commit();
  }

  Future<void> deleteCustomerList(
    Store thisStore,
    CustomerList customerList,
  ) async {
    customerList.deleted = true;

    // var batch = _firestoreService.dataStore.batch();

    await thisStore.customerListsCollection!
        .doc(customerList.id)
        .set(customerList.toJson());

    // customerList.selectedCustomers.forEach((element) {
    //   batch.delete(customerList.customerListsLinkCollection
    //       .doc(element.customerId));
    // });

    // await batch.commit();
  }

  Future<void> deleteCustomer(Store thisStore, StoreCustomer customer) async {
    customer.deleted = true;

    return await thisStore.customersCollection!
        .doc(customer.customerId)
        .set(customer.toJson());
  }

  Future<List<StoreCoupon>> getCoupons(
    Store? thisStore, {
    bool order = false,
  }) async {
    if (thisStore == null) return [];

    var collection = _firestoreService.dataStore!.collection('coupons');

    var query = collection.where('businessId', isEqualTo: thisStore.businessId);

    if (order) query = query.orderBy('expiryDate', descending: true);

    return ((await (query).get()).docs
        .map(
          (c) =>
              StoreCoupon.fromJson(c.data())
                ..documentReference = thisStore.customersCollection!.doc(c.id),
        )
        .toList());
  }

  Future<FeaturedStore?>? getFeaturedStore(Store? thisStore) async {
    if (thisStore == null) return null;

    var collection = _firestoreService.dataStore!.collection('featured_stores');

    var query = collection.doc(thisStore.businessId);

    var data = (await query.get()).data();

    if (data != null) {
      return FeaturedStore.fromJson((await query.get()).data()!);
    } else {
      return FeaturedStore();
    }
  }

  Future<List<FeaturedStore>> getAllFeaturedStores() async {
    var collection = _firestoreService.dataStore!.collection('featured_stores');

    var query = collection
        .where('endDate', isGreaterThan: DateTime.now().millisecondsSinceEpoch)
        .orderBy('endDate', descending: true);

    return (await (query).get()).docs
        .map(
          (c) =>
              FeaturedStore.fromJson(c.data())
                ..documentReference = collection.doc(c.id),
        )
        .toList();
  }

  Stream<List<StoreCoupon>> getCouponsStream(
    Store? thisStore, {
    bool order = false,
  }) {
    if (thisStore == null) throw Exception('store has not been provided');

    var collection = _firestoreService.dataStore!.collection('coupons');

    var query = collection.where('businessId', isEqualTo: thisStore.businessId);

    if (order) query = query.orderBy('expiryDate', descending: true);

    return query.snapshots().map(
      (event) => event.docs
          .map(
            (e) => StoreCoupon.fromJson(e.data())
              ..documentReference = thisStore.customersCollection!.doc(e.id),
          )
          .toList(),
    );
  }

  Future<void> deleteCoupon(Store item, StoreCoupon coupon) async {
    coupon.documentReference!.update({'deleted': true});

    var nonRedeemedCoupons = await coupon.allocatedCouponsCollection!
        .where('redeemed', isEqualTo: false)
        .get();

    for (var d in nonRedeemedCoupons.docs) {
      coupon.allocatedCouponsCollection!.doc(d.id).update({'revoked': true});
    }
  }

  //coupon gets written here
  Future<void> saveCoupon(Store? item, StoreCoupon coupon) async {
    var collection = _firestoreService.dataStore!.collection('coupons');

    return await collection.doc(coupon.id).set(coupon.toJson());
  }

  //coupon gets written here
  //   Future<void> savePromotion(Store item, StorePromotion promo) async {
  //     var collection = _firestoreService.dataStore
  //         .collection('stores')
  //         .doc(item.id)
  //         .collection('promotions');

  //     return await collection.doc(promo.id).set(promo.toJson());
  //   }
}
