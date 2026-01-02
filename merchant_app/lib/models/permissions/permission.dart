import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'permission.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class Permission extends TimeStampedEntity {
  String? name, description, permissionGroupId, subGroupName;
  bool? enabled;

  Permission({
    this.name,
    this.description,
    this.permissionGroupId,
    this.subGroupName,
    this.enabled,
  });

  factory Permission.fromJson(Map<String, dynamic> json) =>
      _$PermissionFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionToJson(this);
}
