import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/stock/stock_run_helper.dart';
import 'package:quiver/strings.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/stock_take_item.dart';
import 'package:littlefish_merchant/tools/network_image/flutter_network_image.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/quantity_adjustment.dart';

class ProductQuantityAdjustmentPage extends StatelessWidget {
  final String displayName;
  final String? productId;
  final String? imageUri;
  final StockUnitType? unitType;
  final Function(double, StockRunType) callback;
  final double initialValue;
  final String? category;
  final bool showProductImage;
  final bool isEmbedded;
  final bool? enableProfileAction;

  const ProductQuantityAdjustmentPage({
    Key? key,
    required this.displayName,
    required this.callback,
    this.productId,
    this.imageUri,
    this.unitType,
    this.initialValue = 0,
    this.category,
    this.showProductImage = true,
    this.isEmbedded = false,
    this.enableProfileAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? imageWidget;
    if (showProductImage) {
      if (isNotBlank(imageUri) && productId != null) {
        imageWidget = Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.secondary),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: getIt<FlutterNetworkImage>().asImageProviderById(
                id: productId!,
                category: 'products',
                legacyUrl: imageUri!,
                height: AppVariables.listImageHeight,
                width: AppVariables.listImageWidth,
              ),
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        imageWidget = Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  Theme.of(
                    context,
                  ).extension<AppliedSurface>()?.brandSubTitle ??
                  Colors.red,
            ),
            color: Theme.of(context).extension<AppliedSurface>()?.brandSubTitle,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.inventory_2_outlined,
            size: 36,
            color: Theme.of(context).extension<AppliedSurface>()?.brand,
          ),
        );
      }
    }

    return QuantityAdjustment(
      title: displayName,
      image: imageWidget,
      initialValue: initialValue,
      unitType: unitType == StockUnitType.byFraction
          ? QuantityUnitType.fractional
          : QuantityUnitType.integer,
      increaseReasons: StockRunHelper.stockIncreaseDisplayReasons,
      decreaseReasons: StockRunHelper.stockDecreaseDisplayReasons,
      onConfirmed: (adjustedQuantity, selectedReason) {
        final StockRunType? stockRunType = selectedReason != null
            ? StockRunHelper.reasonMap[selectedReason]
            : null;

        double difference = adjustedQuantity - initialValue;
        callback(difference.abs(), stockRunType!);
      },
      category: category,
      showQuantityInfo: true,
      enableProfileAction: enableProfileAction,
    );
  }
}
