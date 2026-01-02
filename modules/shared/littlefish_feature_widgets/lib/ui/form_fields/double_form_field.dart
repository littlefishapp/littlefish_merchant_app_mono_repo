// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DoubleFormField extends StatefulWidget {
  final String hintText, labelText;
  final double? initialValue;
  final bool autoValidate;
  final double? maxValue;
  final double? minValue;
  final Function(double) onSaveValue;
  final Function(double?)? onFieldSubmitted;
  final Function(double)? onChanged;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction inputAction;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool enabled;
  final bool isRequired;
  final Color? color;
  final TextEditingController? controller;
  final bool useOutlineStyling;

  const DoubleFormField({
    required Key key,
    required this.onSaveValue,
    required this.hintText,
    required this.labelText,
    this.isRequired = false,
    this.inputAction = TextInputAction.none,
    this.suffixIcon,
    this.maxValue,
    this.minValue,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.onChanged,
    this.focusNode,
    this.nextFocusNode,
    this.autoValidate = false,
    this.initialValue,
    this.enabled = true,
    this.color,
    this.controller,
    this.useOutlineStyling = false,
  }) : super(key: key);

  @override
  State<DoubleFormField> createState() => _DoubleFormFieldState();
}

class _DoubleFormFieldState extends State<DoubleFormField> {
  late double initialValue;
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
        widget.onFieldSubmitted!(double.parse(controller.text));
      }
    }
  }

  @override
  void didUpdateWidget(DoubleFormField oldWidget) {
    if (widget.controller != null &&
        (widget.controller != oldWidget.controller)) {
      controller = widget.controller ?? TextEditingController();
    }

    if (widget.initialValue != oldWidget.initialValue) {
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InkWell(
          borderRadius: BorderRadius.circular(30.0),
          onTap: () {
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
          splashColor: Theme.of(context).colorScheme.primary,
          child: CircleAvatar(
            backgroundColor:
                widget.color ?? Theme.of(context).colorScheme.secondary,
            child: const Icon(Icons.remove),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: controller,
            enabled: widget.enabled,
            key: widget.key,
            focusNode: widget.focusNode,

            textAlign: TextAlign.center,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: widget.useOutlineStyling
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : const UnderlineInputBorder(),
              labelText: widget.isRequired
                  ? '${widget.labelText} *'
                  : widget.labelText,
              hintText: widget.hintText,
              suffixIcon: widget.suffixIcon != null
                  ? Icon(widget.suffixIcon)
                  : null,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon)
                  : null,
            ),
            enableInteractiveSelection: true,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp('[a-zA-z]')),
              FilteringTextInputFormatter.deny(RegExp('\\s')),
              // FilteringTextInputFormatter.allow(
              //   RegExp("[\\d]"),
              // ),
            ],
            // keyboardType: TextInputType.number,
            // textInputAction: widget.inputAction,
            onFieldSubmitted: (value) {
              if (null != widget.onFieldSubmitted && validateValue(value)) {
                double parsedValue = double.parse(value);

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
            validator: (value) {
              if (!validateValue(value)) {
                return 'Please enter a valid value for ${widget.labelText}';
              }
              return null;
            },
            onChanged: (value) {
              if (null != widget.onChanged) {
                if (validateValue(value)) {
                  double parsedValue = double.tryParse(value) ?? 0.00;
                  if (widget.minValue != null &&
                      parsedValue < widget.minValue!) {
                    setState(() {
                      initialValue = widget.minValue!;
                      controller.text = widget.minValue.toString();
                    });
                  } else if (widget.maxValue != null &&
                      parsedValue > widget.maxValue!) {
                    double newVal = double.parse(
                      value.substring(0, value.length - 1),
                    );
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
            onSaved: (value) {
              if (validateValue(value)) {
                widget.onSaveValue(double.parse(value!));
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          borderRadius: BorderRadius.circular(30.0),
          onTap: () {
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
          splashColor: Theme.of(context).colorScheme.primary,
          child: CircleAvatar(
            backgroundColor:
                widget.color ?? Theme.of(context).colorScheme.secondary,
            child: const Icon(Icons.add),
          ),
        ),
      ],
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
