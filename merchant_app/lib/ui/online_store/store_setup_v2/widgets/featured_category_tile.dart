// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/tools/network_image/flutter_network_image.dart';
import 'package:quiver/strings.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';

class FeaturedCategoriesTile extends StatelessWidget {
  const FeaturedCategoriesTile({
    Key? key,
    required this.item,
    this.onTap,
    this.selected = false,
  }) : super(key: key);

  final bool selected;

  final StockCategory item;

  final Function(StockCategory item)? onTap;

  @override
  Widget build(BuildContext context) {
    return stockProductTile(context, item);
  }

  Widget stockProductTile(BuildContext context, StockCategory item) {
    return InkWell(
      onTap: onTap == null
          ? null
          : () {
              if (onTap != null) onTap!(item);
            },
      child: SizedBox(
        height: 88,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: isNotBlank(item.imageUri)
                    ? getIt<FlutterNetworkImage>().asWidget(
                        id: item.id!,
                        category: 'products',
                        legacyUrl: item.imageUri!,
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
              const SizedBox(width: 16),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.displayName != null)
                      context.labelMedium(
                        item.displayName!,
                        alignLeft: true,
                        overflow: TextOverflow.ellipsis,
                        isBold: true,
                        color: Theme.of(
                          context,
                        ).extension<AppliedTextIcon>()?.primary,
                      ),
                    context.paragraphXSmall(
                      '${item.productCount} items',
                      color: Theme.of(
                        context,
                      ).extension<AppliedTextIcon>()?.secondary,
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
