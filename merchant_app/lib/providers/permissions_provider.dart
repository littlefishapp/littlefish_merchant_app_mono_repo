// Flutter imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'dart:io';
// Package imports:
import 'package:permission_handler/permission_handler.dart';

class PermissionsProvider with ChangeNotifier {
  static final PermissionsProvider instance = PermissionsProvider._internal();

  PermissionsProvider._internal();

  factory PermissionsProvider() => instance;

  // static PermissionsProvider of(BuildContext context, {bool listen = true}) =>
  //     Provider.of<PermissionsProvider>(context, listen: listen);

  Permission? get cameraStatus =>
      (_permissions).firstWhere((p) => p == Permission.camera);

  Permission? get locationStatus =>
      (_permissions).firstWhere((p) => p == Permission.location);

  Permission? get contactsStatus =>
      (_permissions).firstWhere((p) => p == Permission.contacts);

  Permission? get storageStatus =>
      (_permissions).firstWhere((p) => p == Permission.storage);

  Permission? get notificationStatus =>
      (_permissions).firstWhere((p) => p == Permission.notification);

  Permission? get photosStatus =>
      (_permissions).firstWhere((p) => p == Permission.photos);

  Permission? get videosStatus =>
      (_permissions).firstWhere((p) => p == Permission.videos);

  List<Permission?> _permissions = <Permission>[];

  List<Permission?> get permissions {
    return List.from(_permissions);
  }

  List<PermissionStatus?> permissionStatuses = <PermissionStatus?>[];

  // Method to check Android version and adjust permissions accordingly
  Future<void> _adjustPermissionsBasedOnAndroidVersion() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int sdkInt = androidInfo.version.sdkInt;

