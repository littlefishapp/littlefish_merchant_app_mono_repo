import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
//import 'package:google_geocoding_plus/google_geocoding_plus.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/tools/converters/flexible_double_converted.dart';
import 'package:quiver/strings.dart';
import 'package:uuid/uuid.dart';
import '../../../../tools/converters/iso_date_time_converter.dart';
import '../../../geo_flutter_fire/geo_flutter_fire_export.dart';
import '../internationalization/country_codes.dart';
import '../shared/firebase_document_model.dart';
import 'store_attribute.dart';
import 'store_subtype.dart';
import 'store_preferences.dart';
import 'store_banner.dart';

part 'store.g.dart';

LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

@JsonSerializable(explicitToJson: true)
@EpochDateTimeConverter()
@OnlineStoreTypeConverter()
class Store extends FirebaseDocumentModel {
  LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

  Store({
    this.id,
    this.averageRating,
    this.banners,
    this.businessId,
    this.coverImageUrl,
    this.createdBy,
    this.dateCreated,
    this.deliverySettings,
    this.description,
    this.displayName,
    this.slogan,
    this.hasDeals,
    this.isFeatured,
    this.isPublic,
    this.isOnline,
    this.marketPlaceEnabled,
    this.logoUrl,
    this.bannerUrl,
    this.aboutImageUrl,
    this.name,
    this.primaryAddress,
    this.searchName,
    this.storeUrl,
    this.totalRatings,
    this.tradingHours,
    this.collectionSettings,
    this.isConfigured,
    this.contactInformation,
    this.totalCategories,
    this.countryData,
    this.coverImageAddress,
    this.totalCustomers,
    this.logoAddress,
    this.bannerAddress,
    this.aboutImageAddress,
    this.totalProducts,
    this.storeCategories,
    this.storePreferences,
    this.productsOnSaleCount = 0,
    this.totalFeaturedProducts = 0,
    this.totalStoreProductTypes = 0,
    this.totalStoreAttributes = 0,
    this.deleted,
    this.onlineStoreType,
    this.storeSubtypeId,
    this.storeTypeId,
    this.storeId,
    this.uniqueSubdomain,
    this.shortenCatalogueUrl,
    this.isDomainLive,
  });

  Store.defaults() {
    id = businessId = storeId = const Uuid().v4();
    onlineStoreType = OnlineStoreType.retail;
    totalRatings = 0;
    averageRating = 0;
    productsOnSaleCount = 0;
    totalStoreProductTypes = totalStoreAttributes = 0;
    dateCreated = DateTime.now();
    isFeatured = false;
    isPublic = false;
    isOnline = false;
    marketPlaceEnabled = false;
    hasDeals = false;
    // this.options = StoreCategoryOptions();

    primaryAddress = StoreAddress();

    //we need to have the basic settings enabled...
    storePreferences = StorePreferences()
      ..acceptsOnlineOrders = true
      ..freeDelivery = FreeDelivery()
      ..onlineFee = OnlineFee()
      ..theme = StoreTheme();
    contactInformation = ContactInformation();
    deleted = false;
    isDomainLive = false;
  }

  String? id;

  String? businessId, storeId;

  OnlineStoreType? onlineStoreType;

  bool? isDomainLive;

  String? name;

  String? displayName;

  String? slogan;

  String? searchName;

  String? description;

  String? storeSubtypeId;

  String? storeTypeId;

  String? shortenCatalogueUrl;

  String? get instagramHandle => contactInformation?.instagram;

  String? get facebookPage => contactInformation?.facebook;

  String? get emailAddress => contactInformation?.email;

  String? get website => contactInformation?.website;

  String? get telephone => contactInformation?.telephoneNumber;

  String? get whatsappLine => contactInformation?.whatsapp;

  bool get hasDescription => isNotBlank(description ?? '');

  bool get hasInsta => isNotBlank(contactInformation?.instagram ?? '');

  bool get hasFacebook => isNotBlank(contactInformation?.facebook ?? '');

  bool get hasEmail => isNotBlank(contactInformation?.email ?? '');

  bool get hasWebsite => isNotBlank(contactInformation?.website ?? '');

  bool get hasTelephone =>
      isNotBlank(contactInformation?.telephoneNumber ?? '');

  bool get hasWhatsapp => isNotBlank(contactInformation?.whatsapp ?? '');

  String? logoUrl;

  String? bannerUrl;

  String? aboutImageUrl;

  bool get hasLogo => isNotBlank(logoUrl ?? '');

  bool get hasBanner => isNotBlank(bannerUrl ?? '');

  bool get hasAboutImageUrl => isNotBlank(aboutImageUrl ?? '');

  String? logoAddress;

  String? bannerAddress;

  String? aboutImageAddress;

  String? coverImageUrl;

  bool get hasCoverImage => isNotBlank(coverImageUrl ?? '');

  String? coverImageAddress;

  ContactInformation? contactInformation;

  //the url that will be shared [dynamic link?]
  String? storeUrl;

  @JsonKey(defaultValue: [])
  List<StoreBanner>? banners;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<StoreAttribute>? storeAttributes;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<StoreProductType>? storeProductTypes;

