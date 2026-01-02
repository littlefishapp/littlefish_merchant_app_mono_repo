// Package imports:
import 'package:built_value/built_value.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_core/business/models/business.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/app/app.dart';

// Project imports:
import 'package:littlefish_merchant/models/assets/app_assets.dart';

import 'package:littlefish_merchant/models/security/verification.dart';
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/models/staff/employee.dart';

import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/models/store/business_type.dart';
import 'package:littlefish_merchant/redux/ui/ui_entity_state.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/utils/linked_account_utils.dart';

import '../../models/permissions/business_user_role.dart';

part 'business_state.g.dart';

abstract class BusinessState
    implements Built<BusinessState, BusinessStateBuilder> {
  BusinessState._();

  factory BusinessState() => _$BusinessState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    employees: <Employee>[],
    types: <BusinessType>[],
    businesses: <Business>[],
    users: <BusinessUser>[],
    businessUsers: <BusinessUser>[],
    usersBusinessRoles: <BusinessUserRole>[],
  );

  // static Serializer<BusinessState> get serializer => _$businessStateSerializer;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  UserPermissions? get businessPermissions {
    if (businessId == null) return null;

    if (businessUsers == null || businessUsers!.isEmpty) {
      return null;
    }

    if (businessUsers!.any((p) => p.businessId == businessId)) {
      var permissions = businessUsers!
          .firstWhereOrNull((p) => p.businessId == businessId)
          ?.permissions;

      if (permissions != null) {
        permissions.isOwner =
            businessUsers!
                .firstWhereOrNull((user) => user.businessId == businessId)
                ?.role ==
            UserRoleType.owner;
      }

      return permissions;
    } else {
      return null;
    }
  }

  List<Business>? get businesses;

  List<BusinessUser>? get businessUsers;

  String? get businessId;

  BusinessProfile? get profile;

  List<LinkedAccount>? get linkedAccounts => profile?.linkedAccounts;

  List<LinkedAccount> get enabledLinkedAccounts {
    List<LinkedAccount> accounts = List.from(linkedAccounts ?? []);
    var state = AppVariables.store?.state.environmentState.environmentConfig;
    bool zapperEnabled = state?.zapperEnabled ?? false;
    bool snapscanEnabled = state?.snapscanEnabled ?? false;
    bool kycEnabled = state?.enableKYC ?? false;
    bool isCybersourceEnabled = state?.cybersourceEnabled ?? false;
    List<ProviderType> disabledProviders = [];

    if (!zapperEnabled) {
      disabledProviders.add(ProviderType.zapper);
    }
    if (!snapscanEnabled) {
      disabledProviders.add(ProviderType.snapscan);
    }
    if (!kycEnabled) {
      disabledProviders.add(ProviderType.kYC);
    }
    if (!isCybersourceEnabled) {
      disabledProviders.add(ProviderType.cRDB);
    }

    accounts = accounts
        .where(
          (provider) =>
              !disabledProviders.contains(provider.providerType) &&
              ((provider.enabled == true) ||
                  ProviderType.wizzitTapToPay == provider.providerType),
        )
        .toList();

    return accounts;
  }

  // TODO(Michael): These should be pulled from the backend
  List<LinkedAccount> get availableProviders {
    return LinkedAccountUtils.getLinkableAccounts();
  }

  List<SalesChannel>? get salesChannels => profile?.salesChannels;

  List<BusinessType>? get types;

  List<Employee>? get employees;

  List<BusinessUser?>? get users;

  List<BusinessUserRole>? get usersBusinessRoles;

  Verification? get verificationStatus;

  bool isCompleted() {
    return profile?.validate() ?? false;
  }
}

abstract class EmployeesUIState
    implements Built<EmployeesUIState, EmployeesUIStateBuilder> {
  factory EmployeesUIState() {
    return _$EmployeesUIState._(
      item: UIEntityState<Employee>(Employee.create(), isNew: true),
    );
  }

  EmployeesUIState._();

  UIEntityState<Employee>? get item;

  bool get isNew => item?.isNew ?? false;
}

abstract class BusinessUsersUIState
    implements Built<BusinessUsersUIState, BusinessUsersUIStateBuilder> {
  factory BusinessUsersUIState() {
    return _$BusinessUsersUIState._(
      item: UIEntityState<BusinessUser>(BusinessUser.create(), isNew: true),
    );
  }

  BusinessUsersUIState._();

  UIEntityState<BusinessUser?>? get item;

  List<BusinessUserRole>? get userRoles;

  bool get isNew => item?.isNew ?? false;
}
