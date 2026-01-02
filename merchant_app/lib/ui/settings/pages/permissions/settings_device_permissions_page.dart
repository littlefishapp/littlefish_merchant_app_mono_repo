// remove ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/providers/permissions_provider.dart';

import '../../../../app/app.dart';
import '../../../../app/theme/applied_system/applied_surface.dart';

class SettingsDevicePermissionsPage extends StatefulWidget {
  static const String route = 'general/device-permissions';

  const SettingsDevicePermissionsPage({Key? key}) : super(key: key);

  @override
  State<SettingsDevicePermissionsPage> createState() =>
      _SettingsDevicePermissionsPageState();
}

class _SettingsDevicePermissionsPageState
    extends State<SettingsDevicePermissionsPage> {
  @override
  void initState() {
    PermissionsProvider.instance.getDevicePermissions().then((value) {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final showSideNav =
        isTablet || (AppVariables.store!.state.enableSideNavDrawer ?? false);
    return AppScaffold(
      title: 'Device Permissions',
      enableProfileAction: !showSideNav,
      hasDrawer: false,
      displayNavDrawer: false,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            PermissionsProvider.instance.getDevicePermissions().then((result) {
              if (mounted) setState(() {});
            });
          },
        ),
      ],
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: PermissionsProvider.instance.permissions.length,
        itemBuilder: (BuildContext context, int index) {
          return PermissionTile(
            onTap: (item) async {
              // if permission is not granted, request permission,
              // check status and show dialog to open device settings
              // to allow permission if second permission request was also denied
              if (PermissionsProvider.instance.permissionStatuses[index] !=
                  PermissionStatus.granted) {
                var result = await PermissionsProvider.instance
                    .requestPermission(item!)
                    .then((value) async {
                      var st = await value!.status;
                      if (st != PermissionStatus.granted) {
                        showPermissionDialog(context, item);
                      }
                    });
                if (mounted) {
                  setState(() {
                    PermissionsProvider.instance.permissions[index] = result;
                  });
                }
              }

              // await PermissionsProvider.instance.requestPermission(item!);
              // if (mounted) setState(() {});
            },
            permission: PermissionsProvider.instance.permissions[index],
            status: PermissionsProvider.instance.permissionStatuses[index],
          );
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(),
      ),
    );
  }
}

class PermissionTile extends StatelessWidget {
  final Permission? permission;
  final PermissionStatus? status;

  final Function(Permission? permission) onTap;

  const PermissionTile({
    Key? key,
    required this.permission,
    required this.onTap,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      dense: !EnvironmentProvider.instance.isLargeDisplay!,
      leading: _buildPlaceholderImage(context, icon()),
      title: context.labelMedium(friendlyName(), isBold: true, alignLeft: true),
      subtitle: context.labelMedium(
        friendlyStatus(),
        isBold: false,
        alignLeft: true,
      ),
      trailing: Icon(statusIcon(), color: statusColor(context)),
      onTap: () {
        onTap(permission);
      },
    );
  }

  Widget _buildPlaceholderImage(BuildContext context, IconData icon) {
    return Container(
      width: AppVariables.appDefaultlistItemSize,
      height: AppVariables.appDefaultlistItemSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppliedSurface>()?.brandSubTitle,
        border: Border.all(color: Colors.transparent, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(child: Icon(icon)),
    );
  }

  String friendlyName() {
    return permission
            .toString()
            .toString()
            .split('.')
            .last
            .substring(0, 1)
            .toUpperCase() +
        permission.toString().toString().split('.').last.substring(1);
  }

  Color statusColor(BuildContext context) {
    switch (status) {
      case PermissionStatus.granted:
        return Theme.of(context).extension<AppliedTextIcon>()?.success ??
            Colors.black54;
      case PermissionStatus.denied:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        return Theme.of(context).extension<AppliedTextIcon>()?.error ??
            Colors.black54;
      default:
        return Theme.of(context).extension<AppliedTextIcon>()?.error ??
            Colors.black54;
    }
  }

  IconData statusIcon() {
    switch (status) {
      case PermissionStatus.granted:
        return Icons.check_circle;
      case PermissionStatus.denied:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        return LittleFishIcons.error;
      default:
        return FontAwesomeIcons.exclamation;
    }
  }

  String friendlyStatus() {
    switch (status) {
      case PermissionStatus.granted:
        return 'Allowed';
      case PermissionStatus.denied:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        return 'Not Allowed';
      default:
        return 'Unknown';
    }
  }

  IconData icon() {
    if (permission!.value == Permission.location.value) {
      return Icons.location_on;
    } else if (permission!.value == Permission.phone.value) {
      return Icons.phone;
    } else if (permission!.value == Permission.calendarWriteOnly.value) {
      return Icons.calendar_today;
    } else if (permission!.value == Permission.calendarFullAccess.value) {
      return Icons.calendar_today;
    } else if (permission!.value == Permission.camera.value) {
      return Icons.camera_alt;
    } else if (permission!.value == Permission.contacts.value) {
      return Icons.contacts;
    } else if (permission!.value == Permission.microphone.value) {
      return Icons.mic;
    } else if (permission!.value == Permission.sensors.value) {
      return Icons.phone;
    } else if (permission!.value == Permission.sms.value) {
      return Icons.sms;
    } else if (permission!.value == Permission.storage.value) {
      return Icons.storage;
    } else if (permission!.value == Permission.photos.value) {
      return Icons.photo;
    } else if (permission!.value == Permission.videos.value) {
      return Icons.videocam;
    } else {
      return Icons.question_answer;
    }
  }
}