  bool get hasBanners => banners != null && banners!.isNotEmpty;

  @JsonKey(defaultValue: 0.0)
  double? averageRating;

  @JsonKey(defaultValue: 0)
  int? totalRatings;

  bool get hasRatings {
    return totalRatings != null && totalRatings! > 0;
  }

  String? createdBy;

  String? uniqueBusinessName;

  String? uniqueSubdomain;

  DateTime? dateCreated;

  @JsonKey(defaultValue: false)
  bool? deleted;

  @JsonKey(defaultValue: false)
  bool? isFeatured;

  @JsonKey(defaultValue: false)
  bool? isPublic;

  @JsonKey(defaultValue: false)
  bool? isOnline;

  @JsonKey(defaultValue: false)
  bool? marketPlaceEnabled;

  @JsonKey(defaultValue: false)
  bool? hasDeals;

  @JsonKey(defaultValue: false)
  bool? isConfigured;

  @JsonKey(name: 'primary_address')
  StoreAddress? primaryAddress;

  @JsonKey(defaultValue: 0)
  int? totalProducts;

  int? totalStoreProductTypes;

  @JsonKey(defaultValue: 0)
  int? totalCategories;

  @JsonKey(defaultValue: 0)
  int? totalCustomers;

  int? totalStoreAttributes;

  @JsonKey(defaultValue: 0)
  int? totalOrders;

  @JsonKey(defaultValue: 0)
  int? activeOrders;

  @JsonKey(defaultValue: 0)
  int? totalFollowers;

  @JsonKey(defaultValue: 0)
  int? totalFlyers;

  @JsonKey(defaultValue: 0)
  int? totalViews;

  int? productsOnSaleCount;

  int? totalFeaturedProducts;

  @JsonKey(defaultValue: 0)
  int? totalCoupons;

  @JsonKey(defaultValue: <TradingDay>[])
  List<TradingDay>? tradingHours;

  @JsonKey(includeFromJson: false, includeToJson: false)
  GeoPoint? get geoPoint => primaryAddress?.location?.geopoint;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, bool>? storeCategories;

  @JsonKey(name: 'delivery_settings')
  DeliverySettings? deliverySettings;

  @JsonKey(name: 'collection_settings')
  CollectionSettings? collectionSettings;

  @JsonKey(name: 'store_preferences')
  StorePreferences? storePreferences;

  //internationalization
  @JsonKey(name: 'country_data')
  CountryCode? countryData;

  Map<String, int>? orderStatusCounts;

  String? get defaultCurrency => countryData?.currencyCode;

  String? get countryCode => countryData?.countryCode;

  String? get countryName => countryData?.countryName;

  CurrencyCode? get currency {
    if (countryData == null) {
      return null;
    } else {
      return CurrencyCode.fromCountryCode(countryData!);
    }
  }

  CollectionReference? get productCollection =>
      documentReference?.collection('products');

  CollectionReference? get customersCollection =>
      documentReference?.collection('customers');

  CollectionReference? get usersCollection =>
      documentReference?.collection('users');

  CollectionReference? get categoryCollection =>
      documentReference?.collection('categories');

  CollectionReference? get storeProductTypesCollection =>
      documentReference?.collection('store_product_types');

  CollectionReference? get storeAttributesCollection =>
      documentReference?.collection('store_attributes');

  CollectionReference? get orderStatusCollection =>
      documentReference?.collection('order_statuses');

  CollectionReference? get lostSalesCollection =>
      documentReference?.collection('lostSales');

  CollectionReference? get couponsCollection =>
      documentReference?.collection('coupons');

  CollectionReference? get customerListsCollection =>
      documentReference?.collection('customer_lists');

  CollectionReference? get priceListsCollection =>
      documentReference?.collection('price_lists');

  CollectionReference? get productVariantsCollection =>
      documentReference?.collection('product_variants');

  CollectionReference? get timelineCollection =>
      documentReference?.collection('timeline_events');

  CollectionReference? get galleryCollection =>
      documentReference?.collection('gallery');

  CollectionReference? get promotionCountCollection =>
      documentReference?.collection('promotion_counts');

  CollectionReference? get orderAnalyticsCollection =>
      documentReference?.collection('order_analytics');

  // setup validators
  bool get brandConfigured =>
      (!isBlank(logoAddress) &&
      !isBlank(bannerAddress) &&
      !isBlank(aboutImageAddress) &&
      !isBlank(coverImageAddress) &&
      !isBlank(storePreferences?.theme?.primaryColor) &&
      !isBlank(storePreferences?.theme?.secondaryColor));

  bool get businessInformationConfigured =>
      isNotBlank(name) && isNotBlank(description);

  bool get addressConfigured =>
      (!isBlank(primaryAddress?.addressLine1) &&
      !isBlank(primaryAddress?.addressLine2) &&
      !isBlank(primaryAddress?.city) &&
      !isBlank(primaryAddress?.country));

  bool get storeTypesConfigured =>
      (isNotBlank(storeTypeId) && isNotBlank(storeSubtypeId));

  bool get productCategoriesConfigured => (totalCategories ?? 0) > 0;

