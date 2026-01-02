import 'package:flutter/material.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/app_settings/app_settings_state.dart';

import 'package:redux/redux.dart';

class ReportCenterVM extends StoreViewModel<AppState> {
  ReportCenterVM.fromStore(super.store) : super.fromStore();

  LittleFishCore core = LittleFishCore.instance;

  LoggerService get logger => core.get<LoggerService>();

  ConfigService get configService => core.get<ConfigService>();

  String get businessId => store?.state.businessState.businessId ?? '';

  String get endPoint => store?.state.reportsUrl ?? '';

  String layout = 'default';

  AppSettingsState get appSettings => store!.state.appSettingsState;

  bool get isPos => appSettings.isPOSBuild;

  String get reportMode => appSettings.reportVersion ?? 'default';

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    state = store?.state;

    if (isPos) {
      layout = configService.getStringValue(
        key: 'config_pos_report_center_layout',
        defaultValue: 'default',
      );
    } else {
      layout = configService.getStringValue(
        key: 'config_app_report_center_layout',
        defaultValue: 'default',
      );
    }
  }
}
