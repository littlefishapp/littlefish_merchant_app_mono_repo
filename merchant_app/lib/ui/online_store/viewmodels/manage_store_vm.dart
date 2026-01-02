// remove ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/simple_app_scaffold.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/HomePage/online_store_main_home_page.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/redux/search/search_actions.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/redux/store/store_state.dart';
import 'package:littlefish_merchant/redux/system_data/system_data_state.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/order_status_contants.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/littlefish_firestore.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/littlefish_service.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/services/notification_service_cf.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/services/product_service_cf.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/services/store_service_cf.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/services/user_service_cf.dart';
import 'package:littlefish_merchant/ui/online_store/services/service_factory.dart';
import 'package:littlefish_merchant/ui/online_store/shared/input_modal.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

import '../../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../../features/ecommerce_shared/models/internationalization/country_codes.dart';
import '../../../features/ecommerce_shared/models/online/system_variant.dart';
import '../../../features/ecommerce_shared/models/store/broadcast.dart';
import '../../../features/ecommerce_shared/models/store/notification.dart';
import '../../../features/ecommerce_shared/models/store/promotion.dart';
import '../../../features/ecommerce_shared/models/store/store.dart' as store_ui;
import '../../../features/ecommerce_shared/models/store/store_attribute.dart';
import '../../../features/ecommerce_shared/models/store/store_customer.dart';
import '../../../features/ecommerce_shared/models/store/store_preferences.dart';
import '../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../features/ecommerce_shared/models/store/store_subtype.dart';
import '../../../features/ecommerce_shared/models/store/store_user.dart';
import '../../../features/ecommerce_shared/models/user/user.dart';
import '../../../services/promotion_service_cf.dart';
import '../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../common/presentaion/components/form_fields/string_form_field.dart';

class ManageStoreVM extends StoreItemViewModel<store_ui.Store, StoreState> {
  ManageStoreVM.fromStore(Store<AppState> store) : super.fromStore(store);

  List<StoreProduct>? get products => store!.state.storeState.products;

  int get currentNavIndex => store!.state.storeUIState.currentNavIndex ?? 0;

  Promotion? get selectedPromotion =>
      store!.state.storeUIState.selectedPromotion;

  List<String?>? searchStatuses;

  bool get isSetupComplete => setupCompletionPercentage == 100;

  List<SystemVariant> get productVariants =>
      store!.state.systemDataState.variants ?? <SystemVariant>[];

  List<OrderStatus> get orderStatuses =>
      store!.state.storeState.orderStatuses ?? <OrderStatus>[];

  List<CheckoutOrder> get selectedOrders =>
      store!.state.storeUIState.selectedOrders ?? <CheckoutOrder>[];

  String get selectedOrderStatus =>
      store!.state.storeUIState.selectedOrderStatus ?? '';

  bool get hasOrders => orders.isNotEmpty;

  List<CheckoutOrder> get orders =>
      store!.state.storeState.orders ?? <CheckoutOrder>[];

  List<StoreProduct>? featuredProducts;

  dynamic totalCombinations = [];
  List? separatedCombinations = [];
  List<SystemVariant>? selectedVariants = [];
  List<VariantTitle> variantTitles = [];
  ProductVariant? productVariant;

  String? get storeName => item == null ? '' : item?.displayName;

  StoreUIState? get storeUIState => store?.state.storeUIState;
  SystemDataState? get systemDataState => store?.state.systemDataState;
  StoreSubtype? get storeSubtype => storeUIState?.selectedStoreSubtype;

  // bool get isDarkMode => store?.state.isDarkMode ?? false;

  bool get isVerified => store!.state.authUser?.emailVerified ?? false;

  bool get hasStore => item != null;

  String? get countryName => item?.countryName;

  String? get countryCode => item?.countryCode;

  String? get currencyCode => item?.defaultCurrency;

  String? get shortCurrencyCode => item?.currency?.symbol;

  List<StoreAttribute> get selectedAttributes =>
      storeUIState?.selectedStoreAttributes ?? [];

  List<List<StoreAttribute>> get storeAttributeGroups =>
      storeUIState?.storeAttributeOptions ?? [[]];

