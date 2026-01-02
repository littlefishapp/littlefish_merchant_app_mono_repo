// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/custom_keypad.dart';
import 'package:quiver/strings.dart';

class NumberFormField extends StatefulWidget {
  final String hintText, labelText;
  final int? initialValue;
  final bool autoValidate;
  final Function(int) onSaveValue;
  final Function(int?)? onFieldSubmitted;
  final Function(int?)? onChanged;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction inputAction;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool enabled;
  final bool isRequired;
  final Color? color, borderColor;
  final TextEditingController? controller;
  final bool useOutlineStyling, useDecorator;
  final int? maxValue, minValue;
  final double? buttonSize, textFieldWidth;

  const NumberFormField({
    required Key key,
    required this.onSaveValue,
    required this.hintText,
    required this.labelText,
    this.isRequired = false,
    this.inputAction = TextInputAction.none,
    this.suffixIcon,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.onChanged,
    this.focusNode,
    this.nextFocusNode,
    this.autoValidate = false,
    this.initialValue,
    this.enabled = true,
    this.color,
    this.borderColor,
    this.controller,
    this.useOutlineStyling = false,
    this.minValue,
    this.maxValue,
    this.buttonSize,
    this.textFieldWidth,
    this.useDecorator = true,
  }) : super(key: key);

  @override
  State<NumberFormField> createState() => _NumberFormFieldState();
}

class _NumberFormFieldState extends State<NumberFormField> {
  late int initialValue;
  late TextEditingController controller;

