// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/workspaces/workspace.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';

ThunkAction<AppState> fetchWorkspaces() {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SetWorkspaceLoadingAction(true));
      //TODO(lampian): add this to to feature flag
      String config =
          '''[{"name":"Store","navbarConfig":[{"pageType":"Home","description":"Home"},{"pageType":"Sell","description":"Sell"},{"pageType":"Sales","description":"History"},{"pageType":"Orders","description":"Orders"},{"pageType":"GetPaid","description":"Get Paid"}]},{"name":"Management","navbarConfig":[{"pageType":"Home","description":"Home"},{"pageType":"Products","description":"Products"},{"pageType":"Stock","description":"Stock"},{"pageType":"EStore","description":"e-Store"},{"pageType":"More","description":"Manage"}]}]''';
      List<dynamic> parsedJsonArray = jsonDecode(config);
      var storeWorkspaceList =
          (parsedJsonArray[0]?['navbarConfig'] as List<dynamic>);
      var manageWorkspaceList =
          (parsedJsonArray[1]?['navbarConfig'] as List<dynamic>);

      if (userHasPermission(allowTransactionHistory) == false) {
        storeWorkspaceList.removeWhere(
          (element) => element.toString().toLowerCase().contains('History'),
        );
        parsedJsonArray[0]['navbarConfig'] = storeWorkspaceList;
      }

      if (userHasPermission(allowOrder) == false) {
        storeWorkspaceList.removeWhere(
          (element) => element.toString().toLowerCase().contains('orders'),
        );
        parsedJsonArray[0]['navbarConfig'] = storeWorkspaceList;
      }

      if (userHasPermission(allowProduct) == false) {
        manageWorkspaceList.removeWhere(
          (element) => element.toString().toLowerCase().contains('products'),
        );
        parsedJsonArray[1]['navbarConfig'] = manageWorkspaceList;
      }

      if (userHasPermission(allowInventoryStock) == false) {
        manageWorkspaceList.removeWhere(
          (element) => element.toString().toLowerCase().contains('stock'),
        );
        parsedJsonArray[1]['navbarConfig'] = manageWorkspaceList;
      }

      if (userHasPermission(allowOnlineStore) == false) {
        manageWorkspaceList.removeWhere(
          (element) => element.toString().toLowerCase().contains('estore'),
        );
        parsedJsonArray[1]['navbarConfig'] = manageWorkspaceList;
      }

      if ((userHasPermission(allowInvoice) == false) &&
          (userHasPermission(allowPaymentLink) == false) &&
          !AppVariables.enableGetPaid) {
        storeWorkspaceList.removeWhere(
          (element) => element.toString().toLowerCase().contains('getpaid'),
        );
        parsedJsonArray[0]['navbarConfig'] = storeWorkspaceList;
      }

      List<Workspace> workspaces = parsedJsonArray
          .map((item) => Workspace.fromJson(item))
          .toList();
      store.dispatch(SetWorkspaceLoadingAction(false));
      store.dispatch(WorkspacesLoadedAction(workspaces));
      store.dispatch(
        ManageControlSetMenuExpandedStateAction([false, false, false]),
      );
    });
  };
}

ThunkAction<AppState> setActiveWorkspace({
  required Workspace workspace,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SetWorkspaceAction(workspace));
      saveDefaultWorkspace(workspace.name);
      completer?.complete();
    });
  };
}

ThunkAction<AppState> loadDefaultWorkspace() {
  return (Store<AppState> store) async {
    Future(() async {
      var workspaces = store.state.workspaceState.workspaces;
      getDefaultWorkspace().then((defaultWorkspaceName) {
        if (defaultWorkspaceName != null &&
            defaultWorkspaceName.isNotEmpty &&
            workspaces != null) {
          var workspace = workspaces
              .where((w) => w.name == defaultWorkspaceName)
              .first;
          store.dispatch(SetWorkspaceAction(workspace));
        }
      });
    });
  };
}

class SetWorkspaceAction {
  Workspace value;

  SetWorkspaceAction(this.value);
}

class SetWorkspaceLoadingAction {
  bool value;

  SetWorkspaceLoadingAction(this.value);
}

class WorkspacesLoadedAction {
  List<Workspace> value;

  WorkspacesLoadedAction(this.value);
}

//TODO (tshief-littlefishapp) Move value out into own redux state
class ManageControlExpandedStateAction {
  int index;
  bool isOpen;

  ManageControlExpandedStateAction(this.index, this.isOpen);
}

class ManageControlSetMenuExpandedStateAction {
  List<bool> value;

  ManageControlSetMenuExpandedStateAction(this.value);
}
