// project imports
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';

class PublishStoreValidator {
  static PublishStoreValidatorResponse validateStore(ManageStoreVMv2 vm) {
    if (!vm.isProductCatalogueComplete()) {
      return PublishStoreValidatorResponse.noOnlineProducts;
    }
    if (!vm.isBrandInfoComplete()) {
      return PublishStoreValidatorResponse.brandNotConfigured;
    }
    if (!vm.isBusinessInfoSetupComplete()) {
      return PublishStoreValidatorResponse.businessInfoNotConfigured;
    }
    if (!vm.isDeliveryandCollectionComplete()) {
      return PublishStoreValidatorResponse.deliveryAndCollectionNotConfigured;
    }
    if (!vm.isDomainNameComplete) {
      return PublishStoreValidatorResponse.domainNotConfigured;
    }
    if (isFalse(vm.item?.isConfigured)) {
      return PublishStoreValidatorResponse.isConfiguredFalse;
    }

    return PublishStoreValidatorResponse.success;
  }

  static String? getValidationMessage(
    PublishStoreValidatorResponse validationResponse,
  ) {
    switch (validationResponse) {
      case PublishStoreValidatorResponse.success:
        return null;
      case PublishStoreValidatorResponse.brandNotConfigured:
        return 'Please ensure your brand is correctly setup, for example, brand colours.';
      case PublishStoreValidatorResponse.businessInfoNotConfigured:
        return 'Please ensure all required business information is setup.';
      case PublishStoreValidatorResponse.deliveryAndCollectionNotConfigured:
        return 'Please ensure all required delivery and collection is setup.';
      case PublishStoreValidatorResponse.domainNotConfigured:
        return 'Please ensure your domain is set.';
      case PublishStoreValidatorResponse.isConfiguredFalse:
        return 'Please ensure you have completed your online store setup.';
      case PublishStoreValidatorResponse.noOnlineProducts:
        return 'Please ensure you have at least one online product published.';
      default:
        return '';
    }
  }
}
