import 'package:built_value/built_value.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/features/errors/data/models/error_reports.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';

part 'error_state.g.dart';

@immutable
@JsonSerializable()
abstract class ErrorState implements Built<ErrorState, ErrorStateBuilder> {
  factory ErrorState() => _$ErrorState._(
    hasError: false,
    isLoading: false,
    errorReport: null,
    error: null,
    appErrorReportedSuccessfully: false,
  );

  const ErrorState._();

  ErrorReport? get errorReport;

  GeneralError? get error;

  bool get hasError;

  bool get isLoading;

  bool get appErrorReportedSuccessfully;
}
