class LookupFailure {
  final int? statusCode;
  final String message;
  final Object? error;

  const LookupFailure({this.statusCode, required this.message, this.error});
}

class LookupResult {
  final bool? value; // null when we failed
  final LookupFailure? failure;

  const LookupResult.success(this.value) : failure = null;
  const LookupResult.failure(this.failure) : value = null;

  bool get isSuccess => failure == null;
}
