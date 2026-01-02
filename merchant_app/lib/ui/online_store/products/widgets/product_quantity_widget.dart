import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';
import '../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../models/enums.dart';

class ProductQuantityWidget extends StatefulWidget {
  final StoreProduct product;

  final double initialValue;

  final TextStyle? textStyle;

  final Function(double? value) onChanged;

  final ItemDisplayMode displayMode;

  const ProductQuantityWidget({
    Key? key,
    required this.product,
    required this.initialValue,
    required this.onChanged,
    this.textStyle,
    this.displayMode = ItemDisplayMode.grid,
  }) : super(key: key);

  @override
  ProductQuantityWidgetState createState() => ProductQuantityWidgetState();
}

class ProductQuantityWidgetState extends State<ProductQuantityWidget> {
  late double? value;

  changeValue(double? value) {
    if (mounted) {
      setState(() {
        this.value = value;
      });
    } else {
      this.value = value;
    }
  }

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(kBorderRadius!),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.circular(kBorderRadius!),
              elevation: 1,
              child: InkWell(
                borderRadius: BorderRadius.circular(kBorderRadius!),
                onTap: () {
                  if (value == 0) return;

                  value = (value ?? 0) - 1;

                  widget.onChanged(value);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadius!),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.remove,
                    size: widget.displayMode == ItemDisplayMode.grid
                        ? null
                        : 18,
                  ),
                ),
              ),
            ),
            Text(
              value!.floor().toString(),
              style:
                  widget.textStyle ??
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: widget.displayMode == ItemDisplayMode.grid
                        ? 24
                        : 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            Material(
              borderRadius: BorderRadius.circular(kBorderRadius!),
              elevation: 1,
              child: InkWell(
                borderRadius: BorderRadius.circular(kBorderRadius!),
                onTap: () {
                  value = (value ?? 0) + 1;

                  widget.onChanged(value);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadius!),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.add,
                    size: widget.displayMode == ItemDisplayMode.grid
                        ? null
                        : 18,
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
