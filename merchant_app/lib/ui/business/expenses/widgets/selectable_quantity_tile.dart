import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/number_form_field.dart';

/// general purpose widget designed similar to a ListTile with on tap functionality as well as a quantity field
/// consisting of a NumberFormField ('+' and '-' buttons) to alter the quantity.
class SelectableQuantityTile extends StatelessWidget {
  final SelectableQuantityTileItem item;
  final bool selected;
  final bool enableHighlighting;
  final bool enableQuantityField;
  final Function()? tileOnTap;
  final Function(double quantity)? onFieldSubmitted;
  final double? initialValue;
  final int? maxValue;
  final int? minValue;

  const SelectableQuantityTile({
    Key? key,
    required this.item,
    this.selected = false,
    this.tileOnTap,
    this.onFieldSubmitted,
    this.initialValue,
    this.enableHighlighting = true,
    this.enableQuantityField = true,
    this.minValue,
    this.maxValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double quantity = initialValue ?? 0;
    bool isSelected = selected;

    if (quantity > 0) {
      isSelected = true;
    } else {
      isSelected = false;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: tileInfo(context, quantity, isSelected),
        ),
        if (isSelected && enableQuantityField)
          _quantityField(context, quantity, isSelected),
      ],
    );
  }

  tileInfo(BuildContext context, double quantity, bool isSelected) => InkWell(
    onTap: () {
      isSelected = true;
      // increase item quantity
      quantity += 1;

      if (tileOnTap != null) tileOnTap!();
    },
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      // height: item.height ?? 68,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (item.leadingWidget != null)
            _buildLeadingWidget(context, isSelected),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Visibility(
                  visible: item.title != null || item.trailText != null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_buildTitle(context), _buildTrailText(context)],
                  ),
                ),
                Visibility(
                  visible: item.subTitle != null || item.subTrailText != null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSubtitle(context),
                      _buildSubTrailText(context),
                    ],
                  ),
                ),
                Visibility(
                  visible:
                      item.subSubTitle != null || item.subSubTrailText != null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSubSubTitle(context),
                      _buildSubSubTrailText(context),
                    ],
                  ),
                ),
                // _buildSubtitle(context),
                // _buildSubSubTitle(context),
                const SizedBox(height: 2),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  // If an item is selected (tapped) then we show a '+' and'-' buttons (NumberFormField)
  // to change the quantity of the item or keep tapping item to add more of it.
  // Pressing the delete button clears the item sets quantity to zero
  // Selected items get a green border around the image/icon
  // as well as a checkmark on the top right corner.
  _quantityField(BuildContext context, double quantity, bool isSelected) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.quantityWidget != null) item.quantityWidget!,
          if (item.quantityWidget != null) const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: NumberFormField(
              minValue: minValue,
              maxValue: maxValue,
              buttonSize: 48,
              textFieldWidth: 56,
              useDecorator: false,
              enabled: true,
              hintText: 'How many do you have?',
              key: Key('$key quantity field'),
              labelText: '',
              onSaveValue: (value) {
                quantity = value.toDouble();
              },
              inputAction: TextInputAction.done,
              initialValue:
                  initialValue?.toInt() ?? quantity.toInt(), //quantity.toInt(),
              color: Colors.white,
              borderColor: Theme.of(context).colorScheme.primary,
              onFieldSubmitted: (value) {
                if (value != null) {
                  // Get difference between new quantity and current quantity,
                  // can be positive or negative (if '+' or '-' was pressed).
                  // Negative difference subtracts from the quantity,
                  // positive difference adds to the quantity.
                  double? difference = value.toDouble() - quantity;
                  quantity = quantity + difference;

                  // If quantity is zero then we hide the quantity field
                  if (quantity <= 0) {
                    isSelected = false;
                  }

                  if (onFieldSubmitted != null) {
                    onFieldSubmitted!(quantity);
                  }
                }
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          ),
        ],
      ),
      if (item.trailingWidget != null)
        Align(alignment: Alignment.centerRight, child: item.trailingWidget!),
    ],
  );

  _buildLeadingWidget(BuildContext context, bool isSelected) {
    return Stack(
      children: [
        Container(
          width: item.leadingWidgetSize,
          height: item.leadingWidgetSize,
          margin: const EdgeInsets.only(top: 8, right: 8),
          child: item.leadingWidget is Image ? null : item.leadingWidget,
          decoration: BoxDecoration(
            border: Border.all(
              color: enableHighlighting && isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              width: enableHighlighting && isSelected ? 2 : 1,
            ),
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(4),
            image: item.leadingWidget is Image
                ? DecorationImage(
                    image: (item.leadingWidget as Image).image,
                    fit: BoxFit.cover, // Set the fit property to BoxFit.cover
                  )
                : null,
          ),
        ),
        if (isSelected && enableHighlighting)
          Positioned(
            top: 0, // Adjust this value to control the overlap
            right: 0, // Adjust this value to control the overlap
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
          ),
      ],
    );
  }

  _buildTitle(BuildContext context) {
    return item.title ?? const Text('');
  }

  _buildSubtitle(BuildContext context) {
    return Expanded(flex: 2, child: item.subTitle ?? const Text(''));
  }

  _buildSubSubTitle(BuildContext context) {
    return item.subSubTitle ?? const Text('');
  }

  _buildTrailText(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.topRight,
        child: item.trailText ?? const Text(''),
      ),
    );
  }

  _buildSubTrailText(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.topRight,
        child: item.subTrailText ?? const Text(''),
      ),
    );
  }

  _buildSubSubTrailText(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.topRight,
        child: item.subSubTrailText ?? const Text(''),
      ),
    );
  }
}

class SelectableQuantityTileItem {
  final Text? title;
  final Text? subTitle;
  final Text? subSubTitle;
  final dynamic leadingWidget; // e.g. image or icon
  final double? leadingWidgetSize;
  final Text? trailText;
  final Text? subTrailText;
  final Text? subSubTrailText;
  final dynamic trailingWidget; // e.g. button or text
  final Widget? quantityWidget;
  final double? height;

  SelectableQuantityTileItem({
    this.title,
    this.subTitle,
    this.subSubTitle,
    this.leadingWidget,
    this.leadingWidgetSize = 56,
    this.trailText,
    this.trailingWidget,
    this.quantityWidget,
    this.subTrailText,
    this.subSubTrailText,
    this.height,
  });
}
