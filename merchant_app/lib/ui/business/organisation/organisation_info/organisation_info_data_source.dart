import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/ui/business/organisation/organisation_info/organisation_info_entity.dart';
import 'package:littlefish_merchant/ui/business/organisation/organisation_info/organisation_info_model.dart';

class OrganisationInfoDataSource {
  OrganisationInfoEntity getOrganisationInfoConfiguration() {
    final ConfigService configService = core.get<ConfigService>();
    var configMap = configService.getObjectValue(
      key: 'organisation_info',
      defaultValue: {},
    );
    if (configMap.isEmpty) {
      // use this default value to test configurations
      configMap = getOrganisationInfoDefaultMap('default');
    }
    final OrganisationInfoModel model = OrganisationInfoModel();
    final OrganisationInfoEntity entity = model.fromJson(configMap);
    debugPrint('### OrganisationInfoConfiguration');
    return entity;
  }
}

/// Do not remove this until testing completed
Map<String, dynamic> getOrganisationInfoDefaultMap(String key) {
  if (key == 'sbsa') {
    return {'name': 'SBSA Organisation', 'domain': 'standardbank.com'};
  }

  if (key == 'absa') {
    return {'name': 'ABSA Organisation', 'domain': 'absa.com'};
  }
  // Default fallback
  return {'name': 'Littlefish', 'domain': 'littlefishapp.com'};
}
