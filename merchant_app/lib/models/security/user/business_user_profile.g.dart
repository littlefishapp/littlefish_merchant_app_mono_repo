// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessUserProfile _$BusinessUserProfileFromJson(Map<String, dynamic> json) =>
    BusinessUserProfile(
      user: json['user'] == null
          ? null
          : UserProfile.fromJson(json['user'] as Map<String, dynamic>),
      business: json['business'] == null
          ? null
          : BusinessProfile.fromJson(json['business'] as Map<String, dynamic>),
      password: json['password'] as String?,
    );

Map<String, dynamic> _$BusinessUserProfileToJson(
  BusinessUserProfile instance,
) => <String, dynamic>{
  'password': instance.password,
  'business': instance.business,
  'user': instance.user,
};
