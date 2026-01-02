import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiver/strings.dart';

import '../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../injector.dart';
import '../../../models/stock/stock_product.dart';
import '../../../tools/network_image/flutter_network_image.dart';
import '../../../tools/textformatter.dart';
import '../../../common/presentaion/components/text_tag.dart';

class LibraryItemTileTablet extends StatelessWidget {
  const LibraryItemTileTablet({
    Key? key,
    required this.item,
    this.onTap,
    this.onRemove,
    this.onLongPress,
  }) : super(key: key);

  final StockProduct item;

  final Function(StockProduct item)? onTap;

  final Function()? onLongPress;

  final Function(StockProduct item)? onRemove;

  @override
  Widget build(BuildContext context) {
    return tile(context, item);
  }

  tile(BuildContext context, StockProduct item) => Material(
    child: CardNeutral(
      child: InkWell(
        onLongPress: onLongPress,
        onTap: onTap != null ? onTap!(item) : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  image: isNotBlank(item.imageUri)
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
                child: isNotBlank(item.imageUri)
                    ? null
                    : Container(
                        constraints: const BoxConstraints.expand(),
                        color: Theme.of(context).colorScheme.secondary,
                        child: Icon(
                          item.productType == ProductType.physical
                              ? MdiIcons.tag
                              : MdiIcons.account,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${item.displayName}',
              style: const TextStyle(fontSize: 12),
              maxLines: 3,
            ),
            TextTag(
              displayText: item.regularPrice! > 0
                  ? TextFormatter.toStringCurrency(
                      item.regularPrice,
                      currencyCode: '',
                    )
                  : 'Variable',
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    ),
  );
}
