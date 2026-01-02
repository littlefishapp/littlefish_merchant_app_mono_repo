import 'package:flutter/material.dart';
import 'package:littlefish_core/terminal_management/models/terminal.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/components/linked_devices_device_tile.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/components/linked_devices_helper.dart';

class LinkedDevicesSuccessView extends StatefulWidget {
  const LinkedDevicesSuccessView({
    super.key,
    required this.context,
    required this.terminals,
    required this.deviceId,
    this.doPushTransaction = false,
  });

  final BuildContext context;
  final List<Terminal> terminals;
  final String deviceId;
  final bool doPushTransaction;

  @override
  State<LinkedDevicesSuccessView> createState() =>
      _LinkedDevicesSuccessViewState();
}

class _LinkedDevicesSuccessViewState extends State<LinkedDevicesSuccessView> {
  late ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final onLinePeriod = LinkedDevicesHelper.onLinePeriod();

    return Expanded(
      child: Scrollbar(
        controller: scrollController,
        child: ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemCount: widget.terminals.length,
          itemBuilder: (ctx, index) {
            var device = widget.terminals[index];
            final position = device.id.indexOf('_');
            var deviceIdFromId = 'Unknown';
            if (position > 0) {
              deviceIdFromId = device.id.substring(position + 1);
            }
            final selected =
                device.id.contains(widget.deviceId) &&
                widget.deviceId.isNotEmpty;
            final isOnline = LinkedDevicesHelper.isOnline(
              terminal: device,
              onLinePeriod: onLinePeriod,
            );
            return LinkedDevicesDeviceTile(
              selected: selected,
              device: device,
              deviceId: deviceIdFromId,
              doPushTransaction: widget.doPushTransaction,
              isOnline: isOnline,
            );
          },
        ),
      ),
    );
  }

  void _scrollListener() {
    // if (scrollController.position.extentAfter < 80) {
    //   final status = widget.context.read<LinkedDevicesBloc>().state.status;
    //   if (status != LinkedDevicesStatus.loading) {
    //     debugPrint('## scroll listner => GetNext ');
    //     widget.context.read<LinkedDevicesBloc>().add(GetMoreLinkedDevices());
    //   }
    // }
  }
}
