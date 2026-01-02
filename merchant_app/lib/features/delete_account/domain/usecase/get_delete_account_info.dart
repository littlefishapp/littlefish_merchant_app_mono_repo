import 'package:littlefish_merchant/features/delete_account/data/data_source/delete_account_info_data_source.dart';
import 'package:littlefish_merchant/features/delete_account/domain/entity/delete_account_info_entity.dart';

class _GetDeleteAccountInfo {
  final DeleteAccountInfoDataSource dataSource = DeleteAccountInfoDataSource();
  DeleteAccountInfoEntity build() {
    final entity = dataSource.getDeleteAccountInfoConfiguration();
    return entity;
  }
}

DeleteAccountInfoEntity getDeleteAccountInfo() =>
    _GetDeleteAccountInfo().build();
