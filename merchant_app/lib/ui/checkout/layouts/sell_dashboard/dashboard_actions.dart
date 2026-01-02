import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/features/getapp/get_app_widget.dart';
import 'package:littlefish_merchant/injector.dart' as dash_injector;
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/business/expenses/pages/quick_refund_page.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/library/select_products_page.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/dashboard_terminalinfo.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/perform_balance_enquiry_dialog.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/perform_update_device_parameters.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/print_batch_dialog.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/print_last_receipt_dialog.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/sell_view_item.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_action_page.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_quick_sale_page.dart';
import 'package:littlefish_merchant/ui/checkout/layouts/sell_dashboard/checkout_close_batch_dialog.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:littlefish_merchant/ui/sales/sales_page.dart';
import 'package:littlefish_payments/managers/terminal_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:redux/redux.dart';

class DashBoardActions {
  final Map<String, String> authList = {'': ''};

  List<SellViewItem> dashBoardActions({
    required BuildContext context,
    required Store<AppState> store,
    bool isGuestMode = false,
  }) {
    return getSellViewItems(
      context: context,
      store: store,
      isGuestMode: isGuestMode,
    );
  }

  List<SellViewItem> getSellViewItems({
    required BuildContext context,
    required Store<AppState> store,
    bool isGuestMode = false,
  }) {
    List<SellViewItem> configuredList = isGuestMode
        ? getGuestConfiguredList()
        : getLoggedInConfiguredList();

    final implementedList = getImplementedSellViewItems(
      context: context,
      store: store,
    );

    final resultingSellViewItems = _determineSellViewItems(
      context: context,
      store: store,
      configuredList: configuredList,
      implementedList: implementedList,
    );

    return resultingSellViewItems;
  }

  List<SellViewItem> _determineSellViewItems({
    required BuildContext context,
    required Store<AppState> store,
    required List<SellViewItem> configuredList,
    required List<SellViewItem> implementedList,
  }) {
    final resultingSellViewItems = <SellViewItem>[];
    for (var configuredItem in configuredList) {
      for (final item in implementedList) {
        if (item.route.isEmpty && item.action == null) continue;
        if (item.name.isEmpty) continue;

        final configuredItemInImplmentedList = configuredItem.name.contains(
          item.name,
        );

        if (configuredItemInImplmentedList) {
          var iconString = item.icon;
          if (configuredItem.icon.isNotEmpty) {
            iconString = configuredItem.icon;
          }

          if (Platform.isAndroid && configuredItem.iconAndroid.isNotEmpty) {
            iconString = configuredItem.iconAndroid;
          }

          if (Platform.isIOS && configuredItem.iconIOS.isNotEmpty) {
            iconString = configuredItem.iconIOS;
          }

          final sellViewItemHasChildren = configuredItem.subItems.isNotEmpty;
          List<SellViewItem> subItems = [];
          if (sellViewItemHasChildren) {
            subItems = _determineSubItems(
              context: context,
              store: store,
              configuredList: configuredItem.subItems,
              implementedList: implementedList,
            );
            debugPrint('### DashboardActions subItems: ${subItems.length}');
          }

          final configuredItemsHasChildren = configuredItem.subItems.isNotEmpty;
          if (configuredItemsHasChildren && subItems.isEmpty) {
            debugPrint(
              '### DashboardActions configuredItem has children, '
              'but implementedItem has no children: ${item.name}',
            );
            continue;
          }

          final augmentedItem = SellViewItem(
            name: item.name,
            icon: iconString,
            iconAndroid: item.iconAndroid,
            iconIOS: item.iconIOS,
            displayName: configuredItem.displayName,
            iconData: item.iconData,
            route: item.route,
            action: item.action,
            subItems: subItems,
          );
          resultingSellViewItems.add(augmentedItem);
          debugPrint('### DashboardActions added item: ${item.name}');
          debugPrint('### DashboardActions route : [${item.route}]');
          continue;
        }
      }
    }
    debugPrint(
      '### DashboardActions resultingSellViewItems: '
      '${resultingSellViewItems.length}',
    );
    return resultingSellViewItems;
  }

