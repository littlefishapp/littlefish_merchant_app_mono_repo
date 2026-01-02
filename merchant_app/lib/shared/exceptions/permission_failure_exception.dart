class PermissionFailureException implements Exception {
  String message;

  PermissionFailureException({required this.message});
}