  bool get onlinePreferencesConfigured {
    if (storePreferences != null) {
      if (storePreferences!.acceptsOnlineOrders!) {
        if (!(collectionSettings?.enabled ?? false) &&
            (deliverySettings?.enabled ?? false)) {
          return false;
        } else {
          return true;
        }
      }
      return true;
    }

    return false;
  }

  bool get tradingHoursConfigured {
    if (tradingHours != null) {
      return tradingHours!.any((element) => element.isOpen);
    }
    return false;
  }

  bool get contactInformationConfigured =>
      (contactInformation != null &&
      !isBlank(contactInformation!.email) &&
      (!isBlank(contactInformation!.mobileNumber) ||
          !isBlank(contactInformation!.telephoneNumber)));

  bool get personalizationConfigured =>
      (
      //(this.banners?.length ?? 0) > 0 &&
      !isBlank(storePreferences!.theme?.layout) &&
      !isBlank(storePreferences!.theme?.primaryColor) &&
      !isBlank(storePreferences!.theme?.secondaryColor));

  bool get productsConfigured => (totalProducts ?? 0) > 0;

  int get setupCompletionPercentage {
    var count = 0;

    // if (productsConfigured) count++;
    // if (productCategoriesConfigured) count++;
    if (personalizationConfigured) count++;
    if (contactInformationConfigured) count++;
    if (tradingHoursConfigured) count++;
    if (onlinePreferencesConfigured) count++;
    if (storeTypesConfigured) count++;
    if (addressConfigured) count++;
    if (brandConfigured) count++;
    if (businessInformationConfigured) count++;

    return ((count / 8) * 100).toInt();
  }

  factory Store.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$StoreFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  //load the gallery from the store object, avoid additional layers
  // Future<void> loadGallery({bool refresh = false}) async {
  //   if (!refresh || (this.gallery ?? []).isNotEmpty) return;

  //   var result = (await this
  //           ?.galleryCollection
  //           ?.where('isDeleted', isEqualTo: false)
  //           ?.get())
  //       ?.docs
  //       ?.map(
  //         (e) => SystemGalleryItem.fromJson(e.data)
  //           ..documentReference = e.reference,
  //       );

  //   this.gallery = result;
  // }

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  Map<String, dynamic> toJson() => _$StoreToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class StoreCategoryOptions {
  StoreCategoryOptions({
    this.alcohol,
    this.artsAndCrafts,
    this.babyAndChildren,
    this.butchersMarket,
    this.childrenToys,
    this.cleaningAndSanitization,
    this.cleaningProducts,
    this.fashionAndClothing,
    this.freshProduce,
    this.electronics,
    this.gardenAndOutdoor,
    this.hardwareAndDIY,
    this.groceries,
    this.other,
  });

  @JsonKey(name: 'alcohol', defaultValue: false)
  bool? alcohol;

  @JsonKey(name: 'arts_and_crafts', defaultValue: false)
  bool? artsAndCrafts;

  @JsonKey(name: 'baby_products', defaultValue: false)
  bool? babyAndChildren;

  @JsonKey(name: 'butchers_market', defaultValue: false)
  bool? butchersMarket;

  @JsonKey(name: 'children_toys', defaultValue: false)
  bool? childrenToys;

  @JsonKey(name: 'cleaning_and_sanitation', defaultValue: false)
  bool? cleaningAndSanitization;

  @JsonKey(name: 'cleaning_products', defaultValue: false)
  bool? cleaningProducts;

  @JsonKey(name: 'fashion_and_clothing', defaultValue: false)
  bool? fashionAndClothing;

  @JsonKey(name: 'fresh_produce', defaultValue: false)
  bool? freshProduce;

  @JsonKey(name: 'hardware_and_diy', defaultValue: false)
  bool? hardwareAndDIY;

  @JsonKey(name: 'garden_and_outdoor', defaultValue: false)
  bool? gardenAndOutdoor;

  @JsonKey(name: 'electronics', defaultValue: false)
  bool? electronics;

  @JsonKey(name: 'groceries', defaultValue: false)
  bool? groceries;

  @JsonKey(name: 'other', defaultValue: false)
  bool? other;

  factory StoreCategoryOptions.fromJson(Map<String, dynamic> json) =>
      _$StoreCategoryOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$StoreCategoryOptionsToJson(this);

  Map<String, dynamic> toJsonCustom() => <String, bool?>{
    'alcohol': alcohol,
    'arts_and_crafts': artsAndCrafts,
    'baby_and_children': babyAndChildren,
    'butchers_market': butchersMarket,
    'children_toys': childrenToys,
    'cleaning_and_sanitation': cleaningAndSanitization,
    'cleaning_products': cleaningProducts,
    'fashion_and_clothing': fashionAndClothing,
    'fresh_produce': freshProduce,
    'hardware_and_diy': hardwareAndDIY,
    'garden_and_outdoor': gardenAndOutdoor,
    'electronics': electronics,
    'groceries': groceries,
    'other': other,
  };
}

@JsonSerializable()
@EpochDateTimeConverter()
class TradingDay {
  TradingDay({
    this.closingTime,
    this.dow,
    this.openingTime,
    this.isOpen = false,
    this.is24Hours = false,
  });

