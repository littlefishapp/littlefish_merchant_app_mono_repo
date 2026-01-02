// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) =>
    User(
        id: json['id'] as String?,
        userId: json['userId'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        email: json['email'] as String?,
        registeredDate: const DateTimeConverter().fromJson(
          json['registeredDate'],
        ),
        mobileNumber: json['mobileNumber'] as String?,
        internationalNumber: json['internationalNumber'] as String?,
        avatar: json['avatar'] as String?,
        company: json['company'] as String?,
        dateOfBirth: const DateTimeConverter().fromJson(json['dateOfBirth']),
        jobTitle: json['jobTitle'] as String?,
        prefix: json['prefix'] as String?,
        suffix: json['suffix'] as String?,
        gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
        countryCode: json['countryCode'] as String?,
        profileImageUri: json['profileImageUri'] as String?,
        accountType: $enumDecodeNullable(
          _$UserAccountTypeEnumMap,
          json['accountType'],
        ),
        userScoreCard: json['userScoreCard'] == null
            ? null
            : UserScoreLevel.fromJson(
                json['userScoreCard'] as Map<String, dynamic>,
              ),
        emailVerified: json['emailVerified'] as bool? ?? false,
        mobileNumberVerified: json['mobileNumberVerified'] as bool? ?? false,
        identityVerified: json['identityVerified'] as bool? ?? false,
        identityNumber: json['identityNumber'] as String?,
      )
      ..username = json['username'] as String?
      ..businessCount = (json['businessCount'] as num?)?.toInt() ?? 0
      ..nickName = json['nickName'] as String?
      ..deleted = json['deleted'] as bool? ?? false
      ..score = (json['score'] as num?)?.toDouble() ?? 0
      ..level = (json['level'] as num?)?.toInt() ?? 1
      ..levelName = json['levelName'] as String?
      ..levelDescription = json['levelDescription'] as String?
      ..gallery =
          (json['gallery'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          []
      ..countryData = json['country_data'] == null
          ? null
          : CountryCode.fromJson(json['country_data'] as Map<String, dynamic>);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'prefix': instance.prefix,
  'suffix': instance.suffix,
  'company': instance.company,
  'jobTitle': instance.jobTitle,
  'username': instance.username,
  'identityNumber': instance.identityNumber,
  'identityVerified': instance.identityVerified,
  'businessCount': instance.businessCount,
  'nickName': instance.nickName,
  'dateOfBirth': const DateTimeConverter().toJson(instance.dateOfBirth),
  'accountType': _$UserAccountTypeEnumMap[instance.accountType],
  'avatar': instance.avatar,
  'registeredDate': const DateTimeConverter().toJson(instance.registeredDate),
  'mobileNumber': instance.mobileNumber,
  'internationalNumber': instance.internationalNumber,
  'email': instance.email,
  'gender': _$GenderEnumMap[instance.gender],
  'countryCode': instance.countryCode,
  'profileImageUri': instance.profileImageUri,
  'emailVerified': instance.emailVerified,
  'mobileNumberVerified': instance.mobileNumberVerified,
  'deleted': instance.deleted,
  'userScoreCard': instance.userScoreCard?.toJson(),
  'score': instance.score,
  'level': instance.level,
  'levelName': instance.levelName,
  'levelDescription': instance.levelDescription,
  'gallery': instance.gallery,
  'country_data': instance.countryData?.toJson(),
};

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
  Gender.notSpecified: 'notSpecified',
};

const _$UserAccountTypeEnumMap = {
  UserAccountType.individual: 'individual',
  UserAccountType.business: 'business',
};

UserLinkedAccount _$UserLinkedAccountFromJson(Map<String, dynamic> json) =>
    UserLinkedAccount(
      accountId: json['accountId'] as String?,
      description: json['description'] as String?,
      featureImageUrl: json['featureImageUrl'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$UserLinkedAccountToJson(UserLinkedAccount instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'featureImageUrl': instance.featureImageUrl,
    };

Billing _$BillingFromJson(Map<String, dynamic> json) => Billing(
  address1: json['address1'] as String?,
  address2: json['address2'] as String?,
  city: json['city'] as String?,
  company: json['company'] as String?,
  country: json['country'] as String?,
  email: json['email'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  phone: json['phone'] as String?,
  postCode: json['postCode'] as String?,
  state: json['state'] as String?,
);

Map<String, dynamic> _$BillingToJson(Billing instance) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'company': instance.company,
  'email': instance.email,
  'phone': instance.phone,
  'address1': instance.address1,
  'address2': instance.address2,
  'city': instance.city,
  'postCode': instance.postCode,
  'country': instance.country,
  'state': instance.state,
};

Shipping _$ShippingFromJson(Map<String, dynamic> json) => Shipping(
  address1: json['address1'] as String?,
  address2: json['address2'] as String?,
  city: json['city'] as String?,
  company: json['company'] as String?,
  country: json['country'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  postCode: json['postCode'] as String?,
  state: json['state'] as String?,
);

Map<String, dynamic> _$ShippingToJson(Shipping instance) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'company': instance.company,
  'address1': instance.address1,
  'address2': instance.address2,
  'city': instance.city,
  'postCode': instance.postCode,
  'country': instance.country,
  'state': instance.state,
};

UserStoreLink _$UserStoreLinkFromJson(Map<String, dynamic> json) =>
    UserStoreLink(
      dateFollowed: const DateTimeConverter().fromJson(json['dateFollowed']),
      storeId: json['storeId'] as String?,
      userId: json['userId'] as String?,
      dateUnfollowed: const DateTimeConverter().fromJson(
        json['dateUnfollowed'],
      ),
      isFollowing: json['isFollowing'] as bool?,
      name: json['name'] as String?,
      storeLogoUrl: json['storeLogoUrl'] as String?,
      businessId: json['businessId'] as String?,
    );

Map<String, dynamic> _$UserStoreLinkToJson(
  UserStoreLink instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'storeId': instance.storeId,
  'businessId': instance.businessId,
  'name': instance.name,
  'storeLogoUrl': instance.storeLogoUrl,
  'dateFollowed': const DateTimeConverter().toJson(instance.dateFollowed),
  'dateUnfollowed': const DateTimeConverter().toJson(instance.dateUnfollowed),
  'isFollowing': instance.isFollowing,
};

UserProductUpdatedView _$UserProductUpdatedViewFromJson(
  Map<String, dynamic> json,
) => UserProductUpdatedView(
  productId: json['productId'] as String?,
  productName: json['productName'] as String?,
  featureImage: json['featureImage'] as String?,
  sellingPrice: (json['sellingPrice'] as num?)?.toDouble(),
  id: json['id'] as String?,
)..dateUpdated = const DateTimeConverter().fromJson(json['dateUpdated']);

Map<String, dynamic> _$UserProductUpdatedViewToJson(
  UserProductUpdatedView instance,
) => <String, dynamic>{
  'id': instance.id,
  'productId': instance.productId,
  'productName': instance.productName,
  'featureImage': instance.featureImage,
  'sellingPrice': instance.sellingPrice,
  'dateUpdated': const DateTimeConverter().toJson(instance.dateUpdated),
};

UserStoreView _$UserStoreViewFromJson(Map<String, dynamic> json) =>
    UserStoreView(
      storeId: json['storeId'] as String?,
      userId: json['userId'] as String?,
      dateViewed: const DateTimeConverter().fromJson(json['dateViewed']),
      userName: json['userName'] as String?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$UserStoreViewToJson(UserStoreView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'storeId': instance.storeId,
      'dateViewed': const DateTimeConverter().toJson(instance.dateViewed),
    };

UserLocation _$UserLocationFromJson(Map<String, dynamic> json) =>
    UserLocation(
        addressLine1: json['addressLine1'] as String?,
        addressLine2: json['addressLine2'] as String?,
        city: json['city'] as String?,
        country: json['country'] as String?,
        enabled: json['enabled'] as bool?,
        friendlyName: json['friendlyName'] as String?,
        location: json['location'] == null
            ? null
            : StoreLocation.fromJson(json['location'] as Map<String, dynamic>),
        locationId: json['locationId'] as String?,
        postalCode: json['postalCode'] as String?,
        state: json['state'] as String?,
        isPrimary: json['isPrimary'] as bool?,
      )
      ..id = json['id'] as String?
      ..placeId = json['placeId'] as String?
      ..userId = json['userId'] as String?
      ..mapUrl = json['mapUrl'] as String?;

Map<String, dynamic> _$UserLocationToJson(UserLocation instance) =>
    <String, dynamic>{
      'friendlyName': instance.friendlyName,
      'enabled': instance.enabled,
      'isPrimary': instance.isPrimary,
      'id': instance.id,
      'placeId': instance.placeId,
      'userId': instance.userId,
      'locationId': instance.locationId,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'country': instance.country,
      'state': instance.state,
      'postalCode': instance.postalCode,
      'city': instance.city,
      'location': instance.location?.toJson(),
      'mapUrl': instance.mapUrl,
    };

UserNotificationToken _$UserNotificationTokenFromJson(
  Map<String, dynamic> json,
) => UserNotificationToken(
  appBuildNumber: json['appBuildNumber'] as String?,
  appName: json['appName'] as String?,
  appVersionNumber: json['appVersionNumber'] as String?,
  deviceInfo: json['deviceInfo'] == null
      ? null
      : UserDevice.fromJson(json['deviceInfo'] as Map<String, dynamic>),
  packageName: json['packageName'] as String?,
  token: json['token'] as String?,
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$UserNotificationTokenToJson(
  UserNotificationToken instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'token': instance.token,
  'deviceInfo': instance.deviceInfo?.toJson(),
  'packageName': instance.packageName,
  'appName': instance.appName,
  'appBuildNumber': instance.appBuildNumber,
  'appVersionNumber': instance.appVersionNumber,
};

UserDevice _$UserDeviceFromJson(Map<String, dynamic> json) => UserDevice(
  userId: json['userId'] as String?,
  brand: json['brand'] as String?,
  device: json['device'] as String?,
  fingerprint: json['fingerprint'] as String?,
  host: json['host'] as String?,
  accessDate: const DateTimeConverter().fromJson(json['accessDate']),
  deviceId: json['deviceId'] as String?,
  display: json['display'] as String?,
  isPhysicalDevice: json['isPhysicalDevice'] as bool?,
  manufacturer: json['manufacturer'] as String?,
  product: json['product'] as String?,
  platform: json['platform'] as String?,
  systemVersion: json['systemVersion'] as String?,
);

Map<String, dynamic> _$UserDeviceToJson(UserDevice instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'brand': instance.brand,
      'device': instance.device,
      'display': instance.display,
      'fingerprint': instance.fingerprint,
      'host': instance.host,
      'manufacturer': instance.manufacturer,
      'product': instance.product,
      'deviceId': instance.deviceId,
      'platform': instance.platform,
      'systemVersion': instance.systemVersion,
      'isPhysicalDevice': instance.isPhysicalDevice,
      'accessDate': const DateTimeConverter().toJson(instance.accessDate),
    };

UserWishListProduct _$UserWishListProductFromJson(Map<String, dynamic> json) =>
    UserWishListProduct(
      productId: json['productId'] as String?,
      userId: json['userId'] as String?,
      businessId: json['businessId'] as String?,
      dateAdded: const IsoDateTimeConverter().fromJson(json['dateAdded']),
      notes: json['notes'] as String?,
      productName: json['productName'] as String?,
      userName: json['userName'] as String?,
      featureImageUrl: json['featureImageUrl'] as String?,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UserWishListProductToJson(
  UserWishListProduct instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'productName': instance.productName,
  'businessId': instance.businessId,
  'featureImageUrl': instance.featureImageUrl,
  'userId': instance.userId,
  'userName': instance.userName,
  'dateAdded': const IsoDateTimeConverter().toJson(instance.dateAdded),
  'sellingPrice': instance.sellingPrice,
  'notes': instance.notes,
};

ShippingMethod _$ShippingMethodFromJson(Map<String, dynamic> json) =>
    ShippingMethod(
      classCost: json['classCost'] as String?,
      cost: (json['cost'] as num?)?.toDouble(),
      description: json['description'] as String?,
      id: json['id'] as String?,
      methodId: json['methodId'] as String?,
      methodTitle: json['methodTitle'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$ShippingMethodToJson(ShippingMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'cost': instance.cost,
      'classCost': instance.classCost,
      'methodId': instance.methodId,
      'methodTitle': instance.methodTitle,
    };

UserPointEvent _$UserPointEventFromJson(Map<String, dynamic> json) =>
    UserPointEvent(
      eventDate: const DateTimeConverter().fromJson(json['eventDate']),
      description: json['description'] as String?,
      id: json['id'] as String?,
      points: (json['points'] as num?)?.toDouble(),
      userId: json['userId'] as String?,
      eventType: json['eventType'] as String?,
    );

Map<String, dynamic> _$UserPointEventToJson(UserPointEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventType': instance.eventType,
      'userId': instance.userId,
      'eventDate': const DateTimeConverter().toJson(instance.eventDate),
      'description': instance.description,
      'points': instance.points,
    };

UserGoal _$UserGoalFromJson(Map<String, dynamic> json) => UserGoal(
  description: json['description'] as String?,
  id: json['id'] as String?,
  currentCount: (json['currentCount'] as num?)?.toDouble(),
  dateCreated: const DateTimeConverter().fromJson(json['dateCreated']),
  eventId: json['eventId'] as String?,
  eventQty: (json['eventQty'] as num?)?.toDouble(),
  goalId: json['goalId'] as String?,
  name: json['name'] as String?,
  claimed: json['claimed'] as bool? ?? false,
);

Map<String, dynamic> _$UserGoalToJson(UserGoal instance) => <String, dynamic>{
  'id': instance.id,
  'goalId': instance.goalId,
  'dateCreated': const DateTimeConverter().toJson(instance.dateCreated),
  'name': instance.name,
  'description': instance.description,
  'eventId': instance.eventId,
  'eventQty': instance.eventQty,
  'currentCount': instance.currentCount,
  'claimed': instance.claimed,
};

UserNotificationTopic _$UserNotificationTopicFromJson(
  Map<String, dynamic> json,
) => UserNotificationTopic(
  allowed: json['allowed'] as bool?,
  description: json['description'] as String?,
  topic: json['topic'] as String?,
  topicId: json['topicId'] as String?,
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$UserNotificationTopicToJson(
  UserNotificationTopic instance,
) => <String, dynamic>{
  'topic': instance.topic,
  'topicId': instance.topicId,
  'userId': instance.userId,
  'description': instance.description,
  'allowed': instance.allowed,
};

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      followedStores:
          (json['followedStores'] as List<dynamic>?)
              ?.map((e) => UserStoreLink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentlyViewedProducts:
          (json['recentlyViewedProducts'] as List<dynamic>?)
              ?.map((e) => StoreProduct.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentlyViewedStores:
          (json['recentlyViewedStores'] as List<dynamic>?)
              ?.map((e) => UserStoreView.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userId: json['userId'] as String?,
      userLanguage: json['userLanguage'] as String? ?? 'en',
      userTheme: json['userTheme'] as String? ?? 'light',
      wishlist:
          (json['wishlist'] as List<dynamic>?)
              ?.map(
                (e) => UserWishListProduct.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$UserPreferencesToJson(
  UserPreferences instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'userTheme': instance.userTheme,
  'userLanguage': instance.userLanguage,
  'wishlist': instance.wishlist?.map((e) => e.toJson()).toList(),
  'recentlyViewedProducts': instance.recentlyViewedProducts
      ?.map((e) => e.toJson())
      .toList(),
  'recentlyViewedStores': instance.recentlyViewedStores
      ?.map((e) => e.toJson())
      .toList(),
  'followedStores': instance.followedStores?.map((e) => e.toJson()).toList(),
};

UserThirdPartyAccount _$UserThirdPartyAccountFromJson(
  Map<String, dynamic> json,
) => UserThirdPartyAccount(
  id: json['id'] as String?,
  name: json['name'] as String?,
  displayName: json['displayName'] as String?,
  deleted: json['deleted'] as bool?,
  config: json['config'],
  accountType: _$JsonConverterFromJson<String, UserThirdPartyAccountType>(
    json['accountType'],
    const UserThirdPartyAccountTypeConverter().fromJson,
  ),
  userId: json['userId'] as String?,
  logoUrl: json['logoUrl'] as String?,
);

Map<String, dynamic> _$UserThirdPartyAccountToJson(
  UserThirdPartyAccount instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'displayName': instance.displayName,
  'logoUrl': instance.logoUrl,
  'userId': instance.userId,
  'deleted': instance.deleted,
  'config': instance.config,
  'accountType': _$JsonConverterToJson<String, UserThirdPartyAccountType>(
    instance.accountType,
    const UserThirdPartyAccountTypeConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
