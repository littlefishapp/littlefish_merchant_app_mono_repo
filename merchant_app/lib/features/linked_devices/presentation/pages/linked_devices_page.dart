import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlefish_core/terminal_management/models/terminal.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/components/linked_device_transaction_failed_view.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/components/linked_devices_error_view.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/components/linked_devices_no_items_view.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/components/linked_devices_pushing_sale_view.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/components/linked_devices_success_view.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import '../../../../common/presentaion/components/form_fields/search_text_field.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../bloc/linkeddevices_bloc.dart';

class LinkedDevicesPage extends StatelessWidget {
  static const route = 'business/linked-devices';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  LinkedDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LinkedDevicesBloc, LinkedDevicesState>(
      listener: (context, state) async {
        if (state.status == LinkedDevicesStatus.completeSale) {
          if (context.mounted) {
            Navigator.popUntil(context, ModalRoute.withName(SellPage.route));
          }
        }
      },
      builder: (context, state) {
        debugPrint(
          '### LinkedDevicesPage:  ${state.status.name} '
          ' ${state.linkedDevices.length}',
        );
        final doPushSaleActive = context
            .read<LinkedDevicesBloc>()
            .doPushSaleActive;
        final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
        final showSideNav =
            isTablet ||
            (AppVariables.store!.state.enableSideNavDrawer ?? false);
        return AppScaffold(
          key: _scaffoldKey,
          title: 'Linked Merchant Devices',
          enableProfileAction: !showSideNav,
          hasDrawer: false,
          displayNavDrawer: false,
          body: scaffoldBody(
            context: context,
            state: state,
            doPushTransaction: doPushSaleActive,
          ),
          persistentFooterButtons: manageControls(
            context: context,
            state: state,
          ),
        );
      },
    );
  }

  Widget scaffoldBody({
    required BuildContext context,
    required LinkedDevicesState state,
    bool doPushTransaction = false,
  }) {
    if (state.status == LinkedDevicesStatus.loading ||
        state.status == LinkedDevicesStatus.initial) {
      return const AppProgressIndicator();
    } else if (state.status == LinkedDevicesStatus.errorSale) {
      return LinkedDevicesTransactionFailedView(context: context, message: '');
    } else if (state.status == LinkedDevicesStatus.error) {
      return LinkedDevicesErrorView(context: context, message: '');
    } else if (state.status == LinkedDevicesStatus.pushingSale) {
      return LinkedDevicesPushingSaleView(context: context);
    }

    return loadedView(
      terminals: state.linkedDevices,
      context: context,
      currentDeviceId: state.currentDeviceId,
      searchQuery: state.searchQuery,
      doPushTransaction: doPushTransaction,
    );
  }

  Widget loadedView({
    List<Terminal> terminals = const [],
    required BuildContext context,
    String currentDeviceId = '',
    String searchQuery = '',
    bool doPushTransaction = false,
  }) {
    return Column(
      children: [
        linkedDevicesSearchTile(context, searchQuery),
        if (doPushTransaction)
          Padding(
            padding: const EdgeInsets.all(24),
            child: context.labelMedium(
              'Select a terminal to proceeed with payment',
              isBold: true,
              alignLeft: false,
              color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
            ),
          ),
        if (terminals.isEmpty)
          LinkedDevicesNoItemsView(context: context)
        else
          LinkedDevicesSuccessView(
            context: context,
            terminals: terminals,
            deviceId: currentDeviceId,
            doPushTransaction: doPushTransaction,
          ),
      ],
    );
  }

  Widget linkedDevicesSearchTile(BuildContext context, String searchQuery) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SearchTextField(
        initialValue: searchQuery,
        keyboardType: TextInputType.emailAddress,
        onChanged: (query) {
          context.read<LinkedDevicesBloc>().add(FilterLinkedDevices(query));
        },
        onClear: () {
          context.read<LinkedDevicesBloc>().add(const FilterLinkedDevices(''));
        },
      ),
    );
  }

  List<Widget> manageControls({
    required BuildContext context,
    required LinkedDevicesState state,
  }) {
    final showReload =
        state.status == LinkedDevicesStatus.initial ||
        state.status == LinkedDevicesStatus.loading ||
        state.status == LinkedDevicesStatus.loaded;
    final showRetry = state.status == LinkedDevicesStatus.errorSale;
    final noMoreToLoad = context
        .read<LinkedDevicesBloc>()
        .allTerminalsRetrieved();

    return [
      if (showRetry)
        ButtonPrimary(
          text: 'Retry',
          onTap: (_) {
            context.read<LinkedDevicesBloc>().add(
              const SchedulePushSaleTerminalEvent(null),
            );
            context.read<LinkedDevicesBloc>().add(
              const DoPushSaleTerminalEvent(''),
            ); // todo sort out deviceid
          },
        ),
      if (showReload)
        Row(
          children: [
            Expanded(
              flex: 1,
              child: ButtonSecondary(
                text: '',
                icon: Icons.refresh,
                onTap: (_) {
                  context.read<LinkedDevicesBloc>().add(GetLinkedDevices());
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 6,
              child: ButtonPrimary(
                text: 'Load more',
                disabled: noMoreToLoad,
                onTap: (_) {
                  context.read<LinkedDevicesBloc>().add(GetMoreLinkedDevices());
                },
              ),
            ),
          ],
        ),
    ];
  }
}
