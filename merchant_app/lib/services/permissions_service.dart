// Package imports:
import 'package:permission_handler/permission_handler.dart';

Future<List<Permission>> getDevicePermissions() async {
  var permissions = (await [
    Permission.contacts,
    Permission.calendarWriteOnly,
    Permission.calendarFullAccess,
    Permission.location,
    Permission.camera,
    Permission.storage,
    Permission.microphone,
    Permission.phone,
    Permission.sms,
  ].request()).keys;

  var rr = permissions.toList();

  return rr;
}
