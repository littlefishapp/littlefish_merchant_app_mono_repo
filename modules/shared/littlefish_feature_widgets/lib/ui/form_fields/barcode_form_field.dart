// Dart imports:
// remove ignore_for_file: use_build_context_synchronously

import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:littlefish_merchant/app/app.dart';

// Package imports:
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:littlefish_merchant/providers/permissions_provider.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/pages/popup_forms/barcode_popup_form.dart';

import '../../../../../widgets/app/theme/applied_system/applied_surface.dart';
import '../../../../../widgets/app/theme/applied_system/applied_text_icon.dart';

class BarcodeFormField extends StatefulWidget {
  final String? hintText, labelText, initialValue;
  final bool autoValidate;
  final Function(dynamic value) onSaveValue;
  final Function(dynamic value)? onChanged;
  final Function(dynamic value)? onFieldSubmitted;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction inputAction;
  final bool isRequired;
  final bool enabled;
  final TextEditingController? controller;
  final bool useOutlineStyling;
  final bool canScanBarcode;
  final Function(String)? onItemScanned;
  final bool laserScannerAvailable;

  const BarcodeFormField({
    required Key key,
    required this.onSaveValue,
    required this.hintText,
    required this.labelText,
    this.inputAction = TextInputAction.none,
    this.onFieldSubmitted,
    this.onChanged,
    this.focusNode,
    this.nextFocusNode,
    this.enabled = true,
    this.autoValidate = false,
    this.initialValue,
    this.isRequired = true,
    this.controller,
    this.useOutlineStyling = false,
    this.canScanBarcode = true,
    this.onItemScanned,
    this.laserScannerAvailable = false,
  }) : super(key: key);

  @override
  State<BarcodeFormField> createState() => _BarcodeFormFieldState();
}