  FocusNode? _focusNode;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    initialValue = widget.initialValue ?? 0;
    controller.text = initialValue.toString();
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
      if (null != widget.onFieldSubmitted && validateValue(controller.text)) {
        widget.onFieldSubmitted!(int.parse(controller.text));
      }
    }
  }

  @override
  void didUpdateWidget(NumberFormField oldWidget) {
    if (widget.controller != null &&
        (widget.controller != oldWidget.controller)) {
      controller = widget.controller ?? TextEditingController();
    }

    if (widget.initialValue != oldWidget.initialValue) {
      initialValue = widget.initialValue ?? 0;
      controller = TextEditingController(text: widget.initialValue.toString());
    }

    if (oldWidget.controller == null) {
      return;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        decrementQuantity(),
        editQuantity(context),
        incrementQuantity(),
      ],
    );
  }

  captureQuantity(BuildContext context) {
    return showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppVariables.appDefaultRadius),
        ),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        bottom: true,
        child: SizedBox(
          height: 480,
          child: CustomKeyPad(
            isLoading: false,
            enableAppBar: false,
            isDescriptionRequired: false,
            isAmountCapture: false,
            title: 'Capture Quantity',
            heading: 'Capture Quantity',
            enableDescription: false,
            confirmErrorMessage: 'Please enter the quantity',
            confirmButtonText: 'Confirm Quantity',
            onValueChanged: (double amount) {},
            onDescriptionChanged: (String description) {},
            onSubmit: (amount, description) {
              Navigator.of(context).pop((amount));
            },
            initialValue: (widget.initialValue?.toDouble()) ?? 0,
            parentContext: ctx,
          ),
        ),
      ),
    );
  }

  Widget incrementQuantity() {
    return SizedBox(
      height: 36,
      width: 36,
      child: Material(
        color: Theme.of(context).extension<AppliedSurface>()?.brandSubTitle,
        borderRadius: BorderRadius.circular(4),
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: 24,
          icon: const Icon(Icons.add),
          onPressed: () {
            if (widget.enabled) {
              if (widget.maxValue == null) {
                setState(() {
                  initialValue = (initialValue) + 1;
                  controller.text = initialValue.toString();
                });
              } else {
                if ((initialValue) < widget.maxValue!.toInt()) {
                  setState(() {
                    initialValue = (initialValue) + 1;
                    controller.text = initialValue.toString();
                  });
                }
              }

              if (null != widget.onFieldSubmitted) {
                widget.onFieldSubmitted!(initialValue);
              }
            }
          },
        ),
      ),
    );
  }

  Widget editQuantity(BuildContext context) {
    final textIconColours =
        Theme.of(context).extension<AppliedTextIcon>() ??
        const AppliedTextIcon();
    final textColor = textIconColours.emphasized;

    final textStyle = context.styleParagraphSmallRegular!.copyWith(
      color: textColor,
    );

    return SizedBox(
      width: widget.textFieldWidth ?? 72,
      child: TextFormField(
        enabled: true,
        readOnly: true,
        controller: controller,
        focusNode: widget.focusNode,
        key: widget.key,
        style: textStyle,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        enableInteractiveSelection: true,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp('[a-zA-z]')),
          FilteringTextInputFormatter.deny(RegExp('\\s')),
          FilteringTextInputFormatter.allow(RegExp('[\\d]')),
        ],
        keyboardType: TextInputType.number,
        textInputAction: widget.inputAction,
        onFieldSubmitted: (value) {
          if (widget.onFieldSubmitted != null && isBlank(value)) {
            widget.onFieldSubmitted!(0);

            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            }
          }

          if (null != widget.onFieldSubmitted && validateValue(value)) {
            int parsedValue = int.parse(value);
            if (widget.minValue != null && parsedValue < widget.minValue!) {
              setState(() {
                initialValue = widget.minValue!;
                controller.text = widget.minValue.toString();
              });
            } else if (widget.maxValue != null &&
                parsedValue > widget.maxValue!) {
              setState(() {
                initialValue = widget.maxValue!;
                controller.text = widget.maxValue.toString();
              });
            } else {
              setState(() {
                initialValue = parsedValue;
              });
            }

            widget.onFieldSubmitted!(initialValue);

            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            }
          }
        },
        onChanged: (value) {
          if (null != widget.onChanged) {
            if (validateValue(value)) {
              int parsedValue = int.tryParse(value) ?? 0;
              if (widget.minValue != null && parsedValue < widget.minValue!) {
                setState(() {
                  initialValue = widget.minValue!;
                  controller.text = widget.minValue.toString();
                });
              } else if (widget.maxValue != null &&
                  parsedValue > widget.maxValue!) {
                int newVal = int.parse(value.substring(0, value.length - 1));
                setState(() {
                  initialValue = newVal;
                  controller.text = newVal.toString();
                });
              } else {
                setState(() {
                  initialValue = parsedValue;
                });
              }

              widget.onChanged!(initialValue);
            }
          }
        },
        validator: (value) {
          if (!validateValue(value)) {
            return 'Please enter a valid value for ${widget.labelText}';
          }
          return null;
        },
        onSaved: (value) {
          if (validateValue(value)) {
            widget.onSaveValue(int.parse(value!));
          }
        },
        onEditingComplete: () {
          if (null != widget.onFieldSubmitted) {
            widget.onFieldSubmitted!(initialValue);
          }
        },
        onTap: () async {
          controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controller.text.length,
          );

          await captureQuantity(context).then((value) {
            if (value != null) {
              setState(() {
                initialValue = value.toInt();
                controller.text = initialValue.toString();
              });

              if (null != widget.onFieldSubmitted) {
                widget.onFieldSubmitted!(initialValue);
              }

              if (validateValue(value)) {
                widget.onSaveValue(int.parse(value!));
              }
            }
          });
        },
      ),
    );
  }

  Widget decrementQuantity() {
    return SizedBox(
      height: 36,
      width: 36,
      child: Material(
        color: Theme.of(context).extension<AppliedSurface>()?.brandSubTitle,
        borderRadius: BorderRadius.circular(4),
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: 24,
          icon: const Icon(Icons.remove),
          onPressed: () async {
            if (!widget.enabled) {
              return;
            }

            if (widget.enabled && initialValue > 0) {
              if (widget.minValue == null) {
                setState(() {
                  initialValue = (initialValue) - 1;
                  controller.text = initialValue.toString();
                });
              } else {
                if ((initialValue) > widget.minValue!.toInt()) {
                  setState(() {
                    initialValue = (initialValue) - 1;
                    controller.text = initialValue.toString();
                  });
                }
              }

              if (null != widget.onFieldSubmitted) {
                widget.onFieldSubmitted!(initialValue);
              }
            }
          },
        ),
      ),
    );
  }

  bool validateValue(String? value) {
    if (value == null || value.isEmpty) return false;

    //here we need to define the pattern
    var regexPattern = '[\\d]';

    RegExp expression = RegExp(regexPattern);
    return expression.hasMatch(value);
  }
}
