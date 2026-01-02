import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/enums.dart';

abstract class ActionModalBuilder {
  Widget buildActionModal({
    required BuildContext context,
    required String title,
    required String description,
    Widget? customWidget,
    required String acceptText,
    required String cancelText,
    Function(BuildContext)? onTap,
    required StatusType status,
    bool enableVerticalActions = true,
    bool useBoxIcon = true,
    bool showAcceptButton = true,
    bool showCancelButton = true,
  });
}
