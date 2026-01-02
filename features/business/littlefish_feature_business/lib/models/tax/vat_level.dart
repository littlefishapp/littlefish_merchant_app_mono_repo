import 'package:json_annotation/json_annotation.dart';

part 'vat_level.g.dart';

@JsonSerializable()
class VatLevel {
  VatLevel({
    this.vatLevelId,
    this.name,
    this.rate,
    this.isDefault = false,
    this.isActive = false,
  });

  String? vatLevelId;
  String? name;
  double? rate;
  bool isDefault;
  bool isActive;

  factory VatLevel.fromJson(Map<String, dynamic> json) =>
      _$VatLevelFromJson(json);
  Map<String, dynamic> toJson() => _$VatLevelToJson(this);
}