  Map<String, dynamic>? get storeInfo => item?.toJson();

  List<StoreProductCategory> get categories =>
      store!.state.storeState.productCategories ?? <StoreProductCategory>[];

  bool get hasCategories => categories.isNotEmpty;

  List<StoreUser>? teamMembers;

  bool get hasTeamMembers => teamMembers != null && teamMembers!.isNotEmpty;

  late StoreServiceCF service;

  late Function(
    store_ui.StoreAddress? address,
    GlobalKey<FormState> key,
    BuildContext ctx,
  )
  saveAddress;

  late Function(StorePreferences? preferences, BuildContext ctx)
  saveStorePreferences;

  late Function(StoreProductCategory? preferences, BuildContext ctx)
  upsertProdCategory;

  late Function(
    StoreProductCategory? subCategory,
    StoreProductCategory? parentCategory,
    BuildContext ctx,
  )
  upsertSubProductCategory;

  late Function(StoreProductCategory subCategory, BuildContext ctx)
  deleteProductSubCategory;

  late Function(StoreProductCategory category, BuildContext ctx)
  deleteProdCategory;

  Function(BuildContext context, StoreProduct product)? upsertProduct;
  Function(BuildContext context, StoreProduct product)? deleteProduct;
  late Function(BuildContext context, OrderStatus? status) deleteStatus;
  late Function(BuildContext context, OrderStatus? status) upsertStatus;

  Function(BuildContext ctx)? publishStore;

  late Function(BuildContext ctx) setConfigured;

  late Function(BuildContext ctx, {String? errorMessage}) updateOnlineStore;

  Function(BuildContext ctx)? saveStoreCategories;
  late Function(BuildContext ctx, store_ui.Store? store)
  saveBusinessInformation;

  ServiceFactory? serviceFactory;

  LittleFishService? littleFishService;

  ProductServiceCF? productServiceCF;

  PromotionServiceCF? promotionServiceCF;

  Function? isSubdomainUnique;

  int get setupCompletionPercentage {
    var count = 0;

    if (checkMinProducts()) count++;
    // if (productsConfigured) count++;
    // if (productCategoriesConfigured) count++;
    // if (item!.personalizationConfigured) count++;
    if (item?.contactInformationConfigured == true) count++;
    if (item?.onlinePreferencesConfigured == true) count++;
    if (item?.addressConfigured == true) count++;
    if (item?.brandConfigured == true) count++;
    //if (item!.businessInformationConfigured) count++;
    if (item?.tradingHoursConfigured == true) count++;
    if (item?.storeTypesConfigured == true) count++;

    var percentage = ((count / 7) * 100).toInt();

    return percentage;
  }

  int get selectedOrderIndex =>
      store!.state.storeUIState.selectedOrderIndex ?? 0;

  // void sendVerificationEmail(BuildContext context) async {
  //   var user = FirebaseAuth.instance.currentUser!;

  //   if (user.emailVerified) {
  //     store!.dispatch(ReloadFirebaseUserAction());
  //     return;
  //   }

  //   user.sendEmailVerification();

  //   showMessageDialog(
  //     context,
  //     S.of(context)!.checkYourEmailMessage,
  //     Icons.email,
  //   ).then((value) {
  //     store!.dispatch(ReloadFirebaseUserAction());
  //   });
  // }

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    state = store!.state.storeState;
    service = StoreServiceCF(store: store);
    serviceFactory = ServiceFactory();

    littleFishService = LittleFishService.fromStore(store);

    promotionServiceCF = PromotionServiceCF(store: store);

    item = state!.store;
    featuredProducts = state!.featuredProducts;
    teamMembers = state!.teamMembers;

    isLoading = state!.isLoading ?? false;

    hasError = state!.hasError;

    searchStatuses = List.from(
      store.state.searchState.orderSearchParams?.statusFilters ?? [],
    );

    saveAddress = (address, key, ctx) async {
      if ((key.currentState?.validate() ?? false)) {
        key.currentState!.save();

        var completer = snackBarCompleter(ctx, 'Saved', shouldPop: true);

        store.dispatch(
          saveStoreAddress(item!.primaryAddress, completer: completer),
        );

        await completer?.future;
      }
    };

