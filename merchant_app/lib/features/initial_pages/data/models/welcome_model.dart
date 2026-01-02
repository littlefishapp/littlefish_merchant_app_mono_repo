// File: welcome_model.dart
import 'package:littlefish_merchant/features/initial_pages/domain/entities/welcome_entity.dart';

class WelcomeModel {
  WelcomeEntity fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is String) {
        return value.toLowerCase() == 'true';
      }
      return false; // default fallback
    }

    List<String> parseStringList(dynamic value) {
      if (value is List) {
        return value.map((e) => e?.toString() ?? '').toList();
      }
      return [];
    }

    List<double> parseDoubleList(dynamic value) {
      if (value is List) {
        return value.map((e) {
          if (e is double) return e;
          if (e is String) return double.tryParse(e) ?? 0.0;
          return 0.0;
        }).toList();
      }
      return [];
    }

    String parseSize(dynamic value, {String defaultValue = 'medium'}) {
      if (value is String) return value.toLowerCase();
      return defaultValue;
    }

    return WelcomeEntity(
      inverseColour: parseBool(json['inverseColour']),
      topRow: parseStringList(json['topRow']),
      middleRow: parseStringList(json['middleRow']),
      bottomRow: parseStringList(json['bottomRow']),
      topWeight: parseStringList(json['topWeight']),
      middleWeight: parseStringList(json['middleWeight']),
      bottomWeight: parseStringList(json['bottomWeight']),
      topSize: parseSize(json['topSize'], defaultValue: 'xsmall'),
      middleSize: parseSize(json['middleSize']),
      bottomSize: parseSize(json['bottomSize']),
      componentPadding: parseDoubleList(json['componentPadding']),
    );
  }

  Map<String, dynamic> toJson(WelcomeEntity entity) {
    return {
      'inverseColour': entity.inverseColour,
      'topRow': entity.topRow,
      'middleRow': entity.middleRow,
      'bottomRow': entity.bottomRow,
      'topWeight': entity.topWeight,
      'middleWeight': entity.middleWeight,
      'bottomWeight': entity.bottomWeight,
      'topSize': entity.topSize,
      'middleSize': entity.middleSize,
      'bottomSize': entity.bottomSize,
      'componentPadding': entity.componentPadding,
    };
  }
}