  List<SellViewItem> _determineSubItems({
    required BuildContext context,
    required Store<AppState> store,
    required List<SellViewItem> configuredList,
    required List<SellViewItem> implementedList,
  }) {
    final resultingSellViewItems = <SellViewItem>[];
    for (var configuredItem in configuredList) {
      for (final item in implementedList) {
        if (item.route.isEmpty && item.action == null) continue;
        if (item.name.isEmpty) continue;

        final configuredItemInImplmentedList = configuredItem.name.contains(
          item.name,
        );

        if (configuredItemInImplmentedList) {
          var iconString = item.icon;
          if (configuredItem.icon.isNotEmpty) {
            iconString = configuredItem.icon;
          }

          if (Platform.isAndroid && configuredItem.iconAndroid.isNotEmpty) {
            iconString = configuredItem.iconAndroid;
          }

          if (Platform.isIOS && configuredItem.iconIOS.isNotEmpty) {
            iconString = configuredItem.iconIOS;
          }

          final augmentedItem = SellViewItem(
            name: item.name,
            icon: iconString,
            iconAndroid: item.iconAndroid,
            iconIOS: item.iconIOS,
            displayName: configuredItem.displayName,
            iconData: item.iconData,
            route: item.route,
            action: item.action,
            subItems: [],
          );
          resultingSellViewItems.add(augmentedItem);
          debugPrint('### DashboardActions added sub item: ${item.name}');
          debugPrint('### DashboardActions sub item route : [${item.route}]');
          continue;
        }
      }
    }
    debugPrint(
      '### DashboardActions resultingSellViewItems: '
      '${resultingSellViewItems.length}',
    );
    return resultingSellViewItems;
  }

  List<SellViewItem> getLoggedInConfiguredList() {
    LittleFishCore core = LittleFishCore.instance;
    final ConfigService configService = core.get<ConfigService>();

    final layout = configService.getObjectValue(
      key: 'config_sell_view_items',
      defaultValue: authList,
    );
    debugPrint('### DashBoardActions $layout');
    List<SellViewItem> actionList = [];
    if (layout != null && layout is Map<String, dynamic>) {
      if (layout.containsKey('sale_actions')) {
        final actions = layout['sale_actions'];
        if (actions is List) {
          actionList = actions.map((e) {
            if (e is Map<String, dynamic>) {
              return SellViewItem.fromJson(e);
            } else {
              return const SellViewItem();
            }
          }).toList();
        }
      }
    }
    return actionList;
  }

  List<SellViewItem> getGuestConfiguredList() {
    LittleFishCore core = LittleFishCore.instance;
    final ConfigService configService = core.get<ConfigService>();

    final layout = configService.getObjectValue(
      key: 'config_sell_view_items',
      defaultValue: authList,
    );
    debugPrint('### DashBoardActions $layout');
    List<SellViewItem> actionList = [];
    if (layout != null && layout is Map<String, dynamic>) {
      if (layout.containsKey('guest_sale_actions')) {
        final actions = layout['guest_sale_actions'];
        if (actions is List) {
          actionList = actions.map((e) {
            if (e is Map<String, dynamic>) {
              return SellViewItem.fromJson(e);
            } else {
              return const SellViewItem();
            }
          }).toList();
        }
      }
    }
    return actionList;
  }

