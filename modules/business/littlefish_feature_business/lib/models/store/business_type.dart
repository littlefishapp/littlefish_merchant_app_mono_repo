// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'business_type.g.dart';

@JsonSerializable(explicitToJson: true)
@IsoDateTimeConverter()
class BusinessType {
  BusinessType({
    this.description,
    this.enabled,
    this.id,
    this.name,
    this.subTypes,
  });

  String? id, name, description;

  bool? enabled;

  List<BusinessType>? subTypes;

  factory BusinessType.fromJson(Map<String, dynamic> json) =>
      _$BusinessTypeFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessTypeToJson(this);
}
