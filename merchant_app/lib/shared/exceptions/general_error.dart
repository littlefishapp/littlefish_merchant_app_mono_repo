import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/strings.dart';
part 'general_error.g.dart';

@JsonSerializable()
class GeneralError extends Error {
  final String message;
  final String? methodName;
  final Object? error;
  final String? errorCode;

  GeneralError({
    required this.message,
    this.methodName,
    this.error,
    this.errorCode,
  });

  @override
  String toString() {
    var buffer = StringBuffer();
    if (message.isNotEmpty) {
      buffer.writeln(message);
    } else {
      buffer.writeln(error.toString());
    }
    if (isNotBlank(errorCode)) {
      buffer.writeln('ErrorCode: $errorCode');
    }
    return buffer.toString();
  }
}
