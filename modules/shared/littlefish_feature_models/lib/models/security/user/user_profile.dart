import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_core/auth/models/auth_user.dart';
import 'package:littlefish_merchant/models/security/verification.dart';
import 'package:uuid/uuid.dart';
import 'package:littlefish_merchant/models/shared/data_item.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'user_profile.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class UserProfile extends DataItem {
  UserProfile({
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
    this.verificationStatus,
  });

  UserProfile.fromFirebaseUser(AuthUser user, {bool setEmail = true}) {
    id = const Uuid().v4();
    userId = user.uid;
    if (setEmail) {
      email = user.email;
      mobileNumber = user.mobileNumber;
    } else {
      //we should assume that this user has a mobile number in the username and it should be extracted
      mobileNumber = user.email!.substring(0, user.email!.indexOf('@'));
    }

    displayName = user.displayName;
    profileImageUri = user.profileImageUri;
  }

  String? userId, firstName, lastName, prefix, suffix, company, jobTitle;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get displayName {
    var title = prefix == null ? '' : '$prefix. ';

    return "$title${firstName ?? ""}${lastName == null ? "" : ", $lastName"}";
  }

  DateTime? dateOfBirth;

  String? avatar;

  DateTime? registeredDate;

  String? mobileNumber, internationalNumber, email;

  Gender? gender;

  String? countryCode;

  String? profileImageUri;

  Verification? verificationStatus;

  @override
  bool validate() {
    return firstName != null &&
        firstName!.isNotEmpty &&
        lastName != null &&
        lastName!.isNotEmpty &&
        email != null &&
        email!.isNotEmpty; //&&
    // this.mobileNumber != null &&
    // this.mobileNumber.isNotEmpty;
  }

  factory UserProfile.create() => UserProfile(jobTitle: 'Secondary User');

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

enum Gender {
  @JsonValue(0)
  male,
  @JsonValue(1)
  female,
  @JsonValue(2)
  other,
  @JsonValue(3)
  notSpecified,
}
