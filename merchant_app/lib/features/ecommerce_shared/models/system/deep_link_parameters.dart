import 'package:collection/collection.dart' show IterableExtension;
import 'package:json_annotation/json_annotation.dart';

@DeepLinkTypeConverter()
class DeepLinkParameters {
  DeepLinkType? type;
  Map<dynamic, dynamic>? values;
  bool? linkOpenedApp;

  DeepLinkParameters({this.type, this.values, this.linkOpenedApp});

  factory DeepLinkParameters.fromLink(
    Map<dynamic, dynamic> json,
    bool linkOpenedApp,
  ) {
    return DeepLinkParameters(
      type: const DeepLinkTypeConverter().fromJson(json['type']),
      values: json,
      linkOpenedApp: linkOpenedApp,
    );
  }
}

class DeepLinkTypeConverter implements JsonConverter<DeepLinkType?, String> {
  const DeepLinkTypeConverter();

  @override
  DeepLinkType? fromJson(String? json) {
    return DeepLinkType.values.firstWhereOrNull(
      (element) => element.toString().split('.').last == json,
    );
  }

  @override
  String toJson(DeepLinkType? object) {
    return object.toString().split('.').last;
  }
}

enum DeepLinkType { post, product, category, coupon, register, store }
