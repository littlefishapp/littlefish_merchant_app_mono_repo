import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/hardware/scanners/littlefish_scanner.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/device/interfaces/device_details.dart';
import 'package:littlefish_payments/models/terminal/terminal_data.dart';
import 'package:redux/redux.dart';

import '../../../../features/pos/data/data_source/pos_service.dart';
import '../../../../redux/app/app_state.dart';

Future<bool> checkPosLaserScanningAvailable(Store<AppState>? store) async {
  LittleFishCore core = LittleFishCore.instance;
  LoggerService logger = LittleFishCore.instance.get<LoggerService>();

  try {
    if (!AppVariables.isPOSBuild) {
      return false;
    }

    if (!core.isRegistered<LittleFishScanner>()) {
      return false;
    }

    if (AppVariables.deviceInfo != null) {
      return deviceSupportsLaserScanning(AppVariables.deviceInfo);
    }

    var posScanService = PosService.fromStore(store: store);

    final terminalInfo = await posScanService.getTerminalInfo();

    return deviceSupportsLaserScanning(terminalInfo);
  } catch (e) {
    logger.error(
      'checkPosLaserScanningAvailable',
      'An error occurred while checking if POS laser scanning is available: $e',
      error: e,
      stackTrace: StackTrace.current,
    );
    return false;
  }
}

bool deviceSupportsLaserScanning(dynamic info) {
  if (info is DeviceDetails) {
    return info.deviceModel?.toLowerCase().contains('920pro') ?? false;
  }

  if (info is TerminalData) {
    return info.modelNumber.toLowerCase().contains('920pro');
  }

  return false;
}
