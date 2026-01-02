import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/decimal_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/numeric_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/models/stock/stock_take_item.dart';
import 'package:littlefish_merchant/ui/products/products/pages/product_quantity_adjustment_page.dart';

typedef StockAdjustmentCallback =
    Future<void> Function(double difference, StockRunType reason);

class StockControlFields extends StatelessWidget {
  // Parameters for controlling visibility and behavior
  final bool isStockTrackable;
  final StockUnitType unitType;
  final ProductType productType;

  // Parameters for 'Unit of Measure' field
  final String? unitOfMeasure;
  final ValueChanged<String> onUnitOfMeasureChanged;

  // Parameters for 'Stock Count' field
  final double stockCount;
  final ValueChanged<double> onStockCountChanged;

  // Parameters for 'Low Stock Value' field
  final double lowStockValue;
  final ValueChanged<double> onLowStockValueChanged;

  final String productDisplayName;
  final String? productId;
  final String? imageUri;
  final String? productCategoryName;
  final StockAdjustmentCallback? onStockAdjusted;

  const StockControlFields({
    super.key,
    // Visibility controllers
    required this.isStockTrackable,
    required this.unitType,
    required this.productType,

    // Unit of Measure properties
    required this.unitOfMeasure,
    required this.onUnitOfMeasureChanged,

    // Stock Count properties
    required this.stockCount,
    required this.onStockCountChanged,

    // --- onStockCountTap is removed ---

    // Low Stock Value properties
    required this.lowStockValue,
    required this.onLowStockValueChanged,

    // +++ Add new params for modal +++
    required this.productDisplayName,
    this.productId,
    this.imageUri,
    this.productCategoryName,
    this.onStockAdjusted,
  });

  void _showQuantityAdjustmentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        top: false,
        bottom: true,
        child: SizedBox(
          height: 480,
          child: ProductQuantityAdjustmentPage(
            isEmbedded: true,
            showProductImage: false,
            displayName: productDisplayName,
            productId: productId,
            imageUri: imageUri,
            category: productCategoryName,
            unitType: unitType,
            initialValue: stockCount,
            callback: (difference, reason) async {
              if (onStockAdjusted != null) {
                await onStockAdjusted!(difference, reason);
              }
            },
            enableProfileAction: false,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Unit of Measure Field
        Visibility(
          visible: unitType == StockUnitType.byFraction && isStockTrackable,
          child: Column(
            children: [
              StringFormField(
                prefixIcon: Icons.cases_outlined,
                hintText: 'e.g., kg, L, m',
                useOutlineStyling: true,
                textAlign: TextAlign.end,
                key: const Key('unitOfMeasure'),
                labelText: 'Unit of Measure',
                onSaveValue: (value) {
                  if (value != null) onUnitOfMeasureChanged(value);
                },
                inputAction: TextInputAction.next,
                initialValue: unitOfMeasure ?? 'kg',
                onFieldSubmitted: onUnitOfMeasureChanged,
                isRequired: false,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Stock Count Field (Decimal for 'byFraction')
        Visibility(
          visible:
              unitType == StockUnitType.byFraction &&
              productType == ProductType.physical &&
              isStockTrackable,
          child: Column(
            children: [
              DecimalFormField(
                prefixIcon: Icons.numbers,
                hintText: 'How many do you have?',
                useOutlineStyling: true,
                key: const Key('dStockCount'),
                labelText: 'Stock Count',
                onSaveValue: (value) =>
                    onStockCountChanged(value < 0 ? 0 : value),
                inputAction: TextInputAction.next,
                initialValue: stockCount,
                onFieldSubmitted: (value) =>
                    onStockCountChanged(value < 0 ? 0 : value),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Stock Count Field (Integer for 'byUnit')
        Visibility(
          visible:
              unitType == StockUnitType.byUnit &&
              productType == ProductType.physical &&
              isStockTrackable,
          child: Column(
            children: [
              InkWell(
                onTap: () => _showQuantityAdjustmentModal(context),
                child: NumericFormField(
                  prefixIcon: Icons.numbers,
                  hintText: 'How many do you have?',
                  enabled: false,
                  key: const Key('quantity'),
                  useOutlineStyling: true,
                  labelText: 'Stock Count',
                  onSaveValue: (value) =>
                      onStockCountChanged(value < 0 ? 0 : value.toDouble()),
                  inputAction: TextInputAction.next,
                  initialValue: stockCount.floor(),
                  onFieldSubmitted: (value) =>
                      onStockCountChanged(value < 0 ? 0 : value.toDouble()),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Low Stock Value Field
        Visibility(
          visible: isStockTrackable,
          child: DecimalFormField(
            prefixIcon: LittleFishIcons.warning,
            hintText: 'What value counts as low stock for this item?',
            key: const Key('lowstock'),
            labelText: 'Low Stock Value',
            useOutlineStyling: true,
            onSaveValue: onLowStockValueChanged,
            inputAction: TextInputAction.next,
            initialValue: lowStockValue,
            onFieldSubmitted: onLowStockValueChanged,
          ),
        ),
      ],
    );
  }
}
