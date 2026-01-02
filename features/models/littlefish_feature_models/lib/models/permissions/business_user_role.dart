import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'business_user_role.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class BusinessUserRole extends TimeStampedEntity {
  String? roleId, businessUserId, businessId;

  BusinessUserRole({this.roleId, this.businessUserId, this.businessId});

  BusinessUserRole.create() {
    dateUpdated = DateTime.now();
    dateCreated = DateTime.now();
    deleted = false;
  }

  factory BusinessUserRole.fromJson(Map<String, dynamic> json) =>
      _$BusinessUserRoleFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessUserRoleToJson(this);
}
