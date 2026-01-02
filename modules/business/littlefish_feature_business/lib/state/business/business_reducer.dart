// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/shared/data/address.dart';
import 'package:littlefish_merchant/models/shared/data/contact.dart';
import 'package:littlefish_merchant/models/staff/employee.dart';
import 'package:littlefish_merchant/models/store/receipt_data.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/redux/business/business_state.dart';
import 'package:littlefish_merchant/redux/ui/ui_entity_state.dart';

final businessProfileReducer = combineReducers<BusinessState>([
  TypedReducer<BusinessState, SetBusinessStateLoadingAction>(onSetLoading).call,
  TypedReducer<BusinessState, BusinessProfileLoadFailure>(
    onProfileFailure,
  ).call,
  TypedReducer<BusinessState, BusinessProfileLoadedAction>(
    onSetBusinessProfile,
  ).call,
  TypedReducer<BusinessState, SetBusinessListAction>(onSetBusinesses).call,
  TypedReducer<BusinessState, BusinessUsersLoadedAction>(onUsersLoaded).call,
  TypedReducer<BusinessState, SetSelectedBusinessAction>(
    onSetSelectedBusiness,
  ).call,
  TypedReducer<BusinessState, BusinessTypesLoadedAction>(
    onSetBusinessTypes,
  ).call,
  TypedReducer<BusinessState, EmployeeChangedAction>(
    onBusinessEmployeeChanged,
  ).call,
  TypedReducer<BusinessState, EmployeesLoadedAction>(onEmployeesLoaded).call,
  TypedReducer<BusinessState, SetStoreCreditEnabledAction>(
    onSetStoreCreditEnabledAction,
  ).call,
  TypedReducer<BusinessState, BusinessUserChangedAction>(
    onBusinessUserChangedTop,
  ).call,
  TypedReducer<BusinessState, BusinessUsersUpdateAction>(
    onBusinessUsersUpdateAction,
  ).call,
  TypedReducer<BusinessState, SetBusinessPermissionsListAction>(
    onSetBusinessPermissions,
  ).call,
  TypedReducer<BusinessState, SetBusinessLinkedAccountsAction>(
    onSetBusinessLinkedAccountsAction,
  ).call,
  TypedReducer<BusinessState, SetBusinessSalesChannelsAction>(
    onSetBusinessSalesChannelsAction,
  ).call,
  TypedReducer<BusinessState, SignoutAction>(clearState).call,
  TypedReducer<BusinessState, SetVerificationStatusAction>(
    onSetVerificationStatusAction,
  ).call,
  TypedReducer<BusinessState, SetUsersBusinessRoles>(
    onSetUserBusinessRoles,
  ).call,
  TypedReducer<BusinessState, SetUsersBusinessRolesFailure>(
    onSetUsersBusinessRolesFailure,
  ).call,
  TypedReducer<BusinessState, UpdateUsersBusinessRoles>(
    onUpdateUserBusinessRoles,
  ).call,
  TypedReducer<BusinessState, UpdateUsersBusinessRolesFailure>(
    onUpdateUsersBusinessRolesFailure,
  ).call,
  TypedReducer<BusinessState, RemoveFromUsersBusinessRoles>(
    onRemoveUsersBusinessRoles,
  ).call,
]);

BusinessState onSetBusinessPermissions(
  BusinessState state,
  SetBusinessPermissionsListAction action,
) => state.rebuild((b) => b.businessUsers = action.value);

BusinessState onSetStoreCreditEnabledAction(
  BusinessState state,
  SetStoreCreditEnabledAction action,
) => state.rebuild((b) => b.profile!.storeCreditSettings = action.value);

BusinessState onSetBusinessLinkedAccountsAction(
  BusinessState state,
  SetBusinessLinkedAccountsAction action,
) => state.rebuild((b) {
  b.profile!.linkedAccounts = action.value;
  if (action.toggleIsLoading) {
    b.isLoading = !(b.isLoading ?? true);
  }
});

BusinessState onSetBusinessSalesChannelsAction(
  BusinessState state,
  SetBusinessSalesChannelsAction action,
) => state.rebuild((b) => b.profile!.salesChannels = action.value);

BusinessState onBusinessUserChangedTop(
  BusinessState state,
  BusinessUserChangedAction action,
) => state.rebuild(
  (b) => b.users = action.type == ChangeType.removed
      ? _removeUser(b.users, action.value)
      : _addOrUpdateUser(b.users, action.value),
);

