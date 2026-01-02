// features/home/data/data_sources/home_header_data_source.dart
import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/ui/home/home_board_header/home_header_model.dart';
import 'package:littlefish_merchant/ui/home/home_board_header/home_header_entity.dart';

class HomeHeaderDataSource {
  HomeHeaderEntity getConfig() {
    try {
      final configService = core.get<ConfigService>();

      var layout = configService.getObjectValue(
        key: 'ui_template_home_board_header',
      );

      debugPrint(
        '#### Templates HomeHeaderDataSource ld rxd : ${!layout.isEmpty}',
      );

      if (layout.isEmpty) {
        layout = _getDefaultMap('sbsa');
      }

      return HomeHeaderModel().fromJson(layout);
    } catch (e) {
      debugPrint('#### $e');
      return HomeHeaderEntity(); // safe fallback
    }
  }

  // Keep returning proper Map<String, dynamic>
  Map<String, dynamic> _getDefaultMap(String flavor) {
    if (flavor == 'sbsa') {
      return {
        'hasDecoratedSurface': true,
        'header1Texts': ['Welcome to,'],
        'header1Weights': ['standard'],
        'header1Sizes': ['normal'],
        'header2Texts': ['Simply', 'BLU'],
        'header2Weights': ['standard', 'bold'],
        'header2Sizes': ['large', 'large'],
        'useBusinessNameForHeader2': false,
        'widgetPadding': [16.0, 0.0, 16.0, 0.0],
        'businessTileEnabled': true,
        'businessTileDashEnabled': false,
        'businessTilePadding': [8.0, 0.0, 4.0, 0.0],
        'businessTileBorderRadius': 8.0,
      };
    }

    return {
      'hasDecoratedSurface': false,
      'header1Texts': ['Welcome', ' ', 'to'],
      'header1Weights': ['', '', ''],
      'header1Sizes': ['medium', 'medium', 'medium'],
      'header2Texts': ['LittleFish', ' ', 'Merchant'],
      'header2Weights': ['bold', 'bold', 'bold'],
      'header2Sizes': ['large', 'large', 'large'],
      'useBusinessNameForHeader2': true,
      'widgetPadding': [0.0, 0.0, 0.0, 0.0],
      'businessTileEnabled': false,
      'businessTileDashEnabled': true,
      'businessTilePadding': [0.0, 0.0, 0.0, 0.0],
      'businessTileBorderRadius': '8.0',
    };
  }
}
