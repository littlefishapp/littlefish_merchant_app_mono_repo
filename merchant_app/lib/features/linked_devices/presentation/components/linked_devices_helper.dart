import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/terminal_management/models/terminal.dart';

import '../../../../tools/helpers/auth_helper.dart';

class LinkedDevicesHelper {
  static int onLinePeriod() {
    final ConfigService configService = core.get<ConfigService>();

    final onlineValue = configService.getStringValue(
      key: 'terminal_online_period',
      defaultValue: '120',
    );

    final onlinePeriod = int.tryParse(onlineValue) ?? 120;
    return onlinePeriod;
  }

  static bool isOnline({required Terminal terminal, onLinePeriod = 120}) {
    if (onLinePeriod <= 0) {
      return true;
    }

    final triggerTime = DateTime.now().toUtc().subtract(
      Duration(minutes: onLinePeriod),
    );
    final lastOnline = terminal.dateUpdated ?? terminal.dateCreated;
    return lastOnline.isAfter(triggerTime);
  }
}
