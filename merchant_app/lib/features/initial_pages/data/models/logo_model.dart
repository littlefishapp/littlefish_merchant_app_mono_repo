// logo_model.dart
import 'package:littlefish_merchant/features/initial_pages/domain/entities/logo_entity.dart';

class LogoModel {
  LogoEntity fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is String) {
        return value.toLowerCase() == 'true';
      }
      return false; // default fallback
    }

    double parseDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0; // default fallback
    }

    return LogoEntity(
      showVersion: parseBool(json['showVersion']),
      centreLogo: parseBool(json['centreLogo']),
      leftPadding: parseDouble(json['leftPadding']),
      topPadding: parseDouble(json['topPadding']),
      bottomPadding: parseDouble(json['bottomPadding']),
      rightPadding: parseDouble(json['rightPadding']),
      height: parseDouble(json['height']),
      width: parseDouble(json['width']),
      useHeight: parseBool(json['useHeight']),
      useWidth: parseBool(json['useWidth']),
      inverseColour: parseBool(json['inverseColour']),
      boxFit: json['boxFit'] ?? 'contain',
    );
  }

  Map<String, dynamic> toJson(LogoEntity entity) {
    return {
      'showVersion': entity.showVersion,
      'centreLogo': entity.centreLogo,
      'leftPadding': entity.leftPadding,
      'topPadding': entity.topPadding,
      'bottomPadding': entity.bottomPadding,
      'rightPadding': entity.rightPadding,
      'height': entity.height,
      'width': entity.width,
      'useHeight': entity.useHeight,
      'useWidth': entity.useWidth,
      'inverseColour': entity.inverseColour,
      'boxFit': entity.boxFit,
    };
  }
}
