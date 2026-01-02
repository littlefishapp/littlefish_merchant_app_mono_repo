import 'package:littlefish_merchant/features/store_switching/model/business_store.dart';

import '../../../../models/store/business_profile.dart';
import '../../../../shared/exceptions/general_error.dart';

class LoadBusinessesAction {
  LoadBusinessesAction();
}

class LoadBusinessesSuccessAction {
  final List<BusinessStore> businessStores;
  LoadBusinessesSuccessAction(this.businessStores);
}

class LoadBusinessesFailureAction {
  final GeneralError error;

  LoadBusinessesFailureAction(this.error);
}

class RegisterBusinessAction {
  final BusinessProfile profile;
  final void Function(BusinessProfile?)? onSuccess;
  final void Function(Exception)? onFailure;

  RegisterBusinessAction(this.profile, {this.onSuccess, this.onFailure});
}

class SetBusinessStoresLoadingAction {
  final bool value;

  SetBusinessStoresLoadingAction(this.value);
}
