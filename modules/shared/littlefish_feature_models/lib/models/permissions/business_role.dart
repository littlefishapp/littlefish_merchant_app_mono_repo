import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'business_role.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class BusinessRole extends TimeStampedEntity {
  String? name, description, businessId;
  bool? systemRole;
  List<String>? permissions;

  BusinessRole({
    this.name,
    this.description,
    this.businessId,
    this.permissions,
    this.systemRole,
  });

  BusinessRole.create({required String businessId, required String createdBy}) {
    deleted = false;
    createdBy = createdBy;
    systemRole = false;
    businessId = businessId;
    dateCreated = DateTime.now().toUtc();
    permissions = [];
  }

  factory BusinessRole.fromJson(Map<String, dynamic> json) =>
      _$BusinessRoleFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessRoleToJson(this);
}