BusinessState onBusinessUsersUpdateAction(
  BusinessState state,
  BusinessUsersUpdateAction action,
) => state.rebuild((b) {
  b.hasError = false;
  b.errorMessage = null;
  b.users = action.type == ChangeType.removed
      ? _removeUser(b.users, action.value)
      : _addOrUpdateUser(b.users, action.value);
});

BusinessState onUsersLoaded(
  BusinessState state,
  BusinessUsersLoadedAction action,
) => state.rebuild((b) => b.users = action.value);

BusinessState clearState(BusinessState state, SignoutAction action) =>
    state.rebuild((b) {
      b.businesses = null;
      b.businessId = null;
      b.usersBusinessRoles = null;
      b.employees = [];
      b.isLoading = false;
      b.hasError = false;
      b.errorMessage = null;
      b.users = [];
      b.businessUsers = [];
      b.profile = null;
    });

BusinessState onSetBusinesses(
  BusinessState state,
  SetBusinessListAction action,
) => state.rebuild((b) => b.businesses = action.value);

BusinessState onSetSelectedBusiness(
  BusinessState state,
  SetSelectedBusinessAction action,
) => state.rebuild((b) {
  b.businessId = action.value?.id;
  b.employees = b.employees?..removeWhere((e) => e.businessId != b.businessId);
});

BusinessState onSetBusinessTypes(
  BusinessState state,
  BusinessTypesLoadedAction action,
) {
  return state.rebuild((b) {
    b.types = action.value;
  });
}

BusinessState onSetBusinessProfile(
  BusinessState state,
  BusinessProfileLoadedAction action,
) {
  if (action.value != null) {
    //set the default values
    action.value!.contacts = action.value!.contacts ?? <Contact>[];
    action.value!.address = action.value!.address ?? Address();
    action.value!.receiptData = action.value!.receiptData ?? ReceiptData();
    action.value!.contactDetails =
        action.value!.contactDetails ??
        ContactDetail(
          isPrimary: true,
          label: 'Telephone',
          value: '',
          isEmail: false,
        );
  }

  return state.rebuild((b) {
    b.profile = action.value;
  });
}

BusinessState onProfileFailure(
  BusinessState state,
  BusinessProfileLoadFailure action,
) => state.rebuild((b) {
  b.errorMessage = action.value;
  b.hasError = true;
});

BusinessState onSetLoading(
  BusinessState state,
  SetBusinessStateLoadingAction action,
) => state.rebuild((b) {
  b.isLoading = action.value;
});

BusinessState onBusinessEmployeeChanged(
  BusinessState state,
  EmployeeChangedAction action,
) => state.rebuild((b) {
  var emps = action.type == ChangeType.removed
      ? _removeItem(b.employees ?? <Employee>[], action.value)
      : _addOrUpdateItem(b.employees ?? <Employee>[], action.value);
  b.employees = emps.cast<Employee>();
});

BusinessState onEmployeesLoaded(
  BusinessState state,
  EmployeesLoadedAction action,
) => state.rebuild((b) => b.employees = action.value);

BusinessState onSetVerificationStatusAction(
  BusinessState state,
  SetVerificationStatusAction action,
) => state.rebuild((b) => b.verificationStatus = action.verificationStatus);

List<Employee?> _addOrUpdateItem(List<Employee?> state, Employee? item) {
  if (state.isEmpty) {
    state = [item];
    return state;
  }

  var index = state.indexWhere((i) => i!.id == item!.id);
  if (index >= 0) {
    return state..[index] = item;
  } else {
    return state..add(item);
  }
}

List _removeItem(List<Employee> state, Employee? item) {
  if (state.isEmpty) return [];
  state.removeWhere((i) => i.newID == item!.newID);

  return state;
}

List<BusinessUser?> _addOrUpdateUser(
  List<BusinessUser?>? state,
  BusinessUser? item,
) {
  if (state == null || state.isEmpty) {
    state = [item];
    return state;
  }

  var index = state.indexWhere((i) => i!.id == item!.id);
  if (index >= 0) {
    return state..[index] = item;
  } else {
    return state..add(item);
  }
}

List<BusinessUser?>? _removeUser(
  List<BusinessUser?>? state,
  BusinessUser? item,
) {
  if (state == null || state.isEmpty) {
    return state;
  }
  state.removeWhere((i) => i!.id == item!.id);
  return state;
}

