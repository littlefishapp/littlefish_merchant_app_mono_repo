// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreBanner _$StoreBannerFromJson(Map<String, dynamic> json) => StoreBanner(
  bannerMessage: json['bannerMessage'] as String?,
  bannerUrl: json['bannerUrl'] as String?,
  enabled: json['enabled'] as bool?,
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
);

Map<String, dynamic> _$StoreBannerToJson(StoreBanner instance) =>
    <String, dynamic>{
      'bannerUrl': instance.bannerUrl,
      'bannerMessage': instance.bannerMessage,
      'enabled': instance.enabled,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };
