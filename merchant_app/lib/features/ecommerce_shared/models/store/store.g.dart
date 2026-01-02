// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) =>
    Store(
        id: json['id'] as String?,
        averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
        banners:
            (json['banners'] as List<dynamic>?)
                ?.map((e) => StoreBanner.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        businessId: json['businessId'] as String?,
        coverImageUrl: json['coverImageUrl'] as String?,
        createdBy: json['createdBy'] as String?,
        dateCreated: const EpochDateTimeConverter().fromJson(
          json['dateCreated'],
        ),
        deliverySettings: json['delivery_settings'] == null
            ? null
            : DeliverySettings.fromJson(
                json['delivery_settings'] as Map<String, dynamic>,
              ),
        description: json['description'] as String?,
        displayName: json['displayName'] as String?,
        slogan: json['slogan'] as String?,
        hasDeals: json['hasDeals'] as bool? ?? false,
        isFeatured: json['isFeatured'] as bool? ?? false,
        isPublic: json['isPublic'] as bool? ?? false,
        isOnline: json['isOnline'] as bool? ?? false,
        marketPlaceEnabled: json['marketPlaceEnabled'] as bool? ?? false,
        logoUrl: json['logoUrl'] as String?,
        bannerUrl: json['bannerUrl'] as String?,
        aboutImageUrl: json['aboutImageUrl'] as String?,
        name: json['name'] as String?,
        primaryAddress: json['primary_address'] == null
            ? null
            : StoreAddress.fromJson(
                json['primary_address'] as Map<String, dynamic>,
              ),
        searchName: json['searchName'] as String?,
        storeUrl: json['storeUrl'] as String?,
        totalRatings: (json['totalRatings'] as num?)?.toInt() ?? 0,
        tradingHours:
            (json['tradingHours'] as List<dynamic>?)
                ?.map((e) => TradingDay.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        collectionSettings: json['collection_settings'] == null
            ? null
            : CollectionSettings.fromJson(
                json['collection_settings'] as Map<String, dynamic>,
              ),
        isConfigured: json['isConfigured'] as bool? ?? false,
        contactInformation: json['contactInformation'] == null
            ? null
            : ContactInformation.fromJson(
                json['contactInformation'] as Map<String, dynamic>,
              ),
        totalCategories: (json['totalCategories'] as num?)?.toInt() ?? 0,
        countryData: json['country_data'] == null
            ? null
            : CountryCode.fromJson(
                json['country_data'] as Map<String, dynamic>,
              ),
        coverImageAddress: json['coverImageAddress'] as String?,
        totalCustomers: (json['totalCustomers'] as num?)?.toInt() ?? 0,
        logoAddress: json['logoAddress'] as String?,
        bannerAddress: json['bannerAddress'] as String?,
        aboutImageAddress: json['aboutImageAddress'] as String?,
        totalProducts: (json['totalProducts'] as num?)?.toInt() ?? 0,
        storePreferences: json['store_preferences'] == null
            ? null
            : StorePreferences.fromJson(
                json['store_preferences'] as Map<String, dynamic>,
              ),
        productsOnSaleCount:
            (json['productsOnSaleCount'] as num?)?.toInt() ?? 0,
        totalFeaturedProducts:
            (json['totalFeaturedProducts'] as num?)?.toInt() ?? 0,
        totalStoreProductTypes:
            (json['totalStoreProductTypes'] as num?)?.toInt() ?? 0,
        totalStoreAttributes:
            (json['totalStoreAttributes'] as num?)?.toInt() ?? 0,
        deleted: json['deleted'] as bool? ?? false,
        onlineStoreType: _$JsonConverterFromJson<String, OnlineStoreType?>(
          json['onlineStoreType'],
          const OnlineStoreTypeConverter().fromJson,
        ),
        storeSubtypeId: json['storeSubtypeId'] as String?,
        storeTypeId: json['storeTypeId'] as String?,
        storeId: json['storeId'] as String?,
        uniqueSubdomain: json['uniqueSubdomain'] as String?,
        shortenCatalogueUrl: json['shortenCatalogueUrl'] as String?,
        isDomainLive: json['isDomainLive'] as bool?,
      )
      ..uniqueBusinessName = json['uniqueBusinessName'] as String?
      ..totalOrders = (json['totalOrders'] as num?)?.toInt() ?? 0
      ..activeOrders = (json['activeOrders'] as num?)?.toInt() ?? 0
      ..totalFollowers = (json['totalFollowers'] as num?)?.toInt() ?? 0
      ..totalFlyers = (json['totalFlyers'] as num?)?.toInt() ?? 0
      ..totalViews = (json['totalViews'] as num?)?.toInt() ?? 0
      ..totalCoupons = (json['totalCoupons'] as num?)?.toInt() ?? 0
      ..orderStatusCounts = (json['orderStatusCounts'] as Map<String, dynamic>?)
          ?.map((k, e) => MapEntry(k, (e as num).toInt()));

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
  'id': instance.id,
  'businessId': instance.businessId,
  'storeId': instance.storeId,
  'onlineStoreType': const OnlineStoreTypeConverter().toJson(
    instance.onlineStoreType,
  ),
  'isDomainLive': instance.isDomainLive,
  'name': instance.name,
  'displayName': instance.displayName,
  'slogan': instance.slogan,
  'searchName': instance.searchName,
  'description': instance.description,
  'storeSubtypeId': instance.storeSubtypeId,
  'storeTypeId': instance.storeTypeId,
  'shortenCatalogueUrl': instance.shortenCatalogueUrl,
  'logoUrl': instance.logoUrl,
  'bannerUrl': instance.bannerUrl,
  'aboutImageUrl': instance.aboutImageUrl,
  'logoAddress': instance.logoAddress,
  'bannerAddress': instance.bannerAddress,
  'aboutImageAddress': instance.aboutImageAddress,
  'coverImageUrl': instance.coverImageUrl,
  'coverImageAddress': instance.coverImageAddress,
  'contactInformation': instance.contactInformation?.toJson(),
  'storeUrl': instance.storeUrl,
  'banners': instance.banners?.map((e) => e.toJson()).toList(),
  'averageRating': instance.averageRating,
  'totalRatings': instance.totalRatings,
  'createdBy': instance.createdBy,
  'uniqueBusinessName': instance.uniqueBusinessName,
  'uniqueSubdomain': instance.uniqueSubdomain,
  'dateCreated': const EpochDateTimeConverter().toJson(instance.dateCreated),
  'deleted': instance.deleted,
  'isFeatured': instance.isFeatured,
  'isPublic': instance.isPublic,
  'isOnline': instance.isOnline,
  'marketPlaceEnabled': instance.marketPlaceEnabled,
  'hasDeals': instance.hasDeals,
  'isConfigured': instance.isConfigured,
  'primary_address': instance.primaryAddress?.toJson(),
  'totalProducts': instance.totalProducts,
  'totalStoreProductTypes': instance.totalStoreProductTypes,
  'totalCategories': instance.totalCategories,
  'totalCustomers': instance.totalCustomers,
  'totalStoreAttributes': instance.totalStoreAttributes,
  'totalOrders': instance.totalOrders,
  'activeOrders': instance.activeOrders,
  'totalFollowers': instance.totalFollowers,
  'totalFlyers': instance.totalFlyers,
  'totalViews': instance.totalViews,
  'productsOnSaleCount': instance.productsOnSaleCount,
  'totalFeaturedProducts': instance.totalFeaturedProducts,
  'totalCoupons': instance.totalCoupons,
  'tradingHours': instance.tradingHours?.map((e) => e.toJson()).toList(),
  'delivery_settings': instance.deliverySettings?.toJson(),
  'collection_settings': instance.collectionSettings?.toJson(),
  'store_preferences': instance.storePreferences?.toJson(),
  'country_data': instance.countryData?.toJson(),
  'orderStatusCounts': instance.orderStatusCounts,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

StoreCategoryOptions _$StoreCategoryOptionsFromJson(
  Map<String, dynamic> json,
) => StoreCategoryOptions(
  alcohol: json['alcohol'] as bool? ?? false,
  artsAndCrafts: json['arts_and_crafts'] as bool? ?? false,
  babyAndChildren: json['baby_products'] as bool? ?? false,
  butchersMarket: json['butchers_market'] as bool? ?? false,
  childrenToys: json['children_toys'] as bool? ?? false,
  cleaningAndSanitization: json['cleaning_and_sanitation'] as bool? ?? false,
  cleaningProducts: json['cleaning_products'] as bool? ?? false,
  fashionAndClothing: json['fashion_and_clothing'] as bool? ?? false,
  freshProduce: json['fresh_produce'] as bool? ?? false,
  electronics: json['electronics'] as bool? ?? false,
  gardenAndOutdoor: json['garden_and_outdoor'] as bool? ?? false,
  hardwareAndDIY: json['hardware_and_diy'] as bool? ?? false,
  groceries: json['groceries'] as bool? ?? false,
  other: json['other'] as bool? ?? false,
);

Map<String, dynamic> _$StoreCategoryOptionsToJson(
  StoreCategoryOptions instance,
) => <String, dynamic>{
  'alcohol': instance.alcohol,
  'arts_and_crafts': instance.artsAndCrafts,
  'baby_products': instance.babyAndChildren,
  'butchers_market': instance.butchersMarket,
  'children_toys': instance.childrenToys,
  'cleaning_and_sanitation': instance.cleaningAndSanitization,
  'cleaning_products': instance.cleaningProducts,
  'fashion_and_clothing': instance.fashionAndClothing,
  'fresh_produce': instance.freshProduce,
  'hardware_and_diy': instance.hardwareAndDIY,
  'garden_and_outdoor': instance.gardenAndOutdoor,
  'electronics': instance.electronics,
  'groceries': instance.groceries,
  'other': instance.other,
};

TradingDay _$TradingDayFromJson(Map<String, dynamic> json) => TradingDay(
  closingTime: const EpochDateTimeConverter().fromJson(json['closingTime']),
  dow: (json['dow'] as num?)?.toInt() ?? 1,
  openingTime: const EpochDateTimeConverter().fromJson(json['openingTime']),
  isOpen: json['isOpen'] as bool? ?? false,
  is24Hours: json['is24Hours'] as bool? ?? false,
);

Map<String, dynamic> _$TradingDayToJson(
  TradingDay instance,
) => <String, dynamic>{
  'isOpen': instance.isOpen,
  'is24Hours': instance.is24Hours,
  'dow': instance.dow,
  'openingTime': const EpochDateTimeConverter().toJson(instance.openingTime),
  'closingTime': const EpochDateTimeConverter().toJson(instance.closingTime),
};

StoreAddress _$StoreAddressFromJson(Map<String, dynamic> json) => StoreAddress(
  friendlyName: json['friendlyName'] as String?,
  addressLine1: json['addressLine1'] as String?,
  addressLine2: json['addressLine2'] as String?,
  city: json['city'] as String?,
  country: json['country'] as String?,
  enabled: json['enabled'] as bool?,
  location: json['location'] == null
      ? null
      : StoreLocation.fromJson(json['location'] as Map<String, dynamic>),
  locationId: json['locationId'] as String?,
  state: json['state'] as String?,
  postalCode: json['postalCode'] as String?,
  placeId: json['placeId'] as String?,
  id: json['id'] as String?,
  isPrimary: json['isPrimary'] as bool?,
);

Map<String, dynamic> _$StoreAddressToJson(StoreAddress instance) =>
    <String, dynamic>{
      'isPrimary': instance.isPrimary,
      'friendlyName': instance.friendlyName,
      'id': instance.id,
      'enabled': instance.enabled,
      'locationId': instance.locationId,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'country': instance.country,
      'state': instance.state,
      'postalCode': instance.postalCode,
      'city': instance.city,
      'location': instance.location?.toJson(),
      'placeId': instance.placeId,
    };

StoreCategory _$StoreCategoryFromJson(Map<String, dynamic> json) =>
    StoreCategory(
      displayName: json['displayName'] as String?,
      slogan: json['slogan'] as String?,
      enabled: json['enabled'] as bool?,
      featureImageUrl: json['featureImageUrl'] as String?,
      name: json['name'] as String?,
      searchName: json['searchName'] as String?,
      description: json['description'] as String?,
      storeCount: (json['storeCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StoreCategoryToJson(StoreCategory instance) =>
    <String, dynamic>{
      'name': instance.name,
      'displayName': instance.displayName,
      'slogan': instance.slogan,
      'description': instance.description,
      'searchName': instance.searchName,
      'featureImageUrl': instance.featureImageUrl,
      'enabled': instance.enabled,
      'storeCount': instance.storeCount,
    };

DeliverySettings _$DeliverySettingsFromJson(Map<String, dynamic> json) =>
    DeliverySettings(
        enabled: json['enabled'] as bool? ?? false,
        deliveryRadius: (json['deliveryRadius'] as num?)?.toInt() ?? 10,
        estimatedDelivery: const TimeOfDayConverter().fromJson(
          json['estimatedDelivery'] as String?,
        ),
        sameDay: json['sameDay'] as bool? ?? false,
        minimumOrderValue: json['minimumOrderValue'] == null
            ? 10
            : const FlexibleDoubleConverter().fromJson(
                json['minimumOrderValue'],
              ),
        deliveryAddress: json['deliveryAddress'] as String?,
        useBusinessAddress: json['useBusinessAddress'] as bool? ?? false,
        deliveryInstructions: json['deliveryInstructions'] as String?,
      )
      ..sameDayCutoffTime = const TimeOfDayConverter().fromJson(
        json['sameDayCutoffTime'] as String?,
      );

Map<String, dynamic> _$DeliverySettingsToJson(DeliverySettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'sameDay': instance.sameDay,
      'useBusinessAddress': instance.useBusinessAddress,
      'deliveryRadius': instance.deliveryRadius,
      'minimumOrderValue': const FlexibleDoubleConverter().toJson(
        instance.minimumOrderValue,
      ),
      'deliveryInstructions': instance.deliveryInstructions,
      'deliveryAddress': instance.deliveryAddress,
      'sameDayCutoffTime': const TimeOfDayConverter().toJson(
        instance.sameDayCutoffTime,
      ),
      'estimatedDelivery': const TimeOfDayConverter().toJson(
        instance.estimatedDelivery,
      ),
    };

CollectionSettings _$CollectionSettingsFromJson(Map<String, dynamic> json) =>
    CollectionSettings(
      pickupTime: const TimeOfDayConverter().fromJson(
        json['pickupTime'] as String?,
      ),
      enabled: json['enabled'] as bool? ?? false,
      useBusinessAddress: json['useBusinessAddress'] as bool? ?? false,
      collectionInstructions: json['collectionInstructions'] as String?,
    )..collectionAddress = json['collectionAddress'] as String?;

Map<String, dynamic> _$CollectionSettingsToJson(CollectionSettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'useBusinessAddress': instance.useBusinessAddress,
      'collectionAddress': instance.collectionAddress,
      'collectionInstructions': instance.collectionInstructions,
      'pickupTime': const TimeOfDayConverter().toJson(instance.pickupTime),
    };

OnlineFee _$OnlineFeeFromJson(Map<String, dynamic> json) => OnlineFee(
  amount: (json['amount'] as num?)?.toDouble(),
  enabled: json['enabled'] as bool? ?? false,
  isFixedAmount: json['isFixedAmount'] as bool? ?? true,
  isVariableAmount: json['isVariableAmount'] as bool? ?? false,
);

Map<String, dynamic> _$OnlineFeeToJson(OnlineFee instance) => <String, dynamic>{
  'enabled': instance.enabled,
  'amount': instance.amount,
  'isFixedAmount': instance.isFixedAmount,
  'isVariableAmount': instance.isVariableAmount,
};

FreeDelivery _$FreeDeliveryFromJson(Map<String, dynamic> json) => FreeDelivery(
  amount: (json['amount'] as num?)?.toDouble(),
  enabled: json['enabled'] as bool? ?? false,
);

Map<String, dynamic> _$FreeDeliveryToJson(FreeDelivery instance) =>
    <String, dynamic>{'enabled': instance.enabled, 'amount': instance.amount};

ContactInformation _$ContactInformationFromJson(Map<String, dynamic> json) =>
    ContactInformation(
      email: json['email'] as String?,
      facebook: json['facebook'] as String?,
      instagram: json['instagram'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      telephoneNumber: json['telephoneNumber'] as String?,
      twitter: json['twitter'] as String?,
      website: json['website'] as String?,
      whatsapp: json['whatsapp'] as String?,
    );

Map<String, dynamic> _$ContactInformationToJson(ContactInformation instance) =>
    <String, dynamic>{
      'email': instance.email,
      'facebook': instance.facebook,
      'instagram': instance.instagram,
      'mobileNumber': instance.mobileNumber,
      'telephoneNumber': instance.telephoneNumber,
      'twitter': instance.twitter,
      'website': instance.website,
      'whatsapp': instance.whatsapp,
    };

LinkedAccount _$LinkedAccountFromJson(Map<String, dynamic> json) =>
    LinkedAccount(
      config: json['config'] as String?,
      deleted: json['deleted'] as bool?,
      createdBy: json['createdBy'] as String?,
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
      updatedBy: json['updatedBy'] as String?,
      dateUpdated: json['dateUpdated'] == null
          ? null
          : DateTime.parse(json['dateUpdated'] as String),
      providerName: json['providerName'] as String?,
      id: json['id'] as String?,
      enabled: json['enabled'] as bool?,
      providerType: _$JsonConverterFromJson<int, ProviderType>(
        json['providerType'],
        const ProviderTypeConverter().fromJson,
      ),
      imageURI: json['imageURI'] as String?,
      hasQRCode: json['hasQRCode'] as bool?,
      isQRCodeEnabled: json['isQRCodeEnabled'] as bool?,
      linkedAccountType: _$JsonConverterFromJson<int, LinkedAccountType>(
        json['linkedAccountType'],
        const LinkedAccountTypeConverter().fromJson,
      ),
    );

Map<String, dynamic> _$LinkedAccountToJson(LinkedAccount instance) =>
    <String, dynamic>{
      'providerType': _$JsonConverterToJson<int, ProviderType>(
        instance.providerType,
        const ProviderTypeConverter().toJson,
      ),
      'providerName': instance.providerName,
      'id': instance.id,
      'imageURI': instance.imageURI,
      'hasQRCode': instance.hasQRCode,
      'isQRCodeEnabled': instance.isQRCodeEnabled,
      'config': instance.config,
      'linkedAccountType': _$JsonConverterToJson<int, LinkedAccountType>(
        instance.linkedAccountType,
        const LinkedAccountTypeConverter().toJson,
      ),
      'enabled': instance.enabled,
      'deleted': instance.deleted,
      'dateUpdated': instance.dateUpdated?.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'dateCreated': instance.dateCreated?.toIso8601String(),
      'createdBy': instance.createdBy,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

StoreCoupon _$StoreCouponFromJson(Map<String, dynamic> json) =>
    StoreCoupon(
        allocationCount: (json['allocationCount'] as num?)?.toDouble(),
        businessId: json['businessId'] as String?,
        deleted: json['deleted'] as bool? ?? false,
        expiryDate: const DateTimeConverter().fromJson(json['expiryDate']),
        id: json['id'] as String?,
        limit: (json['limit'] as num?)?.toDouble(),
        quantity: (json['quantity'] as num?)?.toDouble(),
        startDate: const DateTimeConverter().fromJson(json['startDate']),
        type: json['type'] as String?,
        value: (json['value'] as num?)?.toDouble(),
        featureImageAddress: json['featureImageAddress'] as String?,
        storeLogoImageAddress: json['storeLogoImageAddress'] as String?,
        level: (json['level'] as num?)?.toInt() ?? -1,
        restrictToLevel: json['restrictToLevel'] as bool? ?? false,
        minimumSpend: (json['minimumSpend'] as num?)?.toDouble() ?? 0.0,
        desription: json['desription'] as String?,
        displayName: json['displayName'] as String?,
        slogan: json['slogan'] as String?,
        name: json['name'] as String?,
      )
      ..featureImageUrl = json['featureImageUrl'] as String?
      ..storeLogoUrl = json['storeLogoUrl'] as String?
      ..storeBannerUrl = json['storeBannerUrl'] as String?
      ..storeAboutImageUrl = json['storeAboutImageUrl'] as String?;

Map<String, dynamic> _$StoreCouponToJson(StoreCoupon instance) =>
    <String, dynamic>{
      'name': instance.name,
      'displayName': instance.displayName,
      'slogan': instance.slogan,
      'desription': instance.desription,
      'deleted': instance.deleted,
      'id': instance.id,
      'businessId': instance.businessId,
      'quantity': instance.quantity,
      'startDate': const DateTimeConverter().toJson(instance.startDate),
      'expiryDate': const DateTimeConverter().toJson(instance.expiryDate),
      'restrictToLevel': instance.restrictToLevel,
      'level': instance.level,
      'type': instance.type,
      'limit': instance.limit,
      'allocationCount': instance.allocationCount,
      'value': instance.value,
      'featureImageUrl': instance.featureImageUrl,
      'featureImageAddress': instance.featureImageAddress,
      'storeLogoUrl': instance.storeLogoUrl,
      'storeBannerUrl': instance.storeBannerUrl,
      'storeAboutImageUrl': instance.storeAboutImageUrl,
      'storeLogoImageAddress': instance.storeLogoImageAddress,
      'minimumSpend': instance.minimumSpend,
    };

AllocatedCoupon _$AllocatedCouponFromJson(Map<String, dynamic> json) =>
    AllocatedCoupon(
      businessId: json['businessId'] as String?,
      couponId: json['couponId'] as String?,
      userId: json['userId'] as String?,
      dateAllocated: const DateTimeConverter().fromJson(json['dateAllocated']),
      expiryDate: const DateTimeConverter().fromJson(json['expiryDate']),
      id: json['id'] as String?,
      redeemed: json['redeemed'] as bool?,
      value: (json['value'] as num?)?.toDouble(),
      revoked: json['revoked'] as bool?,
      userName: json['userName'] as String?,
      type: json['type'] as String?,
      minimumSpend: (json['minimumSpend'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$AllocatedCouponToJson(AllocatedCoupon instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'userId': instance.userId,
      'userName': instance.userName,
      'businessId': instance.businessId,
      'couponId': instance.couponId,
      'redeemed': instance.redeemed,
      'revoked': instance.revoked,
      'value': instance.value,
      'expiryDate': const DateTimeConverter().toJson(instance.expiryDate),
      'dateAllocated': const DateTimeConverter().toJson(instance.dateAllocated),
      'minimumSpend': instance.minimumSpend,
    };

StoreReferral _$StoreReferralFromJson(Map<String, dynamic> json) =>
    StoreReferral(
      dateReffered: const DateTimeConverter().fromJson(json['dateReffered']),
      email: json['email'] as String?,
      id: json['id'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      refferedBy: json['refferedBy'] as String?,
      storeName: json['storeName'] as String?,
      contactName: json['contactName'] as String?,
    );

Map<String, dynamic> _$StoreReferralToJson(StoreReferral instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeName': instance.storeName,
      'contactName': instance.contactName,
      'mobileNumber': instance.mobileNumber,
      'email': instance.email,
      'dateReffered': const DateTimeConverter().toJson(instance.dateReffered),
      'refferedBy': instance.refferedBy,
    };

StoreTrendData _$StoreTrendDataFromJson(Map<String, dynamic> json) =>
    StoreTrendData(
      growthTrend: (json['growthTrend'] as num?)?.toInt() ?? 0,
      lostFollowers: (json['lostFollowers'] as num?)?.toInt() ?? 0,
      newFollowers: (json['newFollowers'] as num?)?.toInt() ?? 0,
      storeId: json['storeId'] as String?,
      trendDate: const DateTimeConverter().fromJson(json['trendDate']),
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$StoreTrendDataToJson(StoreTrendData instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'trendDate': const DateTimeConverter().toJson(instance.trendDate),
      'newFollowers': instance.newFollowers,
      'lostFollowers': instance.lostFollowers,
      'growthTrend': instance.growthTrend,
      'viewCount': instance.viewCount,
    };

StoreSalesData _$StoreSalesDataFromJson(Map<String, dynamic> json) =>
    StoreSalesData(
      storeId: json['storeId'] as String?,
      trendDate: const DateTimeConverter().fromJson(json['trendDate']),
      cancelledOrders: (json['cancelledOrders'] as num?)?.toInt() ?? 0,
      completedOrders: (json['completedOrders'] as num?)?.toInt() ?? 0,
      newOrders: (json['newOrders'] as num?)?.toInt() ?? 0,
      totalProductsSold: (json['totalProductsSold'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StoreSalesDataToJson(StoreSalesData instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'trendDate': const DateTimeConverter().toJson(instance.trendDate),
      'newOrders': instance.newOrders,
      'cancelledOrders': instance.cancelledOrders,
      'completedOrders': instance.completedOrders,
      'totalProductsSold': instance.totalProductsSold,
    };

StoreGoal _$StoreGoalFromJson(Map<String, dynamic> json) => StoreGoal(
  autoExtend: json['autoExtend'] as bool? ?? true,
  currentQty: (json['currentQty'] as num?)?.toInt() ?? 0,
  description: json['description'] as String?,
  displayName: json['displayName'] as String?,
  slogan: json['slogan'] as String?,
  extensionQty: (json['extensionQty'] as num?)?.toInt() ?? 5,
  name: json['name'] as String?,
  target: (json['target'] as num?)?.toInt() ?? 1,
  type:
      $enumDecodeNullable(_$StoreGoalTypeEnumMap, json['type']) ??
      StoreGoalType.products,
);

Map<String, dynamic> _$StoreGoalToJson(StoreGoal instance) => <String, dynamic>{
  'name': instance.name,
  'displayName': instance.displayName,
  'slogan': instance.slogan,
  'description': instance.description,
  'type': _$StoreGoalTypeEnumMap[instance.type],
  'target': instance.target,
  'currentQty': instance.currentQty,
  'autoExtend': instance.autoExtend,
  'extensionQty': instance.extensionQty,
};

const _$StoreGoalTypeEnumMap = {
  StoreGoalType.products: 'products',
  StoreGoalType.sales: 'sales',
  StoreGoalType.customers: 'customers',
  StoreGoalType.promotions: 'promotions',
  StoreGoalType.coupons: 'coupons',
  StoreGoalType.flyers: 'flyers',
  StoreGoalType.onSaleProducts: 'onSaleProducts',
  StoreGoalType.featuredProducts: 'featuredProducts',
  StoreGoalType.featuredStore: 'featuredStore',
};

FeaturedStore _$FeaturedStoreFromJson(Map<String, dynamic> json) =>
    FeaturedStore(
      startDate: const EpochDateTimeConverter().fromJson(json['startDate']),
      endDate: const EpochDateTimeConverter().fromJson(json['endDate']),
      enabled: json['enabled'] as bool? ?? true,
      storeId: json['storeId'] as String?,
      displayName: json['displayName'] as String?,
      slogan: json['slogan'] as String?,
      description: json['description'] as String?,
      categoryOptions: json['categoryOptions'] == null
          ? null
          : StoreCategoryOptions.fromJson(
              json['categoryOptions'] as Map<String, dynamic>,
            ),
      totalCategories: (json['totalCategories'] as num?)?.toInt() ?? 0,
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
      totalProducts: (json['totalProducts'] as num?)?.toInt() ?? 0,
      primaryAddress: json['primaryAddress'] == null
          ? null
          : StoreAddress.fromJson(
              json['primaryAddress'] as Map<String, dynamic>,
            ),
      logoAddress: json['logoAddress'] as String?,
      bannerAddress: json['bannerAddress'] as String?,
      aboutImageAddress: json['aboutImageAddress'] as String?,
      logoUrl: json['logoUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      aboutImageUrl: json['aboutImageUrl'] as String?,
      coverAddress: json['coverAddress'] as String?,
      coverUrl: json['coverUrl'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FeaturedStoreToJson(FeaturedStore instance) =>
    <String, dynamic>{
      'startDate': const EpochDateTimeConverter().toJson(instance.startDate),
      'endDate': const EpochDateTimeConverter().toJson(instance.endDate),
      'duration': instance.duration,
      'enabled': instance.enabled,
      'storeId': instance.storeId,
      'displayName': instance.displayName,
      'description': instance.description,
      'slogan': instance.slogan,
      'categoryOptions': instance.categoryOptions?.toJson(),
      'primaryAddress': instance.primaryAddress?.toJson(),
      'logoUrl': instance.logoUrl,
      'logoAddress': instance.logoAddress,
      'bannerUrl': instance.bannerUrl,
      'bannerAddress': instance.bannerAddress,
      'aboutImageUrl': instance.aboutImageUrl,
      'aboutImageAddress': instance.aboutImageAddress,
      'coverUrl': instance.coverUrl,
      'coverAddress': instance.coverAddress,
      'totalProducts': instance.totalProducts,
      'totalOrders': instance.totalOrders,
      'totalCategories': instance.totalCategories,
    };
