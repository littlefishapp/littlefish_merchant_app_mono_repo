import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/strings.dart';

part 'store_search_params.g.dart';

@JsonSerializable(explicitToJson: true)
class StoreSearchParams {
  StoreSearchParams({
    this.storeAttributes,
    this.storeType,
    this.searchName,
    this.searchOnSale = false,
    this.searchFeatured = false,
    this.deliveryEnabled,
    this.collectionEnabled,
    this.storeProductTypes,
    this.storeSubtype,
    this.locationFilter,
    this.limit = 15,
    this.offset = 0,
  });

  String? searchName;

  List<String>? storeAttributes;

  String? storeType;

  int limit, offset;

  String? storeSubtype;

  List<String>? storeProductTypes;

  LocationFilter? locationFilter;

  bool? deliveryEnabled;

  bool? collectionEnabled;

  bool? searchOnSale;

  bool? searchFeatured;

  bool get hasSearchValues =>
      isNotBlank(searchName) ||
      (storeAttributes?.isNotEmpty ?? false) ||
      (storeType?.isNotEmpty ?? false) ||
      (storeProductTypes?.isNotEmpty ?? false) ||
      (searchOnSale ?? false) ||
      (searchFeatured ?? false) ||
      (collectionEnabled ?? false) ||
      (deliveryEnabled ?? false);

  bool get categoriesSelected => storeType != null;

  factory StoreSearchParams.fromJson(Map<String, dynamic> json) =>
      _$StoreSearchParamsFromJson(json);

  Map<String, dynamic> toJson() => _$StoreSearchParamsToJson(this);
}

@JsonSerializable()
class LocationFilter {
  double? latitude, longitude;
  double? distance;
  String? name;

  LocationFilter({this.distance = 5, this.latitude, this.longitude, this.name});

  factory LocationFilter.fromJson(Map<String, dynamic> json) =>
      _$LocationFilterFromJson(json);

  Map<String, dynamic> toJson() => _$LocationFilterToJson(this);
}
