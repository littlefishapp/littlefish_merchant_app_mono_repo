import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:littlefish_core/auth/models/auth_user.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
// import 'package:google_geocoding_plus/google_geocoding_plus.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:localstorage/localstorage.dart';
import 'package:quiver/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../../tools/converters/iso_date_time_converter.dart';
import '../internationalization/country_codes.dart';
import '../points/user_points.dart';
import '../shared/firebase_document_model.dart';
import '../store/store.dart';
import '../store/store_product.dart';

part 'user.g.dart';

LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

@JsonSerializable(explicitToJson: true)
@DateTimeConverter()
class User extends FirebaseDocumentModel {
  LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

  User({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.registeredDate,
    this.mobileNumber,
    this.internationalNumber,
    this.avatar,
    this.company,
    this.dateOfBirth,
    this.jobTitle,
    this.prefix,
    this.suffix,
    this.gender,
    this.countryCode,
    this.profileImageUri,
    this.accountType,
    this.userScoreCard,
    this.emailVerified,
    this.mobileNumberVerified,
    this.identityVerified,
    this.identityNumber,
  });

  User.fromAuthUser(AuthUser user, {AuthUserInfo? additionalUserInfo}) {
    id = user.uid;
    userId = user.uid;
    email = user.email;
    mobileNumber = user.mobileNumber;
    profileImageUri = user.profileImageUri;
    username = additionalUserInfo?.username ?? user.email;
    gallery = [];
    registeredDate = DateTime.now();
    deleted = emailVerified = mobileNumberVerified = false;
    identityVerified = false;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User.fromAuthResult(AuthUser result) {
    var user = result;

    id = user.uid;
    userId = user.uid;
    email = user.email;
    mobileNumber = user.mobileNumber;
    profileImageUri = user.profileImageUri;
    gallery = [];
    registeredDate = DateTime.now();
    username = result.additionalUserInfo?.username;
    identityVerified = false;

    authData = result;
    deleted = false;
  }

  User.fromUserAndUserProfile(AuthUser posUser, UserProfile posUserProfile) {
    id = posUser.uid;
    userId = posUser.uid;
    firstName = posUserProfile.firstName;
    lastName = posUserProfile.lastName;
    email = posUser.email;
    registeredDate = posUserProfile.registeredDate;
    mobileNumber = posUserProfile.mobileNumber;
    internationalNumber = posUserProfile.internationalNumber;
    avatar = posUserProfile.avatar;
    company = posUserProfile.company;
    dateOfBirth = posUserProfile.dateOfBirth;
    jobTitle = posUserProfile.jobTitle;
    prefix = posUserProfile.prefix;
    suffix = posUserProfile.suffix;
    countryCode = posUserProfile.countryCode;
    profileImageUri = posUserProfile.profileImageUri;
    accountType = UserAccountType.business;
    identityNumber = '';
    userScoreCard = null;
    emailVerified = false;
    mobileNumberVerified = false;
    identityVerified = false;
  }

  User.fromBusiness(Store business, AuthUser user) {
    accountType = UserAccountType.business;
    id = const Uuid().v4();
    userId = user.uid;
    email = business.contactInformation!.email;
    mobileNumber = business.contactInformation!.mobileNumber;
    profileImageUri = business.logoUrl;
    deleted = false;
    username = user.email;
    firstName = business.displayName;
    locations = [UserLocation.fromStoreAddress(business.primaryAddress!)];
    lastName = 'Business';
  }

  String? id;

  String? userId,
      firstName,
      lastName,
      prefix,
      suffix,
      company,
      jobTitle,
      username;

  String? identityNumber;

  @JsonKey(defaultValue: false)
  bool? identityVerified;

  @JsonKey(defaultValue: 0)
  int? businessCount;

  String? nickName;

  String get displayName {
    var title = prefix == null ? '' : '$prefix. ';

    return "$title${firstName ?? ""}${lastName == null ? "" : " $lastName"}";
  }

  @JsonKey(
    defaultValue: <UserLinkedAccount>[],
    includeFromJson: false,
    includeToJson: false,
  )
  List<UserLinkedAccount>? linkedAccounts;

  @JsonKey(
    defaultValue: <UserNotificationTopic>[],
    includeFromJson: false,
    includeToJson: false,
  )
  List<UserNotificationTopic>? notificationTopics;

  @JsonKey(
    defaultValue: <UserThirdPartyAccount>[],
    includeFromJson: false,
    includeToJson: false,
  )
  List<UserThirdPartyAccount>? thirdPartyAccounts;

  @JsonKey(includeFromJson: false, includeToJson: false)
  UserPreferences? userPreferences;

  DateTime? dateOfBirth;

  UserAccountType? accountType;

  String? avatar;

  DateTime? registeredDate;

  String? mobileNumber, internationalNumber, email;

  Gender? gender;

  String? countryCode;

  String? profileImageUri;

  @JsonKey(defaultValue: false)
  bool? emailVerified;

  @JsonKey(defaultValue: false)
  bool? mobileNumberVerified;

  @JsonKey(defaultValue: false)
  bool? deleted;

  //important to set the user
  UserScoreLevel? userScoreCard;

  @JsonKey(defaultValue: 0)
  double? score;

  @JsonKey(defaultValue: 1)
  int? level;

  String? levelName;

  String? levelDescription;

  @JsonKey(defaultValue: <String>[])
  List<String>? gallery;

  @JsonKey(includeFromJson: false, includeToJson: false)
  dynamic authData;

  @JsonKey(includeFromJson: false, includeToJson: false, defaultValue: [])
  List<UserLocation>? locations;

  @JsonKey(name: 'country_data')
  CountryCode? countryData;

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get locationsCollection =>
      documentReference?.collection('locations');

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get wishlistCollection =>
      documentReference?.collection('wishlist');

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get voucherCollection =>
      documentReference?.collection('vouchers');

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get trackedOrdersCollection =>
      documentReference?.collection('tracked_orders');

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get receiptsCollection =>
      documentReference?.collection('user_receipts');

  CollectionReference? get scoreEventsCollection =>
      documentReference?.collection('score_events');

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get goalsCollection =>
      documentReference?.collection('user_goals');

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get linkedAccountsCollection =>
      documentReference?.collection('linkedAccounts');

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get accountsCollection =>
      documentReference?.collection('user_accounts');

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get reviewsCollection =>
      documentReference?.collection('productReviews');

  @JsonKey(includeFromJson: false, includeToJson: false)
  CollectionReference? get notificationTopicsCollection =>
      documentReference?.collection('notificationTopics');

  factory User.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$UserFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  // factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Future<void> saveToLocal() async {
    // also added await initLocalStorage() in the bootstrapApp
    /// NOTE: No more individual LocalStorage instances: The new API uses a global localStorage instance instead of creating individual LocalStorage('filename') instances
    // final LocalStorage storage = LocalStorage('user_profile');

    try {
      // Not needed anymore
      // final ready = await storage.ready;
      // if (ready) {
      localStorage.setItem(userId!, jsonEncode(toJson()));
      // }
    } catch (err) {
      logger.debug(
        'features.ecommerce.user',
        'Error saving user profile to local storage: ${err.toString()}',
      );
    }
  }

