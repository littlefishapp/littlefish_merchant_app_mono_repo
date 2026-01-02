import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';

class DeleteIcon extends StatelessWidget {
  final Color? color;
  const DeleteIcon({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.delete,
      color: color ?? Theme.of(context).extension<AppliedTextIcon>()?.error,
    );
  }
}
