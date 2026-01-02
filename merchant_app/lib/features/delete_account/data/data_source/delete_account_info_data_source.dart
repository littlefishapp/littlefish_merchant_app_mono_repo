import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/delete_account/data/models/delete_account_info_model.dart';
import 'package:littlefish_merchant/features/delete_account/domain/entity/delete_account_info_entity.dart';

class DeleteAccountInfoDataSource {
  DeleteAccountInfoEntity getDeleteAccountInfoConfiguration() {
    final ConfigService configService = core.get<ConfigService>();
    var configMap = configService.getObjectValue(
      // The key is the top-level key for the configuration in the JSON
      key: 'deleteAccount',
      defaultValue: {},
    );

    if (configMap.isEmpty) {
      // use this default value to test configurations
      configMap = getDeleteAccountInfoDefaultMap('sbsa');
    }

    final model = DeleteAccountInfoModel();
    final DeleteAccountInfoEntity entity = model.fromJson(configMap);
    debugPrint('### DeleteAccountInfoConfiguration');
    return entity;
  }
}

/// Default fallback map
Map<String, dynamic> getDeleteAccountInfoDefaultMap(String key) {
  if (key.contains('absa')) {
    return {'deleteAccountAllowed': false, 'deleteAccountActionVisible': true};
  }

  if (key.contains('sbsa')) {
    return {'deleteAccountAllowed': false, 'deleteAccountActionVisible': true};
  }

  // Default fallback values if config is missing
  return {'deleteAccountAllowed': true, 'deleteAccountActionVisible': true};
}