  // Future<void> loadLocations([bool refresh = false]) async {
  //   if (this.locations != null && this.locations.isNotEmpty && !refresh) return;

  //   if (this.locations == null) this.locations = [];

  //   var api = ServiceFactory();

  //   //this will get the locations from the database based on the user
  //   var result = await api.getUserLocations(this);

  //   this.locations = result;

  //   return result;
  // }

  Future<void> savePreferences() async {
    if (userPreferences == null) return;
    try {
      var key = '${userId ?? 'guest'}:user_preferences';

      var prefs = await SharedPreferences.getInstance();

      await prefs.setString(key, jsonEncode(userPreferences!.toJson()));
    } catch (error) {
      // reportCheckedError(error);
      rethrow;
    }

    return;
  }

  Future<UserPreferences> getPreferences() async {
    var prefs = await SharedPreferences.getInstance();

    var key = '${userId ?? 'guest'}:user_preferences';

    if (prefs.containsKey(key)) {
      return UserPreferences.fromJson(jsonDecode(prefs.getString(key)!));
    } else {
      var result = UserPreferences.setup(userId);
      await prefs.setString(key, jsonEncode(result.toJson()));

      return result;
    }
  }
}

@JsonSerializable(explicitToJson: true)
@DateTimeConverter()
class UserLinkedAccount {
  LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

  UserLinkedAccount({
    this.accountId,
    this.description,
    this.featureImageUrl,
    this.name,
    this.type,
  });

  String? accountId;

  //business
  //individual?
  String? type;