    isSubdomainUnique =
        (String? storeId, String? subdomain, Store<AppState>? store) async {
          bool isUnique = await StoreServiceCF(
            store: store!,
          ).subdomainExists(storeId, subdomain);

          return isUnique;
        };

    saveStorePreferences = (preferences, ctx) async {
      var completer = snackBarCompleter(
        ctx,
        'Preferences Saves',
        shouldPop: true,
      );

      store.dispatch(updateStore(item, completer: completer));

      await completer?.future;
    };

    upsertProdCategory = (category, ctx) async {
      category!.searchName = category.name = cleanString(category.displayName);
      category.deleted = false;
      category.dateUpdated = DateTime.now();
      category.categoryId = category.id;
      category.businessId = store.state.storeState.store!.businessId;
      category.productCount ??= 0;

      var completer = snackBarCompleter(ctx, 'Saved', shouldPop: true);
      if (category.isNew!) {
        store.dispatch(StoreIncrementCategoryAction());
      }

      store.dispatch(upsertProductCategory(category, completer: completer));

      await completer?.future;
    };

    upsertSubProductCategory = (category, parentCategory, ctx) async {
      category!.searchName = category.name = cleanString(category.displayName);
      category.deleted = false;
      category.dateUpdated = DateTime.now();
      category.categoryId = category.id;
      category.productCount ??= 0;

      var completer = snackBarCompleter(ctx, 'Saved', shouldPop: true);

      store.dispatch(
        upsertProductSubCategory(
          category,
          parentCategory: parentCategory,
          completer: completer,
        ),
      );

      await completer?.future;
      // }
    };

    deleteProductSubCategory = (category, ctx) async {
      var completer = snackBarCompleter(ctx, 'Deleted', shouldPop: false);

      isLoading = true;
      store.dispatch(
        deleteProductSubCategoryAction(
          category,
          parentCategory: null,
          completer: completer,
        ),
      );

      await completer?.future;
      // }
    };

    deleteProdCategory = (category, ctx) async {
      isLoading = true;
      var completer = snackBarCompleter(ctx, 'Deleted', shouldPop: false);

      store.dispatch(deleteProductCategory(category, completer: completer));

      await completer?.future;
      // }
    };

    deleteStatus = (ctx, status) async {
      isLoading = true;
      store.dispatch(
        deleteOrderStatus(
          status,
          completer: snackBarCompleter(ctx, 'Deleted', shouldPop: true),
        ),
      );
    };

    upsertStatus = (ctx, status) async {
      status!.name = status.searchName = cleanString(status.displayName);

      store.dispatch(
        upsertOrderStatus(
          status,
          completer: snackBarCompleter(ctx, 'Saved', shouldPop: true),
        ),
      );
    };

    upsertProduct = (ctx, prod) async {
      if (prod.isNew ?? false) {
        prod.businessId = store.state.storeState.store!.businessId;
        prod.createdBy = store.state.authUser!.uid;
        prod.dateCreated = DateTime.now();
      }

      if (isBlank(prod.displayName) ||
          (prod.sellingPrice ?? 0.0) <= 0.00 ||
          (prod.costPrice ?? 0.0) <= 0.00) {
        showMessageDialog(ctx, 'Incomplete', Icons.thumb_down);

        return null;
      }

      //important to set these values
      prod.currencyCode = currencyCode;
      prod.countryCode = countryCode;
      prod.shortCurrencyCode = shortCurrencyCode;
      prod.name = prod.searchName = cleanString(item!.displayName);

      prod.productId = prod.id;

      var completer = snackBarCompleter(ctx, 'Saved', shouldPop: false);

      store.dispatch(upsertProductAction(prod, completer: completer));

      await completer?.future;

      isLoading = false;

      return prod;
    };

    deleteProduct = (ctx, prod) async {
      var completer = snackBarCompleter(ctx, 'Deleted', shouldPop: true);

      store.dispatch(deleteProductAction(prod, completer: completer));

      await completer?.future;
    };

