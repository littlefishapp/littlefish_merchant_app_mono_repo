// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:built_value/built_value.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiver/strings.dart';
import '../../features/ecommerce_shared/models/online/order_search_params.dart';
import '../../features/ecommerce_shared/models/search/search_attribute.dart';

part 'search_state.g.dart';

@immutable
abstract class SearchState implements Built<SearchState, SearchStateBuilder> {
  const SearchState._();

  factory SearchState() => _$SearchState._(
    hasError: false,
    errorMessage: null,
    productSearchParams: ProductSearchParams(),
    storeSearchParams: StoreSearchParams(),
    orderSearchParams: OrderSearchParams(),
    productResults: const [],
  );

  bool? get hasError;

  String? get errorMessage;

  StoreSearchParams? get storeSearchParams;

  // List<store.Store>? get storeResults;

  ProductSearchParams? get productSearchParams;

  OrderSearchParams? get orderSearchParams;

  List<DocumentSnapshot>? get productResults;
}

class StoreSearchParams {
  StoreSearchParams({
    this.distance = 15,
    this.attributes = const [],
    this.categories = const [],
    this.labels = const [],
    this.lastPosition = 0,
    this.totalCount = 0,
    this.searchName,
    this.searchOnSale = false,
    this.searchFeatured = false,
    this.searchNew = false,
    this.searchFavourites = false,
    this.searchTrending = false,
    this.deliveryEnabled,
    this.collectionEnabled,
  });

  String? searchName;

  double distance;

  List<FilterAttribute> attributes;

  List<String> categories;

  bool? deliveryEnabled;

  bool? collectionEnabled;

  List<String> labels;

  //on each new search this must be set to 0
  //used for paging
  int lastPosition;

  //on each distinct search this total must be set
  int totalCount;

  bool searchOnSale;

  bool searchFeatured;

  bool searchNew;

  bool searchFavourites;

  bool searchTrending;

  bool get hasSearchValues =>
      isNotBlank(searchName) ||
      (attributes.isNotEmpty) ||
      (categories.isNotEmpty) ||
      (labels.isNotEmpty) ||
      searchOnSale ||
      searchFeatured ||
      searchNew ||
      searchFavourites ||
      (collectionEnabled ?? false) ||
      (deliveryEnabled ?? false) ||
      searchTrending;

  bool get categoriesSelected => categories.isNotEmpty;
}

class ProductSearchParams {
  ProductSearchParams({
    this.distance = 15,
    this.attributes = const [],
    this.categories = const [],
    this.subCategories = const [],
    this.labels = const [],
    this.lastPosition = 0,
    this.totalCount = 0,
    this.searchName,
    this.searchOnSale = false,
    this.searchFeatured = false,
    this.searchNew = false,
    this.searchFavourites = false,
  });

  String? searchName;

  double distance;

  List<FilterAttribute> attributes;

  List<String?> categories;

  List<String?> subCategories;

  List<String> labels;

  //on each new search this must be set to 0
  //used for paging
  int lastPosition;

  //on each distinct search this total must be set
  int totalCount;

  bool searchOnSale;

  bool searchFeatured;

  bool searchNew;

  bool searchFavourites;

  bool get hasSearchValues =>
      isNotBlank(searchName) ||
      (attributes.isNotEmpty) ||
      (categories.isNotEmpty) ||
      ((subCategories.isNotEmpty) && (categories.isNotEmpty)) ||
      (labels.isNotEmpty) ||
      searchOnSale ||
      searchFeatured ||
      searchNew ||
      searchFavourites;
}