  String? name;

  String? description;

  String? featureImageUrl;

  factory UserLinkedAccount.fromJson(Map<String, dynamic> json) =>
      _$UserLinkedAccountFromJson(json);

  Map<String, dynamic> toJson() => _$UserLinkedAccountToJson(this);

  Future<void> saveToLocal() async {
    try {
      localStorage.setItem(accountId!, jsonEncode(toJson()));
    } catch (err) {
      logger.debug(
        'features.ecommerce.user.linked_account',
        'Error saving linked account to local storage: ${err.toString()}',
      );
    }
  }
}

class GenderConverter implements JsonConverter<Gender, int> {
  const GenderConverter();

  @override
  Gender fromJson(int json) {
    return Gender.values[json];
  }

  @override
  int toJson(Gender object) {
    return object.index;
  }
}

enum Gender { male, female, other, notSpecified }

@JsonSerializable()
@DateTimeConverter()
class Billing {
  LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

  Billing({
    this.address1,
    this.address2,
    this.city,
    this.company,
    this.country,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.postCode,
    this.state,
  });

  String? firstName;
  String? lastName;
  String? company;
  String? email;
  String? phone;

  String? address1;
  String? address2;
  String? city;
  String? postCode;
  String? country;
  String? state;

  Billing.fromUserProfile(User user) {
    firstName = user.firstName;
    lastName = user.lastName;
    email = user.email;
    phone = user.mobileNumber;
    company = user.company;
  }

  bool get hasBillerInfo =>
      isNotBlank(firstName) && isNotBlank(lastName) && isNotBlank(phone);

  bool get hasBillingAddress =>
      isNotBlank(address1) &&
      isNotBlank(address2) &&
      isNotBlank(city) &&
      isNotBlank(postCode) &&
      isNotBlank(country) &&
      isNotBlank(state);

  String toStringAddress() =>
      '$address1,$address2\r\n$city\r\n$postCode\r\n$state\r\n$country\r\n';

  factory Billing.fromJson(Map<String, dynamic> json) =>
      _$BillingFromJson(json);

  Map<String, dynamic> toJson() => _$BillingToJson(this);

  Future<void> saveToLocal() async {
    try {
      localStorage.setItem('', jsonEncode(toJson()));
    } catch (err) {
      logger.debug(
        'features.ecommerce.user.billing',
        'Error saving billing information to local storage: ${err.toString()}',
      );
    }
  }
}

@JsonSerializable()
@DateTimeConverter()
class Shipping {
  LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

  String? firstName;
  String? lastName;
  String? company;
  String? address1;
  String? address2;
  String? city;
  String? postCode;
  String? country;
  String? state;

  Shipping({
    this.address1,
    this.address2,
    this.city,
    this.company,
    this.country,
    this.firstName,
    this.lastName,
    this.postCode,
    this.state,
  });

  Shipping.fromUserProfile(User user) {
    firstName = user.firstName;
    lastName = user.lastName;
    company = user.company;
  }

  Shipping.fromBillingInfo(Billing billingInfo) {
    address1 = billingInfo.address1;
    address2 = billingInfo.address2;
    city = billingInfo.city;
    company = billingInfo.company;
    country = billingInfo.country;
    firstName = billingInfo.firstName;
    lastName = billingInfo.lastName;
    state = billingInfo.state;
    postCode = billingInfo.postCode;
  }

  factory Shipping.fromJson(Map<String, dynamic> json) =>
      _$ShippingFromJson(json);

  Future<void> saveToLocal() async {
    try {
      localStorage.setItem('shipping_information', jsonEncode(toJson()));
    } catch (err) {
      logger.debug(
        'features.ecommerce.user.shipping',
        'Error saving shipping information to local storage: ${err.toString()}',
      );
    }
  }

