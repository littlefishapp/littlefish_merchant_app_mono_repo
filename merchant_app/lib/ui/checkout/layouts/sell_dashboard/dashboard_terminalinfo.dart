import 'package:flutter/material.dart';
import 'package:littlefish_core/terminal_management/models/terminal.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/components/linked_device_view_terminal.dart';

class DashBoardTerminalInfo extends StatelessWidget {
  final Terminal terminal;
  const DashBoardTerminalInfo({super.key, required this.terminal});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: terminal.displayName,
      displayBackNavigation: true,
      enableProfileAction: false,
      body: LinkedDeviceViewTerminal(terminal: terminal),
    );
  }
}