    publishStore = (ctx) async {
      // item.isPublic = true;

      if (item!.countryData == null) {
        item!.countryData = CountryCode.fromIsoCode(
          LocaleProvider.instance.countryCode!,
        );
      }

      var completer = snackBarCompleter(ctx, 'Live', shouldPop: false);

      //think this is important to push to the server and not the client side update push
      store.dispatch(publishStoreAction(item, completer: completer));

      await completer?.future;
    };

    setConfigured = (ctx) async {
      // item.isPublic = true;
      item!.isConfigured = true;

      //load from the country code provided by this region
      //this would be set by remote config on startup based on the calling region
      if (item!.countryData == null) {
        item!.countryData = CountryCode.fromIsoCode(
          LocaleProvider.instance.countryCode!,
        );
      }

      store.dispatch(
        updateStore(
          item,
          completer: snackBarCompleter(
            ctx,
            'Congratulations!',
            shouldPop: false,
          ),
        ),
      );
    };

    updateOnlineStore = (ctx, {String? errorMessage}) async {
      if (isBlank(item!.logoUrl) || isBlank(item!.coverImageUrl)) {
        showMessageDialog(ctx, errorMessage!, LittleFishIcons.warning);

        return;
      }

      Completer? completer = snackBarCompleter(ctx, 'Updated', shouldPop: true);

      store.dispatch(updateStore(item, completer: completer));

      //use this to block the UI
      await completer?.future;
    };

    saveBusinessInformation = (ctx, st) async {
      var completer = snackBarCompleter(ctx, 'Saved', shouldPop: true);

      store.dispatch(updateStore(item, completer: completer));

      await completer?.future;
    };