      if (sdkInt < 33) {
        _desiredPermissions.remove(Permission.photos);
        _desiredPermissions.remove(Permission.videos);
        if (!_desiredPermissions.contains(Permission.storage)) {
          _desiredPermissions.add(Permission.storage);
        }
      } else {
        _desiredPermissions.remove(Permission.storage);
        if (!_desiredPermissions.contains(Permission.photos)) {
          _desiredPermissions.add(Permission.photos);
        }
        if (!_desiredPermissions.contains(Permission.videos)) {
          _desiredPermissions.add(Permission.videos);
        }
      }
    }
  }

  // List of permissions we want access to.
  final _desiredPermissions = [
    Permission.contacts,
    Permission.location,
    Permission.camera,
    Permission.storage,
    Permission.notification,
    Permission.photos,
    Permission.videos,
    // Permission.microphone,
    // Permission.phone,
    // Permission.SMS
  ];

  Future<List<Permission?>> getDevicePermissions() async {
    await _adjustPermissionsBasedOnAndroidVersion();

    // request permissions
    var res = (await _desiredPermissions.request()).keys;

    // returned result list may contain additional permissions that we didn't ask for,
    // for example requesting Permission.location may also return Permission.locationWhenInUse
    var result = res.toList();

    // For every permission we requested, check if it's in the returned list
    // then only return permissions that we asked for.
    result.retainWhere((element) => _desiredPermissions.contains(element));

    permissionStatuses = await Future.wait(
      result.map((element) => element.status),
    );

    _permissions = result;

    return result;
  }

  Future<Permission?> requestPermission(Permission permissionName) async {
    await _adjustPermissionsBasedOnAndroidVersion();

    var status = await permissionName.request();
    // following previous implementation using if statement,
    // but should permissions only be added to the permission list if they are granted?
    // on the device permissions page we have a list of permissions which may
    // be denied so I see no reason for this.
    if (status == PermissionStatus.granted) addPermission(permissionName);

    if (_permissions.isNotEmpty) {
      permissionStatuses = await Future.wait(
        _permissions.map((permission) => permission!.status),
      );

      if (permissions.any((p) => p!.value == permissionName.value)) {
        var currentPermission = permissions.firstWhere(
          (p) => p!.value == permissionName.value,
        )!;
        if (status == PermissionStatus.granted) {
          permissionName = currentPermission;
        }
      }
    }

    return permissionName;
  }

  ///////////// REASON CODE IS COMMENTED OUT ///////////////////////
  ///
  // indexing the permissionStatuses list is not working properly.
  // PermissionStatus.name is a string such as "denied", "granted", etc.
  // Since indexWhere returns first index where a permission status' name
  // (e.g. "denied") is equal to the status.name (e.g "denied"),
  // but the list may contain multiple denied permissions, so it may return
  // an incorrect index.
  // For example:
  // If permission status = Denied,
  // permissions = [Contacts, Location, Camera], and
  // permissionStatuses = [Denied, Granted, Denied], then
  // indexWhere permission status name is "denied" always results in index 0 of
  // permissionStatuses list

  // Additionally, if both permissionStatuses and permissions lists are empty,
  // then we request contact permissions but the user denies the permission,
  // the permission list will stay empty(due to this line
  //'if (status == PermissionStatus.granted) addPermission(permissionName);')
  // as it was only added if status is granted,
  // but the permissionStatuses list will still add a denied status.

  // ******* Possible Improvement in permission handling *********
  // Possible improvement could be creating a dictionary of permissions and their
  // statuses, and then updating the dictionary when a permission is requested
  // or when a status changes. This is beneficial as managing and aligning two
  // independent lists is difficult and error prone.

  //////////////////////////////////////////////////////////////////

  // Future<Permission?> requestPermission(Permission permissionName) async {
  //   // Permission? permission;
  //   if (this.permissions.any((p) => p!.value == permissionName.value)) {
  //     var currentPermission =
  //         this.permissions.firstWhere((p) => p!.value == permissionName.value)!;

  //     var status = await currentPermission.status;

  //     if (status == PermissionStatus.granted) {
  //       permissionName = currentPermission;
  //       var ind = permissionStatuses
  //           .indexWhere((element) => element?.name == status.name);

  //       ind == -1
  //           ? permissionStatuses.add(status)
  //           : permissionStatuses[ind] = status;
  //       return permissionName;
  //     }
  //   }

  //   var status = await permissionName.request();
  //   if (status == PermissionStatus.granted) addPermission(permissionName);
  //   var ind = permissionStatuses
  //       .indexWhere((element) => element?.name == status.name);

  //   ind == -1
  //       ? permissionStatuses.add(status)
  //       : permissionStatuses[ind] = status;

  //   return permissionName;
  // }

  Future<List<Permission>> requestPermissions(List<Permission> items) async {
    await _adjustPermissionsBasedOnAndroidVersion();

    List<Permission> results = [];

    if (items.isEmpty) {
      return [];
    } else {
      for (var permissionName in items) {
        Permission permission;

        if (permissions.any((p) => p!.value == permissionName.value)) {
          var currentPermission = permissions.firstWhere(
            (p) => p!.value == permissionName.value,
          )!;

          var status = await currentPermission.status;
          if (status == PermissionStatus.granted) {
            permission = currentPermission;
            results.add(permission);
            continue;
          }
        }

        var result = await permissionName.request();
        permission = permissionName;
        results.add(permission);
        // if (Platform.isAndroid) {
        // } else if (Platform.isIOS) {
        //   var result = await Permission.requestSinglePermission(permissionName);
        //   permission = Permission(
        //     permissionName,
        //     result,
        //   );

        //   results.add(permission);
        // }

        if (result == PermissionStatus.granted) addPermission(permission);
      }
    }

    return results;
  }

  Future<Permission?> getPermission(Permission permissionName) async {
    await _adjustPermissionsBasedOnAndroidVersion();

    Permission? permission;

    if (permissions.any((p) => p!.value == permissionName.value)) {
      var currentPermission = permissions.firstWhere(
        (p) => p!.value == permissionName.value,
      )!;

      var status = await currentPermission.status;
      var ind = permissionStatuses.indexWhere(
        (element) => element?.name == status.name,
      );

      ind == -1
          ? permissionStatuses.add(status)
          : permissionStatuses[ind] = status;
      if (status == PermissionStatus.granted) {
        permission = currentPermission;
        return permission;
      }
    }

    return permission;
  }

  void addPermission(Permission? permission) {
    if (permissions.any((p) => p!.value == permission!.value)) {
      var index = permissions.indexWhere((p) => p!.value == permission!.value);

      _permissions[index] = permission;
      return;
    } else {
      _permissions.add(permission);
    }
  }

  Future<bool> hasPermission(Permission permissionName) async {
    await _adjustPermissionsBasedOnAndroidVersion();

    if (permissions.any((p) => p!.value == permissionName.value)) {
      var currentPermission = permissions.firstWhere(
        (p) => p!.value == permissionName.value,
      );

      if (currentPermission == null) return false;

      var status = await currentPermission.status;

      var ind = permissionStatuses.indexWhere(
        (element) => element?.name == status.name,
      );

      ind == -1
          ? permissionStatuses.add(status)
          : permissionStatuses[ind] = status;

      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
