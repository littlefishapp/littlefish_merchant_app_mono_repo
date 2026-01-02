import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_refund_item.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/redux/sales/sales_actions.dart';
import 'package:littlefish_merchant/ui/business/expenses/refund_utilities.dart';
import 'package:littlefish_merchant/ui/business/expenses/widgets/selectable_quantity_tile.dart';
import 'package:littlefish_merchant/ui/business/expenses/widgets/tile_config_utils.dart';
import 'package:littlefish_merchant/ui/sales/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:quiver/strings.dart';

import '../../../../common/presentaion/components/icons/delete_icon.dart';
import '../../../../injector.dart';
import '../../../../tools/network_image/flutter_network_image.dart';

class RefundCartPanel extends StatelessWidget {
  final SalesVM vm;
  final List<TileItemInfo>? cartItemsInfo;
  const RefundCartPanel({Key? key, required this.vm, this.cartItemsInfo})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 4.0,
          width: 78.0,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          margin: const EdgeInsets.all(8.0),
        ),
        // Display the total number of items selected on the left
        // and total cost on the right
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              context.paragraphMedium(
                '${(vm.currentRefund?.totalItems ?? 0.0).round()} item(s)',
              ),
              context.paragraphMedium(
                TextFormatter.toStringCurrency(
                  vm.currentRefund?.totalRefund ?? 0.0,
                  currencyCode: '',
                ),
              ),
            ],
          ),
        ),
        if (AppVariables.store!.state.enableDiscounts == true)
          const SizedBox(height: 8),
        const SizedBox(
          height: 16.0,
        ), // Add some spacing between summary and list
        Expanded(child: itemListView(context, vm)),
      ],
    );
  }

  Widget itemListView(BuildContext context, SalesVM vm) => Container(
    child: noRefundInformationFound(vm)
        ? Center(
            child: Column(
              children: [
                const Expanded(child: SizedBox()),
                const Icon(Icons.shopping_cart_outlined, size: 50.0),
                const SizedBox(height: 8.0),
                context.paragraphMedium('Cart is empty.'),
                const SizedBox(height: 16),
                const Text('Select products to be refunded.'),
                const Expanded(child: SizedBox()),
              ],
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: cartItemsInfo!.length,
            itemBuilder: (BuildContext context, int index) {
              return createItemTile(context, cartItemsInfo![index], vm);
            },
            separatorBuilder: (BuildContext context, int index) =>
                const CommonDivider(),
          ),
  );

  Widget createItemTile(
    BuildContext context,
    TileItemInfo itemInfo,
    SalesVM vm,
  ) {
    SelectableQuantityTileItem tileItem = customiseTileWidgets(
      context,
      itemInfo,
      vm,
    );

    CheckoutTransaction? transaction = vm.originalTransactionUnmodified;
    double? quantity =
        vm.getCurrentRefundItemQuantity(itemInfo.cartItemID) ?? 0;
    double? remaining = getQuantityRemainingForItem(
      itemInfo.cartItemID,
      transaction,
    );
    return SelectableQuantityTile(
      item: tileItem,
      initialValue: quantity,
      minValue: 0,
      maxValue: remaining.toInt(),
      tileOnTap: () {
        List<dynamic> parameters = [
          transaction,
          itemInfo,
          itemInfo.cartItemID,
          vm.currentRefund,
        ];
        if (anyParameterIsNull(parameters)) return;

        RefundItem? refundItem = getItemInCurrentRefund(
          itemInfo.cartItemID,
          vm.currentRefund!,
        );
        // double? quantitySold = cartItem?.quantity;
        double? remaining = getQuantityRemainingForItem(
          itemInfo.cartItemID,
          transaction,
        );

        if (remaining <= 0) return; // no more items to refund

        if (refundItem == null) {
          createNewRefundItemAndAddToCart(
            itemInfo.cartItemID,
            transaction!,
            vm,
          );
        } else {
          // refund item already in cart, add 1 more
          if (quantity + 1 <= remaining) {
            refundItem.quantity = quantity + 1;
            vm.store?.dispatch(updateItemToBeRefunded(item: refundItem));
          }
        }
      },
      onFieldSubmitted: (double changedQuantity) {
        List<dynamic> parameters = [
          transaction,
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
          transaction,
        );

        if (newQuantity == 0) {
          vm.store?.dispatch(RemoveRefundItemFromCartAction(refundItem));
        }

        if (newQuantity > 0 && newQuantity <= remaining) {
          if (refundItem == null) {
            createNewRefundItemAndAddToCart(
              itemInfo.cartItemID,
              transaction!,
              vm,
            );
          } else {
            refundItem.quantity = newQuantity;
            refundItem.itemTotalCost =
                (refundItem.itemCost ?? 0) * (refundItem.quantity ?? 0);
            refundItem.itemTotalValue =
                (refundItem.itemValue ?? 0) * (refundItem.quantity ?? 0);
            vm.store?.dispatch(updateItemToBeRefunded(item: refundItem));
          }
        }
      },
      enableHighlighting: false,
      selected: true,
    );
  }

  SelectableQuantityTileItem customiseTileWidgets(
    BuildContext context,
    TileItemInfo itemInfo,
    SalesVM vm,
  ) {
    SelectableQuantityTileItem item = SelectableQuantityTileItem(
      leadingWidget: isNotBlank(itemInfo.imageUri)
          ? getIt<FlutterNetworkImage>().asWidget(
              id: itemInfo.itemId,
              category: 'products',
              legacyUrl: itemInfo.imageUri!,
              height: AppVariables.listImageHeight,
              width: AppVariables.listImageWidth,
            )
          : const Icon(Icons.inventory_2_outlined),
      // title: buildTitle(context, itemInfo.title ?? ""),
      subTitle: buildSubtitle(itemInfo.subtitle ?? ''),
      subSubTitle: buildSubSubTitle(itemInfo.subsubtitle ?? ''),
      trailText: buildTrailText(itemInfo.trailText ?? '', context),
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

        if (isAccepted != null && isAccepted == true) {
          // vm.updateItemToBeRefunded(itemInfo, 0, vm);

          RefundItem? refundItem = vm.getCurrentRefundItem(itemInfo.cartItemID);
          vm.store?.dispatch(RemoveRefundItemFromCartAction(refundItem));
          // vm.store?.dispatch(RemoveRefundItemFromCartAction(refundItem));
        }

        // if (mounted) setState(() {});
      }),
    );

    return item;
  }

  deleteButton(BuildContext context, Function()? onTap) {
    // Delete button deselects item and sets quantity to zero
    // TODO(lampian): use common component
    return InkWell(
      onTap: () {
        if (onTap != null) onTap();
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 1.0,
          ),
        ),
        child: const Center(child: DeleteIcon()),
      ),
    );
  }

  bool noRefundInformationFound(SalesVM vm) {
    // return true if no refund information found, return false if there is information
    bool noItemInfoProvided = cartItemsInfo == null || cartItemsInfo!.isEmpty;
    if (noItemInfoProvided) return true;
    bool noRefundFound = vm.currentRefund == null;
    if (noRefundFound) return true;
    bool noItems =
        vm.currentRefund!.items == null || vm.currentRefund!.items!.isEmpty;
    return noItems == true;
  }
}
