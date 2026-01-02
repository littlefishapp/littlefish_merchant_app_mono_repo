// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_frequency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionFrequency _$SubscriptionFrequencyFromJson(
  Map<String, dynamic> json,
) => SubscriptionFrequency(
  low: json['low'] as String,
  medium: json['medium'] as String,
  high: json['high'] as String,
  lowDays: (json['lowDays'] as num).toInt(),
  mediumDays: (json['mediumDays'] as num).toInt(),
  highDays: (json['highDays'] as num).toInt(),
);

Map<String, dynamic> _$SubscriptionFrequencyToJson(
  SubscriptionFrequency instance,
) => <String, dynamic>{
  'low': instance.low,
  'medium': instance.medium,
  'high': instance.high,
  'lowDays': instance.lowDays,
  'mediumDays': instance.mediumDays,
  'highDays': instance.highDays,
};
