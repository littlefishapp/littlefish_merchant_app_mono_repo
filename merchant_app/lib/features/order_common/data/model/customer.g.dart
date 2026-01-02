// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
  firstName: json['firstName'] as String? ?? '',
  lastName: json['lastName'] as String? ?? '',
  businessId: json['businessId'] as String? ?? '',
  id: json['id'] as String? ?? '',
  email: json['email'] as String? ?? '',
  referenceId: json['referenceId'] as String? ?? '',
  mobileNumber: json['mobileNumber'] as String? ?? '',
  shippingAddress: json['shippingAddress'] == null
      ? const ShippingAddress()
      : ShippingAddress.fromJson(
          json['shippingAddress'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'businessId': instance.businessId,
  'email': instance.email,
  'referenceId': instance.referenceId,
  'mobileNumber': instance.mobileNumber,
  'shippingAddress': instance.shippingAddress.toJson(),
};
