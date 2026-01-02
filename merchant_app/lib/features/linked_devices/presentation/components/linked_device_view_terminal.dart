import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:littlefish_core/terminal_management/models/terminal.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_neutral.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/dropdown_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/bloc/single_linked_device_bloc.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/components/linked_devices_two_item_tile.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/components/text_and_dropdown_field_row.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/components/text_and_toggle_row.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/utils/terminal_helper.dart';

class LinkedDeviceViewTerminal extends StatelessWidget {
  static const route = 'linked-device-detail-view';
  final Terminal terminal;
  final bool isViewMode;
  final bool isManageState;
  final bool isThisDevice;

  const LinkedDeviceViewTerminal({
    super.key,
    required this.terminal,
    this.isViewMode = true,
    this.isManageState = false,
    this.isThisDevice = false,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'MMM dd yyyy HH:mm',
    ).format(terminal.dateCreated.toLocal());
    final lastPing = DateFormat(
      'MMM dd yyyy HH:mm',
    ).format(terminal.device.lastPingTime.toLocal());
    final nameToDisplay = terminal.displayName;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CardNeutral(
        elevation: 2.0,
        child: BlocBuilder<SingleLinkedDeviceBloc, SingleLinkedDeviceState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.center,
                      child: context.labelSmall(
                        'Terminal information:',
                        isBold: true,
                        color: Theme.of(
                          context,
                        ).extension<AppliedTextIcon>()?.primary,
                      ),
                    ),
                  ),
                  displayName(
                    context: context,
                    name: nameToDisplay,
                    isViewMode: isViewMode,
                  ),
                  if (terminal.merchantId.isNotEmpty &&
                          terminal.merchantId.toLowerCase() != 'unknown' ||
                      AppVariables.merchantId.isNotEmpty)
                    LinkedDevicesTwoItemTile(
                      context: context,
                      leading: 'Merchant ID',
                      trailing: _getMerchantId(terminal.merchantId),
                    ),
                  if (terminal.terminalId.isNotEmpty)
                    LinkedDevicesTwoItemTile(
                      context: context,
                      leading: 'Terminal ID',
                      trailing: terminal.terminalId,
                    ),
                  if (terminal.serialNumber.isNotEmpty)
                    LinkedDevicesTwoItemTile(
                      context: context,
                      leading: 'Serial Number',
                      trailing: terminal.serialNumber,
                    ),
                  if (terminal.deviceId.isNotEmpty)
                    LinkedDevicesTwoItemTile(
                      context: context,
                      leading: 'Device ID',
                      trailing: terminal.deviceId,
                    ),
                  LinkedDevicesTwoItemTile(
                    context: context,
                    leading: 'Last Ping',
                    trailing: lastPing,
                  ),
                  LinkedDevicesTwoItemTile(
                    context: context,
                    leading: 'Family',
                    trailing: terminal.family,
                  ),
                  LinkedDevicesTwoItemTile(
                    context: context,
                    leading: 'Type',
                    trailing: terminal.type,
                  ),
                  statusTile(
                    context: context,
                    isManageState: isManageState,
                    status: terminal.status,
                  ),
                  LinkedDevicesTwoItemTile(
                    context: context,
                    leading: 'Date Created',
                    trailing: formattedDate,
                  ),
                  cardPaymentTile(
                    context: context,
                    cardEnabled: AppVariables.isSoftPosBuild
                        ? state.isEnrolled
                        : terminal.cardEnabled,
                    isManageState: isManageState,
                  ),
                  LinkedDevicesTwoItemTile(
                    context: context,
                    leading: 'OS',
                    trailing: terminal.device.os,
                  ),
                  LinkedDevicesTwoItemTile(
                    context: context,
                    leading: 'OS Version',
                    trailing: terminal.device.osVersion,
                  ),
                  LinkedDevicesTwoItemTile(
                    context: context,
                    leading: 'App Version',
                    trailing: terminal.app.version,
                  ),
                  softPosVersionTile(context: context, terminal: terminal),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget displayName({
    required BuildContext context,
    String name = '',
    bool isViewMode = true,
  }) {
    String leading = 'Display Name';
    if (!isViewMode) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: StringFormField(
          useOutlineStyling: true,
          initialValue: name,
          hintText: leading,
          labelText: leading,
          onSaveValue: (String? value) {
            context.read<SingleLinkedDeviceBloc>().add(
              SetDisplayNameEvent(value ?? ''),
            );
          },
          onFieldSubmitted: (String value) {
            context.read<SingleLinkedDeviceBloc>().add(
              SetDisplayNameEvent(value),
            );
          },
        ),
      );
    }

    return LinkedDevicesTwoItemTile(
      context: context,
      leading: leading,
      trailing: name,
    );
  }

  String _getMerchantId(String merchantId) {
    if (merchantId.isNotEmpty && merchantId != 'unknown') {
      return merchantId;
    }
    return AppVariables.merchantId;
  }

  Widget statusTile({
    required BuildContext context,
    String status = '',
    bool isManageState = false,
  }) {
    String leading = 'Status';

    if (isManageState) {
      return TextAndDropdownFieldRow(
        leading: leading,
        initialValue: status,
        onChanged: (dropDownValue) {
          context.read<SingleLinkedDeviceBloc>().add(
            SetStatusEvent((dropDownValue as DropDownValue).value),
          );
        },
        values: TerminalHelper.statusDropDownValues(),
      );
    }

    return LinkedDevicesTwoItemTile(
      context: context,
      leading: 'Status',
      trailing: status,
    );
  }

  Widget cardPaymentTile({
    required BuildContext context,
    bool cardEnabled = false,
    bool isManageState = false,
  }) {
    String leading = 'Card Payments';
    if (isManageState && AppVariables.isSoftPosBuild && isThisDevice) {
      return TextAndToggleRow(
        leading: leading,
        initialValue: cardEnabled,
        forceRefresh: false,
        onChanged: (bool enabled) {
          if (!enabled) {
            context.read<SingleLinkedDeviceBloc>().add(
              DeRegisterDeviceButtonPressedEvent(
                terminal,
                enabled,
                isThisDevice,
              ),
            );
          } else {
            context.read<SingleLinkedDeviceBloc>().add(
              RegisterDeviceButtonPressedEvent(terminal, enabled, isThisDevice),
            );
          }
        },
      );
    }

    return LinkedDevicesTwoItemTile(
      context: context,
      leading: leading,
      trailing: AppVariables.isPOSBuild
          ? 'Enabled'
          : cardEnabled
          ? 'Enabled'
          : 'Disabled',
    );
  }

  Widget softPosVersionTile({
    required BuildContext context,
    required Terminal terminal,
  }) {
    if (AppVariables.isSoftPosBuild && isThisDevice) {
      String version = 'N/A';
      final providerJson = terminal.app.data['provider_sdk_versions'];
      if (providerJson != null) {
        try {
          final decoded = jsonDecode(providerJson);
          version = decoded['softPosVersion'] ?? 'N/A';
        } catch (e) {
          version = 'N/A';
        }
      }
      String leading =
          '${AppVariables.store?.state.softPosProviderName ?? 'Tap To Pay'} Version';

      return LinkedDevicesTwoItemTile(
        context: context,
        leading: leading,
        trailing: version,
      );
    }
    return SizedBox.shrink();
  }
}
