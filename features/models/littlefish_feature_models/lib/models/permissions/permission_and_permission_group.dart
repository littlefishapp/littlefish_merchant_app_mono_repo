import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/permissions/permission.dart';
import 'package:littlefish_merchant/models/permissions/permission_group.dart';
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'permission_and_permission_group.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class PermissionAndPermissionGroup extends TimeStampedEntity {
  List<Permission>? permissions;
  List<PermissionGroup>? permissionGroups;

  PermissionAndPermissionGroup({this.permissions, this.permissionGroups});

  factory PermissionAndPermissionGroup.fromJson(Map<String, dynamic> json) =>
      _$PermissionAndPermissionGroupFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionAndPermissionGroupToJson(this);
}
