import 'package:littlefish_merchant/ui/business/organisation/organisation_info/organisation_info_entity.dart';

class OrganisationInfoModel {
  OrganisationInfoEntity fromJson(Map<String, dynamic> json) {
    return OrganisationInfoEntity(
      name: json['name'] ?? '',
      domain: json['domain'] ?? '',
    );
  }

  Map<String, dynamic> toJson(OrganisationInfoEntity entity) {
    return {'name': entity.name, 'domain': entity.domain};
  }
}
