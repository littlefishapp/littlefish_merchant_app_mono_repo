// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnlineStore _$OnlineStoreFromJson(Map<String, dynamic> json) => OnlineStore(
  dateEstablished: const IsoDateTimeConverter().fromJson(
    json['dateEstablished'],
  ),
  contactDetails: json['contactDetails'] == null
      ? null
      : ContactInformation.fromJson(
          json['contactDetails'] as Map<String, dynamic>,
        ),
  gallery: (json['gallery'] as List<dynamic>?)
      ?.map((e) => GalleryItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  rating: (json['rating'] as num?)?.toDouble(),
  totalRatings: (json['totalRatings'] as num?)?.toInt(),
  tradingTime: json['tradingTime'] == null
      ? null
      : TradingTime.fromJson(json['tradingTime'] as Map<String, dynamic>),
  delivery: json['delivery'] == null
      ? null
      : Shipping.fromJson(json['delivery'] as Map<String, dynamic>),
  pickup: json['pickup'] == null
      ? null
      : Shipping.fromJson(json['pickup'] as Map<String, dynamic>),
  address: json['address'] == null
      ? null
      : Address.fromJson(json['address'] as Map<String, dynamic>),
  businessId: json['businessId'] as String?,
  description: json['description'] as String?,
  displayName: json['displayName'] as String?,
  id: json['id'] as String?,
  isOnline: json['isOnline'] as bool? ?? false,
  logoUri: json['logoUri'] as String?,
  name: json['name'] as String?,
  theme: $enumDecodeNullable(_$SiteThemeEnumMap, json['theme']),
);

Map<String, dynamic> _$OnlineStoreToJson(OnlineStore instance) =>
    <String, dynamic>{
      'isOnline': instance.isOnline,
      'gallery': instance.gallery?.map((e) => e.toJson()).toList(),
      'rating': instance.rating,
      'totalRatings': instance.totalRatings,
      'contactDetails': instance.contactDetails?.toJson(),
      'dateEstablished': const IsoDateTimeConverter().toJson(
        instance.dateEstablished,
      ),
      'tradingTime': instance.tradingTime?.toJson(),
      'pickup': instance.pickup?.toJson(),
      'delivery': instance.delivery?.toJson(),
      'id': instance.id,
      'name': instance.name,
      'displayName': instance.displayName,
      'description': instance.description,
      'logoUri': instance.logoUri,
      'theme': _$SiteThemeEnumMap[instance.theme],
      'address': instance.address?.toJson(),
      'businessId': instance.businessId,
    };

const _$SiteThemeEnumMap = {SiteTheme.theme1: 0, SiteTheme.theme2: 1};

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

GalleryItem _$GalleryItemFromJson(Map<String, dynamic> json) =>
    GalleryItem(type: json['type'] as String?, url: json['url'] as String?);

Map<String, dynamic> _$GalleryItemToJson(GalleryItem instance) =>
    <String, dynamic>{'type': instance.type, 'url': instance.url};

Shipping _$ShippingFromJson(Map<String, dynamic> json) => Shipping(
  address: json['address'] == null
      ? null
      : Address.fromJson(json['address'] as Map<String, dynamic>),
  enabled: json['enabled'] as bool? ?? false,
  orderReady: const IsoDateTimeConverter().fromJson(json['orderReady']),
);

Map<String, dynamic> _$ShippingToJson(Shipping instance) => <String, dynamic>{
  'enabled': instance.enabled,
  'address': instance.address,
  'orderReady': const IsoDateTimeConverter().toJson(instance.orderReady),
};

POSOnlineStoreSettings _$POSOnlineStoreSettingsFromJson(
  Map<String, dynamic> json,
) => POSOnlineStoreSettings(
  enableStore: json['enable_store'] as bool? ?? false,
  enableSocialMedia: json['enable_social_media'] as bool? ?? true,
  enableInstagram: json['enable_instagram'] as bool? ?? true,
  enableFacebook: json['enable_facebook'] as bool? ?? true,
  enableGoogle: json['enable_google'] as bool? ?? false,
  baseUrl: json['baseUrl'] as String? ?? 'littlefish.app',
  useSSL: json['useSSL'] as bool?,
);

Map<String, dynamic> _$POSOnlineStoreSettingsToJson(
  POSOnlineStoreSettings instance,
) => <String, dynamic>{
  'enable_store': instance.enableStore,
  'enable_social_media': instance.enableSocialMedia,
  'enable_instagram': instance.enableInstagram,
  'enable_facebook': instance.enableFacebook,
  'enable_google': instance.enableGoogle,
  'baseUrl': instance.baseUrl,
  'useSSL': instance.useSSL,
};
