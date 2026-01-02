import 'package:json_annotation/json_annotation.dart';

class FlexibleDoubleConverter implements JsonConverter<double?, Object?> {
  const FlexibleDoubleConverter();

  @override
  double? fromJson(Object? json) {
    if (json == null) return null;
    if (json is num) return json.toDouble();
    if (json is String) return double.tryParse(json);
    return null;
  }

  @override
  Object? toJson(double? object) => object;
}
