import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/components/dialog_card_skeleton.dart';
import 'package:littlefish_merchant/models/enums.dart';

import '../../icons/modal_info_icon.dart';

class ActionDialogCard extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String description;
  final Widget? customWidget;
  final String acceptText;
  final Function(BuildContext)? onTap;
  final String cancelText;
  final StatusType status;
  final bool enableVerticalActions;
  final bool enableCloseButton;
  final bool useBoxIcon;
  final bool showAcceptButton;
  final bool showCancelButton;

  const ActionDialogCard({
    super.key,
    this.leading,
    required this.title,
    required this.description,
    this.customWidget,
    required this.acceptText,
    this.onTap,
    required this.cancelText,
    required this.status,
    this.enableVerticalActions = true,
    this.enableCloseButton = true,
    this.useBoxIcon = true,
    this.showAcceptButton = true,
    this.showCancelButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return DialogCardSkeleton(
      enableCloseButton: enableCloseButton,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: leading ?? ModalInfoIcon(status: status, isBoxIcon: useBoxIcon),
      ),
      title: title,
      description: description,
      customWidget: customWidget,
      footerWidgets: _buildFooter(context, status),
    );
  }

  List<Widget> _buildFooter(BuildContext context, StatusType status) {
    return enableVerticalActions
        ? [_buildVerticalActions(context, status)]
        : [_buildHorizontalActions(context, status)];
  }

  Widget _buildVerticalActions(BuildContext context, StatusType status) {
    return Column(
      children: [
        if (showAcceptButton)
          _acceptControl(context: context, shouldExpand: false, status: status),
        if (showCancelButton) _cancelControl(context, false),
      ],
    );
  }

  Widget _buildHorizontalActions(BuildContext context, StatusType status) {
    return Row(
      children: [
        if (showAcceptButton) Expanded(child: _cancelControl(context, false)),
        if (showCancelButton)
          Expanded(
            child: _acceptControl(
              context: context,
              shouldExpand: false,
              status: status,
            ),
          ),
      ],
    );
  }

  Widget _cancelControl(BuildContext context, bool shouldExpand) {
    return ButtonSecondary(
      expand: shouldExpand,
      text: cancelText,
      isNeutral: true,
      onTap: (ctx) => Navigator.of(context).pop(false),
    );
  }

  Widget _acceptControl({
    required BuildContext context,
    required bool shouldExpand,
    required StatusType status,
  }) {
    return ButtonPrimary(
      text: acceptText,
      expand: shouldExpand,
      isNegative: status == StatusType.destructive,
      isNeutral: status == StatusType.neutral,
      onTap: (ctx) {
        if (onTap != null) {
          onTap!(ctx);
        } else {
          Navigator.of(context).pop(true);
        }
      },
    );
  }
}
