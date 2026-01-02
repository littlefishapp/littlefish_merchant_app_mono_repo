import 'dart:io';

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:quiver/strings.dart';
import 'package:intl/intl.dart' as intl;

class ViewCartTile extends StatelessWidget {
  const ViewCartTile({Key? key, required this.transaction}) : super(key: key);

  final CheckoutTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      tileColor: Theme.of(context).colorScheme.background,
      onTap: () {
        _showBottomSheet(context);
      },
      title: context.labelMedium('View cart', alignLeft: true, isBold: true),
      trailing: Icon(
        Platform.isIOS ? Icons.arrow_forward_ios_outlined : Icons.arrow_forward,
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              top: false,
              bottom: true,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).extension<AppliedTextIcon>()?.emphasized,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    context.labelLarge(
                      'Transaction Items',
                      alignLeft: true,
                      isBold: false,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: _getTransactionItems(context),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _getTransactionItems(BuildContext context) {
    List<CheckoutCartItem>? allCartItems = transaction.items;

    if (allCartItems == null || allCartItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: context.labelSmall(
            'There are no items.',
            alignLeft: true,
            isBold: true,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        CheckoutCartItem cartItem = allCartItems[index];
        StockProduct? product = AppVariables.store?.state.productState
            .getProductById(cartItem.productId);
        return ListTile(
          tileColor: Theme.of(context).colorScheme.background,
          key: Key(cartItem.id ?? ''),
          leading: isNotBlank(product?.imageUri)
              ? ListLeadingImageTile(
                  width: AppVariables.appDefaultlistItemSize,
                  height: AppVariables.appDefaultlistItemSize,
                  url: product?.imageUri,
                )
              : _buildPlaceholderImage(context, product?.name),
          title: context.labelMedium(
            '${product?.displayName}',
            alignLeft: true,
            isBold: true,
          ),
          subtitle: context.labelMedium(
            '${cartItem.quantity.round().toString()} items',
            alignLeft: true,
            isBold: false,
          ),
          trailing: context.labelSmall(
            intl.NumberFormat.currency(
              locale: 'en_ZA',
              symbol: 'R',
              decimalDigits: 2,
            ).format((cartItem.itemValue ?? 0) * (cartItem.quantity)),
            alignLeft: true,
            isBold: false,
          ),
        );
      },
      itemCount: allCartItems.length,
    );
  }

  Widget _buildPlaceholderImage(BuildContext context, String? name) {
    return Container(
      width: AppVariables.appDefaultlistItemSize,
      height: AppVariables.appDefaultlistItemSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppliedSurface>()?.brandSubTitle,
        border: Border.all(color: Colors.transparent, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: context.labelMedium(
        name?.substring(0, 2).toUpperCase() ?? '',
        isBold: true,
      ),
    );
  }
}