  Map<String, dynamic> toJson() => _$ShippingToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class UserStoreLink extends FirebaseDocumentModel {
  LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

  UserStoreLink({
    this.dateFollowed,
    this.storeId,
    this.userId,
    this.dateUnfollowed,
    this.isFollowing,
    this.name,
    this.storeLogoUrl,
    this.businessId,
  });

  String get id => '$userId:$storeId';

  String? userId;

  //store being followed
  String? storeId;

  //follower
  String? businessId;

  String? name;

  String? storeLogoUrl;

  bool get hasLogo => storeLogoUrl != null && storeLogoUrl!.isNotEmpty;

  DateTime? dateFollowed;

  DateTime? dateUnfollowed;

  bool? isFollowing;

  factory UserStoreLink.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$UserStoreLinkFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  factory UserStoreLink.fromJson(Map<String, dynamic> json) =>
      _$UserStoreLinkFromJson(json);

  Future<void> saveToLocal() async {
    try {
      localStorage.setItem(id, jsonEncode(toJson()));
    } catch (err) {
      logger.debug(
        'features.ecommerce.user.store_link',
        'Error saving store follow to local storage: ${err.toString()}',
      );
    }
  }

  Map<String, dynamic> toJson() => _$UserStoreLinkToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class UserProductUpdatedView extends FirebaseDocumentModel {
  UserProductUpdatedView({
    this.productId,
    this.productName,
    this.featureImage,
    this.sellingPrice,
    this.id,
  });

  String? id;

  String? productId;

  String? productName;

  String? featureImage;

  double? sellingPrice;

  DateTime? dateUpdated;

  factory UserProductUpdatedView.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) =>
      _$UserProductUpdatedViewFromJson(snapshot.data() as Map<String, dynamic>)
        ..documentSnapshot = snapshot
        ..documentReference = reference;

  factory UserProductUpdatedView.fromJson(Map<String, dynamic> json) =>
      _$UserProductUpdatedViewFromJson(json);

  Map<String, dynamic> toJson() => _$UserProductUpdatedViewToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class UserStoreView extends FirebaseDocumentModel {
  UserStoreView({
    this.storeId,
    this.userId,
    this.dateViewed,
    this.userName,
    this.id,
  });

  String? id;

  String? userId;

  String? userName;

  String? storeId;

  DateTime? dateViewed;

  Future<void> saveToLocal() async {
    try {
      localStorage.setItem(id!, jsonEncode(toJson()));
    } catch (err) {
      logger.error(
        'user.saveToLocal',
        'Error saving store view to local storage',
        error: err,
      );
    }
  }

  factory UserStoreView.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$UserStoreViewFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  factory UserStoreView.fromJson(Map<String, dynamic> json) =>
      _$UserStoreViewFromJson(json);

  Map<String, dynamic> toJson() => _$UserStoreViewToJson(this);
}

@JsonSerializable(explicitToJson: true)
@DateTimeConverter()
class UserLocation extends FirebaseDocumentModel {
  UserLocation({
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.country,
    this.enabled,
    this.friendlyName,
    this.location,
    this.locationId,
    this.postalCode,
    this.state,
    this.isPrimary,
  });

  UserLocation.defaults() {
    enabled = true;
    id = const Uuid().v4();
    location = StoreLocation();
    isPrimary = false;
  }

  UserLocation.fromStoreAddress(StoreAddress location) {
    addressLine1 = location.addressLine1;
    addressLine2 = location.addressLine2;
    city = location.city;
    country = location.country;
    enabled = true;
    friendlyName = location.friendlyName;
    this.location = location.location;
    locationId = location.locationId;
    postalCode = location.postalCode;
    state = location.state;
    isPrimary = true;
  }

  // UserLocation.fromGeoCodingResponse(GeocodingResponse data) {
  //   //if (data == null || data.hasNoResults) return;

  //   //if (data.isDenied) return;

  //   //if (data.isOverQueryLimit) return;

  //   if (data.results == null && data.results!.isEmpty) {
  //     return;
  //   }

  //   final firstElement = data.results!.first;

  //   if (firstElement.addressComponents == null) {
  //     return;
  //   }
  //   final firstAddressComponent = firstElement.addressComponents!;

  //   enabled = true;

  //   placeId = data.results!.first.placeId;

  //   id = const Uuid().v4();

  //   location = StoreLocation();

  //   isPrimary = false;

  //   var streetNumber = firstAddressComponent
  //       .firstWhereOrNull((element) => element.types!.contains('street_number'))
  //       ?.longName;

  //   addressLine1 = streetNumber;

  //   var streetName = firstAddressComponent
  //       .firstWhereOrNull((element) => element.types!.contains('route'))
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

  //   var city = firstAddressComponent
  //       .firstWhereOrNull(
  //           (element) => element.types!.contains('administrative_area_level_2'),)
  //       ?.longName;

  //   this.city = city;

  //   var province = firstAddressComponent
  //       .firstWhereOrNull(
  //           (element) => element.types!.contains('administrative_area_level_1'),)
  //       ?.longName;

  //   state = province;

  //   var country = firstAddressComponent
  //       .firstWhereOrNull((element) => element.types!.contains('country'))
  //       ?.longName;

  //   this.country = country;

  //   var postalCode = firstAddressComponent
  //       .firstWhereOrNull((element) => element.types!.contains('postal_code'))
  //       ?.longName;

  //   this.postalCode = postalCode;

  //   location = StoreLocation(
  //     latitude: firstElement.geometry?.location?.lat ?? 0.0,
  //     longitude: firstElement.geometry?.location?.lng ?? 0.0,
  //   );

  //   enabled = true;
  // }

  String? friendlyName;

  bool? enabled;

  bool? isPrimary;

  String? id;

  String? placeId;

  String? userId;

  String? locationId;

  String? addressLine1;

  String? addressLine2;

  String? country;

  String? state;

  String? postalCode;

  String? city;

  StoreLocation? location;

  String? mapUrl;

  String toStringAddress() =>
      '$addressLine1,$addressLine2\r\n$city\r\n$postalCode\r\n$state\r\n$country\r\n';

  String toShortStringAddress() => '$addressLine1,$addressLine2,$city';

  bool get isPartiallyPopulated =>
      isNotBlank(city) && isNotBlank(country) && isNotBlank(state);
  // isNotBlank(postalCode) &&

  bool get isPopulated =>
      (isNotBlank(addressLine1) || isNotBlank(addressLine2)) &&
      isNotBlank(city) &&
      // isNotBlank(postalCode) &&
      isNotBlank(country) &&
      isNotBlank(state);

  factory UserLocation.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$UserLocationFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  factory UserLocation.fromJson(Map<String, dynamic> json) =>
      _$UserLocationFromJson(json);

  Map<String, dynamic> toJson() => _$UserLocationToJson(this);

  Future<void> saveToLocal() async {
    try {
      localStorage.setItem(id!, jsonEncode(toJson()));
    } catch (err) {}
  }

  @override
  String toString() {
    return '$addressLine1, $addressLine2, $city';
  }
}

@JsonSerializable(explicitToJson: true)
@DateTimeConverter()
class UserNotificationToken {
  UserNotificationToken({
    this.appBuildNumber,
    this.appName,
    this.appVersionNumber,
    this.deviceInfo,
    this.packageName,
    this.token,
    this.userId,
  });

  String? userId;

  String? token;

  UserDevice? deviceInfo;

  String? packageName;

  String? appName;

  String? appBuildNumber;

  String? appVersionNumber;

  factory UserNotificationToken.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationTokenFromJson(json);

  Map<String, dynamic> toJson() => _$UserNotificationTokenToJson(this);
}

enum UserAccountType { individual, business }

@JsonSerializable()
@DateTimeConverter()
class UserDevice {
  String? userId,
      brand,
      device,
      display,
      fingerprint,
      host,
      manufacturer,
      product,
      deviceId,
      platform,
      systemVersion;

  bool? isPhysicalDevice;

  DateTime? accessDate;

  UserDevice({
    this.userId,
    this.brand,
    this.device,
    this.fingerprint,
    this.host,
    this.accessDate,
    this.deviceId,
    this.display,
    this.isPhysicalDevice,
    this.manufacturer,
    this.product,
    this.platform,
    this.systemVersion,
  });

  factory UserDevice.fromAndroidInfo(AndroidDeviceInfo info) {
    return UserDevice(
      accessDate: DateTime.now().toUtc(),
      brand: info.brand,
      device: info.device,
      deviceId: info.id, // TODO(lampian): check id ->  .androidId,
      display: info.display,
      fingerprint: info.fingerprint,
      host: info.host,
      isPhysicalDevice: info.isPhysicalDevice,
      manufacturer: info.manufacturer,
      product: info.product,
      platform: 'Android',
    );
  }

  factory UserDevice.fromIosDeviceInfo(IosDeviceInfo info) {
    return UserDevice(
      platform: 'IOS',
      device: info.model,
      brand: 'Apple',
      accessDate: DateTime.now().toUtc(),
      deviceId: info.identifierForVendor,
      isPhysicalDevice: info.isPhysicalDevice,
      manufacturer: 'Apple',
      host: info.systemName,
      product: info.name,
      systemVersion: info.systemVersion,
      display: info.localizedModel,
    );
  }

  factory UserDevice.fromWindows() {
    return UserDevice(
      platform: 'Windows',
      device: Platform.operatingSystem,
      brand: 'Microsoft',
      accessDate: DateTime.now().toUtc(),
      deviceId: Platform.localHostname,
      isPhysicalDevice: true,
      manufacturer: 'Microsoft',
      host: Platform.localHostname,
      product: Platform.localHostname,
      systemVersion: Platform.operatingSystemVersion,
      display: Platform.operatingSystemVersion,
    );
  }

  factory UserDevice.fromJson(Map<String, dynamic> json) =>
      _$UserDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$UserDeviceToJson(this);
}

@JsonSerializable()
@IsoDateTimeConverter()
class UserWishListProduct {
  UserWishListProduct({
    this.productId,
    this.userId,
    this.businessId,
    this.dateAdded,
    this.notes,
    this.productName,
    this.userName,
    this.featureImageUrl,
    this.sellingPrice,
  });

  UserWishListProduct.fromProduct(StoreProduct product) {
    productId = product.productId;
    productName = product.displayName;
    featureImageUrl = product.featureImageUrl;
    businessId = product.businessId;
    dateAdded = DateTime.now();
    sellingPrice = product.sellingPrice;
  }

  String get id => '$productId:$userId';

  String? productId;

  String? productName;

  String? businessId;

  String? featureImageUrl;

  String? userId;

  String? userName;

  DateTime? dateAdded;

  double? sellingPrice;

  String? notes;

  factory UserWishListProduct.fromJson(Map<String, dynamic> json) =>
      _$UserWishListProductFromJson(json);

  Map<String, dynamic> toJson() => _$UserWishListProductToJson(this);

  Future<void> saveToLocal() async {
    try {
      localStorage.setItem('wishlist', jsonEncode(toJson()));
    } catch (err) {
      logger.error(
        'saveToLocal',
        'Error saving wishlist to local storage',
        error: err,
      );
    }
  }

  @override
  String toString() {
    return productName!;
  }
}

@JsonSerializable()
@DateTimeConverter()
class ShippingMethod {
  String? id;
  String? title;
  String? description;
  double? cost;
  String? classCost;
  String? methodId;
  String? methodTitle;

  ShippingMethod({
    this.classCost,
    this.cost,
    this.description,
    this.id,
    this.methodId,
    this.methodTitle,
    this.title,
  });

  ShippingMethod.cashOnDelivery() {
    id = 'COD';
    title = 'Cash on Delivery';
    description = 'Customer pays when recieving the goods';
    cost = 0.0;
    classCost = 'FREE';
    methodId = 'pickup';
    methodTitle = 'Customer Pickup';
  }

  ShippingMethod.fromMagentoJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['carrier_code'];
    title = parsedJson['carrier_title'];
    description = parsedJson['method_title'];
    cost = parsedJson['amount'] != null
        ? double.parse("${parsedJson["amount"]}")
        : 0.0;
  }

  ShippingMethod.fromOpencartJson(Map<String, dynamic> parsedJson) {
    Map<String, dynamic> quote = parsedJson['quote'];
    Map<String, dynamic>? item = quote.values.isNotEmpty
        ? quote.values.toList()[0]
        : null;
    id = item != null ? item['code'] : '0';
    title = parsedJson['title'] ?? id;
    description = item != null && item['title'] != null ? item['title'] : '';
    cost = 0;
  }

  factory ShippingMethod.fromJson(Map<String, dynamic> json) =>
      _$ShippingMethodFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingMethodToJson(this);

  Future<void> saveToLocal() async {
    try {
      localStorage.setItem(id!, jsonEncode(toJson()));
    } catch (err) {
      logger.error(
        'saveToLocal',
        'Error saving shipping info to local storage',
        error: err,
      );
    }
  }
}

//point system classes
@JsonSerializable()
@DateTimeConverter()
class UserPointEvent {
  UserPointEvent({
    this.eventDate,
    this.description,
    this.id,
    this.points,
    this.userId,
    this.eventType,
  });

