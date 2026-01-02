import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/security/authentication/bank_merchant.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/models/shared/data/address.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';

part 'business_user_profile.g.dart';

@JsonSerializable()
class BusinessUserProfile {
  String? password;
  BusinessProfile? business;

  UserProfile? user;

  BusinessUserProfile({this.user, this.business, this.password});

  BusinessUserProfile.fromBankMerchant(BankMerchant bankMerchant)
    : password = null,
      business = BusinessProfile(
        name: bankMerchant.businessName,
        type: bankMerchant.businessType,
        masterMerchantId: bankMerchant.merchantId,
        businessEmail: bankMerchant.emailAddress,
        address: Address(
          address1: bankMerchant.addressLine1,
          address2: bankMerchant.addressLine2,
          city: bankMerchant.city,
          state: bankMerchant.state,
          postalCode: bankMerchant.postalCode,
          country: bankMerchant.country,
        ),
        mcc: bankMerchant.mcc,
      ),
      user = UserProfile(
        firstName: bankMerchant.firstName,
        lastName: bankMerchant.surname,
        mobileNumber: bankMerchant.mobileNumber,
        email: bankMerchant.emailAddress,
        gender: bankMerchant.gender,
      );

  factory BusinessUserProfile.fromJson(Map<String, dynamic> json) =>
      _$BusinessUserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessUserProfileToJson(this);
}
