import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/tools/security/models/DeviceSecurityInformation.dart';
import 'package:safe_device/safe_device.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:downloadsfolder/downloadsfolder.dart'; // Option 1 for Downloads folder
// import 'package:file_saver/file_saver.dart'; // Option 2 for Downloads folder

class AppSecurityValidation {
  LoggerService logger = LittleFishCore.instance.get<LoggerService>();

  // Check if the app is running on a rooted device
  static Future<bool> _checkRootedDevice() async {
    bool isRooted = await SafeDevice.isJailBroken;
    return isRooted;
  }

  // Check if the app is running in developer mode
  static Future<bool> _checkDeveloperMode() async {
    bool isDeveloperMode = await SafeDevice.isDevelopmentModeEnable;
    bool isUsbDebuggingEnabled = await SafeDevice.isUsbDebuggingEnabled;
    return isDeveloperMode || isUsbDebuggingEnabled;
  }

  // Check if mock location is enabled
  static Future<bool> _checkMockLocationEnabled() async {
    bool isMockLocationEnabled = await SafeDevice.isMockLocation;
    return isMockLocationEnabled;
  }

  // Check if the app is running on external storage
  static Future<bool> _checkOnExternalStorage() async {
    bool isOnExternalStorage = await SafeDevice.isOnExternalStorage;
    return isOnExternalStorage;
  }

  // Retrieve device information
  static Future<DeviceSecurityInformation> _getDeviceInformation() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    String? deviceId;
    bool? isVirtualMachine;
    String? deviceLocation = 'Unknown';
    String? deviceModel;
    String? deviceBrand;
    String? deviceBoard;
    String? deviceSoftwareVersion;

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceId = androidInfo.id;
      isVirtualMachine = androidInfo.isPhysicalDevice;
      deviceModel = androidInfo.model;
      deviceBrand = androidInfo.brand;
      deviceBoard = androidInfo.board;
      deviceSoftwareVersion = androidInfo.version.sdkInt.toString();
      try {
        final ip = await InternetAddress.lookup(
          'www.google.com',
        ); //TODO: THIS SHOULD BE CALLING OUR BACKEND
        if (ip.isNotEmpty) {
          deviceLocation = ip.first.address;
        }
      } catch (ipError) {
        deviceLocation = 'Unable to retrieve location';
      }
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceId = iosInfo.identifierForVendor;
      isVirtualMachine = iosInfo.isPhysicalDevice;
      deviceModel = iosInfo.utsname.machine;
      deviceBrand = 'Apple';
      deviceBoard = iosInfo.systemName;
      deviceSoftwareVersion = iosInfo.systemVersion;
    }

    return DeviceSecurityInformation(
      deviceId: deviceId ?? 'Unknown',
      location: deviceLocation,
      isEmulator: isVirtualMachine ?? false,
      deviceModel: deviceModel ?? 'Unknown',
      deviceBrand: deviceBrand ?? 'Unknown',
      deviceBoard: deviceBoard ?? 'Unknown',
      deviceSoftwareVersion: deviceSoftwareVersion ?? 'Unknown',
    );
  }

  // Check device integrity
  Future<bool> checkDeviceIntegrity() async {
    bool hasFailedIntegrityCheck = false;
    bool isRooted = await _checkRootedDevice();
    bool isDeveloperMode = await _checkDeveloperMode();
    bool isMockLocationEnabled = await _checkMockLocationEnabled();
    bool isOnExternalStorage = await _checkOnExternalStorage();
    bool isReleaseBuild = await _isReleaseBuild();
    bool isProdEnvironment = await _isProdEnvironment();
    bool isPosDevice = await _isPosDevice();

    /// The below checks for release builds, if debugging release comment out this code.
    if (isReleaseBuild) {
      /// Checks to see if the app has been tampered with with the following:
      /// - Rooted device
      /// - Developer mode
      /// - Mock location enabled
      /// - On external storage
      /// - Release build
      /// - Production environment
      /// If any of the above checks are true, then the device integrity check has failed
      /// and the app should not be used
      /// If the app is in debug mode, then the device integrity check will not fail
      /// and the app can be used
      if (isPosDevice) {
        hasFailedIntegrityCheck = false;
      } else {
        if (isMockLocationEnabled ||
            isOnExternalStorage ||
            isRooted ||
            isDeveloperMode) {
          final ConfigService configService = core.get<ConfigService>();
          final deviceSecurityCheckEnabled = configService.getBoolValue(
            key: 'isDeviceSecurityCheckEnabled',
            defaultValue: false,
          );
          hasFailedIntegrityCheck = deviceSecurityCheckEnabled;
        }
      }
    }

    if (hasFailedIntegrityCheck) {
      DeviceSecurityInformation deviceInfo = await _getDeviceInformation();

      debugPrint('Warning: Device integrity check failed!');
      logger.error(
        'app-security-validation.checkDeviceIntegrity()',
        'Device integrity check failed: Rooted: $isRooted, Developer Mode: $isDeveloperMode, Mock Location Enabled: $isMockLocationEnabled, On External Storage: $isOnExternalStorage, Release Build: $isReleaseBuild, Prod Environment: $isProdEnvironment, Device ID: ${deviceInfo.deviceId}, Device Location: ${deviceInfo.location}, Emulator: ${deviceInfo.isEmulator}, Device Model: ${deviceInfo.deviceModel}, Device Brand: ${deviceInfo.deviceBrand}, Device Board: ${deviceInfo.deviceBoard}',
      );
      return false;
    }
    return true;
  }

  Future<bool> _isReleaseBuild() async {
    bool isReleaseBuild = false;
    try {
      if (kReleaseMode) {
        isReleaseBuild = true;
      }
    } catch (e) {
      logger.error(
        'app-security-validation.isReleaseBuild()',
        'Error checking build type: $e',
      );
    }
    return isReleaseBuild;
  }

  Future<bool> _isPosDevice() async {
    return platformType == PlatformType.pos;
  }

  Future<bool> _isProdEnvironment() async {
    bool isProdEnvironment = false;
    try {
      String env = const String.fromEnvironment('APP_ENVIRONMENT');
      if (env == 'prod') {
        isProdEnvironment = true;
      }
    } catch (e) {
      logger.error(
        'app-security-validation.isProdEnvironment()',
        'Error checking environment: $e',
      );
    }
    return isProdEnvironment;
  }

  Future<bool> hasNfc() async {
    try {
      return await NfcManager.instance.isAvailable();
    } catch (e) {
      return false;
    }
  }
}

