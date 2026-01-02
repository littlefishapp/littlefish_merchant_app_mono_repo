import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlefish_core/terminal_management/models/terminal.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/bloc/linkeddevices_bloc.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/bloc/single_linked_device_bloc.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/components/linked_devices_error_view.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/components/linked_device_view_terminal.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class LinkedDeviceDetailPage extends StatefulWidget {
  static const route = 'business/linked-device-detail';
  final Terminal terminal;
  const LinkedDeviceDetailPage({Key? key, required this.terminal})
    : super(key: key);

  @override
  State<LinkedDeviceDetailPage> createState() => _LinkedDeviceDetailPageState();
}

class LinkedDevicesVM {}

class _LinkedDeviceDetailPageState extends State<LinkedDeviceDetailPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      key: _scaffoldKey,
      title: widget.terminal.displayName,
      body: BlocConsumer<SingleLinkedDeviceBloc, SingleLinkedDeviceState>(
        listener: (context, state) async {
          if (state is SoftErrorState) {
            showMessageDialog(
              context,
              state.message,
              LittleFishIcons.error,
              status: StatusType.destructive,
            );
            return;
          }

          if (state is SaveSuccessState) {
            // update terminal in list
            context.read<LinkedDevicesBloc>().add(
              UpdateTerminalEvent(state.terminal!),
            );
            context.read<SingleLinkedDeviceBloc>().add(
              SetViewModeEvent(state.terminal!),
            );
          }
          if (state is DeviceLimitState) {
            showMessageDialog(
              context,
              state.message,
              LittleFishIcons.error,
              status: StatusType.destructive,
            );
          }
          if (state is AddProviderState) {
            final modalService = getIt<ModalService>();
            final bool? discardSelectedDiscount = await modalService
                .showActionModal(
                  context: context,
                  title: state.title ?? 'Info',
                  description: state.message ?? '',
                  status: StatusType.destructive,
                );
            state.completer.complete(discardSelectedDiscount ?? false);
          }
        },
        builder: (context, state) {
          if (state is LoadingState || state is AddProviderState) {
            return const AppProgressIndicator();
          }
          if (state is HardErrorState || state.terminal == null) {
            return LinkedDevicesErrorView(
              context: context,
              message: 'Something went wrong, please try again.',
            );
          }
          return LinkedDeviceViewTerminal(
            terminal: state.terminal!,
            isManageState: state is ManageState,
            isViewMode: !(state is ManageState || state is EditState),
            isThisDevice: state.isCurrentDevice,
          );
        },
      ),
      persistentFooterButtons: context.read<SingleLinkedDeviceBloc>().canModify
          ? [footer(context)]
          : null,
    );
  }

  Widget footer(BuildContext context) {
    return BlocBuilder<SingleLinkedDeviceBloc, SingleLinkedDeviceState>(
      builder: (context, state) {
        if (state is ViewState) {
          return editButton(context, state.terminal!);
        } else if (state is LoadingState) {
          return SizedBox.shrink();
        } else {
          return FooterButtonsSecondaryPrimary(
            primaryButtonText: 'Save',
            onPrimaryButtonPressed: (ctx) {
              context.read<SingleLinkedDeviceBloc>().add(
                SaveTerminalDetailsEvent(),
              );
            },
            onSecondaryButtonPressed: (ctx) => context
                .read<SingleLinkedDeviceBloc>()
                .add(CancelButtonPressedEvent()),
            secondaryButtonText: 'Cancel',
          );
        }
      },
    );
  }

  Widget editButton(BuildContext context, Terminal terminal) {
    return ButtonPrimary(
      text: 'Edit',
      onTap: (_) {
        context.read<SingleLinkedDeviceBloc>().add(
          EditButtonPressedEvent(terminal),
        );
      },
    );
  }
}
