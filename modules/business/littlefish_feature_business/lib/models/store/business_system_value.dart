// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'business_system_value.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class BusinessSystemValue {
  String? id;
  String? businessId;
  String? key;
  String? sectionKey;
  dynamic value;
  DateTime? lastUpdated;

  BusinessSystemValue({
    this.businessId,
    this.id,
    this.key,
    this.lastUpdated,
    this.value,
    this.sectionKey,
  });

  factory BusinessSystemValue.fromJson(Map<String, dynamic> json) =>
      _$BusinessSystemValueFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessSystemValueToJson(this);
}
