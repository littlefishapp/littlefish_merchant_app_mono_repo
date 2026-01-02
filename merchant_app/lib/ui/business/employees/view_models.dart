// Flutter imports:
// remove ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/staff/employee.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/redux/business/business_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class EmployeeListVM extends StoreCollectionViewModel<Employee, BusinessState> {
  EmployeeListVM.fromStore(Store<AppState> store) : super.fromStore(store);

  @override
  List<Employee> get items =>
      store!.state.businessState.employees ?? <Employee>[];

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.businessState;
    selectedItem = store.state.employeeUiState?.item?.item;
    isNew = store.state.employeeUiState?.item?.isNew;

    onSetSelected = (item) => store.dispatch(EmployeeSelectAction(item));
    onAdd = (item, ctx) => store.dispatch(updateOrSaveEmployee(item));
    onRemove = (item, ctx) => store.dispatch(
      removeEmployee(
        item,
        completer: snackBarCompleter(
          ctx,
          '${item.displayName} was removed',
          shouldPop: false,
        ),
      ),
    );

    onRefresh = () => store.dispatch(getEmployees(refresh: true));

    isLoading = state!.isLoading;
    hasError = state!.hasError;
  }
}

class EmployeeVM extends StoreItemViewModel<Employee?, BusinessState> {
  EmployeeVM.fromStore(Store<AppState> store) : super.fromStore(store);

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.businessState;
    isLoading = state!.isLoading;
    hasError = state!.hasError;

    onAdd = (item, ctx) {
      store.dispatch(
        updateOrSaveEmployee(
          item,
          completer: snackBarCompleter(
            ctx!,
            '${item!.displayName} saved successfully!',
            shouldPop: true,
          ),
        ),
      );
    };

    onRemove = (item, ctx) => store.dispatch(
      removeEmployee(
        item,
        completer: snackBarCompleter(
          ctx,
          '${item!.displayName} was removed',
          shouldPop: true,
        ),
      ),
    );

    item = store.state.employeeUiState?.item?.item;
    isNew = store.state.employeeUiState?.item?.isNew;
  }
}