  String? id;

  String? eventType;

  String? userId;

  DateTime? eventDate;

  String? description;

  double? points;

  factory UserPointEvent.fromJson(Map<String, dynamic> json) =>
      _$UserPointEventFromJson(json);

  Map<String, dynamic> toJson() => _$UserPointEventToJson(this);
}

@JsonSerializable()
@DateTimeConverter()
class UserGoal extends FirebaseDocumentModel {
  UserGoal({
    this.description,
    this.id,
    this.currentCount,
    this.dateCreated,
    this.eventId,
    this.eventQty,
    this.goalId,
    this.name,
    this.claimed,
  });

  String? id;

  String? goalId;

  DateTime? dateCreated;

  String? name;

  String? description;

  String? eventId;

  double? eventQty;

  double? currentCount;

  @JsonKey(defaultValue: false)
  bool? claimed;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get accomplishedGoal =>
      ((currentCount ?? 0) >= (eventQty ?? 0)) && ((eventQty ?? 0) > 0);

  factory UserGoal.fromDocumentSnapshot(
    DocumentSnapshot snapshot, {
    DocumentReference? reference,
  }) => _$UserGoalFromJson(snapshot.data() as Map<String, dynamic>)
    ..documentSnapshot = snapshot
    ..documentReference = reference;