  @JsonKey(defaultValue: false)
  bool isOpen;

  @JsonKey(defaultValue: false)
  bool is24Hours;

  @JsonKey(defaultValue: 1)
  int? dow;

  DateTime? openingTime;

  DateTime? closingTime;

  factory TradingDay.defaultDate(dow) {
    var currentDay = DateTime.now();
    return TradingDay(
      closingTime: DateTime(currentDay.year, currentDay.month, dow, 16),
      openingTime: DateTime(currentDay.year, currentDay.month, dow, 8),
      is24Hours: false,
      isOpen: false,
      dow: dow ?? 1,
    );
  }

  factory TradingDay.fromJson(Map<String, dynamic> json) =>
      _$TradingDayFromJson(json);

  Map<String, dynamic> toJson() => _$TradingDayToJson(this);
}

@JsonSerializable(explicitToJson: true)
@DateTimeConverter()
class StoreAddress {
  StoreAddress({
    this.friendlyName,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.country,
    this.enabled,
    this.location,
    this.locationId,
    this.state,
    this.postalCode,
    this.placeId,
    this.id,
    this.isPrimary,
  });

  StoreAddress.copy(StoreAddress source)
    : isPrimary = source.isPrimary,
      friendlyName = source.friendlyName,
      id = source.id,
      enabled = source.enabled,
      locationId = source.locationId,
      addressLine1 = source.addressLine1,
      addressLine2 = source.addressLine2,
      country = source.country,
      state = source.state,
      postalCode = source.postalCode,
      city = source.city,
      location = source.location == null
          ? null
          : StoreLocation.copy(source.location!),
      placeId = source.placeId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StoreAddress &&
        other.id == id &&
        other.friendlyName == friendlyName &&
        other.addressLine1 == addressLine1 &&
        other.addressLine2 == addressLine2 &&
        other.city == city &&
        other.state == state &&
        other.postalCode == postalCode &&
        other.location == location &&
        other.locationId == locationId &&
        other.placeId == placeId &&
        other.isPrimary == isPrimary &&
        other.country == country &&
        other.enabled == enabled;
  }

  @override
  int get hashCode => Object.hash(
    id,
    friendlyName,
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    country,
    enabled,
    locationId,
    placeId,
    isPrimary,
    location,
  );

  // StoreAddress.fromGeoCodingResponse(GeocodingResponse data) {
  //   //if (data == null || data.hasNoResults) return;
  //   if (data.results != null) {
  //     return;
  //   }

  //   if (data.results!.isEmpty) {
  //     return;
  //   }

  //   //if (data.isDenied) return;

  //   // if (data.isOverQueryLimit) return;

  //   placeId = data.results!.first.placeId;

  //   id = const Uuid().v4();

  //   isPrimary = true;

  //   var streetNumber = data.results!.first.addressComponents
  //       ?.firstWhereOrNull((element) => element.types!.contains('street_number'))
  //       ?.longName;

  //   addressLine1 = streetNumber;

  //   var streetName = data.results!.first.addressComponents
  //       ?.firstWhereOrNull((element) => element.types!.contains('route'))
  //       ?.longName;

  //   addressLine2 = streetName;

  //   // var suburb = data.results.first.addressComponents
  //   //     ?.firstWhere(
  //   //         (element) =>
  //   //             element.types.contains('political') ||
  //   //             element.types.contains('sublocality') ||
  //   //             element.types.contains('sublocality_level_1'),
  //   //         orElse: () => null)
  //   //     ?.longName;

  //   // var town = data.results.first.addressComponents
  //   //     ?.firstWhere((element) => element.types.contains('locality'),
  //   //         orElse: () => null)
  //   //     ?.longName;

  //   var city = data.results!.first.addressComponents
  //       ?.firstWhereOrNull(
  //           (element) => element.types!.contains('administrative_area_level_2'),)
  //       ?.longName;

  //   this.city = city;

  //   var province = data.results!.first.addressComponents
  //       ?.firstWhereOrNull(
  //           (element) => element.types!.contains('administrative_area_level_1'),)
  //       ?.longName;

  //   state = province;

  //   var country = data.results!.first.addressComponents
  //       ?.firstWhereOrNull((element) => element.types!.contains('country'))
  //       ?.longName;

  //   this.country = country;

  //   var postalCode = data.results!.first.addressComponents
  //       ?.firstWhereOrNull((element) => element.types!.contains('postal_code'))
  //       ?.longName;

  //   this.postalCode = postalCode;

  //   var loc = GeoFirePoint(
  //     data.results?.first.geometry?.location?.lat ?? 0.0,
  //     data.results?.first.geometry?.location?.lng ?? 0.0,
  //   );

  //   location = StoreLocation.fromGeoFirePoint(loc);

  //   enabled = true;
  // }

  bool? isPrimary;

  String? friendlyName;

  String? id;

  bool? enabled;

  String? locationId;

  String? addressLine1;

  String? addressLine2;

  String? country;

  String? state;

  String? postalCode;