  List<SellViewItem> getImplementedSellViewItems({
    required BuildContext context,
    required Store<AppState> store,
  }) {
    final items = [
      // add permission for quick items tile ?
      SellViewItem(
        displayName: 'Quick Items',
        name: 'quickItems',
        iconData: Icons.home,
        action: (context) {
          //add code to do bootmModalSheet
        },
      ),

      if (userHasPermission(allowQuickSale))
        SellViewItem(
          displayName: 'Purchase',
          name: 'purchase',
          iconData: Icons.local_atm,
          action: (context) {
            final store = StoreProvider.of<AppState>(context);
            final checkoutVM = CheckoutVM.fromStore(store);
            checkoutVM.onClear();
            Navigator.of(context).push(
              CustomRoute(
                maintainState: false,
                builder: (BuildContext context) => const CheckoutQuickSale(),
              ),
            );
          },
        ),

      if (userHasPermission(allowTransactionHistory))
        SellViewItem(
          displayName: 'Transactions',
          name: 'transactions',
          iconData: Icons.history,
          route: SalesPage.route,
        ),
      if (AppVariables.enableCloseBatch)
        SellViewItem(
          iconData: MdiIcons.accountCash,
          displayName: 'Close Batch',
          name: 'closeBatch',
          route: '',
          action: (c) async {
            bool? result = await dash_injector
                .getIt<ModalService>()
                .showActionModal(
                  context: context,
                  title: 'Close Batch',
                  acceptText: 'Yes, Close',
                  cancelText: 'No, back to safety',
                  description: 'Are you sure you want to close the batch?',
                );

            if ((result ?? false) && c.mounted) {
              Navigator.of(c).pop(); // removes the modal actions
              await Navigator.of(c).push(
                MaterialPageRoute(
                  builder: (context) => const CheckoutCloseBatchDialog(),
                ),
              );
            }
          },
        ),
      if (userHasPermission(allowViewCurrentTerminal))
        SellViewItem(
          iconData: Icons.devices,
          displayName: 'Device Details',
          name: 'deviceDetails',
          route: '',
          action: (context) async {
            final businessId = AppVariables.businessId;
            final TerminalManager terminalManager = core.get<TerminalManager>();
            final terminal = await terminalManager.getTerminalInfo(
              'Provider',
              businessId,
            );
            if (context.mounted) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      DashBoardTerminalInfo(terminal: terminal),
                ),
              );
            }
          },
        ),
      if (AppVariables.isPOSBuild &&
          (AppVariables.store!.state.enableGetApp ?? true))
        SellViewItem(
          iconData: MdiIcons.download,
          displayName: 'Get APP',
          name: 'getApp',
          route: '',
          action: (context) {
            showPopupDialog(
              defaultPadding: false,
              context: context,
              useNewModal: true,
              content: Container(
                alignment: Alignment.center,
                child: const GetAppWidget(),
              ),
            );
          },
        ),
      if (userHasPermission(allowMakeProductSale))
        SellViewItem(
          displayName: 'Catalog Sale',
          name: 'productSale',
          iconData: Icons.shopping_cart,
          action: (context) {
            final store = StoreProvider.of<AppState>(context);
            final checkoutVM = CheckoutVM.fromStore(store);
            checkoutVM.onClear();
            Navigator.of(context).push(
              CustomRoute(
                maintainState: false,
                builder: (BuildContext context) => const SelectProductsPage(),
              ),
            );
          },
        ),
      if (userHasPermission(allowWithdrawal))
        SellViewItem(
          displayName: 'Cash Withdrawal',
          name: 'cashWithdrawal',
          iconData: Icons.money,
          route: '',
          action: (context) {
            final store = StoreProvider.of<AppState>(context);
            final checkoutVM = CheckoutVM.fromStore(store);
            checkoutVM.onClear();
            Navigator.of(context).push(
              CustomRoute(
                maintainState: false,
                builder: (BuildContext context) => const CheckoutActionPage(
                  actionType: CheckoutActionType.withdrawal,
                ),
              ),
            );
          },
        ),
      if (userHasPermission(allowQuickRefund))
        SellViewItem(
          displayName: 'Quick Refund',
          name: 'quickRefund',
          iconData: Icons.currency_exchange,
          action: (context) async {
            final store = StoreProvider.of<AppState>(context);
            final checkoutVM = CheckoutVM.fromStore(store);
            checkoutVM.onClear();
            checkoutVM.createQuickRefund();
            await Navigator.of(context).push(
              CustomRoute(
                builder: (BuildContext ctx) =>
                    const QuickRefundPage(sourcePageRoute: SellPage.route),
              ),
            );
          },
        ),
      if (AppVariables.enablePrintLastReceipt)
        SellViewItem(
          displayName: 'Print Last Receipt',
          name: 'printLastReceipt',
          iconData: Icons.receipt_long_sharp,
          route: PrintLastReceiptDialogue.route,
        ),

      if (AppVariables.hasPrinter && userHasPermission(allowRePrintBatch))
        SellViewItem(
          displayName: 'Reprint Batch',
          name: 'rePrintBatch',
          iconData: Icons.print_sharp,
          // route: PrintBatchDialogue.route,
          action: (context) async {
            final modalService = dash_injector.getIt<ModalService>();
            String batchNumber = '';

            bool? isAccepted = await modalService.showActionModal(
              context: context,
              title: 'Print Batch',
              description:
                  'Enter the batch you would like to reprint. If no batch is entered, the last batch will be reprinted.',
              acceptText: 'Confrim',
              cancelText: 'No, Cancel',
              status: StatusType.destructive,
              customWidget: StringFormField(
                enabled: true,
                useOutlineStyling: true,
                onSaveValue: (value) {
                  batchNumber = value ?? '';
                },
                onChanged: (value) => batchNumber = value,
                hintText:
                    'Please Select specific batch you would like to print',
                labelText: 'Batch Number',
                initialValue: batchNumber,
              ),
            );
            debugPrint(
              '#### PrintBatchDialogue: action triggered $isAccepted, nr: [$batchNumber]',
            );
            if (isAccepted == true) {
              if (context.mounted) {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        PrintBatchDialogue(batchNumber: batchNumber),
                  ),
                );
              }
            }
          },
        ),

      if (AppVariables.enableUpdateDeviceParameters)
        SellViewItem(
          displayName: 'Update Parameters',
          name: 'updateParameters',
          iconData: Icons.receipt_long_sharp,
          action: (context) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PerformUpdateDeviceParameters(),
            ),
          ),
        ),

      if (userHasPermission(allowBalanceEnquiry))
        SellViewItem(
          displayName: 'Balance Enquiry',
          name: 'balanceEnquiry',
          iconData: Icons.receipt_long_sharp,
          action: (context) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PerformBalanceEnquiryDialog(),
            ),
          ),
        ),
    ];

    return items;
  }
}
