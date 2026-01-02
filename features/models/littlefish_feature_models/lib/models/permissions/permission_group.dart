import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'permission_group.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class PermissionGroup extends TimeStampedEntity {
  String? name, description, subGroupName;

  PermissionGroup({this.name, this.description, this.subGroupName});

  factory PermissionGroup.fromJson(Map<String, dynamic> json) =>
      _$PermissionGroupFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionGroupToJson(this);
}
