import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/domain/entity/square_button_entity.dart';

class SquareButtonModel {
  SquareButtonEntity fromJson(Map<String, dynamic> json) {
    try {
      return SquareButtonEntity(iconSize: _parseDouble(json['iconSize'], 18.0));
    } catch (e) {
      // returning default entity in case of error
      return SquareButtonEntity();
    }
  }

  double _parseDouble(dynamic value, double defaultValue) {
    try {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? defaultValue;
      return defaultValue;
    } catch (e) {
      var logger =
          LittleFishCore.instance.get<LoggerService>() as LoggerService;
      logger.error(
        this,
        'Something went wrong while parsing double for SquareButtonModel for remote config of square buttons. Returning default values.',
        error: e,
        stackTrace: StackTrace.current,
      );
      return defaultValue;
    }
  }

  Map<String, dynamic> toJson(SquareButtonEntity entity) {
    return {'iconSize': entity.iconSize};
  }
}
