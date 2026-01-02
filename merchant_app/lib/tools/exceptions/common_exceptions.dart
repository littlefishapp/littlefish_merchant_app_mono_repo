class ManagedException implements Exception {
  String? message;

  String? name;

  ManagedException({this.message, this.name});

  @override
  String toString() {
    return message ?? '';
  }
}

class ExceptionResponse implements Exception {
  String? message;

  String? name;

  ExceptionResponse({this.message, this.name});

  @override
  String toString() {
    return message ?? '';
  }
}

class AuthorizationException implements Exception {
  final String error;

  final String description;

  AuthorizationException(this.error, this.description);

  /// Provides a string description of the AuthorizationException.
  @override
  String toString() {
    return description;
  }
}

class NoDataException implements Exception {
  String? message;

  String? name;

  NoDataException({this.message, this.name});

  @override
  String toString() {
    return message ?? '';
  }
}
