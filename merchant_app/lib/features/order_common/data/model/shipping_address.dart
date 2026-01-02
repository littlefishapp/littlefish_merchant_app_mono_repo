import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shipping_address.g.dart';

@JsonSerializable(explicitToJson: true)
class ShippingAddress extends Equatable {
  final String line1;
  final String line2;
  final String city;
  final String province;
  final String country;
  final String zipCode;
  final double latitude;
  final double longitude;
  final String note;
  final String contactName;
  final String contactEmail;
  final String contactMobileNumber;

  const ShippingAddress({
    this.line1 = '',
    this.city = '',
    this.province = '',
    this.contactName = '',
    this.country = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.zipCode = '',
    this.line2 = '',
    this.contactEmail = '',
    this.contactMobileNumber = '',
    this.note = '',
  });

  ShippingAddress copyWith({
    String? line1,
    String? line2,
    String? city,
    String? province,
    String? country,
    String? zipCode,
    double? latitude,
    double? longitude,
    String? note,
    String? contactName,
    String? contactEmail,
    String? contactMobileNumber,
  }) {
    return ShippingAddress(
      city: city ?? this.city,
      contactEmail: contactEmail ?? this.contactEmail,
      contactMobileNumber: contactMobileNumber ?? this.contactMobileNumber,
      contactName: contactName ?? this.contactName,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      longitude: longitude ?? this.longitude,
      note: note ?? this.note,
      province: province ?? this.province,
      zipCode: zipCode ?? this.zipCode,
    );
  }

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);

  @override
  List<Object?> get props => [
    line1,
    line2,
    city,
    province,
    country,
    zipCode,
    latitude,
    longitude,
    note,
    contactName,
    contactEmail,
    contactMobileNumber,
  ];
}
