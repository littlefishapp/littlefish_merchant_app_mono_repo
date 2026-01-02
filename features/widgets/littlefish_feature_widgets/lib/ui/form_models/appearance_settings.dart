// Flutter imports:
import 'package:flutter/material.dart';

class AppearanceSettings {
  AppearanceSettings({
    this.labelText = 'Amount',
    this.padding = EdgeInsets.zero,
    this.hintText,
    this.icon,
    this.labelStyle,
    this.inputStyle,
    this.formattedStyle,
    this.errorStyle,
    this.focusNode,
    this.key,
    this.textInputAction,
  });

  String? labelText;
  String? hintText;

  Widget? icon;

  TextStyle? labelStyle;
  TextStyle? inputStyle;
  TextStyle? formattedStyle;
  TextStyle? errorStyle;

  FocusNode? focusNode;

  Key? key;

  EdgeInsetsGeometry padding;

  TextInputAction? textInputAction;

  AppearanceSettings copyWith({
    String? labelText,
    String? hintText,
    Widget? icon,
    TextStyle? labelStyle,
    TextStyle? inputStyle,
    TextStyle? formattedStyle,
    TextStyle? errorStyle,
    EdgeInsetsGeometry? padding,
    FocusNode? focusNode,
    Key? key,
    TextInputAction? textInputAction,
  }) => AppearanceSettings()
    ..labelText = labelText ?? this.labelText
    ..hintText = hintText ?? this.hintText
    ..icon = icon ?? this.icon
    ..labelStyle = labelStyle ?? this.labelStyle
    ..inputStyle = inputStyle ?? this.inputStyle
    ..formattedStyle = formattedStyle ?? this.formattedStyle
    ..errorStyle = errorStyle ?? this.errorStyle
    ..padding = padding ?? this.padding
    ..focusNode = focusNode ?? this.focusNode
    ..key = key ?? this.key
    ..textInputAction = textInputAction ?? this.textInputAction;
}
