import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/models/store/business_type.dart';

part 'bank_merchant.g.dart';

@JsonSerializable(createToJson: true)
class BankMerchant {
  @JsonKey(name: '_id', defaultValue: '')
  String? id;
  String? firstName;
  String? surname;
  String? emailAddress;
  String? mobileNumber;
  String? businessName;
  BusinessType? businessType;
  Gender? gender;
  String? mcc;
  String? addressLine1;
  String? addressLine2;
  String? country;
  String? state;
  String? postalCode;
  String? city;
  String? deviceSerialNumber;
  String? merchantId;
  String? accountNumber;

  BankMerchant({
    required this.id,
    required this.firstName,
    required this.surname,
    required this.emailAddress,
    required this.mobileNumber,
    required this.businessName,
    required this.mcc,
    required this.businessType,
    required this.addressLine1,
    required this.addressLine2,
    required this.country,
    required this.state,
    required this.postalCode,
    required this.city,
    this.gender = Gender.notSpecified,
    this.deviceSerialNumber,
    this.merchantId,
    this.accountNumber,
  });

  factory BankMerchant.fromJson(Map<String, dynamic> json) =>
      _$BankMerchantFromJson(json);

  Map<String, dynamic> toJson() => _$BankMerchantToJson(this);
}
