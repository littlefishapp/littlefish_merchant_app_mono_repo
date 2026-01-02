import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:littlefish_merchant/models/reports/sales_report.dart';
import 'package:littlefish_merchant/providers/permissions_provider.dart';
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';
import '../handlers/interfaces/permission_handler.dart';
import '../injector.dart';
import 'textformatter.dart';

Future<bool> getCameraAccess() async {
  bool hasPermission = false;

  var cameraStatuses = await Permission.camera.status;

  hasPermission = cameraStatuses.isGranted;

  //request permission
  if (!hasPermission) {
    var cameraStatuses = (await Permission.camera.request());

    hasPermission = cameraStatuses.isGranted;
  }

  return hasPermission;
}

Future<void> requestDefaultPermissions() async {
  await PermissionsProvider.instance.getDevicePermissions();

  List<Permission> missingPermissions = [];

  if (await PermissionsProvider.instance.contactsStatus!.status !=
      PermissionStatus.granted) {
    missingPermissions.add(Permission.contacts);
  }

  if (await PermissionsProvider.instance.cameraStatus!.status !=
      PermissionStatus.granted) {
    missingPermissions.add(Permission.camera);
  }

  //only look for rejected statuses or un-actioned...
  if (await PermissionsProvider.instance.locationStatus!.status ==
      PermissionStatus.denied) {
    missingPermissions.add(Permission.location);
  } else if (await PermissionsProvider.instance.locationStatus!.status ==
      PermissionStatus.denied) {
    missingPermissions.add(Permission.location);
  }

  //here we will ask for the missing permissions to use the app...
  if (missingPermissions.isNotEmpty) {
    await PermissionsProvider.instance.requestPermissions(missingPermissions);
  }
}

Future<Position?> getLocation({
  LocationAccuracy accuracy = LocationAccuracy.medium,
}) async {
  // var locationAccessStatus =
  //     await Permission.getPermissionsStatus([Permission.Location]);

  // if (locationAccessStatus == null || locationAccessStatus.isEmpty) return null;

  // if (locationAccessStatus.first.permissionStatus == PermissionStatus.allow ||
  //     locationAccessStatus.first.permissionStatus == PermissionStatus.always ||
  //     locationAccessStatus.first.permissionStatus ==
  //         PermissionStatus.whenInUse) {
  //   return await Geolocator().getCurrentPosition(desiredAccuracy: accuracy);
  // } else
  return null;
}

Future<void> shareContent({
  required String value,
  required String subject,
}) async {
  await Share.share(value, subject: subject);
}

// Future<Position> getCurrentLocation() async {
//   var hasAccess = await requestLocationAccess();

//   if (hasAccess) {
//     return await Geolocator().getCurrentPosition();
//   } else
//     return null;
// }

Future<PermissionStatus>? requestPermission(Permission permissionName) async {
  var result = await PermissionsProvider.instance.requestPermissions([
    permissionName,
  ]);

  return result.first.status;
}

// Future<bool> requestLocationAccess() async {
//   if (await hasLocationAccess()) return true;

//   var status = await requestPermission(Permission.Location);

//   if (status == PermissionStatus.allow) return true;

//   if (status == PermissionStatus.always) return true;

//   if (status == PermissionStatus.whenInUse) return true;

//   return false;
// }

// Future<bool> hasLocationAccess() async {
//   await PermissionsProvider.instance.getDevicePermissions();

//   var status = PermissionsProvider.instance?.locationStatus?.permissionStatus;

//   if (status == PermissionStatus.allow) return true;

//   if (status == PermissionStatus.always) return true;

//   if (status == PermissionStatus.whenInUse) return true;

//   return false;
// }

//ToDo: remove all special characters
String? cleanString(String? value) {
  return value?.toLowerCase().replaceAll(' ', '_');
}

String? readableCleanString(String? value) {
  return value
      ?.toLowerCase()
      .replaceAll(' ', '')
      .replaceAll(RegExp(r'[^\w\s]+'), '');
}

