// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StorePreferences _$StorePreferencesFromJson(Map<String, dynamic> json) =>
    StorePreferences(
      acceptsOnlineOrders: json['acceptsOnlineOrders'] as bool? ?? false,
      allowGuestCheckout: json['allowGuestCheckout'] as bool? ?? false,
      layoutTemplate: json['layoutTemplate'] as String?,
      showOutOfStock: json['showOutOfStock'] as bool? ?? false,
      theme: json['theme'] == null
          ? null
          : StoreTheme.fromJson(json['theme'] as Map<String, dynamic>),
      allowProductRating: json['allowProductRating'] as bool? ?? false,
      allowStoreRating: json['allowStoreRating'] as bool? ?? false,
      onlineFee: json['onlineFee'] == null
          ? null
          : OnlineFee.fromJson(json['onlineFee'] as Map<String, dynamic>),
      freeDelivery: json['freeDelivery'] == null
          ? null
          : FreeDelivery.fromJson(json['freeDelivery'] as Map<String, dynamic>),
      paymentTypes: json['paymentTypes'] as String?,
      acceptCOD: json['acceptCOD'] as bool? ?? true,
    );

Map<String, dynamic> _$StorePreferencesToJson(StorePreferences instance) =>
    <String, dynamic>{
      'theme': instance.theme?.toJson(),
      'freeDelivery': instance.freeDelivery?.toJson(),
      'onlineFee': instance.onlineFee?.toJson(),
      'paymentTypes': instance.paymentTypes,
      'layoutTemplate': instance.layoutTemplate,
      'acceptsOnlineOrders': instance.acceptsOnlineOrders,
      'acceptCOD': instance.acceptCOD,
      'showOutOfStock': instance.showOutOfStock,
      'allowProductRating': instance.allowProductRating,
      'allowStoreRating': instance.allowStoreRating,
      'allowGuestCheckout': instance.allowGuestCheckout,
    };

StoreTheme _$StoreThemeFromJson(Map<String, dynamic> json) => StoreTheme(
  primaryColor: json['primaryColor'] as String?,
  secondaryColor: json['secondaryColor'] as String?,
  primaryFont: json['primaryFont'] as String?,
  layout: json['layout'] as String?,
);

Map<String, dynamic> _$StoreThemeToJson(StoreTheme instance) =>
    <String, dynamic>{
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
      'primaryFont': instance.primaryFont,
      'layout': instance.layout,
    };
