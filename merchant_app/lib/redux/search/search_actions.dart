// ThunkAction<AppState> setupBaseSearch({
//   refresh = false,
//   Completer? completer,
// }) {
//   return (Store<AppState> store) async {
//     Future(() async {
//       var api = ServiceFactory();

//       try {
//         //we need to load the available categories for the search to take place where required
//         if (store.state.storesState.categories == null ||
//             store.state.storesState.categories!.isEmpty) {
//           var storeCategories = await api.getCategories();

//           //send off the available categories from firestore
//           // store.dispatch(SetStoreCategoriesAction(storeCategories));

//           completer?.complete();
//         }
//       } catch (e) {
//         reportCheckedError(e, trace: StackTrace.current);

//         completer?.completeError(e);

//         //the error has been managed above
//         return;
//       }
//     });
//   };
// }

import '../../features/ecommerce_shared/models/online/order_search_params.dart';
import 'search_state.dart';

class SetStoreSearchParamsAction {
  StoreSearchParams value;

  SetStoreSearchParamsAction(this.value);
}

class SetProductSearchParamsAction {
  ProductSearchParams value;

  SetProductSearchParamsAction(this.value);
}

class SetStoreCategoriesSearchAction {
  List<String> value;

  SetStoreCategoriesSearchAction(this.value);
}

class SetStoreSearchNameAction {
  String value;

  SetStoreSearchNameAction(this.value);
}

class SetStoreSearchSpecialAction {
  bool value;

  SetStoreSearchSpecialAction(this.value);
}

class SetStoreSearchFavouritesAction {
  bool value;

  SetStoreSearchFavouritesAction(this.value);
}

class SetStoreSearchFeaturedAction {
  bool value;

  SetStoreSearchFeaturedAction(this.value);
}

class SetStoreSearchNewStoresAction {
  bool value;

  SetStoreSearchNewStoresAction(this.value);
}

class SetStoreTrendingAction {
  bool value;

  SetStoreTrendingAction(this.value);
}

class SetStoreDistanceAction {
  double value;

  SetStoreDistanceAction(this.value);
}

//Products
class SetProductsCategoriesSearchAction {
  List<String> value;

  SetProductsCategoriesSearchAction(this.value);
}

class SetDeliverySearchAction {
  bool value;

  SetDeliverySearchAction(this.value);
}

class SetCollectionSearchAction {
  bool value;

  SetCollectionSearchAction(this.value);
}

class SetProductsSearchNameAction {
  String value;

  SetProductsSearchNameAction(this.value);
}

class SetProductSearchFeaturedAction {
  bool value;

  SetProductSearchFeaturedAction(this.value);
}

class SetProductSearchOnSaleAction {
  bool value;

  SetProductSearchOnSaleAction(this.value);
}

class SetProductsDistanceAction {
  double value;

  SetProductsDistanceAction(this.value);
}

class SetOrderSearchParamsAction {
  OrderSearchParams value;

  SetOrderSearchParamsAction(this.value);
}

class SetOrderSearchStartDateAction {
  DateTime value;

  SetOrderSearchStartDateAction(this.value);
}

class SetOrderSearchEndDateAction {
  DateTime value;

  SetOrderSearchEndDateAction(this.value);
}

class SetOrderSearchCustomerAction {
  String value;

  SetOrderSearchCustomerAction(this.value);
}

class SetOrderSearchStatusFiltersAction {
  List<String?>? value;

  SetOrderSearchStatusFiltersAction(this.value);
}