// TODO(lampian): fix reportmode
String getStringFromGrouping(String mode, SalesGrouping? key) {
  //String getStringFromGrouping(reportMode.ReportMode? mode, SalesGrouping? key) {
  // switch (mode) {
  //   case ReportMode.day:
  //     return TextFormatter.toShortDate(
  //       dateTime:
  //           DateTime.utc(key!.year!, key.month!, key.day!, key.hour!).toLocal(),
  //       format: "hh:mm",
  //     );
  //     break;
  //   case ReportMode.week:
  //   case ReportMode.month:
  //     return TextFormatter.toShortDate(
  //       dateTime: DateTime.utc(
  //         key!.year!,
  //         key.month!,
  //         key.day!,
  //       ).toLocal(),
  //       format: "dd",
  //     );
  //     break;

  //   case ReportMode.threeMonths:
  //   case ReportMode.year:
  // default:
  return TextFormatter.toShortDate(
    dateTime: DateTime.utc(key!.year!, key.month!).toLocal(),
    format: 'MMM',
  );
  //break;
  // }
}

// Future<SelfieResult> takeSelfie(BuildContext context) async {
//   showProgress(context: context);

//   var selfie = await ImagePicker.pickImage(
//     source: ImageSource.camera,
//     imageQuality: 80,
//   );

//   if (selfie == null) {
//     hideProgress(context);
//     return SelfieResult(
//       message: "No Selfie Taken",
//       isValid: false,
//     );
//   }

//   var detector = FirebaseVision.instance.faceDetector(
//     FaceDetectorOptions(mode: FaceDetectorMode.fast),
//   );

//   try {
//     var fbFile = FirebaseVisionImage.fromFile(selfie);

//     var faces = await detector.processImage(fbFile);

//     if (faces != null && faces.isEmpty) {
//       hideProgress(context);
//       return SelfieResult(
//         message: "Please take a photo with your face in it",
//         isValid: false,
//       );
//     }

//     if (faces != null && faces.length > 1) {
//       hideProgress(context);
//       return SelfieResult(
//         message: "Please take a photo with only you in it",
//         isValid: false,
//       );
//     }

//     hideProgress(context);
//     return SelfieResult(
//       isValid: true,
//       fbImage: fbFile,
//       file: selfie,
//       message: "All Ok!",
//     );
//   } catch (e) {
//     hideProgress(context);
//     return SelfieResult(
//       message: "Something went wrong, please try again",
//       isValid: false,
//     );
//   } finally {
//     detector.close();
//   }
// }

// class SelfieResult {
//   SelfieResult({
//     this.file,
//     this.fbImage,
//     this.isValid,
//     this.message,
//   });

//   File file;

//   FirebaseVisionImage fbImage;

//   bool isValid;

//   String message;
// }

String getGoogleAuthError(String? code) {
  switch (code) {
    case 'too-many-requests':
      return 'We have detected suspicious activity and have blocked this device, try again later';
    case 'email-already-in-use':
      return 'Your details are already inuse by another account';
    case 'invalid-email':
      return 'Email address is not valid';
    case 'weak-password':
      return 'Please enter a more secure password';
    case 'invalid-credential':
    case 'wrong-password':
      return 'Incorrect username or password';
    default:
      return 'Something went wrong, please try again.';
  }
}

Container storeLogo() {
  return Container(
    margin: const EdgeInsets.only(top: 80.0),
    alignment: Alignment.center,
    child: Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.center,
          height: 120,
          child: Image.asset(UIStateData().appLogo, fit: BoxFit.fitHeight),
        ),
      ],
    ),
  );
}

KeyboardActionsConfig keyboardConfig(
  BuildContext context,
  List<FocusNode> nodes,
) {
  return KeyboardActionsConfig(
    keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
    // keyboardBarColor:
    // AppVariables.store!.state.isDarkMode ? Colors.black87 : Colors.grey[100],
    nextFocus: true,
    actions: nodes.map((e) => KeyboardActionsItem(focusNode: e)).toList(),
  );
}

