// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemGalleryItem _$SystemGalleryItemFromJson(Map<String, dynamic> json) =>
    SystemGalleryItem(
      businessId: json['businessId'] as String?,
      createdBy: json['createdBy'] as String?,
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
      id: json['id'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      isRemoved: json['isRemoved'] as bool?,
      itemAddress: json['itemAddress'] as String?,
      itemUrl: json['itemUrl'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$SystemGalleryItemToJson(SystemGalleryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'type': instance.type,
      'dateCreated': instance.dateCreated?.toIso8601String(),
      'itemUrl': instance.itemUrl,
      'itemAddress': instance.itemAddress,
      'isDeleted': instance.isDeleted,
      'isRemoved': instance.isRemoved,
      'createdBy': instance.createdBy,
    };

SystemCountryConfig _$SystemCountryConfigFromJson(Map<String, dynamic> json) =>
    SystemCountryConfig(
      countryCode: json['countryCode'] as String?,
      enabled: json['enabled'] as bool? ?? false,
      name: json['name'] as String?,
    )..financeMarketActive = json['financeMarketActive'] as bool? ?? false;

Map<String, dynamic> _$SystemCountryConfigToJson(
  SystemCountryConfig instance,
) => <String, dynamic>{
  'countryCode': instance.countryCode,
  'enabled': instance.enabled,
  'financeMarketActive': instance.financeMarketActive,
  'name': instance.name,
};

SystemCreditProvider _$SystemCreditProviderFromJson(
  Map<String, dynamic> json,
) => SystemCreditProvider(
  config: json['config'] as Map<String, dynamic>?,
  enabled: json['enabled'] as bool? ?? true,
  name: json['name'] as String?,
  options:
      (json['options'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$SystemCreditProviderToJson(
  SystemCreditProvider instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'options': instance.options,
  'name': instance.name,
  'config': instance.config,
};

SystemPaymentType _$SystemPaymentTypeFromJson(Map<String, dynamic> json) =>
    SystemPaymentType(
      config: json['config'] as Map<String, dynamic>?,
      displayName: json['displayName'] as String?,
      enabled: json['enabled'] as bool?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      logoUrl: json['logoUrl'] as String?,
      fee: (json['fee'] as num?)?.toDouble() ?? 0,
      feeLimit: (json['feeLimit'] as num?)?.toDouble() ?? 0,
      feeType: json['feeType'] as String? ?? 'fixed',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$SystemPaymentTypeToJson(SystemPaymentType instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'name': instance.name,
      'options': instance.options,
      'displayName': instance.displayName,
      'feeType': instance.feeType,
      'fee': instance.fee,
      'feeLimit': instance.feeLimit,
      'type': instance.type,
      'logoUrl': instance.logoUrl,
      'config': instance.config,
    };

WalletProvider _$WalletProviderFromJson(Map<String, dynamic> json) =>
    WalletProvider(
      name: json['name'] as String?,
      displayName: json['displayName'] as String?,
      description: json['description'] as String?,
      config: json['config'],
      logoUrl: json['logoUrl'] as String?,
      enabled: json['enabled'] as bool? ?? true,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$WalletProviderToJson(WalletProvider instance) =>
    <String, dynamic>{
      'name': instance.name,
      'displayName': instance.displayName,
      'id': instance.id,
      'description': instance.description,
      'logoUrl': instance.logoUrl,
      'config': instance.config,
      'enabled': instance.enabled,
    };

FirebaseIndex _$FirebaseIndexFromJson(Map<String, dynamic> json) =>
    FirebaseIndex(
      fields: (json['fields'] as List<dynamic>?)
          ?.map((e) => FirebaseIndexField.fromJson(e as Map<String, dynamic>))
          .toList(),
      queryScope: json['queryScope'] as String?,
      collectionGroup: json['collectionGroup'] as String?,
    );

Map<String, dynamic> _$FirebaseIndexToJson(FirebaseIndex instance) =>
    <String, dynamic>{
      'collectionGroup': instance.collectionGroup,
      'queryScope': instance.queryScope,
      'fields': instance.fields?.map((e) => e.toJson()).toList(),
    };

FirebaseIndexField _$FirebaseIndexFieldFromJson(Map<String, dynamic> json) =>
    FirebaseIndexField(
      fieldPath: json['fieldPath'] as String?,
      order: json['order'] as String?,
    );

Map<String, dynamic> _$FirebaseIndexFieldToJson(FirebaseIndexField instance) =>
    <String, dynamic>{'fieldPath': instance.fieldPath, 'order': instance.order};
