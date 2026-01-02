import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class ProductAttributeChip extends StatelessWidget {
  final String attribute;
  final bool showDeleteIcon;
  final void Function(String)? onDelete;
  const ProductAttributeChip({
    super.key,
    required this.attribute,
    this.showDeleteIcon = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: context.labelSmall(
        attribute,
        color: Theme.of(context).extension<AppliedTextIcon>()?.brand,
      ),
      backgroundColor:
          Theme.of(context).extension<AppliedSurface>()?.positiveSubTitle ??
          Colors.green.shade50,
      deleteIcon: Icon(
        Icons.close,
        size: 18,
        color: Theme.of(context).extension<AppliedTextIcon>()?.brand,
      ),
      side: BorderSide(
        color:
            Theme.of(context).extension<AppliedTextIcon>()?.brand ??
            Colors.green.shade100,
      ),
      onDeleted: showDeleteIcon
          ? () {
              if (onDelete != null) {
                onDelete!(attribute);
              }
            }
          : null,
    );
  }
}
