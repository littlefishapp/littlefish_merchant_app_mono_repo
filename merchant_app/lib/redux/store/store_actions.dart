// removed ignore: depend_on_referenced_packages

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_core/core/littlefish_core.dart' as littlefish_core;
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/storage/models/storage_reference.dart';
import 'package:littlefish_merchant/features/ecommerce_shared/models/internationalization/country_codes.dart';
import 'package:littlefish_merchant/features/ecommerce_shared/models/store/store.dart'
    as ecom_store;
import 'package:littlefish_merchant/features/ecommerce_shared/models/user/user.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/stock/online_product_update.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/services/checkout_service.dart';
import 'package:littlefish_merchant/services/product_service.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/littlefish_firestore.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:uuid/uuid.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/cloud_functions/platform_sync_service.dart';
import 'package:littlefish_merchant/tools/exceptions/common_exceptions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/order_status_contants.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/littlefish_service.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/services/order_service_cf.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/services/product_service_cf.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/services/store_service_cf.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/services/user_service_cf.dart';
import 'package:littlefish_merchant/ui/online_store/services/service_factory.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';
import '../../features/ecommerce_shared/models/checkout/checkout_order.dart';
import '../../features/ecommerce_shared/models/store/promotion.dart';
import '../../features/ecommerce_shared/models/store/store.dart' as b_store;
import '../../features/ecommerce_shared/models/store/store_attribute.dart';
import '../../features/ecommerce_shared/models/store/store_customer.dart';
import '../../features/ecommerce_shared/models/store/store_preferences.dart';
import '../../features/ecommerce_shared/models/store/store_product.dart';
import '../../features/ecommerce_shared/models/store/store_subtype.dart';
import '../../features/ecommerce_shared/models/store/store_type.dart';
import '../../features/ecommerce_shared/models/store/store_user.dart';
import '../../models/enums.dart';

littlefish_core.LittleFishCore core = littlefish_core.LittleFishCore.instance;

LoggerService get logger =>
    littlefish_core.LittleFishCore.instance.get<LoggerService>();

