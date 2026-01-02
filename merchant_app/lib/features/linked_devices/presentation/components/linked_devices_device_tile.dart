import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlefish_core/terminal_management/models/terminal.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/bloc/linkeddevices_bloc.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/bloc/single_linked_device_bloc.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/pages/linked_device_detail_page.dart';

class LinkedDevicesDeviceTile extends StatelessWidget {
  const LinkedDevicesDeviceTile({
    super.key,
    required this.selected,
    required this.device,
    required this.deviceId,
    this.doPushTransaction = false,
    this.isOnline = false,
  });

  final bool selected;
  final Terminal device;
  final String deviceId;
  final bool doPushTransaction;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final title1 = device.displayName;
    final subTitle1 = device.serialNumber.isNotEmpty
        ? device.serialNumber
        : device.deviceId.isNotEmpty
        ? device.deviceId
        : deviceId;
    final subTitle2 = selected
        ? 'This device'
        : '${device.family} ${device.type}';
    final subTitle = '$subTitle1\n$subTitle2';
    return ListTile(
      selected: isOnline || selected,
      tileColor: Theme.of(context).colorScheme.background,
      leading: device.device.os.toLowerCase() == 'android'
          ? const ListLeadingIconTile(icon: Icons.android)
          : const ListLeadingIconTile(icon: Icons.apple),
      title: context.labelSmall(
        title1,
        alignLeft: true,
        isSemiBold: true,
        overflow: TextOverflow.ellipsis,
        color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
      ),
      subtitle: context.labelXSmall(
        subTitle,
        alignLeft: true,
        maxLines: 2,
        color: Theme.of(context).extension<AppliedTextIcon>()?.deEmphasized,
      ),
      trailing: Icon(
        Platform.isIOS ? Icons.arrow_forward_ios_outlined : Icons.arrow_forward,
        color: Theme.of(context).extension<AppliedTextIcon>()?.deEmphasized,
      ),
      onTap: () {
        if (doPushTransaction) {
          context.read<LinkedDevicesBloc>().add(
            DoPushSaleTerminalEvent(device.id),
          );
          return;
        } else {
          context.read<SingleLinkedDeviceBloc>().add(
            InitializeDeviceEvent(device),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LinkedDeviceDetailPage(terminal: device),
            ),
          );
        }
      },
    );
  }
}
