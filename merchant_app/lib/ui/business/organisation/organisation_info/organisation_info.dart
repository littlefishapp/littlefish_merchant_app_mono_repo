import 'package:littlefish_merchant/ui/business/organisation/organisation_info/organisation_info_data_source.dart';
import 'package:littlefish_merchant/ui/business/organisation/organisation_info/organisation_info_entity.dart';

class _GetOrganisationInfo {
  final OrganisationInfoDataSource dataSource = OrganisationInfoDataSource();
  OrganisationInfoEntity build() {
    final entity = dataSource.getOrganisationInfoConfiguration();
    return entity;
  }
}

OrganisationInfoEntity getOrganisationInfo() => _GetOrganisationInfo().build();
