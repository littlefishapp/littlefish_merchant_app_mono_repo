// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingAddress _$ShippingAddressFromJson(Map<String, dynamic> json) =>
    ShippingAddress(
      line1: json['line1'] as String? ?? '',
      city: json['city'] as String? ?? '',
      province: json['province'] as String? ?? '',
      contactName: json['contactName'] as String? ?? '',
      country: json['country'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      zipCode: json['zipCode'] as String? ?? '',
      line2: json['line2'] as String? ?? '',
      contactEmail: json['contactEmail'] as String? ?? '',
      contactMobileNumber: json['contactMobileNumber'] as String? ?? '',
      note: json['note'] as String? ?? '',
    );

Map<String, dynamic> _$ShippingAddressToJson(ShippingAddress instance) =>
    <String, dynamic>{
      'line1': instance.line1,
      'line2': instance.line2,
      'city': instance.city,
      'province': instance.province,
      'country': instance.country,
      'zipCode': instance.zipCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'note': instance.note,
      'contactName': instance.contactName,
      'contactEmail': instance.contactEmail,
      'contactMobileNumber': instance.contactMobileNumber,
    };