    saveStoreCategories = (ctx) async {
      // try {
      //   return await service.saveStoreCategories(item.options, item.businessId);
      // } catch (e) {
      //   showErrorDialog(ctx, e);
      // }
    };
  }

  Future<void> addStoreToAccount(
    context,
    String name,
    String description,
  ) async {
    var posUser = store!.state.currentUser!;
    var posUserProfile = store!.state.userProfile!;

    var user = User(
      id: posUser.uid,
      userId: posUser.uid,
      firstName: posUserProfile.firstName,
      lastName: posUserProfile.lastName,
      email: posUser.email,
      registeredDate: posUserProfile.registeredDate,
      mobileNumber: posUserProfile.mobileNumber,
      internationalNumber: posUserProfile.internationalNumber,
      avatar: posUserProfile.avatar,
      company: posUserProfile.company,
      dateOfBirth: posUserProfile.dateOfBirth,
      jobTitle: posUserProfile.jobTitle,
      prefix: posUserProfile.prefix,
      suffix: posUserProfile.suffix,
      // gender: posUserProfile.gender,
      countryCode: posUserProfile.countryCode,
      profileImageUri: posUserProfile.profileImageUri,
      accountType: UserAccountType.business,
      identityNumber: '',
      userScoreCard: null,
      emailVerified: false,
      mobileNumberVerified: false,
      identityVerified: false,
    );

    var currentStoreId = await FirestoreService().addBusinessToAccount(
      user,
      name,
      description,
      store!.state.businessId!,
    );

    var completer = snackBarCompleter(context, 'Saved', shouldPop: true);

    //the profile needs a refresh at this point...
    // store!.dispatch(
    //   refreshUserProfile(
    //     refresh: true,
    //     completer: completer,
    //   ),
    // );

    store!.dispatch(
      setCurrentStore(currentStoreId, completer: completer, newStore: true),
    );

    Navigator.pushNamed(
      globalNavigatorKey.currentContext!,
      OnlineStoreMainHomePage.route,
    );

    // we need to hold the UI until the refresh is completed
    await completer?.future;
  }

  setLoading(bool loading) {
    store!.dispatch(SetStoreLoadingAction(loading));
  }

  Future<store_ui.FeaturedStore?> getFeaturedStore() async {
    return await LittleFishService.fromStore(store).getFeaturedStore(item);
  }

  deleteAccount(ctx) async {
    store!.dispatch(
      deleteStoreAccount(
        item,
        completer: snackBarCompleter(
          ctx,
          'Your account was deleted',
          shouldPop: false,
        ),
      ),
    );
  }

  setTradingHours(List<store_ui.TradingDay>? hours, ctx) async {
    var completer = snackBarCompleter(ctx, 'Saved', shouldPop: true);
    store!.dispatch(
      saveStoreTradingHours(hours, item!.businessId, completer: completer),
    );

    await completer?.future;
  }

  goOffline(ctx) async {
    var completer = snackBarCompleter(
      ctx,
      'Store is now offline',
      shouldPop: false,
    );
    store!.dispatch(goOfflineAction(item, completer: completer));

    await completer?.future;
  }

  setCategoryProductsToOffline(
    List<StockProduct>? products,
    BuildContext ctx,
    bool runCompleter,
    String categoryId,
  ) {
    if (products != null) {
      for (var element in products) {
        if (element.isOnline == true) {
          element.isOnline = false;
          store!.dispatch(addProduct(product: element));
        }
      }
    }

    if (products != null) {
      var storeProducts = products
          .where(
            (element) => element.categoryId == categoryId,
          ) // .baseCategoryId == categoryId)
          .toList();

      store!.dispatch(removeProductsAction(storeProducts as dynamic));
    }
  }

  bool checkMinProducts({bool refreshStore = false}) {
    bool hasMinProducts = false;

    if (store!.state.storeState.hasProducts) {
      hasMinProducts = store!.state.storeState.products!.isNotEmpty
          ? true
          : false;
    } else {
      store!.dispatch(getProducts(dispatch: false));
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (store!.state.storeState.hasProducts) {
          hasMinProducts = store!.state.storeState.products!.isNotEmpty
              ? true
              : false;
        }
      });
    }

    if (!hasMinProducts && refreshStore && (item?.isPublic ?? false)) {
      store!.dispatch(goOfflineAction(item));
    }

    return hasMinProducts;
  }

  updateStockProduct(StockProduct product) {
    store!.dispatch(addProduct(product: product));
  }

  publishStoreProduct(
    StockProduct product,
    BuildContext ctx,
    StockCategory? category,
    List<StockProduct>? products,
  ) {
    store!.dispatch(
      addProduct(
        product: product,
        runCompleter: false,
        completer: snackBarCompleter(ctx, '${product.displayName} published'),
      ),
    );

    // if (category != null) {
    //   var updatedProducts = products;

    //   // if (updatedProducts != null) {
    //   //   updatedProducts = updatedProducts
    //   //       .map((e) => e.id == product.id ? product : e)
    //   //       .toList();
    //   // }

    //   // store!.dispatch(upsertEcommerceProductCategory(
    //   //   category,
    //   //   products: updatedProducts,
    //   // ));
    // }

    // store!.dispatch(upsertEcommerceProduct(
    //   product,
    //   changeType: ChangeType.added,
    //   completer: snackBarCompleter(
    //     ctx,
    //     "${product.displayName} published successfully",
    //     shouldPop: false,
    //   ),
    // ));
  }

  deleteOnlineProduct(
    StoreProduct product,
    BuildContext context,
    bool runCompleter,
  ) {
    store!.dispatch(
      deleteProductAction(
        product,
        completer: runCompleter
            ? snackBarCompleter(
                context,
                '${product.displayName} was removed',
                shouldPop: false,
                //completerAction: () => checkMinProducts(refreshStore: true),
              )
            : null,
        isOnlineDelete: true,
      ),
    );

    // store!.dispatch(UpdateStoreProductAction(product, ChangeType.removed));
  }

  deleteOnlineCategory(
    StockCategory? stockCat,
    StoreProductCategory storeCat,
    BuildContext ctx,
  ) {
    if (stockCat != null) {
      stockCat.isOnline = false;
      store!.dispatch(
        //addCategory(category: stockCat),
        updateCategoryAndProducts(
          category: stockCat,
          newItems: [],
          deletedItems: [],
        ),
      );
    }

    store!.dispatch(
      deleteProductCategory(
        storeCat,
        completer: snackBarCompleter(
          ctx,
          '${storeCat.displayName} was removed',
          shouldPop: false,
        ),
        isOnlineDelete: true,
      ),
    );
  }

  // deleteOnlineProduct(StoreProduct product, BuildContext context) {
  //   store!.dispatch(
  //     deleteProductAction(
  //       product,
  //       completer: snackBarCompleter(
  //         context,
  //         "${product.displayName} was removed",
  //         shouldPop: false,
  //       ),
  //       isOnlineDelete: true,
  //     ),
  //   );
  // }

  updateCategoryAndProductsToOnline(StockCategory item, BuildContext ctx) {
    store!.dispatch(
      setCategoryAndProductsToOnline(
        item,
        ecommerceUpdate: true,
        context: ctx,
        completer: snackBarCompleter(
          ctx,
          '${item.displayName} category published',
          shouldPop: false,
          // completerAction: () => store!.dispatch(
          //   getStoreCategories(refresh: true),
          // ),
        ),
      ),
    );
  }

  Future<List<Promotion>> getPromotionsByStoreId() async {
    return await LittleFishService.fromStore(
      store,
    ).getPromotionsByStoreId(item!.businessId);
  }

  Future<ProductVariant> getProductVariant(String variantId) async {
    return await LittleFishService.fromStore(
      store,
    ).getProductWithVariants(item!, variantId);
  }

  Future<List<Broadcast>> getBroadcastsByStoreId() async {
    return await LittleFishService.fromStore(
      store,
    ).getBroadcastsByStoreId(item);
  }

  Future<List<StoreCustomer>> getCustomers() async {
    return await LittleFishService.fromStore(store).getStoreCustomers(item);
  }

  Future<List<CustomerList>> getCustomerLists() async {
    return await LittleFishService.fromStore(store).getStoreCustomerLists(item);
  }

  Future<List<PriceList>> getPriceLists() async {
    return await LittleFishService.fromStore(store).getStorePriceLists(item);
  }

  Future<List<StoreProduct>> getStoreProductVariants() async {
    return await LittleFishService.fromStore(
      store,
    ).getStoreProductVariants(item);
  }

  Future<List<store_ui.StoreCoupon>> getCoupons() async {
    return await LittleFishService.fromStore(store).getCoupons(item);
  }

  Stream<List<store_ui.StoreCoupon>> getCouponStream() {
    return LittleFishService.fromStore(store).getCouponsStream(item);
  }

  Future<void> saveCoupon(store_ui.StoreCoupon coupon) async {
    coupon.businessId = item!.businessId;

    return await LittleFishService.fromStore(store).saveCoupon(item, coupon);
  }

  setSelectedOrderStatus(String status) {
    store!.dispatch(selectOrderStatus(status));
  }

  Stream<QuerySnapshot<Object?>> getFilteredOrders() {
    FirestoreService serv = FirestoreService();

    return serv.getOrdersStreamFiltered(
      item!,
      store!.state.searchState.orderSearchParams!,
    );
  }

  setOrderFilterStatus(List<String?>? filters) {
    store!.dispatch(SetOrderSearchStatusFiltersAction(filters));
  }

  // Future<void> savePromotion(storeUI.StorePromotion promotion) async {
  //   // coupon.businessId = this.item.businessId;

  //   return await LittleFishService.fromStore(this.store)
  //       .savePromotion(this.item, promotion);
  // }

  Future<ProductVariant> upsertProductVariant(
    ProductVariant productVariant,
    BuildContext context,
  ) async {
    var productService = ProductServiceCF(store: store!);

    if (productVariant.isNew == true) {}
    var prod = await productService.upsertProductVariant(productVariant);
    await showSuccess(context, 'Saved', LittleFishIcons.info);
    Navigator.of(context).pop(prod);
    return prod;
  }

  Future<StoreProduct> upsertProductWithVariant(
    StoreProduct storeProduct,
    BuildContext context, {
    required List<StoreProduct> removedItems,
  }) async {
    var productService = ProductServiceCF(store: store!);

    if (storeProduct.isNew == true) {
      storeProduct.deleted = false;
      storeProduct.businessId = item!.businessId;
      storeProduct.dateUpdated = DateTime.now();
      storeProduct.dateCreated = DateTime.now();
      storeProduct.updatedBy = storeProduct.createdBy =
          store!.state.authUser!.uid;
      storeProduct.currencyCode = currencyCode;
      storeProduct.countryCode = countryCode;
      storeProduct.shortCurrencyCode = shortCurrencyCode;
    } else {
      storeProduct.dateUpdated = DateTime.now();
      storeProduct.updatedBy = store!.state.authUser!.uid;
    }

    var prod = await productService.upsertProductWithVariant(
      storeProduct,
      removedItems: removedItems,
    );

    if (storeProduct.isNew!) {
      store!.dispatch(StoreIncrementProductAction());
    }

    if (removedItems.isNotEmpty) {
      store!.dispatch(StoreDecrementProductAction());
    }

    await showSuccess(context, 'Saved', LittleFishIcons.info);
    Navigator.of(context).pop(prod);
    return prod;
  }

  Future<void> deleteProductVariant(StoreProduct productVariant) async {
    var productService = ProductServiceCF(store: store!);

    await productService.deleteProduct(
      productVariant.id,
      productVariant.businessId,
    );
    return;
  }

  Future<void> saveCustomer(StoreCustomer customer) async {
    customer.businessId = item!.id;

    return await LittleFishService.fromStore(
      store,
    ).saveCustomer(item!, customer);
  }

  Future<void> deleteCustomer(StoreCustomer customer) async {
    return await LittleFishService.fromStore(
      store,
    ).deleteCustomer(item!, customer);
  }

  Future<void> saveCustomerList(
    CustomerList customerList,
    List<CustomerListLink> removedCustomers,
  ) async {
    customerList.name = customerList.searchName = cleanString(
      customerList.displayName,
    );
    return await LittleFishService.fromStore(
      store,
    ).saveCustomerList(item!, customerList, removedCustomers: removedCustomers);
  }

  Future<void> deleteCustomerList(CustomerList customerList) async {
    return await LittleFishService.fromStore(
      store,
    ).deleteCustomerList(item!, customerList);
  }

  Future<void> saveUserInvite(StoreUserInvite invite) async {
    return await UserServiceCF(store: store!).createUserInvite(invite);
  }

  Future<void> savePriceList(
    PriceList priceList,
    List<PriceListLink>? removedProducts,
  ) async {
    priceList.name = priceList.searchName = cleanString(priceList.displayName);
    return await LittleFishService.fromStore(
      store,
    ).savePriceList(item!, priceList, removedProducts: removedProducts);
  }

  Future<void> deletePriceList(PriceList priceList) async {
    return await LittleFishService.fromStore(
      store,
    ).deletePriceList(item!, priceList);
  }

  Future<void> goLive(ctx) async {
    var completer = snackBarCompleter(
      ctx,
      'Store is Now Online',
      shouldPop: false,
    );

    item!.isPublic = true;
    item!.isConfigured = true;

    //load from the country code provided by this region
    //this would be set by remote config on startup based on the calling region
    if (item!.countryData == null) {
      item!.countryData = CountryCode.fromIsoCode(
        LocaleProvider.instance.countryCode ?? 'ZA',
      );
    }
    store!.dispatch(updateStore(item, completer: completer));

    await completer?.future;
  }

  Future<void> enableMarketPlace(ctx) async {
    var completer = snackBarCompleter(
      ctx,
      'Market Place is Now Online',
      shouldPop: false,
    );

    //item!.marketPlaceEnabled = true;
    store!.dispatch(updateStore(item, completer: completer));

    await completer?.future;
  }

  Future<void> disableMarketPlace(ctx) async {
    var completer = snackBarCompleter(
      ctx,
      'Market Place is Now Offline',
      shouldPop: false,
    );

    //item!.marketPlaceEnabled = false;
    store!.dispatch(updateStore(item, completer: completer));

    await completer?.future;
  }

  Future<void> saveStoreTypeInfo(BuildContext context) async {
    try {
      store!.dispatch(
        saveStoreSubtype(
          completer: actionCompleter(context, () async {
            await showMessageDialog(context, 'Saved', LittleFishIcons.info);

            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }),
        ),
      );
    } catch (e) {
      showMessageDialog(context, (e as dynamic).message, LittleFishIcons.error);
    }
  }

  Future<void> sendMessageToTopic(StoreNotification notification) async {
    return await NotificationServiceCF(
      store: store!,
    ).sendMessageToTopic(notification);
  }

  updateOrder(ctx, order, orderStatus) async {
    // isLoading = true;
    store!.dispatch(
      updateOrderAction(
        order,
        orderStatus,
        completer: snackBarCompleter(ctx, 'Order updated', shouldPop: true),
      ),
    );
    // }
  }

  cancelOrder(ctx, order) async {
    var status = OrderStatusConstants.cancelled;

    await showPopupDialog(
      defaultPadding: false,
      context: ctx,
      content: const InputModal(
        title: 'Cancel',
        description: 'Cancellation Reason',
        inputTitle: 'Cancellation',
      ),
    ).then((res) {
      if (!isBlank(res)) {
        status.description = res;

        store!.dispatch(
          updateOrderAction(
            order,
            status,
            completer: snackBarCompleter(ctx, 'Cancelled', shouldPop: true),
          ),
        );
      }
    });
  }

  setPromotion() {
    store!.dispatch(
      SetSelectedPromotionAction(
        Promotion(
          // businessId: item.businessId,
          id: const Uuid().v4(),
          // currentUser: store.state.firebaseUser.uid,
          dateRun: DateTime.now(),
        ),
      ),
    );
  }

  setPromotionContent({String? title, String? message, PromotionType? type}) {
    store!.dispatch(
      SetSelectedPromotionContentAction(title: title, message: message),
    );
    store!.dispatch(SetSelectedPromotionTypeAction(type));
  }

  setPromotionUsers(List<String> users) {
    store!.dispatch(SetSelectedPromotionUsersAction(users));
  }

  setPromotionTopic(String topic) {
    store!.dispatch(SetSelectedPromotionTopicAction(topic));
  }

  Future<void> saveFeaturedStore(store_ui.FeaturedStore store, ctx) async {
    try {
      await promotionServiceCF!.saveFeaturedStore(store);
    } catch (e) {
      isLoading = false;
      showErrorDialog(ctx, e);
    }
  }

  Future<void> deletedFeaturedStore(store_ui.FeaturedStore store, ctx) async {
    try {
      await promotionServiceCF!.deleteFeaturedStore(store);
    } catch (e) {
      isLoading = false;
      showErrorDialog(ctx, e);
    }
  }

  Future<void> cancelPromotion(Promotion promo) async =>
      await promotionServiceCF!.cancelPromotion(promo);

  Future<void> deletePromotion(Promotion promo) async =>
      await promotionServiceCF!.deletePromotion(promo);

  Future<void> createPromotion(Promotion promo) async =>
      await promotionServiceCF!.createPromotion(promo);

  Future<void> createBroadcast(Broadcast broadcast) async {
    return await promotionServiceCF!.createBroadcast(broadcast);
  }

  SimpleAppScaffold cancellationPopup(BuildContext ctx) {
    String? reason = '';
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    var formFields = <Widget>[
      Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              'Cancellation Reason,',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              'Please enter a cancellation reason below,',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: StringFormField(
              hintText: 'Out of Stock',
              key: const Key('reason'),
              labelText: 'Cancellation Reason',
              // focusNode: formModel.setFocusNode("name"),
              initialValue: reason,
              onFieldSubmitted: (value) {
                reason = value;
              },
              inputAction: TextInputAction.next,
              isRequired: true,
              onSaveValue: (value) {
                reason = value;
              },
            ),
          ),
        ],
      ),
    ];

    return SimpleAppScaffold(
      bottomButtonFunction: () {
        if (formKey.currentState?.validate() ?? false) {
          formKey.currentState!.save();
          Navigator.of(ctx).pop(reason);
        }
      },
      body: Form(
        key: formKey,
        child: MediaQuery.removePadding(
          removeTop: true,
          context: ctx,
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: formFields,
          ),
        ),
      ),
    );
  }
}
