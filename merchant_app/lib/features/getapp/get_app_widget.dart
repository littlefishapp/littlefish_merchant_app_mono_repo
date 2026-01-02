import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/features/getapp/layouts/default/get_app_widget_default.dart';
import 'package:littlefish_merchant/features/getapp/shared/get_app_vm.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

class GetAppWidget extends StatelessWidget {
  const GetAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GetAppVM>(
      converter: (store) => GetAppVM.fromStore(store),
      builder: ((context, vm) {
        return GetAppWidgetDefault(url: vm.appUrl);
      }),
    );
  }
}
