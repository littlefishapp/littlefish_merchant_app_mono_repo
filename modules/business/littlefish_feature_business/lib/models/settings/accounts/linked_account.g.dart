// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linked_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkedAccount _$LinkedAccountFromJson(Map<String, dynamic> json) =>
    LinkedAccount(
      config: json['config'] as String?,
      deleted: json['deleted'] as bool?,
      createdBy: json['createdBy'] as String?,
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
      updatedBy: json['updatedBy'] as String?,
      dateUpdated: json['dateUpdated'] == null
          ? null
          : DateTime.parse(json['dateUpdated'] as String),
      providerName: json['providerName'] as String?,
      id: json['id'] as String?,
      enabled: json['enabled'] as bool?,
      providerType: $enumDecodeNullable(
        _$ProviderTypeEnumMap,
        json['providerType'],
      ),
      imageURI: json['imageURI'] as String?,
      hasQRCode: json['hasQRCode'] as bool?,
      isQRCodeEnabled: json['isQRCodeEnabled'] as bool?,
      linkedAccountType: $enumDecodeNullable(
        _$LinkedAccountTypeEnumMap,
        json['linkedAccountType'],
      ),
    );

Map<String, dynamic> _$LinkedAccountToJson(
  LinkedAccount instance,
) => <String, dynamic>{
  'providerType': _$ProviderTypeEnumMap[instance.providerType],
  'providerName': instance.providerName,
  'id': instance.id,
  'imageURI': instance.imageURI,
  'hasQRCode': instance.hasQRCode,
  'isQRCodeEnabled': instance.isQRCodeEnabled,
  'config': instance.config,
  'linkedAccountType': _$LinkedAccountTypeEnumMap[instance.linkedAccountType],
  'enabled': instance.enabled,
  'deleted': instance.deleted,
  'dateUpdated': instance.dateUpdated?.toIso8601String(),
  'updatedBy': instance.updatedBy,
  'dateCreated': instance.dateCreated?.toIso8601String(),
  'createdBy': instance.createdBy,
};

const _$ProviderTypeEnumMap = {
  ProviderType.zapper: 0,
  ProviderType.snapscan: 1,
  ProviderType.cRDB: 2,
  ProviderType.kYC: 3,
  ProviderType.pos: 4,
  ProviderType.cybersourceTapToPay: 5,
  ProviderType.wizzitTapToPay: 6,
  ProviderType.fnbECom: 7,
};

const _$LinkedAccountTypeEnumMap = {LinkedAccountType.payment: 0};

SalesChannel _$SalesChannelFromJson(Map<String, dynamic> json) => SalesChannel(
  salesChannelType: $enumDecodeNullable(
    _$SalesChannelTypeEnumMap,
    json['salesChannelType'],
  ),
  config: json['config'] as String?,
  createdBy: json['createdBy'] as String?,
  dateCreated: const IsoDateTimeConverter().fromJson(json['dateCreated']),
  channelName: json['channelName'] as String?,
  dateUpdated: const IsoDateTimeConverter().fromJson(json['dateUpdated']),
  deleted: json['deleted'] as bool?,
  id: json['id'] as String?,
  storeId: json['storeId'] as String?,
  syncItems: json['syncItems'] as bool? ?? true,
  updatedBy: json['updatedBy'] as String?,
  imageUri: json['imageUri'] as String?,
);

Map<String, dynamic> _$SalesChannelToJson(SalesChannel instance) =>
    <String, dynamic>{
      'channelName': instance.channelName,
      'id': instance.id,
      'storeId': instance.storeId,
      'config': instance.config,
      'deleted': instance.deleted,
      'updatedBy': instance.updatedBy,
      'createdBy': instance.createdBy,
      'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
      'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
      'salesChannelType': _$SalesChannelTypeEnumMap[instance.salesChannelType],
      'imageUri': instance.imageUri,
      'syncItems': instance.syncItems,
    };

const _$SalesChannelTypeEnumMap = {SalesChannelType.littleFishEcommerce: 0};