ThunkAction<AppState> setCurrentStore(
  String? storeId, {
  refresh = false,
  Completer? completer,
  manage = false,
  newStore = false,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      var api = ServiceFactory();

      try {
        //ToDo: look in the current cache to see if the store exists
        if (isBlank(storeId)) {
          throw ManagedException(message: 'storeId provided is not valid');
        }

        store.dispatch(SetStoreLoadingAction(true));

        var s = await api.getStore(storeId!);

        if (s == null) {
          return;
        }

        s.storePreferences ??= StorePreferences()..acceptsOnlineOrders = true;

        s.primaryAddress ??= b_store.StoreAddress();

        s.contactInformation ??= b_store.ContactInformation();

        var featuredProducts = (await api.getStoreFeaturedProducts(s));

        //load all the products that the owner has marked for special display
        store.dispatch(SetStoreFeaturedProductsAction(featuredProducts));

        var products = (await api.getStoreProducts(s));

        store.dispatch(SetStoreProductsAction(products));

        var productCategories = await api.getProductCategories(s);

        store.dispatch(SetCurrentStoreAction(s));

        //load all the current base categories into the state - short lived
        store.dispatch(SetCurrentStoreCategoriesAction(productCategories));

        api
            .getOrderStatuses(s)
            .then((value) {
              if (value.any(
                    (element) =>
                        element.name == OrderStatusConstants.pending.name,
                  ) ==
                  false) {
                store.dispatch(
                  upsertOrderStatus(
                    OrderStatusConstants.pending,
                    setLoading: false,
                  ),
                );
              }
              if (value.any(
                    (element) =>
                        element.name == OrderStatusConstants.confirmed.name,
                  ) ==
                  false) {
                store.dispatch(
                  upsertOrderStatus(
                    OrderStatusConstants.confirmed,
                    setLoading: false,
                  ),
                );
              }
              if (value.any(
                    (element) =>
                        element.name == OrderStatusConstants.cancelled.name,
                  ) ==
                  false) {
                store.dispatch(
                  upsertOrderStatus(
                    OrderStatusConstants.cancelled,
                    setLoading: false,
                  ),
                );
              }
              if (value.any(
                    (element) =>
                        element.name == OrderStatusConstants.complete.name,
                  ) ==
                  false) {
                store.dispatch(
                  upsertOrderStatus(
                    OrderStatusConstants.complete,
                    setLoading: false,
                  ),
                );
              }

              store.dispatch(OrdersStatusesLoadedAction(value));
              logger.debug(
                'store-actions',
                'dispatched to state updated value',
              );
            })
            .catchError((error) {
              reportCheckedError(error);
            });

        api
            .getOrders(s)
            .then((value) {
              logger.debug('store-actions', 'updated state async value');
              store.dispatch(OrdersLoadedAction(value));
              // store.dispatch(SetSelectedOrdersAction(value));
              logger.debug(
                'store-actions',
                'dispatched to state updated value',
              );
            })
            .catchError((error) {
              reportCheckedError(error);
            });

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> getStoreProducts({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      var api = ServiceFactory();

      var storeState = store.state.storeState;

      if (!refresh && (storeState.products?.length ?? 0) > 0) {
        return;
      }

      store.dispatch(SetStoreLoadingAction(true));

      try {
        var products = (await api.getStoreProducts(storeState.store!));
        store.dispatch(SetStoreProductsAction(products));
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> getStoreCategories({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      var api = ServiceFactory();

      var storeState = store.state.storeState;

      if (!refresh && (storeState.productCategories?.length ?? 0) > 0) {
        return;
      }

      store.dispatch(SetStoreLoadingAction(true));

      try {
        var categories = (await api.getProductCategories(storeState.store!));
        store.dispatch(SetCurrentStoreCategoriesAction(categories));
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> selectBaseCategory(
  StoreProductCategory? category, {
  refresh = false,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      var api = LittleFishService.fromStore(store);

      try {
        //reset the current data if a null is passed
        if (category == null) {
          store.dispatch(SetStoreSelectedCategoryAction(null));
          store.dispatch(SetStoreSubcategoriesAction(null));

          return;
        }

        store.dispatch(StoreSetSearchingProductsAction(true));

        store.dispatch(SetStoreSelectedCategoryAction(category));
        store.dispatch(SetStoreSubcategoriesAction([]));

        var categoryId = category.categoryId;

        var products = await api.getProductsByCategory(
          store.state.storeState.store!,
          categoryId,
        );

        //set all the base category products - always lazy load
        store.dispatch(SetStoreCategoryProductsAction(products));

        List<String> allSubCategories = [];

        for (var p in products) {
          var subs = p.subCategories;

          if (subs == null || subs.isEmpty) continue;

          allSubCategories.addAll((subs.map((s) => s.toString())));
        }

        //only add distinct values no duplicates
        var distinctSubs = allSubCategories.toSet().toList();

        store.dispatch(SetStoreSubcategoriesAction(distinctSubs));

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(StoreSetSearchingProductsAction(false));
      }
    });
  };
}

// ThunkAction<AppState> visitStoreFromPromotion(
//   Promotion promotion,
//   BuildContext context, {
//   Completer completer,
// }) {
//   return (Store<AppState> store) async {
//     Future(() async {
//       Navigator.of(context).pushNamed(StoreScreen.route, arguments: [
//         promotion.storeInfo.storeId,
//         true,
//         promotion.type,
//         promotion.data,
//       ]);
//     });
//   };
// }

ThunkAction<AppState> selectOrderStatus(
  String status, {
  refresh = false,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        //clear the sub category flags
        if (isBlank(status)) return;

        if (status != 'all') {
          store.dispatch(SetStoreLoadingAction(true));

          var cleanStatus = cleanString(status);

          store.dispatch(SetSelectedOrderStatusAction(cleanStatus));

          store.state.storeState.orders?.sort(
            (a, b) => a.orderDate!.isAfter(b.orderDate!) ? 1 : -1,
          );

          var filteredOrders =
              store.state.storeState.orders
                  ?.where((x) => cleanString(x.status) == cleanStatus)
                  .toList() ??
              <CheckoutOrder>[];
          store.dispatch(SetSelectedOrdersAction(filteredOrders));
        } else {
          store.dispatch(
            SetSelectedOrdersAction(store.state.storeState.orders),
          );
        }

        store.dispatch(SetStoreLoadingAction(false));

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);

        completer?.completeError(e);
        store.dispatch(SetStoreLoadingAction(false));

        //the error has been managed above
        return;
      } finally {
        store.dispatch(StoreSetSearchingProductsAction(false));
      }
    });
  };
}

ThunkAction<AppState> selectSubCategory(
  String? subCategory, {
  refresh = false,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        //clear the sub category flags
        if (subCategory == null || isBlank(subCategory)) {
          store.dispatch(SetSelectedSubCategoryAction(null));
          store.dispatch(SetStoreSubCategoryProductsAction(null));
        } else {
          store.dispatch(SetSelectedSubCategoryAction(subCategory));

          List<StoreProduct> subProducts = [];

          store.dispatch(StoreSetSearchingProductsAction(true));

          store.state.storeUIState.categoryProducts?.forEach((p) {
            var subs = p.subCategories;
            if (subs == null || subs.isEmpty) {
              return;
            } else if (subs.any((sc) => sc.toString() == subCategory)) {
              subProducts.add(p);
            }
          });

          //filter all the products that are potentially linked to this sub category
          store.dispatch(SetStoreSubCategoryProductsAction(subProducts));
        }

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(StoreSetSearchingProductsAction(false));
      }
    });
  };
}

ThunkAction<AppState> saveStoreAddress(
  b_store.StoreAddress? address, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        if (address == null) return;

        var service = StoreServiceCF(store: store);

        var currentStore = store.state.storeState.store;

        if (currentStore == null) return;

        await service.saveLocationInformation(address, currentStore.id);
        store.dispatch(SetStoreAddressAction(address));

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> updateStore(
  b_store.Store? currentStore, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        if (currentStore == null) return;

        store.dispatch(SetStoreLoadingAction(true));

        var service = StoreServiceCF(store: store);

        await service.upsertFirebaseStore(currentStore);
        store.dispatch(UpdateStoreAction(currentStore));
        store.dispatch(SetStoreLoadingAction(false));

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(SetStoreLoadingAction(false));

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> addOnlineStoreToAccount(
  b_store.Store item, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(SetStoreLoadingAction(true));

      var posUser = store.state.currentUser!;
      var posUserProfile = store.state.userProfile!;

      var user = User.fromUserAndUserProfile(posUser, posUserProfile);

      var currentStoreId = await FirestoreService().addBusinessStoreToAccount(
        user,
        item,
        store.state.businessId!,
      );

      store.dispatch(
        setCurrentStore(currentStoreId, completer: completer, newStore: true),
      );

      store.dispatch(SetStoreLoadingAction(false));

      await completer?.future;
    } catch (e) {
      reportCheckedError(e, trace: StackTrace.current);
      store.dispatch(SetStoreLoadingAction(false));
      completer?.completeError(e);
    }
  };
}

