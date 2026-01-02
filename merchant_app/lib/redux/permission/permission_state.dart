import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/models/permissions/business_role.dart';
import 'package:littlefish_merchant/models/permissions/permission.dart';
import 'package:littlefish_merchant/models/permissions/permission_group.dart';

part 'permission_state.g.dart';

abstract class PermissionState
    implements Built<PermissionState, PermissionStateBuilder> {
  const PermissionState._();

  factory PermissionState() => _$PermissionState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    isNew: false,
    permissions: const <Permission>[],
    userPermissions: <Permission>[],
    permissionGroups: const <PermissionGroup>[],
    roles: <BusinessRole>[],
    currentBusinessRole: null,
  );

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isNew;

  List<Permission>? get permissions;

  List<Permission>? get userPermissions;

  List<PermissionGroup>? get permissionGroups;

  List<BusinessRole>? get roles;

  BusinessRole? get currentBusinessRole;
}