final employeeUIReducer = combineReducers<EmployeesUIState>([
  TypedReducer<EmployeesUIState, EmployeeChangedAction>(onEmployeeChanged).call,
  TypedReducer<EmployeesUIState, EmployeeCreateAction>(onCreateEmployee).call,
  TypedReducer<EmployeesUIState, EmployeeEditAction>(onEditEmployee).call,
  TypedReducer<EmployeesUIState, EmployeeSelectAction>(onSelectEmployee).call,
]);

EmployeesUIState onEmployeeChanged(
  EmployeesUIState state,
  EmployeeChangedAction action,
) {
  return state.rebuild(
    (b) => b.item = UIEntityState(Employee.create(), isNew: true),
  );
}

EmployeesUIState onCreateEmployee(
  EmployeesUIState state,
  EmployeeCreateAction action,
) {
  return state.rebuild(
    (b) => b.item = UIEntityState(Employee.create(), isNew: true),
  );
}

EmployeesUIState onEditEmployee(
  EmployeesUIState state,
  EmployeeEditAction action,
) => state.rebuild((b) => b.item = UIEntityState(action.value, isNew: false));

EmployeesUIState onSelectEmployee(
  EmployeesUIState state,
  EmployeeSelectAction action,
) {
  return state.rebuild((b) {
    // if (b.item.item == action.value)
    //   b.item = UIEntityState(
    //     Employee.create(),
    //     isNew: true,
    //   );
    // else
    b.item = UIEntityState(action.value, isNew: false);
  });
}

final businessUserUIStateReducer = combineReducers<BusinessUsersUIState>([
  TypedReducer<BusinessUsersUIState, BusinessUsersLoadedAction>(
    onBusinessUsersLoaded,
  ).call,
  TypedReducer<BusinessUsersUIState, BusinessUserChangedAction>(
    onBusinessUserChanged,
  ).call,
  TypedReducer<BusinessUsersUIState, BusinessUserSelectedAction>(
    onBusinessUserSelected,
  ).call,
  TypedReducer<BusinessUsersUIState, BusinessUserCreateAction>(
    onCreateBusinessUser,
  ).call,
]);

BusinessUsersUIState onBusinessUsersLoaded(
  BusinessUsersUIState state,
  BusinessUsersLoadedAction action,
) => state.rebuild(
  (b) =>
      b.item = UIEntityState<BusinessUser>(BusinessUser.create(), isNew: true),
);

BusinessUsersUIState onBusinessUserSelected(
  BusinessUsersUIState state,
  BusinessUserSelectedAction action,
) => state.rebuild((b) {
  b.item = UIEntityState<BusinessUser?>(action.value, isNew: false);
});

BusinessUsersUIState onBusinessUserChanged(
  BusinessUsersUIState state,
  BusinessUserChangedAction action,
) => onCreateBusinessUser(state, BusinessUserCreateAction());

BusinessUsersUIState onCreateBusinessUser(
  BusinessUsersUIState state,
  BusinessUserCreateAction action,
) => state.rebuild(
  (b) =>
      b.item = UIEntityState<BusinessUser>(BusinessUser.create(), isNew: true),
);

BusinessState onSetUserBusinessRoles(
  BusinessState state,
  SetUsersBusinessRoles action,
) => state.rebuild((b) => b.usersBusinessRoles = action.userBusinessRoles);

BusinessState onSetUsersBusinessRolesFailure(
  BusinessState state,
  SetUsersBusinessRolesFailure action,
) => state.rebuild((b) {
  b.errorMessage = action.value;
  b.hasError = true;
});

BusinessState onUpdateUserBusinessRoles(
  BusinessState state,
  UpdateUsersBusinessRoles action,
) => state.rebuild((b) {
  if (action.oldRoleId != null && action.newBusinessRole != null) {
    b.usersBusinessRoles?.removeWhere(
      (element) => element.id == action.oldRoleId,
    );
    b.usersBusinessRoles?.add(action.newBusinessRole!);
  }
});

BusinessState onUpdateUsersBusinessRolesFailure(
  BusinessState state,
  UpdateUsersBusinessRolesFailure action,
) => state.rebuild((b) {
  b.errorMessage = action.value;
  b.hasError = true;
});

BusinessState onRemoveUsersBusinessRoles(
  BusinessState state,
  RemoveFromUsersBusinessRoles action,
) => state.rebuild((b) {
  if (action.userBusinessRoles?.isNotEmpty ?? false) {
    b.usersBusinessRoles?.removeWhere(
      (element) => action.userBusinessRoles!.contains(element),
    );
  }
});
