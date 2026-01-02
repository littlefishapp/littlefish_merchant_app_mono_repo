import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:quiver/strings.dart';

import '../../../injector.dart';
import '../../../models/stock/stock_product.dart';
import '../../../tools/network_image/flutter_network_image.dart';
import '../../../tools/textformatter.dart';
import '../../../common/presentaion/components/dialogs/common_dialogs.dart';

class LibraryItemTile extends StatelessWidget {
  const LibraryItemTile({
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
    return deleteTile(context, item);
  }

  deleteTile(BuildContext context, StockProduct item) => Slidable(
    endActionPane: ActionPane(
      extentRatio: .25,
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (ctx) async {
            var result = await confirmDismissal(context, null);

            if (result == true) {
              onRemove!(item);
            }
          },
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ],
    ),
    child: InkWell(
      onTap: onTap != null ? onTap!(item) : null,
      onLongPress: onLongPress,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 88,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
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
                child: isBlank(item.imageUri)
                    ? Icon(
                        Icons.inventory_2_outlined,
                        size: 24,
                        color: Theme.of(context).colorScheme.secondary,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.displayName!,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      //fontFamily: UIStateData.primaryFontFamily,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${item.quantity.round()} items',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(158, 156, 159, 1),
                      //fontFamily: UIStateData.primaryFontFamily,
                    ),
                  ),
                ],
              ),
              Expanded(
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
                        color: Color.fromRGBO(62, 117, 104, 1),
                        //fontFamily: UIStateData.primaryFontFamily,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
