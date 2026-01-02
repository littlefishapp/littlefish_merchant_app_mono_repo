// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_search_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreSearchParams _$StoreSearchParamsFromJson(Map<String, dynamic> json) =>
    StoreSearchParams(
      storeAttributes: (json['storeAttributes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      storeType: json['storeType'] as String?,
      searchName: json['searchName'] as String?,
      searchOnSale: json['searchOnSale'] as bool? ?? false,
      searchFeatured: json['searchFeatured'] as bool? ?? false,
      deliveryEnabled: json['deliveryEnabled'] as bool?,
      collectionEnabled: json['collectionEnabled'] as bool?,
      storeProductTypes: (json['storeProductTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      storeSubtype: json['storeSubtype'] as String?,
      locationFilter: json['locationFilter'] == null
          ? null
          : LocationFilter.fromJson(
              json['locationFilter'] as Map<String, dynamic>,
            ),
      limit: (json['limit'] as num?)?.toInt() ?? 15,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$StoreSearchParamsToJson(StoreSearchParams instance) =>
    <String, dynamic>{
      'searchName': instance.searchName,
      'storeAttributes': instance.storeAttributes,
      'storeType': instance.storeType,
      'limit': instance.limit,
      'offset': instance.offset,
      'storeSubtype': instance.storeSubtype,
      'storeProductTypes': instance.storeProductTypes,
      'locationFilter': instance.locationFilter?.toJson(),
      'deliveryEnabled': instance.deliveryEnabled,
      'collectionEnabled': instance.collectionEnabled,
      'searchOnSale': instance.searchOnSale,
      'searchFeatured': instance.searchFeatured,
    };

LocationFilter _$LocationFilterFromJson(Map<String, dynamic> json) =>
    LocationFilter(
      distance: (json['distance'] as num?)?.toDouble() ?? 5,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$LocationFilterToJson(LocationFilter instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'distance': instance.distance,
      'name': instance.name,
    };
