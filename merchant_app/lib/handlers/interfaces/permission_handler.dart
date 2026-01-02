abstract class PermissionHandler {
  bool hasPermission(String permissionName);

  Future<void> populatePermissionData({String? roleId});

  bool hasRole(String roleName);
}
