// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'subscription_frequency.g.dart';

@JsonSerializable()
class SubscriptionFrequency {
  String low, medium, high;
  int lowDays, mediumDays, highDays;

  SubscriptionFrequency({
    required this.low,
    required this.medium,
    required this.high,
    required this.lowDays,
    required this.mediumDays,
    required this.highDays,
  });

  factory SubscriptionFrequency.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFrequencyFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionFrequencyToJson(this);

  factory SubscriptionFrequency.fromJsonRobust(Map<String, dynamic> json) {
    var lowDays = 0;
    if (json.containsKey('lowDays')) {
      final value = json['lowDays'];
      if (value is int) {
        lowDays = value;
      } else if (value is double) {
        lowDays = value.toInt();
      }
    }
    var mediumDays = 0;
    if (json.containsKey('mediumDays')) {
      final value = json['mediumDays'];
      if (value is int) {
        mediumDays = value;
      } else if (value is double) {
        mediumDays = value.toInt();
      }
    }
    var highDays = 0;
    if (json.containsKey('highDays')) {
      final value = json['highDays'];
      if (value is int) {
        highDays = value;
      } else if (value is double) {
        highDays = value.toInt();
      }
    }

    return SubscriptionFrequency(
      low: json['low'] as String,
      medium: json['medium'] as String,
      high: json['high'] as String,
      lowDays: lowDays,
      mediumDays: mediumDays,
      highDays: highDays,
    );
  }
}
