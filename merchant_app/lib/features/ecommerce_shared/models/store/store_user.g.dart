// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreUser _$StoreUserFromJson(Map<String, dynamic> json) => StoreUser(
  id: json['id'] as String?,
  businessId: json['businessId'] as String?,
  displayName: json['displayName'] as String?,
  email: json['email'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  mobileNumber: json['mobileNumber'] as String?,
  role: json['role'] as String?,
  uid: json['uid'] as String?,
  userName: json['userName'] as String?,
  profileImageUrl: json['profileImageUrl'] as String?,
  bio: json['bio'] as String?,
)..dateCreated = const DateTimeConverter().fromJson(json['dateCreated']);

Map<String, dynamic> _$StoreUserToJson(StoreUser instance) => <String, dynamic>{
  'businessId': instance.businessId,
  'id': instance.id,
  'uid': instance.uid,
  'userName': instance.userName,
  'email': instance.email,
  'mobileNumber': instance.mobileNumber,
  'profileImageUrl': instance.profileImageUrl,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'displayName': instance.displayName,
  'role': instance.role,
  'bio': instance.bio,
  'dateCreated': const DateTimeConverter().toJson(instance.dateCreated),
};

StoreUserInvite _$StoreUserInviteFromJson(Map<String, dynamic> json) =>
    StoreUserInvite(
        email: json['email'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        mobileNumber: json['mobileNumber'] as String?,
        role: json['role'] as String?,
        inviteCode: json['inviteCode'] as String?,
        dateSent: const EpochDateTimeConverter().fromJson(json['dateSent']),
      )
      ..storeId = json['storeId'] as String?
      ..storeName = json['storeName'] as String?
      ..inviterName = json['inviterName'] as String?
      ..inviterEmail = json['inviterEmail'] as String?
      ..inviterId = json['inviterId'] as String?;

Map<String, dynamic> _$StoreUserInviteToJson(StoreUserInvite instance) =>
    <String, dynamic>{
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'mobileNumber': instance.mobileNumber,
      'storeId': instance.storeId,
      'storeName': instance.storeName,
      'role': instance.role,
      'inviteCode': instance.inviteCode,
      'dateSent': const EpochDateTimeConverter().toJson(instance.dateSent),
      'inviterName': instance.inviterName,
      'inviterEmail': instance.inviterEmail,
      'inviterId': instance.inviterId,
    };

RequestVerification _$RequestVerificationFromJson(Map<String, dynamic> json) =>
    RequestVerification(
      verifyEmail: json['verifyEmail'] as bool?,
      verifyNumber: json['verifyNumber'] as bool?,
    );

Map<String, dynamic> _$RequestVerificationToJson(
  RequestVerification instance,
) => <String, dynamic>{
  'verifyEmail': instance.verifyEmail,
  'verifyNumber': instance.verifyNumber,
};

OTPRequest _$OTPRequestFromJson(Map<String, dynamic> json) => OTPRequest(
  requestId: json['requestId'] as String?,
  emailOTP: json['emailOTP'] as String?,
  numberOTP: json['numberOTP'] as String?,
  verifyEmail: json['verifyEmail'] as bool?,
  verifyNumber: json['verifyNumber'] as bool?,
);

Map<String, dynamic> _$OTPRequestToJson(OTPRequest instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'emailOTP': instance.emailOTP,
      'numberOTP': instance.numberOTP,
      'verifyEmail': instance.verifyEmail,
      'verifyNumber': instance.verifyNumber,
    };
