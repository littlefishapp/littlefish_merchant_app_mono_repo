// File: drawer_title_model.dart

import 'package:littlefish_merchant/common/presentaion/components/drawers/main_drawer_title.dart/domain/entity/drawer_title_entity.dart';

class DrawerTitleModel {
  DrawerTitleEntity fromJson(Map<String, dynamic> json) {
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

    String parseString(dynamic value, {String defaultValue = ''}) {
      if (value is String) return value;
      return defaultValue;
    }

    return DrawerTitleEntity(
      inverseColour: parseBool(json['inverseColour']),
      texts: parseStringList(json['texts']),
      textSizes: parseStringList(json['textSizes']),
      textWeights: parseStringList(json['textWeights']),
      showIcon: parseBool(json['showIcon']),
      useAssetLogo: parseBool(json['useAssetLogo']),
      padding: parseDoubleList(json['padding']),
    );
  }

  Map<String, dynamic> toJson(DrawerTitleEntity entity) {
    return {
      'inverseColour': entity.inverseColour,
      'texts': entity.texts,
      'textSizes': entity.textSizes,
      'textWeights': entity.textWeights,
      'showIcon': entity.showIcon,
      'useAssetLogo': entity.useAssetLogo,
      'padding': entity.padding,
    };
  }
}
