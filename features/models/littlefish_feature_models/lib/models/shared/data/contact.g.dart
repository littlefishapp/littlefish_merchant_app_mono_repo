// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
  (json['contactDetails'] as List<dynamic>?)
      ?.map((e) => ContactDetail.fromJson(e as Map<String, dynamic>))
      .toList(),
  json['id'] as String?,
  json['lastName'] as String?,
  json['name'] as String?,
  json['title'] as String?,
);

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'lastName': instance.lastName,
  'title': instance.title,
  'contactDetails': instance.contactDetails,
};

ContactDetail _$ContactDetailFromJson(Map<String, dynamic> json) =>
    ContactDetail(
      isPrimary: json['isPrimary'] as bool?,
      label: json['label'] as String?,
      value: json['value'] as String?,
      isEmail: json['isEmail'] as bool?,
    );

Map<String, dynamic> _$ContactDetailToJson(ContactDetail instance) =>
    <String, dynamic>{
      'isPrimary': instance.isPrimary,
      'label': instance.label,
      'value': instance.value,
      'isEmail': instance.isEmail,
    };