  String? city;

  StoreLocation? location;

  String? placeId;

  String toStringAddress() =>
      '$addressLine1\r\n$city\r\n$state\r\n$country\r\n';

  String toShortStringAddress() => '$addressLine1,$city';

  bool get isPartiallyPopulated =>
      isNotBlank(city) && isNotBlank(country) && isNotBlank(state);

  bool get isPopulated =>
      isNotBlank(addressLine1) &&
      isNotBlank(city) &&
      isNotBlank(country) &&
      isNotBlank(state);

  factory StoreAddress.fromJson(Map<String, dynamic> json) =>
      _$StoreAddressFromJson(json);

  Map<String, dynamic> toJson() => _$StoreAddressToJson(this);
}

class StoreLocation {
  StoreLocation({this.hash, this.latitude, this.longitude});

  StoreLocation.copy(StoreLocation source)
    : hash = source.hash,
      latitude = source.latitude,
      longitude = source.longitude;

  StoreLocation.fromGeoFirePoint(GeoFirePoint point) {
    hash = point.hash;
    latitude = point.latitude;
    longitude = point.longitude;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StoreLocation &&
        other.hash == hash &&
        other.longitude == longitude &&
        other.latitude == latitude;
  }

  @override
  int get hashCode => Object.hash(hash, longitude, latitude);

  double? latitude, longitude;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? hash;

  @JsonKey(includeFromJson: false, includeToJson: false)
  GeoPoint? get geopoint {
    if (latitude != null && longitude != null) {
      return GeoPoint(latitude!, longitude!);
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'geohash': hash,
  };

  factory StoreLocation.fromJson(Map<String, dynamic> data) => StoreLocation(
    hash: data['geohash'],
    latitude: (data['geopoint'] as GeoPoint?)?.latitude ?? data['latitude'],
    longitude: (data['geopoint'] as GeoPoint?)?.longitude ?? data['longitude'],
  );
}

@JsonSerializable()
class StoreCategory extends FirebaseDocumentModel {
  StoreCategory({
    this.displayName,
    this.slogan,
    this.enabled,
    this.featureImageUrl,
    this.name,
    this.searchName,
    this.description,
    this.storeCount,
  });

  String? name;

  String? displayName;

  String? slogan;

  String? description;

  String? searchName;

  String? featureImageUrl;

  bool? enabled;

  int? storeCount;

  factory StoreCategory.fromJson(Map<String, dynamic> json) =>
      _$StoreCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoreCategoryToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Map<String, dynamic>>? locales;

  CollectionReference? get localesCollection =>
      documentReference?.collection('locales');

  dynamic getLocaleValue({
    required String languageCode,
    required String translationKey,
    required String defaultValue,
  }) {
    //here we need to lookup in the current collection and see if it exists....

    if (locales == null) return defaultValue;

    logger.debug(
      'features.ecommerce.store.category',
      'Searching for locale key: $translationKey, default: $defaultValue, language: $languageCode',
    );

    var thisLocale = locales!.firstWhereOrNull(
      (element) => element['languageCode'] == languageCode,
    );

    if (thisLocale == null) {
      logger.debug('features.ecommerce.store.category', 'No locale key found');
      return defaultValue;
    }

    logger.debug(
      'features.ecommerce.store.category',
      'Locale found with code: $languageCode',
    );

    var keys = thisLocale['keys'];

    logger.debug('features.ecommerce.store.category', 'Locale keys: $keys');

    if (!keys.containsKey(translationKey)) return defaultValue;

    return keys[translationKey];
  }

  Future<void> addLocale({required String languageCode}) async {
    //load all....
    if (isBlank(languageCode)) {
      logger.debug(
        'features.ecommerce.store.category',
        'Loading all languages into category',
      );
      var values = await localesCollection!.get();

      locales ??= [];

      for (var element in values.docs) {
        locales!.add({'languageCode': element.id, 'keys': element.data});
      }
    } else {
      logger.debug(
        'features.ecommerce.store.category',
        'Adding language: $languageCode into category: $displayName',
      );
      //load only this single locale...
      var doc = (await localesCollection?.doc(languageCode).get())!;

      if (!doc.exists) {
        // debugPrint('locale $languageCode, does not exist in category: $displayName');

        // reportCheckedError(Exception('locale $languageCode, does not exist in category: $displayName'));
        return;
      }

      logger.debug(
        'features.ecommerce.store.category',
        'Locale values exist for: $displayName',
      );

      var data = doc.data;

      locales ??= [];

      locales!.add({'languageCode': languageCode, 'keys': data});
    }
  }
}

enum ShippingMode { collectionOnly, deliveryOnly, collectionAndDelivery }

@JsonSerializable()
@TimeOfDayConverter()
class DeliverySettings {
  DeliverySettings({
    this.enabled = false,
    this.deliveryRadius,
    this.estimatedDelivery,
    this.sameDay = false,
    this.minimumOrderValue,
    this.deliveryAddress,
    this.useBusinessAddress = false,
    this.deliveryInstructions,
  });

