import 'package:flutter/material.dart';

// project imports
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class FulfilmentMethodFilter extends StatefulWidget {
  final FulfilmentMethod? selectedFulfilmentMethod;
  final Function(FulfilmentMethod?) onChanged;

  const FulfilmentMethodFilter({
    super.key,
    required this.selectedFulfilmentMethod,
    required this.onChanged,
  });

  @override
  State<FulfilmentMethodFilter> createState() => _FulfilmentMethodFilterState();
}

class _FulfilmentMethodFilterState extends State<FulfilmentMethodFilter> {
  final String _allText = 'All';
  final String _deliveryText = 'Delivery';
  final String _collectionText = 'Collection';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: context.labelLarge('Dispatch Type', isBold: true),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _channelsList(context),
          ),
        ),
      ],
    );
  }

  List<Widget> _channelsList(BuildContext context) {
    return [
      _checkboxTile(context, _allText, FulfilmentMethod.undefined),
      _checkboxTile(context, _deliveryText, FulfilmentMethod.delivery),
      _checkboxTile(context, _collectionText, FulfilmentMethod.collection),
    ];
  }

  Widget _checkboxTile(
    BuildContext context,
    String fulfilmentMethodText,
    FulfilmentMethod fulfilmentMethod,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onChanged(
            widget.selectedFulfilmentMethod == fulfilmentMethod
                ? null
                : fulfilmentMethod,
          );
        });
      },
      child: Row(
        children: [
          Checkbox(
            activeColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
            side: BorderSide(
              color:
                  Theme.of(context).extension<AppliedTextIcon>()?.brand ??
                  Colors.red,
              width: 2,
            ),
            value: _isSelected(fulfilmentMethod),
            onChanged: (bool? isSelected) {
              setState(() {
                widget.onChanged(
                  widget.selectedFulfilmentMethod == fulfilmentMethod
                      ? null
                      : fulfilmentMethod,
                );
              });
            },
          ),
          context.paragraphMedium(fulfilmentMethodText, isSemiBold: true),
        ],
      ),
    );
  }

  bool _isSelected(FulfilmentMethod fulfilmentMethod) {
    return widget.selectedFulfilmentMethod == fulfilmentMethod;
  }
}
