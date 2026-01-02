import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/notifications/models/notification_event.dart';
import 'package:littlefish_core/notifications/models/notification_settings.dart';
import 'package:littlefish_core/notifications/services/async_notification_service.dart';
import 'package:littlefish_core/terminal_management/terminal_manager_settings.dart';
import 'package:littlefish_notifications_fcm/firebase_notification_service.dart';
import 'package:littlefish_payments/managers/terminal_manager.dart';
import '../app.dart';

class TerminalInjector {
  static Future<bool> inject({
    void Function(NotificationEvent)? callback,
  }) async {
    LittleFishCore core = LittleFishCore.instance;

    final LoggerService logger = core.get<LoggerService>();

    final ConfigService configService = core.get<ConfigService>();
    try {
      final terminalManager = TerminalManager();

      var terminalsettings = TerminalManagerSettings(
        baseUrl: AppVariables.baseUrl,
        version: 'v1',
      );

      final result = await terminalManager.initialise(
        settings: terminalsettings,
      );

      final packageName = await TerminalManager.getPackageInformation();

      /// fetch terminal ONLY after its been initialised
      final terminal = await terminalManager.getTerminalInfo(
        packageName,
        AppVariables.businessId,
        // autoRegister: true,
      );

      if (!result) {
        logger.warning(
          'TerminalInjector',
          'Unable to initialise terminal manager',
        );
        return false;
      }

      final bool configTerminalManagementEnabled = configService.getBoolValue(
        key: 'config_enable_terminal_management',
        defaultValue: false,
      );
      if (!configTerminalManagementEnabled) {
        logger.error(
          'TerminalInjector',
          'terminal management disabled',
          error: 'terminal management disabled',
          stackTrace: StackTrace.current,
        );
      } else {
        await terminalManager.registerTerminal(packageName, terminal: terminal);

        try {
          await terminalManager.realtimeNotificationInitialise(
            terminal: terminal,
            onRealTimeEvent: (NotificationEvent onRealTimeEvent) async {
              if (onRealTimeEvent.type == 'registerMissingV1') {
                await terminalManager.registerTerminalInNotifications(
                  terminal: terminal,
                );
              } else {
                if (callback != null) {
                  callback(onRealTimeEvent);
                }
              }
            },
            onAsyncEvent: (NotificationEvent onAsyncEvent) {
              //Not required, async events are managed seperately...
            },
          );

          core.registerService<TerminalManager>(instance: terminalManager);
        } catch (realtimeError) {
          logger.error(
            'TerminalInjector',
            'An unexpected error occured whilst initializing the realtime notification client.',
            error: realtimeError,
            stackTrace: StackTrace.current,
          );

          return false;
        }

        try {
          //Async notification client is here, which can feed off the same events (callback(asyncevent))
          FirebaseNotificationService asyncNotificationService =
              FirebaseNotificationService();

          await asyncNotificationService.initialise(
            NotificationSettings(enabled: true),
            (asyncEvent) {
              if (callback != null) {
                callback(asyncEvent);
              }
            },
          );

          core.registerService<AsyncNotificationService>(
            instance: asyncNotificationService,
          );
        } catch (error) {
          logger.error(
            'TerminalInjector',
            'An unexpected error when trying to inject the async notification service',
            error: error,
            stackTrace: StackTrace.current,
          );
        }

        if (terminalManager.isReady) {
          return true;
        }
      }
    } catch (e) {
      logger.error(
        'TerminalInjector',
        'An unexpected error occurred whilst injecting terminal',
        error: e,
        stackTrace: StackTrace.current,
      );
    }

    return false;
  }

  static Future<bool> injectWithNoTerminal({
    void Function(NotificationEvent)? callback,
  }) async {
    LittleFishCore core = LittleFishCore.instance;

    final LoggerService logger = LittleFishCore.instance.get<LoggerService>();

    var terminalsettings = TerminalManagerSettings(
      baseUrl: AppVariables.baseUrl,
      version: 'v1',
    );

    try {
      final terminalManager = TerminalManager();
      await terminalManager.initialise(
        settings: terminalsettings,
        onRealTimeEvent: (p0) {
          debugPrint('### TerminalInjector: $p0');
          if (callback != null) {
            callback(p0);
          }
        },
        onAsyncEvent: (p0) {
          debugPrint('### TerminalInjector: $p0');
        },
      );

      if (terminalManager.isReady &&
          core.isRegistered<TerminalManager>() == false) {
        core.registerLazyService<TerminalManager>(() => terminalManager);

        return true;
      }
    } on Exception catch (e) {
      debugPrint('### TerminalInjector: $e');
      logger.warning(
        'TerminalInjector',
        'An unexpected error occurred whilst injecting terminal',
        error: e,
        stackTrace: StackTrace.current,
      );
    }
    return false;
  }
}
