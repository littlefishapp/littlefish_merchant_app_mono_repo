import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/modal_theme_config.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/modal_builder_interfaces/action_modal_builder.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/models/enums.dart';

class ModalService {
  final ActionModalBuilder actionModalBuilder;
  final ModalThemeConfig modalThemeConfig;

  ModalService({
    required this.actionModalBuilder,
    required this.modalThemeConfig,
  });

  Future<bool?> showActionModal({
    required BuildContext context,
    StatusType status = StatusType.destructive,
    String title = 'Are you sure?',
    String description = 'Do you want to proceed?',
    Widget? customWidget,
    String acceptText = 'Yes',
    String cancelText = 'No',
    bool showAcceptButton = true,
    bool showCancelButton = true,
    Function(BuildContext)? onTap,
    bool barrierDismissable = true,
  }) async {
    final modal = actionModalBuilder.buildActionModal(
      context: context,
      title: title,
      description: description,
      customWidget: customWidget,
      acceptText: acceptText,
      cancelText: cancelText,
      showAcceptButton: showAcceptButton,
      showCancelButton: showCancelButton,
      onTap: onTap,
      status: status,
      useBoxIcon: modalThemeConfig.enableIconBackground,
      enableVerticalActions: modalThemeConfig.enableVerticalActions,
    );
    return await showDialog<bool>(
      context: context,
      builder: (context) => modal,
      barrierDismissible: barrierDismissable,
    );
  }

  Future<String> showTextInputModal({
    required BuildContext context,
    StatusType status = StatusType.destructive,
    String title = 'Enter Information',
    String description = 'Please enter the required information.',
    String initialValue = '',
    String acceptText = 'Confirm',
    String cancelText = 'Cancel',
    bool showAcceptButton = true,
    bool showCancelButton = true,
    Function(BuildContext)? onTap,
    bool barrierDismissable = true,
  }) async {
    final modal = actionModalBuilder.buildActionModal(
      context: context,
      title: title,
      description: description,
      acceptText: acceptText,
      cancelText: cancelText,
      showAcceptButton: showAcceptButton,
      showCancelButton: showCancelButton,
      onTap: onTap,
      status: status,
      useBoxIcon: modalThemeConfig.enableIconBackground,
      enableVerticalActions: modalThemeConfig.enableVerticalActions,
      customWidget: StringFormField(
        controller: TextEditingController(text: initialValue),
        onSaveValue: (String? value) {},
        hintText: '',
        labelText: '',
        initialValue: initialValue,
        isRequired: true,
      ),
    );
    return await showDialog<String>(
          context: context,
          builder: (context) => modal,

          barrierDismissible: barrierDismissable,
        ) ??
        '';
  }
}