  factory UserGoal.fromJson(Map<String, dynamic> json) =>
      _$UserGoalFromJson(json);

  Map<String, dynamic> toJson() => _$UserGoalToJson(this);
}

@JsonSerializable(explicitToJson: true)
@DateTimeConverter()
class UserNotificationTopic {
  UserNotificationTopic({
    this.allowed,
    this.description,
    this.topic,
    this.topicId,
    this.userId,
  });

  String? topic;

  String? topicId;

  String? userId;

  String? description;

  bool? allowed;

  factory UserNotificationTopic.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationTopicFromJson(json);

  Map<String, dynamic> toJson() => _$UserNotificationTopicToJson(this);
}

@JsonSerializable(explicitToJson: true)
@DateTimeConverter()
class UserPreferences {
  UserPreferences({
    // this.allowedTopics,
    this.followedStores,
    this.recentlyViewedProducts,
    this.recentlyViewedStores,
    this.userId,
    this.userLanguage,
    this.userTheme,
    this.wishlist,
  });

  UserPreferences.setup(String? userIdValue) {
    userId = userIdValue;
    // this.userTheme = kDefaultTheme;
    // this.allowNotifications = true;
    // this.userLanguage = kDefaultLanguageCode;

    wishlist = [];
    followedStores = [];
    recentlyViewedProducts = [];
    recentlyViewedStores = [];

    // this.allowedTopics = [

    // ];
  }