List<Color> chartPallete = [
  Theme.of(globalNavigatorKey.currentContext!).colorScheme.primary,
  Theme.of(globalNavigatorKey.currentContext!).colorScheme.secondary,
  Colors.red,
  Colors.blue,
  Colors.indigo,
  Colors.pink,
  Colors.orange,
  Colors.deepOrange,
  Colors.purple,
];

enum ImageType { cover, banner, logo }

bool isNotZeroOrNull(double? amount) {
  return amount != null && amount != 0;
}

bool isNotZeroOrNullDecimal(Decimal? amount) {
  return amount != null && amount != Decimal.zero;
}

bool isZeroOrNull(num? value) {
  return value == null || value == 0;
}

bool isGreaterThanZero(num? value) {
  if (value == null || value == 0) return false;
  return value > 0;
}

bool isNullOrEmpty<E>(List<E>? itemsList) {
  return itemsList == null || itemsList.isEmpty;
}

bool isNotNullOrEmpty<E>(List<E>? itemsList) {
  if (isNullOrEmpty(itemsList)) return false;
  return true;
}

//Uses injected Permission Handler to determine whether the current logged in user has specific permission
bool userHasPermission(String permissionName) {
  final PermissionHandler permissionHandler = getIt.get<PermissionHandler>();
  final result = permissionHandler.hasPermission(permissionName);
  if (result) {
    debugPrint('### userHasPermission: $permissionName = $result');
  }
  return result;
}

bool userHasRole(String roleName) {
  return getIt.get<PermissionHandler>().hasRole(roleName);
}

bool isTrue(bool? value) {
  return value != null && value == true;
}

bool isFalse(bool? value) {
  return value != null && value == false;
}

bool isFalseOrNull(bool? value) {
  return value == null || value == false;
}

bool isNotTrue(bool? value) {
  return value != true;
}

bool isNotFalse(bool? value) {
  return value != false;
}

Map<K, T> listToMap<K, T>(List<T> list, K Function(T) keyExtractor) {
  return {for (var item in list) keyExtractor(item): item};
}

String broadPOSMessageLookUp(String message) {
  switch (message) {
    case '0000':
      return 'SUCCESSFUL';
    case '0001':
      return 'DECLINE';
    case '0002':
      return 'TIMEOUT';
    case '0003':
      return 'ABORTED';
    case '0004':
      return 'GENERAL_ERROR';
    case '0005':
      return 'SEND_ERROR';
    case '0006':
      return 'RECEIVE_ERROR';
    case '0007':
      return 'COMM_ERROR';
    case '0008':
      return 'SWIPE_ERROR';
    case '0009':
      return 'NOT_FOUND';
    case '0010':
      return 'PRINTER_NOT_SUPPORTED';
    case '0011':
      return 'OUT_OF_PAPER';
    case '0012':
      return 'PRINTER_DISABLED';
    case '0013':
      return 'CARD_NOT_ACTIVATED';
    case '0014':
      return 'MULTI_CARD_CONFLICT';
    case '0015':
      return 'NO_RESPONSE_TIMEOUT';
    case '0016':
      return 'PROTOCOL_ERROR';
    case '0017':
      return 'COMMUNICATION_ERROR';
    default:
      return '';
  }
}

String? tryTrimMobileNumber(String? mobileNo) {
  if (mobileNo == null) {
    return mobileNo;
  }
  // TODO: Make this more dynamic
  if (mobileNo.length > 9 && mobileNo.startsWith('+27')) {
    return mobileNo.substring(3);
  }
  return mobileNo;
}

String? safeParseString(dynamic value, {String? defaultValue}) {
  if (value is String) return value;
  if (value is int || value is double) return value.toString();
  return defaultValue;
}

int? safeParseInt(dynamic value, {int? defaultValue}) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    return int.tryParse(value) ?? defaultValue;
  }
  return defaultValue;
}

bool? safeParseBool(dynamic value, {bool? defaultValue}) {
  if (value is bool) return value;
  if (value is String) {
    return (value.toLowerCase() == 'true');
  }
  return defaultValue;
}
