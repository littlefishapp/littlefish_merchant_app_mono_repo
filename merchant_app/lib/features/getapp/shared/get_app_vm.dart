import 'package:flutter/material.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:redux/redux.dart';

class GetAppVM extends StoreViewModel<AppState> {
  GetAppVM.fromStore(super.store) : super.fromStore();

  late String appUrl;
  late bool getAppEnabled;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    state = store!.state;

    LittleFishCore core = LittleFishCore.instance;

    final ConfigService configService = core.get<ConfigService>();

    appUrl = configService.getStringValue(
      key: 'config_app_download_url',
      defaultValue: 'https://littlefishapp.com/',
    );

    getAppEnabled = configService.getBoolValue(
      key: 'feature_get_app_enabled',
      defaultValue: false,
    );
  }
}