  String? userId;

  @JsonKey(defaultValue: 'light')
  String? userTheme;

  // @JsonKey(defaultValue: true)
  // bool allowNotifications;

  // @JsonKey(defaultValue: [])
  // List<UserNotificationTopic> allowedTopics;

  @JsonKey(defaultValue: 'en')
  String? userLanguage;

  @JsonKey(defaultValue: [])
  List<UserWishListProduct>? wishlist;

  @JsonKey(defaultValue: [])
  List<StoreProduct>? recentlyViewedProducts;

  @JsonKey(defaultValue: [])
  List<UserStoreView>? recentlyViewedStores;

  @JsonKey(defaultValue: [])
  List<UserStoreLink>? followedStores;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);
}

@JsonSerializable(explicitToJson: true)
@UserThirdPartyAccountTypeConverter()
class UserThirdPartyAccount {
  String? id, name, displayName;
  String? logoUrl;
  String? userId;
  bool? deleted;
  dynamic config;
  UserThirdPartyAccountType? accountType;

  UserThirdPartyAccount({
    this.id,
    this.name,
    this.displayName,
    this.deleted,
    this.config,
    this.accountType,
    this.userId,
    this.logoUrl,
  });

  factory UserThirdPartyAccount.fromJson(Map<String, dynamic> json) =>
      _$UserThirdPartyAccountFromJson(json);

  Map<String, dynamic> toJson() => _$UserThirdPartyAccountToJson(this);
}

enum UserThirdPartyAccountType { wallet }

class UserThirdPartyAccountTypeConverter
    implements JsonConverter<UserThirdPartyAccountType, String> {
  const UserThirdPartyAccountTypeConverter();

  @override
  UserThirdPartyAccountType fromJson(String? json) {
    return UserThirdPartyAccountType.values.firstWhereOrNull(
          (element) => element.toString().split('.').last == json,
        ) ??
        UserThirdPartyAccountType.wallet;
  }

  @override
  String toJson(UserThirdPartyAccountType? object) {
    return object?.toString().split('.').last ?? '';
  }
}
