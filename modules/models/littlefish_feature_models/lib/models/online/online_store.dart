// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/data/address.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'online_store.g.dart';

@JsonSerializable(explicitToJson: true)
@IsoDateTimeConverter()
class OnlineStore {
  @JsonKey(defaultValue: false)
  bool? isOnline;
  List<GalleryItem>? gallery;
  double? rating;
  int? totalRatings;
  ContactInformation? contactDetails;
  DateTime? dateEstablished;
  TradingTime? tradingTime;
  Shipping? pickup;
  Shipping? delivery;
  String? id;
  String? name;
  String? displayName;
  String? description;
  String? logoUri;
  SiteTheme? theme;
  Address? address;
  String? businessId;

  OnlineStore({
    this.dateEstablished,
    this.contactDetails,
    this.gallery,
    this.rating,
    this.totalRatings,
    this.tradingTime,
    this.delivery,
    this.pickup,
    this.address,
    this.businessId,
    this.description,
    this.displayName,
    this.id,
    this.isOnline,
    this.logoUri,
    this.name,
    this.theme,
  });

  factory OnlineStore.fromEcommerce(Map<String, dynamic> json) => OnlineStore(
    businessId: json['id'],
    displayName: json['displayName'],
    name: json['name'],
    id: json['id'],
    isOnline: true,
  );

  OnlineStore.create() {
    isOnline = false;
    totalRatings = 0;
    rating = 3;
  }

  factory OnlineStore.fromJson(Map<String, dynamic> json) =>
      _$OnlineStoreFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineStoreToJson(this);
}

enum SiteTheme {
  @JsonValue(0)
  theme1,
  @JsonValue(1)
  theme2,
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

  factory ContactInformation.fromJson(Map<String, dynamic> json) =>
      _$ContactInformationFromJson(json);

  Map<String, dynamic> toJson() => _$ContactInformationToJson(this);
}

@JsonSerializable()
class GalleryItem {
  String? type;
  String? url;

  GalleryItem({this.type, this.url});

  factory GalleryItem.fromJson(Map<String, dynamic> json) =>
      _$GalleryItemFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryItemToJson(this);
}

@JsonSerializable()
@IsoDateTimeConverter()
class Shipping {
  @JsonKey(defaultValue: false)
  bool? enabled;

  Address? address;
  DateTime? orderReady;

  Shipping({this.address, this.enabled, this.orderReady});

  factory Shipping.fromJson(Map<String, dynamic> json) =>
      _$ShippingFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingToJson(this);
}

@JsonSerializable()
class POSOnlineStoreSettings {
  @JsonKey(name: 'enable_store')
  bool enableStore;

  @JsonKey(name: 'enable_social_media')
  bool enableSocialMedia;

  @JsonKey(name: 'enable_instagram')
  bool enableInstagram;

  @JsonKey(name: 'enable_facebook')
  bool enableFacebook;

  @JsonKey(name: 'enable_google')
  bool enableGoogle;

  String baseUrl;

  bool? useSSL;

  POSOnlineStoreSettings({
    this.enableStore = false,
    this.enableSocialMedia = true,
    this.enableInstagram = true,
    this.enableFacebook = true,
    this.enableGoogle = false,
    this.baseUrl = 'littlefish.app',
    this.useSSL,
  });

  factory POSOnlineStoreSettings.fromJson(Map<String, dynamic> json) =>
      _$POSOnlineStoreSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$POSOnlineStoreSettingsToJson(this);
}
