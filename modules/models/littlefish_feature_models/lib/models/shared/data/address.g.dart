// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  address1: json['address1'] as String?,
  address2: json['address2'] as String?,
  city: json['city'] as String?,
  postalCode: json['postalCode'] as String?,
  state: json['state'] as String?,
  country: json['country'] as String?,
  location: json['location'],
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'address1': instance.address1,
  'address2': instance.address2,
  'city': instance.city,
  'state': instance.state,
  'postalCode': instance.postalCode,
  'country': instance.country,
  'location': instance.location,
};
