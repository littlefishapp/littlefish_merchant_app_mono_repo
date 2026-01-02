// removed ignore: depend_on_referenced_packages

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/network_image/flutter_network_image.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:quiver/strings.dart';

class ProductCategoryTile extends StatelessWidget {
  final bool selected;
  final StockProduct item;
  final Function(StockProduct item)? onTap;
  final Function(StockProduct item)? onRemove;
  final StockCategory? category;

  const ProductCategoryTile({
    Key? key,
    required this.item,
    this.selected = false,
    this.category,
    this.onTap,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [productTileCategoryAdd(context)],
    );
  }

  Widget productTileCategoryAdd(BuildContext context) {
    final showImage = item.imageUri != null && isNotBlank(item.imageUri);
    final showIcon = item.imageUri == null || isBlank(item.imageUri);
    return InkWell(
      onTap: () {
        if (selected) {
          onRemove?.call(item);
        } else {
          onTap?.call(item);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: 104,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    margin: const EdgeInsets.only(top: 8, right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                        width: selected ? 2 : 1,
                      ),
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(4),
                      image: showImage
                          ? DecorationImage(
                              image: getIt<FlutterNetworkImage>()
                                  .asImageProviderById(
                                    id: item.id!,
                                    category: 'products',
                                    legacyUrl: item.imageUri!,
                                    height: AppVariables.listImageHeight,
                                    width: AppVariables.listImageWidth,
                                  ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: showIcon
                        ? const Icon(Icons.inventory_2_outlined, size: 24)
                        : null,
                  ),
                  if (selected)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.check, size: 16),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TODO(lampian): fix theme
                  Text(
                    category?.displayName?.toUpperCase() ?? '',
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(158, 156, 159, 1),
                      //fontFamily: UIStateData.primaryFontFamily,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.displayName!,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: item.isStockTrackable ?? true,
                    // TODO(lampian): fix theme
                    child: context.paragraphLarge(
                      '${math.max(item.quantity.round(), 0)} items',
                    ),
                  ),
                  if (!selected) const SizedBox(height: 4),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    item.regularPrice! > 0
                        ? TextFormatter.toStringCurrency(
                            item.regularPrice,
                            currencyCode: '',
                          )
                        : 'Variable',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      // TODO(lampian): get guidance from UI about success colour
                      color: Color(0xFF3E7568),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