ThunkAction<AppState> saveStoreTradingHours(
  List<b_store.TradingDay>? tradingHours,
  String? id, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        store.dispatch(SetStoreLoadingAction(true));

        var service = StoreServiceCF(store: store);

        await service.saveStoreTradingHours(id, tradingHours);
        store.dispatch(UpdateTradingHoursAction(tradingHours));
        store.dispatch(SetStoreLoadingAction(false));

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(SetStoreLoadingAction(false));

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> goOfflineAction(
  b_store.Store? currentStore, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        if (currentStore == null) return;
        store.dispatch(SetStoreLoadingAction(true));
        var service = StoreServiceCF(store: store);

        await service.goOffline(currentStore.businessId ?? currentStore.id);

        currentStore.isPublic = false;

        store.dispatch(UpdateStoreAction(currentStore));

        completer?.complete();
      } catch (e) {
        currentStore!.isPublic = true;
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(SetStoreLoadingAction(false));

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> deleteStoreAccount(
  b_store.Store? currentStore, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        if (currentStore == null) return;

        // store.dispatch(SetStoreLoadingAction(true));

        // Catcher2.navigatorKey?.currentState?.pushAndRemoveUntil(
        //     MaterialPageRoute(
        //       builder: (c) => OnboardingScreen(),
        //     ),
        //     (route) => false);

        var service = UserServiceCF(store: store);
        await service.deleteUser(store.state.authUser!.uid);
        store.dispatch(ClearCurrentStoreAction());

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(SetStoreLoadingAction(false));

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        // store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> publishStoreAction(
  b_store.Store? currentStore, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        if (currentStore == null) return;
        store.dispatch(SetStoreLoadingAction(true));
        var service = StoreServiceCF(store: store);

        await service.publishStore(currentStore);

        currentStore.isPublic = true;

        store.dispatch(UpdateStoreAction(currentStore));
        store.dispatch(SetStoreLoadingAction(false));
        completer?.complete();
      } catch (e) {
        store.dispatch(SetStoreLoadingAction(false));
        reportCheckedError((e as dynamic).message, trace: StackTrace.current);
        var exception = ManagedException(
          message: 'Please Resolve the following:\n ${(e as dynamic).message}',
          name: 'Publish Store',
        );

        completer?.completeError(exception);

        return;
      }
    });
  };
}

ThunkAction<AppState> submitStoreForReviewAction(
  b_store.Store? currentStore, {
  Completer? completer,
  required String storeUrl,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        if (currentStore == null) return;
        store.dispatch(SetStoreLoadingAction(true));
        var service = StoreServiceCF(store: store);

        await service.submitStoreForReview(currentStore, storeUrl);

        store.dispatch(SetStoreLoadingAction(false));
        completer?.complete();
      } catch (e) {
        store.dispatch(SetStoreLoadingAction(false));
        reportCheckedError((e as dynamic).message, trace: StackTrace.current);
        var exception = ManagedException(
          message: 'Please Resolve the following:\n ${(e as dynamic).message}',
          name: 'Publish Store',
        );

        completer?.completeError(exception);

        return;
      }
    });
  };
}

ThunkAction<AppState> isStoreReviewedAction(
  b_store.Store? currentStore, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        if (currentStore == null) return;
        var service = StoreServiceCF(store: store);

        currentStore.isOnline = await service.isStoreReviewed(currentStore);
        store.dispatch(UpdateStoreAction(currentStore));
        completer?.complete();
      } catch (e) {
        reportCheckedError((e as dynamic).message, trace: StackTrace.current);
        var exception = ManagedException(
          message: 'Please Resolve the following:\n ${(e as dynamic).message}',
          name: 'Publish Store',
        );

        completer?.completeError(exception);
        return;
      }
    });
  };
}

ThunkAction<AppState> upsertEcommerceProductCategory(
  StockCategory item, {
  List<StockProduct>? products,
  Completer? completer,
  ChangeType? changeType,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        store.dispatch(SetStoreLoadingAction(true));

        if (changeType != null && changeType == ChangeType.removed) {
          item.deleted = true;
        }

        var service = PlatformSyncServiceCF.fromStore(store);
        // var api = ServiceFactory();

        var result = await service.upsertCategory(item, products: products);

        StoreProductCategory sc = StoreProductCategory.fromJson(result);

        // List<dynamic> list = result.products;

        // List<StoreProduct> sps =
        //     list.map((e) => StoreProduct.fromJson(e)).toList();

        if (changeType != null) {
          store.dispatch(UpdateStoreProductCategoryAction(sc, changeType));
        }

        // if (sps != null) {
        //   sps.forEach((element) {
        //     store.dispatch(StoreProductChangedAction(
        //       element,
        //       ChangeType.upserted,
        //     ));
        //   });
        // }

        store.dispatch(getStoreProducts(refresh: true));

        // int currentProductCount = await api
        //     .getOnlineProductCount(item.businessId ?? store.state.businessId!);

        // if (currentProductCount == 0) {
        //   store.dispatch(goOfflineAction(store.state.storeState.store));
        // }

        store.dispatch(SetStoreLoadingAction(false));

        completer?.complete();
      } catch (e) {
        reportCheckedError((e as dynamic).message, trace: StackTrace.current);
        var exception = ManagedException(
          message: 'Please Resolve the following:\n ${(e as dynamic).message}',
          name: 'Publish Store',
        );

        completer?.completeError(exception);

        return;
      }
    });
  };
}

