// removed ignore: depend_on_referenced_packages, implementation_imports

import 'package:quiver/strings.dart';
import 'package:redux/src/store.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/services/store_service_cf.dart';

class SubDomainValidator {
  final String storeId;
  final Store<AppState> appStore;

  const SubDomainValidator({required this.storeId, required this.appStore});

  Future<SubDomainValidatorResponse> validate(String? subdomain) async {
    if (isBlank(subdomain)) return SubDomainValidatorResponse.emptySubDomain;

    if (!isValidFormat(subdomain!.toLowerCase())) {
      return SubDomainValidatorResponse.invalidSubDomain;
    }
    if (await isSubdomainUnique(subdomain.toLowerCase()) == false) {
      return SubDomainValidatorResponse.notUniqueSubDomain;
    }

    return SubDomainValidatorResponse.success;
  }

  String? getValidationMessage(SubDomainValidatorResponse validationResult) {
    switch (validationResult) {
      case SubDomainValidatorResponse.success:
        return null;
      case SubDomainValidatorResponse.emptySubDomain:
        return 'Please enter a name for your website';
      case SubDomainValidatorResponse.invalidSubDomain:
        return 'Website name has invalid characters.\nOnly letters, numbers and/or dashes (-) are allowed.';
      case SubDomainValidatorResponse.notUniqueSubDomain:
        return 'Website name is already taken, please try a different one.';
      default:
        return '';
    }
  }

  Future<String?> validateAndGetMessage(String? subdomain) async {
    SubDomainValidatorResponse response = await validate(subdomain);
    return getValidationMessage(response);
  }

  bool isValidFormat(String subdomain) {
    final validCharacters = RegExp(r'^[a-zA-Z0-9&-]+$');
    return validCharacters.hasMatch(subdomain);
  }

  Future<bool> isSubdomainUnique(String? subdomain) async {
    return await StoreServiceCF(
      store: appStore,
    ).subdomainExists(storeId, subdomain);
  }
}
