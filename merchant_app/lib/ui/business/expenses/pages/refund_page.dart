// Flutter imports:
// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_discard.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund_item.dart';
import 'package:littlefish_merchant/redux/sales/sales_actions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/business/expenses/pages/refund_payment_method_page.dart';
import 'package:littlefish_merchant/ui/business/expenses/widgets/refund_cart_panel.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
import 'package:quiver/strings.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/ui/sales/view_models.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/ui/business/expenses/widgets/selectable_quantity_tile.dart';
import 'package:littlefish_merchant/ui/business/expenses/widgets/tile_config_utils.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/ui/business/expenses/refund_utilities.dart';

import '../../../../common/presentaion/components/icons/delete_icon.dart';
import '../../../../injector.dart';
import '../../../../tools/network_image/flutter_network_image.dart';

class RefundPage extends StatefulWidget {
  static const String route = 'business/refunds';

  final CheckoutTransaction transaction;
  final List<TileItemInfo> itemInfoList;

  const RefundPage({
    Key? key,
    required this.transaction,
    required this.itemInfoList,
  }) : super(key: key);

  @override
  State<RefundPage> createState() => _RefundPageState();
}

class _RefundPageState extends State<RefundPage> {
  final GlobalKey _moreKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SalesVM>(
      onInit: ((store) {
        store.dispatch(
          SetOriginalTransactionUnmodifiedAction(widget.transaction),
        );
        // create a copy of the transaction used for making modifications before updating the original transaction
        CheckoutTransaction transactionCopy =
            CheckoutTransaction.copyCheckoutTransaction(widget.transaction);
        store.dispatch(SetModifiedTransactionCopyAction(transactionCopy));
      }),
      converter: (store) => SalesVM.fromStore(store),
      builder: (ctx, vm) {
        if (widget.itemInfoList.isEmpty) {
          return noTransactionOrItemsFound(context);
        }

        return scaffold(context, vm);
      },
    );
  }

  Widget noTransactionOrItemsFound(BuildContext context) {
    return const AppScaffold(
      title: 'Select products to refund',
      body: Center(child: Text('No items found')),
    );
  }

  scaffold(context, SalesVM vm) => AppScaffold(
    persistentFooterButtons: <Widget>[
      continueToRefundButton(context, vm.currentRefund),
    ],
    displayAppBar: true,
    title: 'Select products to refund',
    titleWidget: Text(
      'Select products to refund',
      style: TextStyle(
        color: Theme.of(context).colorScheme.onTertiary,
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
      ),
    ),
    actions: <Widget>[
      ButtonDiscard(
        isIconButton: true,
        enablePopPage: true,
        backgroundColor: Colors.transparent,
        borderColor: Colors.transparent,
        modalTitle: 'Discard Refund',
        modalDescription:
            'Would you like to discard your current refund? This will clear your refund cart and you will lose your progress.',
        modalAcceptText: 'Yes. Dicard Refund',
        modalCancelText: 'No, Cancel',
        onDiscard: (ctx) async {
          Navigator.of(context).pop();
          vm.store?.dispatch(discardCurrentRefund());
        },
      ),
    ],
    body: vm.isLoading!
        ? const AppProgressIndicator()
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: layout(context, widget.itemInfoList, vm),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SlidingUpPanel(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    minHeight: 56,
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                    backdropEnabled: true,
                    panel: RefundCartPanel(
                      cartItemsInfo: noRefundInformationFound(vm.currentRefund)
                          ? []
                          : getRefundCartInfo(
                              vm.currentRefund!.items!,
                              widget.itemInfoList,
                            ),
                      vm: vm,
                    ),
                  ),
                ),
              ],
            ),
          ),
  );

  Widget continueToRefundButton(BuildContext context, Refund? refund) {
    return ButtonPrimary(
      text: 'Continue To Refund',
      buttonColor: Theme.of(context).colorScheme.primary,
      upperCase: true,
      onTap: (context) {
        if ((refund?.totalItems ?? 0) <= 0) {
          showMessageDialog(
            context,
            'Please select items to be refunded before continuing.',
            LittleFishIcons.info,
          );
          return;
        }
        Navigator.push(
          context,
          CustomRoute(
            builder: (BuildContext ctx) => const RefundPaymentMethodPage(
              isEmbedded: false,
              sourcePageRoute: RefundPage.route,
            ),
          ),
        );
      },
    );
  }

  layout(BuildContext context, List<TileItemInfo> itemInfoList, SalesVM vm) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: isNotZeroOrNull(widget.transaction.totalDiscount),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: context.paragraphMedium(
                'The refund amount for each product has been adjusted '
                'to reflect the applied discount.',
              ),
            ),
          ),
          transactionItemListView(context, itemInfoList, vm),
        ],
      ),
    );
  }

  transactionItemListView(
    BuildContext context,
    List<TileItemInfo> itemInfoList,
    SalesVM vm,
  ) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: itemInfoList.length,
      itemBuilder: (BuildContext context, int index) {
        return createItemTile(context, itemInfoList[index], vm);
      },
    ),
  );

  Widget createItemTile(
    BuildContext context,
    TileItemInfo itemInfo,
    SalesVM vm,
  ) {
    SelectableQuantityTileItem tileItem = customiseTileWidgets(itemInfo, vm);

    double quantity = vm.getCurrentRefundItemQuantity(itemInfo.cartItemID) ?? 0;
    double remaining = getQuantityRemainingForItem(
      itemInfo.cartItemID,
      widget.transaction,
    );
    return SelectableQuantityTile(
      item: tileItem,
      initialValue: quantity,
      minValue: 0,
      maxValue: remaining.toInt(),
      enableHighlighting: true,
      tileOnTap: () {
        List<dynamic> parameters = [vm.currentRefund];
        if (anyParameterIsNull(parameters)) return;

        RefundItem? refundItem = getItemInCurrentRefund(
          itemInfo.cartItemID,
          vm.currentRefund!,
        );

        double? remaining = getQuantityRemainingForItem(
          itemInfo.cartItemID,
          widget.transaction,
        );

        if (remaining <= 0) return; // no more items to refund

        if (refundItem == null) {
          createNewRefundItemAndAddToCart(
            itemInfo.cartItemID,
            widget.transaction,
            vm,
          );
        } else {
          // refund item already in cart, add 1 more
          if (quantity + 1 <= remaining) {
            refundItem.quantity = quantity + 1;
            refundItem.itemTotalValue =
                (refundItem.itemValue ?? 0) * (refundItem.quantity ?? 0);
            refundItem.itemTotalCost =
                (refundItem.itemCost ?? 0) * (refundItem.quantity ?? 0);
            vm.store?.dispatch(updateItemToBeRefunded(item: refundItem));
          }
        }

        if (mounted) setState(() {});
      },
      onFieldSubmitted: (double changedQuantity) {
        List<dynamic> parameters = [
          widget.transaction,
          itemInfo,
          itemInfo.cartItemID,
          vm.currentRefund,
        ];
        if (anyParameterIsNull(parameters)) return;

        RefundItem? refundItem = getItemInCurrentRefund(
          itemInfo.cartItemID,
          vm.currentRefund!,
        );

        double? currentQuantity = refundItem?.quantity ?? 0;
        double? difference = changedQuantity - currentQuantity;
        double? newQuantity = currentQuantity + difference;

        // get quantity of item still remaining, considering potential past refunds
        double? remaining = getQuantityRemainingForItem(
          itemInfo.cartItemID,
          widget.transaction,
        );

        if (newQuantity == 0) {
          vm.store?.dispatch(RemoveRefundItemFromCartAction(refundItem));
        }

        if (newQuantity > 0 && newQuantity <= remaining) {
          if (refundItem == null) {
            createNewRefundItemAndAddToCart(
              itemInfo.cartItemID,
              widget.transaction,
              vm,
            );
          } else {
            refundItem.quantity = newQuantity;
            refundItem.itemTotalValue =
                (refundItem.itemValue ?? 0) * (refundItem.quantity ?? 0);
            refundItem.itemTotalCost =
                (refundItem.itemCost ?? 0) * (refundItem.quantity ?? 0);
            vm.store?.dispatch(updateItemToBeRefunded(item: refundItem));
          }
        }

        if (mounted) setState(() {});
      },
    );
  }

  SelectableQuantityTileItem customiseTileWidgets(
    TileItemInfo itemInfo,
    SalesVM vm,
  ) {
    SelectableQuantityTileItem item = SelectableQuantityTileItem(
      leadingWidget: isNotBlank(itemInfo.imageUri)
          ? getIt<FlutterNetworkImage>().asWidget(
              id: itemInfo.itemId,
              category: itemInfo.itemType,
              legacyUrl: itemInfo.imageUri!,
              height: AppVariables.listImageHeight,
              width: AppVariables.listImageWidth,
            )
          : const Icon(Icons.inventory_2_outlined),
      subTitle: buildSubtitle(itemInfo.subtitle ?? ''),
      subSubTitle: buildSubSubTitle(itemInfo.subsubtitle ?? ''),
      subTrailText: buildSubTrailText(itemInfo.trailText ?? '', context),
      quantityWidget: buildQuantityText(
        context: context,
        quantityText: 'Refunding',
      ),
      trailingWidget: deleteButton(context, () async {
        final ModalService modalService = getIt<ModalService>();

        bool? isAccepted = await modalService.showActionModal(
          context: context,
          title: 'Remove item?',
          description: 'Are you sure you want to remove this item?',
        );

        if (isAccepted == true) {
          RefundItem? refundItem = vm.getCurrentRefundItem(itemInfo.cartItemID);
          vm.store?.dispatch(RemoveRefundItemFromCartAction(refundItem));
        }

        if (mounted) setState(() {});
      }),
    );

    return item;
  }

  deleteButton(BuildContext context, Function()? onTap) {
    // Delete button deselects item and sets quantity to zero
    return InkWell(
      onTap: () {
        if (onTap != null) onTap();
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(color: const Color(0xFFF2F2F2), width: 1.0),
        ),
        child: const Center(child: DeleteIcon()),
      ),
    );
  }

  TileItemInfo? getTileItemInfoForRefundItem(
    RefundItem refundItem,
    List<TileItemInfo> itemInfoList,
  ) {
    int itemInfoIndexForRefundItem = itemInfoList.indexWhere(
      (TileItemInfo itemInfo) =>
          itemInfo.cartItemID == refundItem.checkoutCartItemId,
    );
    bool itemFound = itemInfoIndexForRefundItem > -1;
    if (itemFound) {
      return itemInfoList[itemInfoIndexForRefundItem];
    }

    return null;
  }

  List<TileItemInfo> getRefundCartInfo(
    List<RefundItem> refundItems,
    List<TileItemInfo> itemInfoList,
  ) {
    List<TileItemInfo> refundCartItemInfoList = [];

    for (var refundItem in refundItems) {
      TileItemInfo? refundInfo = getTileItemInfoForRefundItem(
        refundItem,
        itemInfoList,
      );
      if (refundInfo != null) refundCartItemInfoList.add(refundInfo);
    }

    return refundCartItemInfoList;
  }

  bool noRefundInformationFound(Refund? refund) {
    // return true if no refund information found, return false if there is information
    bool noRefundFound = refund == null || refund.items == null;
    if (noRefundFound) return true;
    bool noItems = refund.items == null || refund.items!.isEmpty;
    return noItems == true;
  }
}