ThunkAction<AppState> upsertProductCategory(
  StoreProductCategory? category, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        store.dispatch(SetStoreLoadingAction(true));

        var service = ServiceFactory();

        category!.dateUpdated = DateTime.now();
        category.updatedBy = store.state.authState.userId;
        var result = await service.upsertProductCategory(
          category,
          store.state.storeState.store!,
        );

        store.dispatch(
          SetStoreCategoriesChangedAction(result, ChangeType.upserted),
        );

        store.dispatch(SetStoreLoadingAction(false));

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(SetStoreLoadingAction(false));

        completer?.completeError(e);

        //the error has been managed above
        // return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> upsertProductSubCategory(
  StoreProductCategory? category, {
  StoreProductCategory? parentCategory,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        store.dispatch(SetStoreLoadingAction(true));

        category!.dateUpdated = DateTime.now();
        category.updatedBy = store.state.authState.userId;

        await parentCategory!.subCategoriesCollection!
            .doc(category.id)
            .set(category.toJson(), SetOptions(merge: true));

        parentCategory.subCategories ??= [];

        parentCategory.subCategories?.removeWhere(
          (element) => element.categoryId == category.categoryId,
        );

        parentCategory.subCategories!.add(category);

        store.dispatch(
          SetStoreCategoriesChangedAction(parentCategory, ChangeType.upserted),
        );

        store.dispatch(SetStoreLoadingAction(false));

        completer?.complete();
      } catch (e) {
        store.dispatch(SetStoreLoadingAction(false));

        reportCheckedError(e, trace: StackTrace.current);

        completer?.completeError(e);

        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> upsertProductAction(
  StoreProduct product, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        store.dispatch(SetStoreLoadingAction(true));

        var service = ProductServiceCF(store: store);

        product.dateUpdated = DateTime.now();
        product.updatedBy = store.state.authState.userId;
        await service.upsertStoreProduct(product);
        store.dispatch(StoreProductChangedAction(product, ChangeType.upserted));
        // store.dispatch(SetRecentlyUpdatedProductAction(product));

        store.dispatch(SetStoreLoadingAction(false));

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(SetStoreLoadingAction(false));

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> updateProductsIsOnline({
  required List<StockProduct> updatedProducts,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      if (updatedProducts.isEmpty) return;

      _initializeProductService(store);

      List<OnlineProductUpdate> productsUpdate = List.generate(
        updatedProducts.length,
        (index) => OnlineProductUpdate(
          updatedProducts[index].id!,
          updatedProducts[index].isOnline,
        ),
      );

      try {
        store.dispatch(SetStoreLoadingAction(true));
        bool updateSuccessful = await productService
            .batchUpdateProductsOnlineStatus(productsUpdate);
        if (updateSuccessful) {
          store.dispatch(BatchUpsertProductsAction(updatedProducts));
        }
        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        completer?.completeError(e);
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> upsertOrderStatus(
  OrderStatus? orderStatus, {
  Completer? completer,
  bool setLoading = true,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        if (setLoading) store.dispatch(SetStoreLoadingAction(true));

        var service = OrderServiceCF(store: store);

        await service.upsertOrderStatus(orderStatus!);
        store.dispatch(
          OrderStatusChangedAction(orderStatus, ChangeType.upserted),
        );
        // store.dispatch(SetRecentlyUpdatedProductAction(product));

        if (setLoading) store.dispatch(SetStoreLoadingAction(false));

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        if (setLoading) store.dispatch(SetStoreLoadingAction(false));

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> loadStoreAttributes(
  StoreSubtype subtype, {
  Completer? completer,
  bool setLoading = true,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        // if (subtype.storeAttributeGroups.isEmpty) {
        //   store.dispatch(
        //     LoadStoreAttributesAction(
        //       [[]],
        //     ),
        //   );
        //   return;
        // } else {
        //   var service = StoreServiceCF(store: store);
        //   List<List<StoreAttribute>> groupedAttributes = [[]];
        //   var result = await service.getStoreSubtypeAttributes(subtype);
        //   result.sort(
        //     (a, b) => a.attributeGroup.toString().toLowerCase().compareTo(
        //           b.attributeGroup.toString().toLowerCase(),
        //         ),
        //   );
        //   var j = 0;
        //   for (var i = 0; i < result.length; i++) {
        //     var currentAttribute = result[i];

        //     if (groupedAttributes[0].isEmpty) {
        //       groupedAttributes[j].add(currentAttribute);
        //     } else {
        //       if (groupedAttributes[j].any((element) =>
        //           element.attributeGroup == currentAttribute.attributeGroup)) {
        //         groupedAttributes[j].add(currentAttribute);
        //       } else {
        //         j += 1;
        //         groupedAttributes.add(List());

        //         groupedAttributes[j].add(currentAttribute);
        //       }
        //     }
        //   }

        //   store.dispatch(LoadStoreAttributesAction(groupedAttributes));
        //   // store.dispatch(SetRecentlyUpdatedProductAction(product));

        //   // if (setLoading) store.dispatch(SetStoreLoadingAction(false));
        // }

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        if (setLoading) store.dispatch(SetStoreLoadingAction(false));

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> updateOrderAction(
  CheckoutOrder? order,
  OrderStatus? orderStatus, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        store.dispatch(SetStoreLoadingAction(true));

        var service = OrderServiceCF(store: store);

        order!.status = orderStatus!.name;
        order.events!.add(
          OrderEvent(
            details: orderStatus.description,
            eventDate: DateTime.now(),
            eventId: const Uuid().v4(),
            title: orderStatus.displayName,
            user: store.state.authUser!.uid,
          ),
        );
        if (orderStatus.name == OrderStatusConstants.out.id) {
          var otp = Tools.generateOTP(digits: 6);
          order.events!.add(
            OrderEvent(
              details: otp,
              eventDate: DateTime.now(),
              eventId: const Uuid().v4(),
              title: 'OTP',
              user: store.state.authUser!.uid,
            ),
          );
        }

        await service.upsertOrder(order);
        store.dispatch(OrderChangedAction(order, ChangeType.upserted));
        store.dispatch(SelectedOrderStatusChangeAction(order));
        // store.dispatch(SetRecentlyUpdatedProductAction(product));

        if (orderStatus.name == OrderStatusConstants.confirmed.id) {
          var sale = CheckoutTransaction.fromCheckoutOrder(order);
          var service = CheckoutService.fromStore(store);
          service
              .pushSale(
                store.state.checkoutState,
                currentTransaction: sale,
                pushToServer: true,
              )
              .then(
                (value) =>
                    store.dispatch(CheckoutPushSaleCompletedAction(true, sale)),
              );
        }

        if (orderStatus.name == OrderStatusConstants.cancelled.id) {
          var service = CheckoutService.fromStore(store);
          try {
            service.cancelSale(order.orderId);
          } catch (e) {
            logger.debug('store-actions', e.toString());
          }
        }

        store.dispatch(SetStoreLoadingAction(false));

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(SetStoreLoadingAction(false));

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> deleteProductAction(
  StoreProduct product, {
  Completer? completer,
  bool isOnlineDelete = false,
  //String? storeId,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        store.dispatch(SetStoreLoadingAction(true));

        var service = ProductServiceCF(store: store);

        if (!isOnlineDelete) {
          await service.deleteProduct(product.id, product.businessId);
        } else {
          // var api = ServiceFactory();
          // int remainingDocs =
          //     await api.unpublishStoreProduct(product.businessId!, product);

          // if (remainingDocs == 0) {
          //   store.dispatch(goOfflineAction(store.state.storeState.store));
          // }
        }

        store.dispatch(StoreProductChangedAction(product, ChangeType.removed));

        store.dispatch(SetStoreLoadingAction(false));

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(SetStoreLoadingAction(false));

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> removeProductsAction(
  List<StoreProduct> products, {
  Completer? completer,
  //String? storeId,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        store.dispatch(SetStoreLoadingAction(true));

        var api = ServiceFactory();

        for (final element in products) {
          element.deleted = true;
          await api.unpublishStoreProduct(element.businessId!, element);
        }

        // int remainingProducts =
        //     await api.getOnlineProductCount(products[0].businessId!);

        // if (remainingProducts == 0) {
        //   store.dispatch(goOfflineAction(store.state.storeState.store));
        // }

        store.dispatch(RemoveStoreProductsAction(products));

        store.dispatch(SetStoreLoadingAction(false));

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(SetStoreLoadingAction(false));

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> deleteProductSubCategoryAction(
  StoreProductCategory category, {
  StoreProductCategory? parentCategory,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        //important to remove all items from the server, a trigger will action the removal of product sub-categories from store products
        await category.documentReference!.delete();

        parentCategory!.subCategories?.removeWhere(
          (element) => element.categoryId == category.categoryId,
        );

        store.dispatch(
          SetStoreCategoriesChangedAction(category, ChangeType.removed),
        );

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(SetStoreLoadingAction(false));

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> deleteProductCategory(
  StoreProductCategory category, {
  Completer? completer,
  bool isOnlineDelete = false,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        store.dispatch(SetStoreLoadingAction(true));

        var service = ProductServiceCF(store: store);

        if (!isOnlineDelete) {
          await service.deleteProductCategory(category.id, category.businessId);
        } else {
          var api = ServiceFactory();
          api.updateStoreCategory(category.businessId!, category);
        }

        //await service.deleteProductCategory(category.id, category.businessId);
        store.dispatch(
          SetStoreCategoriesChangedAction(category, ChangeType.removed),
        );

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(SetStoreLoadingAction(false));

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> deleteOrderStatus(
  OrderStatus? orderStatus, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        store.dispatch(SetStoreLoadingAction(true));

        var service = OrderServiceCF(store: store);

        await service.deleteOrderStatus(
          orderStatus!.id,
          orderStatus.businessId,
        );
        store.dispatch(
          OrderStatusChangedAction(orderStatus, ChangeType.removed),
        );

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(SetStoreLoadingAction(false));

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> saveStoreSubtype({Completer? completer}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        store.dispatch(SetStoreLoadingAction(true));

        var service = StoreServiceCF(store: store);
        var state = store.state.storeUIState;
        await service.saveStoreType(
          store.state.storeState.store!.businessId,
          storeType: state.selectedStoreType!,
          storeSubtype: state.selectedStoreSubtype!,
          storeProductTypes: state.selectedStoreProductTypes,
          storeAttributes: state.selectedStoreAttributes,
        );

        store.dispatch(
          SetStoreOfferingsAction(
            state.selectedStoreType,
            state.selectedStoreSubtype,
          ),
        );

        completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(SetStoreLoadingAction(false));

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> chooseAndUploadStoreBrandImage({
  required BuildContext context,
  required ImageType imageType,
  void Function(String error)? onError,
}) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(SetStoreLoadingAction(true));
      var fileManager = FileManager();
      var onlineStore = store.state.storeState.store;
      if (onlineStore == null) return;

      StorageReference? result = await fileManager.chooseAndUploadImage(
        context,
        itemId:
            'images/profile/${imageType.name == "cover"
                ? "cover"
                : imageType.name == "logo"
                ? "logo"
                : "banners/${onlineStore.banners!.length}"}',
        sectionId: 'brand',
        groupId: onlineStore.businessId,
      );

      if (result == null) return;

      if (imageType == ImageType.logo) {
        store.dispatch(
          SetStoreLogoAction(result.downloadUrl, result.downloadUrl),
        );
      } else if (imageType == ImageType.cover) {
        store.dispatch(
          SetStoreCoverImageAction(result.downloadUrl, result.downloadUrl),
        );
      }
    } catch (error) {
      logger.debug('store-actions', error.toString());
      if (onError != null) {
        onError('Failed to upload image. Please try again.');
      }
    } finally {
      store.dispatch(SetStoreLoadingAction(false));
    }
  };
}

ThunkAction<AppState> chooseAndUploadStoreBrandBannerImage({
  required BuildContext context,
  void Function(String error)? onError,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        store.dispatch(SetStoreLoadingAction(true));
        var fileManager = FileManager();
        var onlineStore = store.state.storeState.store;
        if (onlineStore == null) return;

        StorageReference? result = await fileManager.chooseAndUploadImage(
          context,
          itemId: 'images/profile/banner',
          sectionId: 'brand',
          groupId: onlineStore.businessId,
        );

        if (result == null) return;

        store.dispatch(
          SetStoreBannerAction(result.downloadUrl, result.downloadUrl),
        );
      } catch (error) {
        logger.debug('store-actions', error.toString());
        if (onError != null) {
          onError('Failed to upload image. Please try again.');
        }
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> chooseAndUploadStoreBrandAboutImage({
  required BuildContext context,
  void Function(String error)? onError,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        store.dispatch(SetStoreLoadingAction(true));
        var fileManager = FileManager();
        var onlineStore = store.state.storeState.store;
        if (onlineStore == null) return;

        StorageReference? result = await fileManager.chooseAndUploadImage(
          context,
          itemId: 'images/profile/about',
          sectionId: 'brand',
          groupId: AppVariables.businessId,
        );

        if (result == null) return;

        store.dispatch(
          SetStoreAboutImageAction(result.downloadUrl, result.downloadUrl),
        );
      } catch (error) {
        logger.debug('store-actions', error.toString());
        if (onError != null) {
          onError('Failed to upload image. Please try again.');
        }
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

ThunkAction<AppState> setStoreUrlWithSubdomain(
  String subdomain, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      String hostSite =
          store.state.environmentSettings?.onlineStoreSettings?.baseUrl ??
          'littlefish.mobi';
      String storeUrl = 'https://$subdomain.$hostSite';
      store.dispatch(SetStoreUrlAction(storeUrl));
    });
  };
}

ThunkAction<AppState> storeSubtypeSelected(
  StoreSubtype storeSubtype, {
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        // store.dispatch(SetStoreLoadingAction(true));

        // store.dispatch(SetStoreAttributeOptionsAction(storeAttributes));

        // await service.saveStoreType(
        //   state.store.businessId,
        //   storeType: state.selectedStoreType,
        //   subcategories: state.selectedSubtype,
        //   storeAttributes: state.selectedAttributes,
        // );

        // store.dispatch(
        //   SetStoreSubtypeAction(state.selectedCategory),
        // );

        // store.dispatch(
        //   SetStoreSubcategoriesTotalAction(state.subcategories?.length ?? 0),
        // );

        // completer?.complete();
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);
        store.dispatch(SetStoreLoadingAction(false));

        completer?.completeError(e);

        //the error has been managed above
        return;
      } finally {
        store.dispatch(SetStoreLoadingAction(false));
      }
    });
  };
}

_initializeProductService(Store<AppState> store) {
  productService = ProductService(
    store: store,
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    token: store.state.authState.token,
    businessId: store.state.currentBusinessId,
    currentLocale: store.state.localeState.currentLocale,
  );
}

class ClearCurrentStoreAction {}

class SetSelectedPromotionAction {
  Promotion? value;

  SetSelectedPromotionAction(this.value);
}

class SetSelectedPromotionTypeAction {
  PromotionType? value;

  SetSelectedPromotionTypeAction(this.value);
}

class SetSelectedPromotionContentAction {
  String? title;
  String? message;

  SetSelectedPromotionContentAction({this.title, this.message});
}

class SetSelectedPromotionTargetAction {
  bool value;

  SetSelectedPromotionTargetAction(this.value);
}

class SetSelectedPromotionUsersAction {
  List<String> value;

  SetSelectedPromotionUsersAction(this.value);
}

class SetSelectedPromotionTopicAction {
  String value;

  SetSelectedPromotionTopicAction(this.value);
}

class ClearSelectedPromotionAction {
  ClearSelectedPromotionAction();
}

class SetCurrentStoreAction {
  b_store.Store value;

  SetCurrentStoreAction(this.value);
}

class SetCurrentStoreCategoriesAction {
  List<StoreProductCategory> value;

  SetCurrentStoreCategoriesAction(this.value);
}

class SetStoreSubtypeAction {
  StoreSubtype? value;

  SetStoreSubtypeAction(this.value);
}

class LoadStoreAttributesAction {
  List<List<StoreAttribute>> value;

  LoadStoreAttributesAction(this.value);
}

class SetStoreAttributesAction {
  StoreAttribute value;
  ChangeType changeType;

  SetStoreAttributesAction(this.value, this.changeType);
}

class SetStoreAttributeOptionsAction {
  List<List<StoreAttribute>> value;

  SetStoreAttributeOptionsAction(this.value);
}

class SetStoreProductTypeOptionsAction {
  List<StoreProductType> value;

  SetStoreProductTypeOptionsAction(this.value);
}

class ResetStoreAttributesAction {
  ResetStoreAttributesAction();
}

class SetStoreProductTypeAction {
  ChangeType changeType;
  StoreProductType value;

  SetStoreProductTypeAction(this.value, this.changeType);
}

class SetCurrentStoreTeamAction {
  List<StoreUser> value;

  SetCurrentStoreTeamAction(this.value);
}

class UpdateStoreProductAction {
  StoreProduct product;
  ChangeType changeType;

  UpdateStoreProductAction(this.product, this.changeType);
}

class UpdateStoreProductCategoryAction {
  StoreProductCategory category;
  ChangeType changeType;

  UpdateStoreProductCategoryAction(this.category, this.changeType);
}

class SetCurrentStoreFeaturedAction {
  bool value;

  SetCurrentStoreFeaturedAction(this.value);
}

class SetStoreProductsAction {
  List<StoreProduct> value;

  SetStoreProductsAction(this.value);
}

class SetCurrentNavIndexAction {
  int value;

  SetCurrentNavIndexAction(this.value);
}

class SetStoreCustomersAction {
  List<StoreCustomer> value;

  SetStoreCustomersAction(this.value);
}

class UpdateTradingHoursAction {
  List<b_store.TradingDay>? value;

  UpdateTradingHoursAction(this.value);
}

class SetFollowerCountAction {
  double value;

  SetFollowerCountAction(this.value);
}

class SetStoreOnSaleProductsAction {
  List<StoreProduct> value;

  SetStoreOnSaleProductsAction(this.value);
}

class SetStoreFeaturedProductsAction {
  List<StoreProduct> value;

  SetStoreFeaturedProductsAction(this.value);
}

class SetStoreLoadingAction {
  bool value;

  SetStoreLoadingAction(this.value);
}

//UI State Actions
class SetStoreSelectedCategoryAction {
  dynamic value;

  SetStoreSelectedCategoryAction(this.value);
}

class SetStoreCategoryProductsAction {
  List<StoreProduct> value;

  SetStoreCategoryProductsAction(this.value);
}

class SetSelectedSubCategoryAction {
  String? value;

  SetSelectedSubCategoryAction(this.value);
}

class SetSelectedOrdersAction {
  List<CheckoutOrder>? value;

  SetSelectedOrdersAction(this.value);
}

class SetSelectedOrderStatusAction {
  String? value;

  SetSelectedOrderStatusAction(this.value);
}

class SetStoreSubcategoriesAction {
  List<String>? value;

  SetStoreSubcategoriesAction(this.value);
}

class SetStoreSubCategoryProductsAction {
  List<StoreProduct>? value;

  SetStoreSubCategoryProductsAction(this.value);
}

class SetStoreCategoriesChangedAction {
  StoreProductCategory? value;
  ChangeType changeType;

  SetStoreCategoriesChangedAction(this.value, this.changeType);
}

class SetStoreSubcategoriesTotalAction {
  int value;

  SetStoreSubcategoriesTotalAction(this.value);
}

class SetStoreOfferingsAction {
  StoreType? storeType;
  StoreSubtype? storeSubtype;

  SetStoreOfferingsAction(this.storeType, this.storeSubtype);
}

class SetStoreTypeAction {
  StoreType value;

  SetStoreTypeAction(this.value);
}

class SetStoreLogoAction {
  String url;
  String imageAddress;

  SetStoreLogoAction(this.url, this.imageAddress);
}

class SetStoreCoverImageAction {
  String url;
  String imageAddress;

  SetStoreCoverImageAction(this.url, this.imageAddress);
}

class SetStoreBannerAction {
  String url;
  String imageAddress;

  SetStoreBannerAction(this.url, this.imageAddress);
}

class SetStoreAboutImageAction {
  String url;
  String imageAddress;

  SetStoreAboutImageAction(this.url, this.imageAddress);
}

class SetStoreAddressAction {
  b_store.StoreAddress value;

  SetStoreAddressAction(this.value);
}

class SetStoreDeliverySettingsAction {
  b_store.DeliverySettings value;

  SetStoreDeliverySettingsAction(this.value);
}

class SetStoreCollectionSettingsAction {
  b_store.CollectionSettings value;

  SetStoreCollectionSettingsAction(this.value);
}

class SetStoreOnlineFeeAction {
  b_store.OnlineFee value;

  SetStoreOnlineFeeAction(this.value);
}

class SetStoreCategoryAction {
  b_store.StoreCategoryOptions value;

  SetStoreCategoryAction(this.value);
}

class UpdateStoreAction {
  b_store.Store value;

  UpdateStoreAction(this.value);
}

class SetStoreThemeAction {
  StoreTheme value;

  SetStoreThemeAction(this.value);
}

class ResetStoreProductUIAction {
  ResetStoreProductUIAction();
}

class SetSelectedProductAction {
  StoreProduct value;

  SetSelectedProductAction(this.value);
}

class StoreProductChangedAction {
  StoreProduct value;
  ChangeType changeType;

  StoreProductChangedAction(this.value, this.changeType);
}

class RemoveStoreProductsAction {
  List<StoreProduct> products;

  RemoveStoreProductsAction(this.products);
}

class OrdersStatusesLoadedAction {
  List<OrderStatus> value;

  OrdersStatusesLoadedAction(this.value);
}

class OrdersLoadedAction {
  List<CheckoutOrder> value;

  OrdersLoadedAction(this.value);
}

class OrderStatusChangedAction {
  OrderStatus? value;
  ChangeType changeType;

  OrderStatusChangedAction(this.value, this.changeType);
}

class OrderChangedAction {
  CheckoutOrder? value;
  ChangeType changeType;

  OrderChangedAction(this.value, this.changeType);
}

class SelectedOrderStatusChangeAction {
  CheckoutOrder? value;

  SelectedOrderStatusChangeAction(this.value);
}

class StoreIncrementProductAction {
  StoreIncrementProductAction();
}

class StoreDecrementProductAction {
  StoreDecrementProductAction();
}

class StoreIncrementCategoryAction {
  StoreIncrementCategoryAction();
}

class StoreDecrementCategoryAction {
  StoreDecrementCategoryAction();
}

class StoreIncrementProductCategoryAction {
  String? id;

  StoreIncrementProductCategoryAction(this.id);
}

class StoreDecrementProductCategoryAction {
  String? id;

  StoreDecrementProductCategoryAction(this.id);
}

class StoreSetSearchingProductsAction {
  bool value;

  StoreSetSearchingProductsAction(this.value);
}

class SetSelectedOrderIndexAction {
  int value;

  SetSelectedOrderIndexAction(this.value);
}

class StoreSaleLostAction {
  String? productName;

  String? productId;

  double? quantity;

  String? userId;

  StoreSaleLostAction(
    this.productId,
    this.productName,
    this.quantity, {
    this.userId,
  });
}

class SetStoreNameAction {
  String name;

  SetStoreNameAction(this.name);
}

class SetStoreDescriptionAction {
  String description;

  SetStoreDescriptionAction(this.description);
}

class SetStoreSloganAction {
  String slogan;

  SetStoreSloganAction(this.slogan);
}

class SetStoreMobileNumberAction {
  String mobileNumber;

  SetStoreMobileNumberAction(this.mobileNumber);
}

class SetStoreEmailAddressAction {
  String email;

  SetStoreEmailAddressAction(this.email);
}

class CreateDefaultStoreAction {
  CreateDefaultStoreAction();
}

class UpdateStoreContactInformationAction {
  ecom_store.ContactInformation contactInfo;

  UpdateStoreContactInformationAction(this.contactInfo);
}

class SetStorePrimaryColourAction {
  Color colour;

  SetStorePrimaryColourAction(this.colour);
}

class SetStoreSecondaryColourAction {
  Color colour;

  SetStoreSecondaryColourAction(this.colour);
}

class SetStoreSubDomainAction {
  String subDomain;

  SetStoreSubDomainAction(this.subDomain);
}

class SetStoreDomainIsLiveAction {
  bool isLive;

  SetStoreDomainIsLiveAction(this.isLive);
}

class SetStoreConfigured {
  bool isConfigured;

  SetStoreConfigured(this.isConfigured);
}

class SetStoreCountryCode {
  CountryCode countryCode;

  SetStoreCountryCode(this.countryCode);
}

class SetStoreUrlAction {
  String url;

  SetStoreUrlAction(this.url);
}

class SetProductsOrCategoriesSortOptionsAction {
  SortBy type;
  SortOrder order;

  SetProductsOrCategoriesSortOptionsAction(this.type, this.order);
}

class SetStoreErrorAction {
  bool hasError;
  String? message;

  SetStoreErrorAction({required this.hasError, this.message});
}
