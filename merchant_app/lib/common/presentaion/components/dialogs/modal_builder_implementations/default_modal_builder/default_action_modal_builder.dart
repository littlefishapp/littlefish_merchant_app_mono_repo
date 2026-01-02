import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/components/action_dialog_card.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/modal_builder_interfaces/action_modal_builder.dart';
import 'package:littlefish_merchant/models/enums.dart';

class DefaultActionModalBuilder implements ActionModalBuilder {
  DefaultActionModalBuilder();

  @override
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
  }) {
    return ActionDialogCard(
      title: title,
      description: description,
      customWidget: customWidget,
      acceptText: acceptText,
      cancelText: cancelText,
      onTap: onTap,
      status: status,
      enableVerticalActions: enableVerticalActions,
      showAcceptButton: showAcceptButton,
      showCancelButton: showCancelButton,
    );
  }
}
