// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) =>
    Employee(
        dateOfBirth: const IsoDateTimeConverter().fromJson(json['dob']),
        dateOfEmployment: const IsoDateTimeConverter().fromJson(json['doe']),
        email: json['email'] as String?,
        firstName: json['firstName'] as String?,
        gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
        id: json['id'] as String?,
        identityNumber: json['identityNumber'] as String?,
        lastName: json['lastName'] as String?,
        primaryMobile: json['primaryMobile'] as String?,
        secondaryMobile: json['secondaryMobile'] as String?,
        title: json['title'] as String?,
        address: json['address'] == null
            ? null
            : Address.fromJson(json['address'] as Map<String, dynamic>),
        dateOfTermination: const IsoDateTimeConverter().fromJson(json['dot']),
        jobTitle: json['jobTitle'] as String?,
      )
      ..name = json['name'] as String?
      ..description = json['description'] as String?
      ..status = json['status'] as String?
      ..businessId = json['businessId'] as String?
      ..deviceName = json['deviceName'] as String?
      ..dateCreated = const IsoDateTimeConverter().fromJson(json['dateCreated'])
      ..dateUpdated = const IsoDateTimeConverter().fromJson(json['dateUpdated'])
      ..createdBy = json['createdBy'] as String?
      ..updatedBy = json['updatedBy'] as String?
      ..indexNo = (json['indexNo'] as num?)?.toInt()
      ..deleted = json['deleted'] as bool?
      ..enabled = json['enabled'] as bool?;

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'status': instance.status,
  'businessId': instance.businessId,
  'deviceName': instance.deviceName,
  'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
  'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
  'indexNo': instance.indexNo,
  'deleted': instance.deleted,
  'enabled': instance.enabled,
  'id': instance.id,
  'title': instance.title,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'identityNumber': instance.identityNumber,
  'doe': const IsoDateTimeConverter().toJson(instance.dateOfEmployment),
  'dob': const IsoDateTimeConverter().toJson(instance.dateOfBirth),
  'dot': const IsoDateTimeConverter().toJson(instance.dateOfTermination),
  'gender': _$GenderEnumMap[instance.gender],
  'email': instance.email,
  'jobTitle': instance.jobTitle,
  'primaryMobile': instance.primaryMobile,
  'secondaryMobile': instance.secondaryMobile,
  'address': instance.address,
};

const _$GenderEnumMap = {
  Gender.male: 0,
  Gender.female: 1,
  Gender.other: 2,
  Gender.notSpecified: 3,
};
