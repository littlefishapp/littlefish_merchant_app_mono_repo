// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/HomePage/online_store_main_home_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/HomePage/online_store_setup_home_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/viewmodels/manage_store_vm_v2.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';

import '../../common/presentaion/components/app_progress_indicator.dart';

class OnlineStoreRouterPage extends StatefulWidget {
  static const String route = 'business/online-store-router';

  const OnlineStoreRouterPage({Key? key}) : super(key: key);

  @override
  State<OnlineStoreRouterPage> createState() => _OnlineStoreRouterPageState();
}

class _OnlineStoreRouterPageState extends State<OnlineStoreRouterPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVMv2>(
      converter: (store) => ManageStoreVMv2.fromStore(store),
      onInit: (store) {
        if (store.state.storeState.store == null) {
          store.dispatch(setCurrentStore(store.state.businessId));
        }
      },
      builder: (BuildContext context, ManageStoreVMv2 vm) {
        if (vm.isLoading == true) {
          return const Scaffold(body: Center(child: AppProgressIndicator()));
        }

        if (AppVariables.store?.state.enableStoreSetupV2 == true) {
          return getOnlineStorePage(
            AppVariables.store!.state.storeState.store?.isConfigured ?? false,
          );
        } else {
          return isTrue(vm.item?.isConfigured)
              ? const OnlineStoreMainHomePage()
              : const OnlineStoreSetupHomePage();
        }
      },
    );
  }
}