/// Use the below to save logs to the Downloads folder,
/// Use the `LogManager` class to log messages and save them to a file.
/// Useful for debugging release builds or when you need to keep a record of logs.
class LogManager {
  static final List<String> _logs = [];
  static const String _logFileName = 'app_logs.txt';

  // Function to add a log message
  static void log(String message) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] $message';
    _logs.add(logEntry);
    // You can also print to console for debug builds
    if (kDebugMode) {
      print(logEntry);
    }
  }

  // Function to save logs to a file in the app's documents directory first
  static Future<File> _saveLogsLocally() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_logFileName');
    await file.writeAsString(_logs.join('\n'));
    return file;
  }

  // Function to save logs to the Downloads folder
  static Future<bool> saveLogsToDownloads() async {
    // 1. Request permissions (if necessary)
    if (Platform.isAndroid) {
      // For Android, check and request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          print('Storage permission denied.');
          return false;
        }
      }
    } else if (Platform.isIOS) {
      // For iOS, the Info.plist entries handle access for file sharing.
      // No explicit permission request usually needed here for saving to app's own documents.
      // If you were trying to write to truly shared directories, it would be more complex.
    }

    try {
      // 2. Save logs to a temporary file in the app's documents directory
      final localLogFile = await _saveLogsLocally();

      // 3. Move/Copy the file to the Downloads folder
      if (Platform.isAndroid || Platform.isIOS) {
        // Option 1: Using downloadsfolder package (recommended for simplicity)
        bool? success = await copyFileIntoDownloadFolder(
          localLogFile.path,
          _logFileName,
        );
        if (success == true) {
          print('Logs saved to Downloads folder successfully!');
          // Optionally, delete the temporary local file
          await localLogFile.delete();
          return true;
        } else {
          print(
            'Failed to save logs to Downloads folder using downloadsfolder.',
          );
          return false;
        }

        // Option 2: Using file_saver package (another good alternative)
        /*
        String? path = await FileSaver.instance.saveFile(
          name: _logFileName,
          filePath: localLogFile.path,
          mimeType: MimeType.text, // Specify mime type
        );
        if (path != null) {
          print('Logs saved to Downloads folder successfully at: $path');
          await localLogFile.delete();
          return true;
        } else {
          print('Failed to save logs to Downloads folder using file_saver.');
          return false;
        }
        */
      } else {
        // For other platforms (Desktop/Web), path_provider might give different paths.
        // For Desktop, getDownloadsDirectory() from path_provider is available.
        final downloadDir = await getDownloadsDirectory();
        if (downloadDir != null) {
          final destinationFile = File('${downloadDir.path}/$_logFileName');
          await localLogFile.copy(destinationFile.path);
          print('Logs saved to Downloads folder successfully on desktop!');
          await localLogFile.delete();
          return true;
        } else {
          print('Downloads directory not available on this platform.');
          return false;
        }
      }
    } catch (e) {
      print('Error saving logs: $e');
      return false;
    }
  }

  // Clear logs from memory (optional)
  static void clearLogs() {
    _logs.clear();
  }
}
