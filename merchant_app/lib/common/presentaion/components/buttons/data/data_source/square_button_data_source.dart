import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/app/app.dart' show core;
import 'package:littlefish_merchant/common/presentaion/components/buttons/data/models/square_button_model.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/domain/entity/square_button_entity.dart';

const String squareButtonSettingsKey = 'ui_square_button_settings';

class SquareButtonDataSource {
  SquareButtonEntity getConfiguration() {
    try {
      final ConfigService configService = core.get<ConfigService>();

      // Fetch the JSON object from the config service
      var layout = configService.getObjectValue(
        key: squareButtonSettingsKey,
        defaultValue: {},
      );

      // If empty, use local default
      if (layout.isEmpty) {
        layout = getDefaultMap();
      }

      // Parse the map into our Entity
      final entity = SquareButtonModel().fromJson(layout);

      return entity;
    } catch (e) {
      var layout = getDefaultMap();
      final entity = SquareButtonModel().fromJson(layout);
      return entity;
    }
  }

  /// Default configuration if remote config is missing
  Map<String, dynamic> getDefaultMap() {
    return {'iconSize': 18.0};
  }
}
