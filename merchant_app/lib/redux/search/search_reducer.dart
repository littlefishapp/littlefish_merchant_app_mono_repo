// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/search/search_actions.dart';
import 'package:littlefish_merchant/redux/search/search_state.dart';

final searchReducer = combineReducers<SearchState>([
  TypedReducer<SearchState, SetStoreSearchParamsAction>(
    onSetStoreSearchParams,
  ).call,
  TypedReducer<SearchState, SetProductSearchParamsAction>(
    onSetProductSearchParams,
  ).call,
  TypedReducer<SearchState, SetStoreCategoriesSearchAction>(
    onSetStoreSearchCategories,
  ).call,
  TypedReducer<SearchState, SetStoreSearchNameAction>(
    onSetStoreSearchName,
  ).call,
  TypedReducer<SearchState, SetStoreDistanceAction>(onSetStoreDistance).call,
  TypedReducer<SearchState, SetProductsCategoriesSearchAction>(
    onSetProductSearchCategories,
  ).call,
  TypedReducer<SearchState, SetDeliverySearchAction>(
    onSetDeliverySearchAction,
  ).call,
  TypedReducer<SearchState, SetCollectionSearchAction>(
    onSetCollectionSearchAction,
  ).call,
  TypedReducer<SearchState, SetProductsSearchNameAction>(
    onSetProductsSearchName,
  ).call,
  TypedReducer<SearchState, SetProductsDistanceAction>(
    onSetProductSearchDistance,
  ).call,
  TypedReducer<SearchState, SetProductSearchOnSaleAction>(
    onSetSearchProductSale,
  ).call,
  TypedReducer<SearchState, SetProductSearchFeaturedAction>(
    onSetSearchProductFeatured,
  ).call,
  TypedReducer<SearchState, SetStoreSearchFavouritesAction>(
    onSetSearchFavourites,
  ).call,
  TypedReducer<SearchState, SetStoreSearchFeaturedAction>(
    onSetSearchFeatured,
  ).call,
  TypedReducer<SearchState, SetStoreSearchNewStoresAction>(
    onSetSearchNewStores,
  ).call,
  TypedReducer<SearchState, SetStoreSearchSpecialAction>(
    onSetSearchStoresWithSpecial,
  ).call,
  TypedReducer<SearchState, SetStoreTrendingAction>(
    onSetSearchTrendingStores,
  ).call,
  TypedReducer<SearchState, SetOrderSearchParamsAction>(
    onSetOrderSearchParamsAction,
  ).call,
  TypedReducer<SearchState, SetOrderSearchStatusFiltersAction>(
    onSetOrderSearchStatusFiltersAction,
  ).call,
  TypedReducer<SearchState, SetOrderSearchStartDateAction>(
    onSetOrderSearchStartDateAction,
  ).call,
  TypedReducer<SearchState, SetOrderSearchEndDateAction>(
    onSetOrderSearchEndDateAction,
  ).call,
  TypedReducer<SearchState, SetOrderSearchCustomerAction>(
    onSetOrderSearchCustomerAction,
  ).call,
]);

SearchState onSetOrderSearchStatusFiltersAction(
  SearchState state,
  SetOrderSearchStatusFiltersAction action,
) => state.rebuild((b) => b.orderSearchParams!.statusFilters = action.value);

SearchState onSetOrderSearchEndDateAction(
  SearchState state,
  SetOrderSearchEndDateAction action,
) => state.rebuild((b) => b.orderSearchParams!.endDate = action.value);

SearchState onSetOrderSearchStartDateAction(
  SearchState state,
  SetOrderSearchStartDateAction action,
) => state.rebuild((b) => b.orderSearchParams!.startDate = action.value);

SearchState onSetOrderSearchCustomerAction(
  SearchState state,
  SetOrderSearchCustomerAction action,
) => state.rebuild((b) => b.orderSearchParams!.customerName = action.value);

SearchState onSetOrderSearchParamsAction(
  SearchState state,
  SetOrderSearchParamsAction action,
) => state.rebuild((b) => b.orderSearchParams = action.value);

SearchState onSetDeliverySearchAction(
  SearchState state,
  SetDeliverySearchAction action,
) => state.rebuild((b) => b.storeSearchParams!.deliveryEnabled = action.value);

SearchState onSetCollectionSearchAction(
  SearchState state,
  SetCollectionSearchAction action,
) =>
    state.rebuild((b) => b.storeSearchParams!.collectionEnabled = action.value);

SearchState onSetStoreSearchParams(
  SearchState state,
  SetStoreSearchParamsAction action,
) => state.rebuild((b) => b.storeSearchParams = action.value);

SearchState onSetProductSearchParams(
  SearchState state,
  SetProductSearchParamsAction action,
) => state.rebuild((b) => b.productSearchParams = action.value);

SearchState onSetStoreSearchCategories(
  SearchState state,
  SetStoreCategoriesSearchAction action,
) => state.rebuild((b) => b.storeSearchParams!.categories = action.value);

SearchState onSetStoreSearchName(
  SearchState state,
  SetStoreSearchNameAction action,
) => state.rebuild((b) => b.storeSearchParams!.searchName = action.value);

SearchState onSetStoreDistance(
  SearchState state,
  SetStoreDistanceAction action,
) => state.rebuild((b) => b.storeSearchParams!.distance = action.value);

SearchState onSetProductSearchCategories(
  SearchState state,
  SetProductsCategoriesSearchAction action,
) => state.rebuild((b) => b.productSearchParams!.categories = action.value);

SearchState onSetProductsSearchName(
  SearchState state,
  SetProductsSearchNameAction action,
) => state.rebuild((b) => b.productSearchParams!.searchName = action.value);

SearchState onSetProductSearchDistance(
  SearchState state,
  SetProductsDistanceAction action,
) => state.rebuild((b) => b.productSearchParams!.distance = action.value);

SearchState onSetSearchProductSale(
  SearchState state,
  SetProductSearchOnSaleAction action,
) => state.rebuild((b) => b.productSearchParams!.searchOnSale = action.value);

SearchState onSetSearchProductFeatured(
  SearchState state,
  SetProductSearchFeaturedAction action,
) => state.rebuild((b) => b.productSearchParams!.searchFeatured = action.value);

SearchState onSetSearchStoresWithSpecial(
  SearchState state,
  SetStoreSearchSpecialAction action,
) => state.rebuild((b) => b.storeSearchParams!.searchOnSale = action.value);

SearchState onSetSearchFavourites(
  SearchState state,
  SetStoreSearchFavouritesAction action,
) => state.rebuild((b) => b.storeSearchParams!.searchFavourites = action.value);

SearchState onSetSearchFeatured(
  SearchState state,
  SetStoreSearchFeaturedAction action,
) => state.rebuild((b) => b.storeSearchParams!.searchFeatured = action.value);

SearchState onSetSearchNewStores(
  SearchState state,
  SetStoreSearchNewStoresAction action,
) => state.rebuild((b) => b.storeSearchParams!.searchNew = action.value);

SearchState onSetSearchTrendingStores(
  SearchState state,
  SetStoreTrendingAction action,
) => state.rebuild((b) => b.storeSearchParams!.searchTrending = action.value);
