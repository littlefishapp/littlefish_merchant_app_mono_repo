// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) =>
    UserProfile(
        userId: json['userId'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        email: json['email'] as String?,
        registeredDate: const IsoDateTimeConverter().fromJson(
          json['registeredDate'],
        ),
        mobileNumber: json['mobileNumber'] as String?,
        internationalNumber: json['internationalNumber'] as String?,
        avatar: json['avatar'] as String?,
        company: json['company'] as String?,
        dateOfBirth: const IsoDateTimeConverter().fromJson(json['dateOfBirth']),
        jobTitle: json['jobTitle'] as String?,
        prefix: json['prefix'] as String?,
        suffix: json['suffix'] as String?,
        gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
        countryCode: json['countryCode'] as String?,
        profileImageUri: json['profileImageUri'] as String?,
        verificationStatus: json['verificationStatus'] == null
            ? null
            : Verification.fromJson(
                json['verificationStatus'] as Map<String, dynamic>,
              ),
      )
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..description = json['description'] as String?
      ..createdBy = json['createdBy'] as String?
      ..status = json['status'] as String?
      ..dateCreated = const IsoDateTimeConverter().fromJson(json['dateCreated'])
      ..dateUpdated = const IsoDateTimeConverter().fromJson(json['dateUpdated'])
      ..itemSequence = (json['itemSequence'] as num?)?.toInt();

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'createdBy': instance.createdBy,
      'status': instance.status,
      'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
      'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
      'itemSequence': instance.itemSequence,
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'prefix': instance.prefix,
      'suffix': instance.suffix,
      'company': instance.company,
      'jobTitle': instance.jobTitle,
      'dateOfBirth': const IsoDateTimeConverter().toJson(instance.dateOfBirth),
      'avatar': instance.avatar,
      'registeredDate': const IsoDateTimeConverter().toJson(
        instance.registeredDate,
      ),
      'mobileNumber': instance.mobileNumber,
      'internationalNumber': instance.internationalNumber,
      'email': instance.email,
      'gender': _$GenderEnumMap[instance.gender],
      'countryCode': instance.countryCode,
      'profileImageUri': instance.profileImageUri,
      'verificationStatus': instance.verificationStatus,
    };

const _$GenderEnumMap = {
  Gender.male: 0,
  Gender.female: 1,
  Gender.other: 2,
  Gender.notSpecified: 3,
};
