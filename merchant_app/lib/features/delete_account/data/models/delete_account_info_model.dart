import 'package:littlefish_merchant/features/delete_account/domain/entity/delete_account_info_entity.dart';

class DeleteAccountInfoModel {
  DeleteAccountInfoEntity fromJson(Map<String, dynamic> json) {
    // Note: The original JSON had a typo 'deleteAccountActionVisible: "true"'.
    // Assuming boolean types for boolean-sounding keys.
    return DeleteAccountInfoEntity(
      deleteAccountAllowed: json['deleteAccountAllowed'] ?? false,
      deleteAccountActionVisible: json['deleteAccountActionVisible'] ?? false,
    );
  }

  Map<String, dynamic> toJson(DeleteAccountInfoEntity entity) {
    return {
      'deleteAccountAllowed': entity.deleteAccountAllowed,
      'deleteAccountActionVisible': entity.deleteAccountActionVisible,
    };
  }
}