  @JsonKey(defaultValue: false)
  bool enabled;
  @JsonKey(defaultValue: false)
  bool sameDay;
  @JsonKey(defaultValue: false)
  bool useBusinessAddress;

  @JsonKey(defaultValue: 10)
  int? deliveryRadius;

  @FlexibleDoubleConverter()
  @JsonKey(defaultValue: 10)
  double? minimumOrderValue;

  String? deliveryInstructions;

  String? deliveryAddress;

  TimeOfDay? sameDayCutoffTime;

  TimeOfDay? estimatedDelivery;

  factory DeliverySettings.fromJson(Map<String, dynamic> json) =>
      _$DeliverySettingsFromJson(json);

  Map<String, dynamic> toJson() => _$DeliverySettingsToJson(this);
}

@JsonSerializable()
@TimeOfDayConverter()
class CollectionSettings {
  CollectionSettings({
    this.pickupTime,
    this.enabled = false,
    this.useBusinessAddress = false,
    this.collectionInstructions,
  });

  @JsonKey(defaultValue: false)
  bool? enabled;

  @JsonKey(defaultValue: false)
  bool? useBusinessAddress;

  String? collectionAddress;

  String? collectionInstructions;

  TimeOfDay? pickupTime;

  factory CollectionSettings.fromJson(Map<String, dynamic> json) =>
      _$CollectionSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionSettingsToJson(this);
}

@JsonSerializable(explicitToJson: true)
@FeeTypeConverter()
class OnlineFee {
  OnlineFee({
    this.amount,
    this.enabled = false,
    this.isFixedAmount = true,
    this.isVariableAmount = false,
  });

  bool? enabled;

  double? amount;

  bool? isFixedAmount;

  bool? isVariableAmount;

  factory OnlineFee.fromJson(Map<String, dynamic> json) =>
      _$OnlineFeeFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineFeeToJson(this);
}

@JsonSerializable(explicitToJson: true)
@FeeTypeConverter()
class FreeDelivery {
  FreeDelivery({this.amount, this.enabled = false});

  bool? enabled;

  double? amount;

  factory FreeDelivery.fromJson(Map<String, dynamic> json) =>
      _$FreeDeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$FreeDeliveryToJson(this);
}

enum FeeType { percentage, fixedAmount, distance }

class FeeTypeConverter implements JsonConverter<FeeType, int> {
  const FeeTypeConverter();

  @override
  FeeType fromJson(int json) {
    return FeeType.values[json];
  }

  @override
  int toJson(FeeType object) {
    return object.index;
  }
}

@JsonSerializable()
class ContactInformation {
  String? email;
  String? facebook;
  String? instagram;
  String? mobileNumber;
  String? telephoneNumber;
  String? twitter;
  String? website;
  String? whatsapp;

  ContactInformation({
    this.email,
    this.facebook,
    this.instagram,
    this.mobileNumber,
    this.telephoneNumber,
    this.twitter,
    this.website,
    this.whatsapp,
  });

  ContactInformation.copy(ContactInformation source)
    : email = source.email,
      facebook = source.facebook,
      instagram = source.instagram,
      mobileNumber = source.mobileNumber,
      telephoneNumber = source.telephoneNumber,
      twitter = source.twitter,
      website = source.website,
      whatsapp = source.whatsapp;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContactInformation &&
        other.email == email &&
        other.facebook == facebook &&
        other.instagram == instagram &&
        other.mobileNumber == mobileNumber &&
        other.telephoneNumber == telephoneNumber &&
        other.twitter == twitter &&
        other.website == website &&
        other.whatsapp == whatsapp;
  }

  @override
  int get hashCode => Object.hash(
    email,
    facebook,
    instagram,
    mobileNumber,
    telephoneNumber,
    twitter,
    website,
    whatsapp,
  );

  factory ContactInformation.fromJson(Map<String, dynamic> json) =>
      _$ContactInformationFromJson(json);

  Map<String, dynamic> toJson() => _$ContactInformationToJson(this);
}

@JsonSerializable()
@LinkedAccountTypeConverter()
@ProviderTypeConverter()
class LinkedAccount {
  ProviderType? providerType;
  String? providerName;
  String? id;
  String? imageURI;
  bool? hasQRCode;
  bool? isQRCodeEnabled;
  String? config;
  LinkedAccountType? linkedAccountType;
  bool? enabled;
  bool? deleted;
  DateTime? dateUpdated;
  String? updatedBy;
  DateTime? dateCreated;
  String? createdBy;

  LinkedAccount({
    this.config,
    this.deleted,
    this.createdBy,
    this.dateCreated,
    this.updatedBy,
    this.dateUpdated,
    this.providerName,
    this.id,
    this.enabled,
    this.providerType,
    this.imageURI,
    this.hasQRCode,
    this.isQRCodeEnabled,
    this.linkedAccountType,
  });

  factory LinkedAccount.fromJson(Map<String, dynamic> json) =>
      _$LinkedAccountFromJson(json);