class _BarcodeFormFieldState extends State<BarcodeFormField> {
  late TextEditingController controller;
  late String initialValue;
  String? _errorText;
  FocusNode? _focusNode;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    initialValue = widget.initialValue ?? '';
    controller.text = initialValue;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode?.addListener(_handleFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _focusNode!.removeListener(_handleFocusChange);
    _focusNode!.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode!.hasFocus) {
      if (null != widget.onFieldSubmitted) {
        widget.onFieldSubmitted!(controller.text);
      }
    }
  }

  @override
  void didUpdateWidget(BarcodeFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null &&
        (widget.controller != oldWidget.controller)) {
      controller = widget.controller ?? TextEditingController();
    }

    if (widget.initialValue != oldWidget.initialValue) {
      controller = TextEditingController(text: widget.initialValue ?? '');
    }

    if (oldWidget.controller == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textIconColours =
        Theme.of(context).extension<AppliedTextIcon>() ??
        const AppliedTextIcon();
    final surfaceColors =
        Theme.of(context).extension<AppliedSurface>() ?? const AppliedSurface();
    final isFilled = !widget.useOutlineStyling;
    final fillColor = surfaceColors.primary;
    final iconColor = textIconColours.primary;
    final textColor = textIconColours.emphasized;
    final hintColor = textIconColours.deEmphasized;
    final labelColor = textIconColours.secondary;
    final errorColor = textIconColours.error;

    final textStyle = context.styleParagraphSmallRegular!.copyWith(
      color: textColor,
    );
    final config =
        AppVariables.store?.state.formFieldConfig ?? FormFieldConfig().config;
    final baseHintStyle =
        context.getTextStyle(config.hintTextStyle) ??
        context.styleParagraphSmallRegular;
    final hintStyle = baseHintStyle!.copyWith(color: hintColor);

    final labelStyle = baseHintStyle.copyWith(color: labelColor);
    final errorStyle = context.styleBody03x12R!.copyWith(color: errorColor);

    final enabledBorder = widget.useOutlineStyling
        ? context.inputBorderEnabled()
        : context.inputBorderUnderlineEnabled;

    final border = widget.useOutlineStyling
        ? context.inputBorderEnabled()
        : context.inputBorderUnderlineEnabled;

    final focussedBorder = widget.useOutlineStyling
        ? context.inputBorderFocus()
        : context.inputBorderUnderlineEnabled;

    final disabledBorder = widget.useOutlineStyling
        ? context.inputBorderDisabled()
        : context.inputBorderUnderlineDisabled;

    final errorBorder = widget.useOutlineStyling
        ? context.inputBorderError()
        : context.inputBorderUnderlineError;

    return TextFormField(
      enabled: widget.enabled,
      controller: controller,
      focusNode: widget.focusNode,
      key: widget.key,
      style: textStyle,
      cursorColor: textColor,
      cursorErrorColor: errorColor,
      textCapitalization: TextCapitalization.none,
      decoration: InputDecoration(
        border: border,
        enabledBorder: enabledBorder,
        focusedBorder: focussedBorder,
        disabledBorder: disabledBorder,
        errorBorder: errorBorder,
        isDense: true,
        fillColor: fillColor,
        filled: isFilled,
        prefixIconColor: iconColor,
        suffixIconColor: iconColor,
        suffixIcon: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          child: InkWell(
            child: Icon(
              FontAwesomeIcons.barcode,
              color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
            ),
            onTap: () async => widget.enabled ? await scanBarCode(context) : {},
          ),
        ),
        labelStyle: labelStyle,
        labelText: widget.isRequired
            ? '${widget.labelText} *'
            : widget.labelText,
        alignLabelWithHint: true,
        hintStyle: hintStyle,
        hintText: widget.hintText,
        errorStyle: errorStyle,
        errorText: _errorText,
      ),
      enableInteractiveSelection: true,
      keyboardType: TextInputType.number,
      textInputAction: widget.inputAction,
      onFieldSubmitted: (value) {
        if (null != widget.onFieldSubmitted) {
          widget.onFieldSubmitted!(value);

          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          }
        }
      },
      onChanged: (value) {
        setState(() {
          if (RegExp(r'^\d*$').hasMatch(value)) {
            _errorText = null;
          } else {
            _errorText = 'Please enter only numbers';
          }
        });

        if (widget.onChanged != null) widget.onChanged!(value);
      },
      validator: (value) {
        //we must validate that it is an amount...
        if (!validateValue(value)) {
          return 'Please enter a valid value for ${widget.labelText}';
        }

        return null;
      },
      onSaved: (value) {
        String? trimmedValue = value?.trim();
        //we must validate the amount first as it should never save a bad amount.
        if (validateValue(value)) {
          widget.onSaveValue(trimmedValue);
        }
      },
    );
  }

  Future<void> scanBarCode(BuildContext context) async {
    var canScan = await getCameraAccess();

    if (!canScan) {
      showMessageDialog(
        context,
        'We require access to your camera',
        Icons.camera,
      );
      return;
    }

    if (canScan) {
      var scanResult = await showPopupDialog(
        content: BarcodePopupForm(
          laserScannerAvailable: widget.laserScannerAvailable,
        ),
        context: context,
        height: 392,
      );

      var setBarcodeString = true;

      if (widget.onItemScanned != null && scanResult != null) {
        setBarcodeString = await widget.onItemScanned!(scanResult);
      }

      if (setBarcodeString) {
        setState(() {
          controller.text = scanResult ?? '';
          if (widget.onFieldSubmitted != null) {
            widget.onFieldSubmitted!(controller.text);
          }
        });
      }

      return scanResult;
    } else {
      await showMessageDialog(
        context,
        "You have disabled camera access, please go to your phone's settings and enable it",
        LittleFishIcons.warning,
      );

      return;
    }
  }

  Future<bool> scanAllowed(BuildContext context) async {
    var permissionStatus = await PermissionsProvider.instance.hasPermission(
      Permission.camera,
    );
    return permissionStatus;
  }

  Future<bool?> requestScanPermission(BuildContext context) async {
    if (await scanAllowed(context)) return true;

    var result = await (PermissionsProvider.instance.requestPermission(
      Permission.camera,
    ));

    var st = await result?.status;

    return st?.isGranted;
  }

  bool validateValue(String? value) {
    if (value == null || value.isEmpty) {
      if (!widget.isRequired) return true;
      return false;
    }

    return true;
  }
}
