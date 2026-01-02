// removed ignore: depend_on_referenced_packages

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/network_image/flutter_network_image.dart';
import 'package:quiver/strings.dart';

class ProductTileStockSelect extends StatelessWidget {
  const ProductTileStockSelect({
    super.key,
    required this.onTap,
    required this.onLongPress,
    required this.context,
    required this.item,
  });

  final Function(StockProduct item)? onTap;
  final Function(StockProduct item)? onLongPress;
  final BuildContext context;
  final StockProduct item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null
          ? null
          : () {
              if (onTap != null) onTap!(item);
            },
      onLongPress: () {
        if (onLongPress != null) onLongPress!(item);
      },
      child: SizedBox(
        // width: MediaQuery.of(context).size.width,
        //height: 88,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: isNotBlank(item.imageUri)
                        ? getIt<FlutterNetworkImage>().asWidget(
                            id: (item.id ?? ''),
                            category: 'products',
                            legacyUrl: (item.imageUri ?? ''),
                            height: AppVariables.listImageHeight,
                            width: AppVariables.listImageWidth,
                          )
                        : Icon(
                            Icons.inventory_2_outlined,
                            color: Theme.of(
                              context,
                            ).extension<AppliedTextIcon>()?.secondary,
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.displayName!,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.appThemeLabelLarge,
                    ),
                    const SizedBox(height: 8),
                    context.paragraphMedium(
                      '${math.max(item.quantity.round(), 0)} items',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