  Map<String, dynamic> toJson() => _$LinkedAccountToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class StoreCoupon extends FirebaseDocumentModel {
  StoreCoupon({
    this.allocationCount,
    this.businessId,
    this.deleted,
    this.expiryDate,
    this.id,
    this.limit,
    this.quantity,
    this.startDate,
    this.type,
    this.value,
    this.featureImageAddress,
    this.storeLogoImageAddress,
    this.level,
    this.restrictToLevel,
    this.minimumSpend,
    this.desription,
    this.displayName,
    this.slogan,
    this.name,
  });

  StoreCoupon.defaults() {
    id = const Uuid().v4();
    deleted = false;

    startDate = DateTime.now();
    expiryDate = DateTime.now().add(const Duration(days: 14));

    limit = null;
    quantity = 10;

    restrictToLevel = false;
    level = -1;

    allocationCount = 0;
    minimumSpend = 0.0;
  }

  String? name;

  String? displayName;

  String? slogan;

  String? desription;

  @JsonKey(defaultValue: false)
  bool? deleted;

  String? id;

  String? businessId;

  double? quantity;

  DateTime? startDate;

  DateTime? expiryDate;

  @JsonKey(defaultValue: false)
  bool? restrictToLevel;

  bool get isAllRewardMembers => restrictToLevel! && level == -1;

  int get remainingVouchers =>
      ((quantity ?? 0.0) - (allocationCount ?? 0.0)).toInt();

  @JsonKey(defaultValue: -1)
  int? level;

  //fixed / %
  String? type;

  //if percentage then the limit applies (i.e. up to 50)
  double? limit;

  //total allocated already
  double? allocationCount;

  //if percentage then, it is the % / 100 if not it is the amount
  double? value;

  String? featureImageUrl;

  String? featureImageAddress;

  String? storeLogoUrl;

  String? storeBannerUrl;

  String? storeAboutImageUrl;

  String? storeLogoImageAddress;

  @JsonKey(defaultValue: 0.0)
  double? minimumSpend;

  CollectionReference? get allocatedCouponsCollection =>
      documentReference?.collection('allocations');

  factory StoreCoupon.fromJson(Map<String, dynamic> json) =>
      _$StoreCouponFromJson(json);

  Map<String, dynamic> toJson() => _$StoreCouponToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class AllocatedCoupon extends FirebaseDocumentModel {
  AllocatedCoupon({
    this.businessId,
    this.couponId,
    this.userId,
    this.dateAllocated,
    this.expiryDate,
    this.id,
    this.redeemed,
    this.value,
    this.revoked,
    this.userName,
    this.type,
    this.minimumSpend = 0.0,
  });

  String? id;

  String? type;

  String? userId;

  String? userName;

  String? businessId;

  String? couponId;

  bool? redeemed;

  bool? revoked;

  //the coupon code which will be provided or entered during checkout
  double? value;

  DateTime? expiryDate;

  DateTime? dateAllocated;

  @JsonKey(defaultValue: 0.0)
  double minimumSpend;

  factory AllocatedCoupon.fromJson(Map<String, dynamic> json) =>
      _$AllocatedCouponFromJson(json);

  Map<String, dynamic> toJson() => _$AllocatedCouponToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class StoreReferral {
  StoreReferral({
    this.dateReffered,
    this.email,
    this.id,
    this.mobileNumber,
    this.refferedBy,
    this.storeName,
    this.contactName,
  });

  StoreReferral.defaults() {
    id = const Uuid().v4();
    dateReffered = DateTime.now();
  }

  String? id;

  String? storeName;

  String? contactName;

  String? mobileNumber;

  String? email;

  DateTime? dateReffered;

  String? refferedBy;

  factory StoreReferral.fromJson(Map<String, dynamic> json) =>
      _$StoreReferralFromJson(json);

  Map<String, dynamic> toJson() => _$StoreReferralToJson(this);
}

enum LinkedAccountType { payment }

enum ProviderType { zapper, snapscan }

class LinkedAccountTypeConverter
    implements JsonConverter<LinkedAccountType, int> {
  const LinkedAccountTypeConverter();

  @override
  LinkedAccountType fromJson(int json) {
    return LinkedAccountType.values[json];
  }

  @override
  int toJson(LinkedAccountType object) {
    return object.index;
  }
}

class ProviderTypeConverter implements JsonConverter<ProviderType, int> {
  const ProviderTypeConverter();

  @override
  ProviderType fromJson(int json) {
    return ProviderType.values[json];
  }

  @override
  int toJson(ProviderType object) {
    return object.index;
  }
}

@JsonSerializable()
@DateTimeConverter()
class StoreTrendData {
  StoreTrendData({
    this.growthTrend,
    this.lostFollowers,
    this.newFollowers,
    this.storeId,
    this.trendDate,
    this.viewCount,
  });

  String? storeId;

  DateTime? trendDate;

  @JsonKey(defaultValue: 0)
  int? newFollowers, lostFollowers, growthTrend, viewCount;

  factory StoreTrendData.fromJson(Map<String, dynamic> json) =>
      _$StoreTrendDataFromJson(json);

  Map<String, dynamic> toJson() => _$StoreTrendDataToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class StoreSalesData extends FirebaseDocumentModel {
  StoreSalesData({
    this.storeId,
    this.trendDate,
    this.cancelledOrders,
    this.completedOrders,
    this.newOrders,
    this.totalProductsSold,
  });

  String? storeId;

  DateTime? trendDate;

  @JsonKey(defaultValue: 0)
  int? newOrders, cancelledOrders, completedOrders;

  int? totalProductsSold;

  //sub collections
  CollectionReference? get categorySalesSummaryCollection =>
      documentReference?.collection('categorySalesSummary');

  CollectionReference? get paymentTypesSalesSummaryCollection =>
      documentReference?.collection('paymentTypesSalesSummary');

  CollectionReference? get productSalesSummaryCollection =>
      documentReference?.collection('productSalesSummary');

  CollectionReference? get salesMarkupSummaryCollection =>
      documentReference?.collection('salesMarkupSummary');

  factory StoreSalesData.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$StoreSalesDataFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  factory StoreSalesData.fromJson(Map<String, dynamic> json) =>
      _$StoreSalesDataFromJson(json);

  Map<String, dynamic> toJson() => _$StoreSalesDataToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class StoreGoal {
  StoreGoal({
    this.autoExtend,
    this.currentQty,
    this.description,
    this.displayName,
    this.slogan,
    this.extensionQty,
    this.name,
    this.target,
    this.type,
  });

  String? name;

  String? displayName;

  String? slogan;

  String? description;

  @JsonKey(defaultValue: StoreGoalType.products)
  StoreGoalType? type;

  @JsonKey(defaultValue: 1)
  int? target;

  @JsonKey(defaultValue: 0)
  int? currentQty;

  @JsonKey(defaultValue: true)
  bool? autoExtend;

  @JsonKey(defaultValue: 5)
  int? extensionQty;

  factory StoreGoal.fromJson(Map<String, dynamic> json) =>
      _$StoreGoalFromJson(json);

  Map<String, dynamic> toJson() => _$StoreGoalToJson(this);
}

enum StoreGoalType {
  products,
  sales,
  customers,
  promotions,
  coupons,
  flyers,
  onSaleProducts,
  featuredProducts,
  featuredStore,
}

@JsonSerializable(explicitToJson: true)
@EpochDateTimeConverter()
class FeaturedStore extends FirebaseDocumentModel {
  DateTime? startDate, endDate;
  int? duration;

  @JsonKey(defaultValue: true)
  bool? enabled;

  String? storeId, displayName, description, slogan;

  StoreCategoryOptions? categoryOptions;

  StoreAddress? primaryAddress;

  String? logoUrl, logoAddress;
  String? bannerUrl, bannerAddress;
  String? aboutImageUrl, aboutImageAddress;
  String? coverUrl, coverAddress;

  @JsonKey(defaultValue: 0)
  int? totalProducts, totalOrders, totalCategories;

  FeaturedStore({
    this.startDate,
    this.endDate,
    this.enabled,
    this.storeId,
    this.displayName,
    this.slogan,
    this.description,
    this.categoryOptions,
    this.totalCategories,
    this.totalOrders,
    this.totalProducts,
    this.primaryAddress,
    this.logoAddress,
    this.bannerAddress,
    this.aboutImageAddress,
    this.logoUrl,
    this.bannerUrl,
    this.aboutImageUrl,
    this.coverAddress,
    this.coverUrl,
    this.duration,
  });

  FeaturedStore.fromStore(Store store) {
    enabled = true;
    displayName = store.displayName;
    slogan = store.slogan;
    logoUrl = store.logoUrl;
    bannerUrl = store.bannerUrl;
    aboutImageUrl = store.aboutImageUrl;
    logoAddress = store.logoAddress;
    bannerAddress = store.bannerAddress;
    aboutImageAddress = store.aboutImageAddress;
    coverUrl = store.coverImageUrl;
    coverAddress = store.coverImageAddress;
    description = store.description;
    storeId = store.businessId;
    totalCategories = store.totalCategories;
    totalProducts = store.totalProducts;
    totalOrders = store.totalOrders;
    primaryAddress = store.primaryAddress;
  }

  factory FeaturedStore.fromJson(Map<String, dynamic> json) =>
      _$FeaturedStoreFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturedStoreToJson(this);
}

class StoreCatalogue extends FirebaseDocumentModel {
  StoreCatalogue({
    this.catalogueAddress,
    this.catalogueUrl,
    this.dateCreated,
    this.description,
    this.expiryDate,
    this.id,
    this.isDeleted,
    this.name,
  });

  String? id;

  String? name;

  String? description;

  bool? isDeleted;

  DateTime? expiryDate;

  DateTime? dateCreated;

  String? catalogueUrl;

  String? catalogueAddress;
}

enum OnlineStoreType { retail, wholesale }

class OnlineStoreTypeConverter
    implements JsonConverter<OnlineStoreType?, String> {
  const OnlineStoreTypeConverter();

  @override
  OnlineStoreType? fromJson(String? json) {
    return OnlineStoreType.values.firstWhereOrNull(
      (element) => element.toString().split('.').last == json,
    );
  }

  @override
  String toJson(OnlineStoreType? object) {
    return object.toString().split('.').last;
  }
}
