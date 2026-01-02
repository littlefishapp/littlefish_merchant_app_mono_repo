import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/security/authentication/api_base_response.dart';
import 'package:littlefish_merchant/models/security/authentication/bank_merchant.dart';
import 'package:quiver/strings.dart';

ApiBaseResponse verifyBankMerchant(BankMerchant merchant) {
  String? contactInfo = verifyContactInformation(merchant);
  String? userInfo = verifyUserInformation(merchant);
  String? businessInfo = verifyBusinessInformation(merchant);
  String? addressInfo = verifyAddressInformation(merchant);

  String? errorMessage;

  if (contactInfo != null) {
    errorMessage = contactInfo;
  } else if (userInfo != null) {
    errorMessage = userInfo;
  } else if (businessInfo != null) {
    errorMessage = businessInfo;
  } else if (addressInfo != null) {
    errorMessage = addressInfo;
  }

  if (errorMessage != null) {
    return ApiBaseResponse(success: false, error: errorMessage);
  }

  return ApiBaseResponse(success: true);
}

String? verifyContactInformation(BankMerchant merchant) {
  if (isBlank(merchant.emailAddress) && isBlank(merchant.mobileNumber)) {
    return 'Contact Information is missing';
  }
  return null;
}

String? verifyAddressInformation(BankMerchant merchant) {
  if (isBlank(merchant.country)) return 'Address Information is missing';
  return null;
}

String? verifyBusinessInformation(BankMerchant merchant) {
  if (isBlank(merchant.businessName) || merchant.businessType == null) {
    return 'Business Details is missing';
  }
  return null;
}

String? verifyUserInformation(BankMerchant merchant) {
  return null;
}

String verifyDefaultValue(String? defaultValue) {
  if (defaultValue == null || defaultValue.isEmpty) {
    return '';
  }

  return defaultValue.substring(defaultValue.length - 10);
}

String formatMidValue(String? defaultValue) {
  if (defaultValue == null || defaultValue.isEmpty) {
    return '';
  }

  int merchantIdLength = AppVariables.store?.state.merchantIdLength ?? 10;
  if (defaultValue.length > merchantIdLength) {
    return defaultValue.substring(defaultValue.length - merchantIdLength);
  } else if (defaultValue.length < merchantIdLength) {
    return defaultValue.padLeft(merchantIdLength, '0');
  } else {
    return defaultValue;
  }
}
