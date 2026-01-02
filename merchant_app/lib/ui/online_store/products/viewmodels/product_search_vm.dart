// remove ignore_for_file: implementation_imports

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/search/search_actions.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/littlefish_firestore.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/src/store.dart';

import '../../../../features/ecommerce_shared/models/online/product_search_params.dart';
import '../../../../features/ecommerce_shared/models/store/store.dart'
    as store_ui;
import '../../../../features/ecommerce_shared/models/store/store_product.dart';

class ProductSearchVM extends StoreViewModel<AppState> {
  ProductSearchVM.fromStore(Store<AppState> store, {BuildContext? context})
    : super.fromStore(store, context: context);

  ProductSearchParams? searchParams;

  List<String>? searchCategories;

  Position? currentPosition;

  FirestoreService? storeService;

  List<store_ui.Store>? stores;

  store_ui.Store? currentStore;

  List<StoreProductCategory>? productCategories;

  List<String?> get simpleCategories {
    if (productCategories == null) return <String>[];

    return productCategories!.map((c) => c.displayName?.toString()).toList();
  }

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    storeService ??= FirestoreService();

    // var searchState = store!.state.searchState;

    // state = store.state;

    this.store = store;

    currentStore = store?.state.storeState.store;
    productCategories = store?.state.storeState.productCategories;
    // TODO(lampian): implement
    stores = []; //searchState.storeResults;
  }

  Query<Object?> getQuery() {
    //ToDo: change to api query...
    var collection = currentStore!.productCollection!;

    Query query;

    // if (isNotBlank(searchParams.searchName)) {
    //   var searchName = searchParams.searchName.toLowerCase();

    //   query = (query ?? collection)
    //       .where('searchname', isGreaterThanOrEqualTo: searchName)
    //       .where('searchname', isLessThanOrEqualTo: searchName + 'z')
    //       .orderBy('searchname');
    // }

    query = collection.where('deleted', isEqualTo: false);

    query = query.orderBy('dateCreated', descending: true);

    //if no query, return base collection
    return query;
  }

  dynamic setCategories(List<String>? values) =>
      store?.dispatch(SetProductsCategoriesSearchAction(values ?? []));

  dynamic setDistance(double value) =>
      store?.dispatch(SetProductsDistanceAction(value));

  dynamic setSearchName(String value) =>
      store?.dispatch(SetProductsSearchNameAction(value));

  setSearchFeatured(bool value) {
    store?.dispatch(SetProductSearchFeaturedAction(value));

    if (value && searchParams!.searchOnSale) {
      store?.dispatch(SetProductSearchOnSaleAction(!value));
    }
  }

  setSearchOnSale(bool value) {
    store?.dispatch(SetProductSearchOnSaleAction(value));

    if (value && searchParams!.searchFeatured) {
      store?.dispatch(SetProductSearchFeaturedAction(!value));
    }
  }
}
