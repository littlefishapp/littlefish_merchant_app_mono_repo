import 'package:flutter/material.dart';

class TypographyData {
  final String itemType;
  final FontWeight semiBold;
  final FontWeight bold;
  final FontWeight light;
  final FontWeight regular;
  final double fontSize;
  final String textStyle;
  final Color color;
  final String fontFamily;

  const TypographyData({
    this.itemType = '',
    this.bold = FontWeight.w700,
    this.semiBold = FontWeight.w600,
    this.regular = FontWeight.w400,
    this.light = FontWeight.w300,
    this.fontSize = 16.0,
    this.color = Colors.black87,
    this.textStyle = '',
    this.fontFamily = '',
  });

  TypographyData copyWith({
    String? itemType,
    FontWeight? semiBold,
    FontWeight? bold,
    FontWeight? light,
    FontWeight? regular,
    double? fontSize,
    String? textStyle,
    Color? color,
    String? fontFamily,
  }) {
    return TypographyData(
      bold: bold ?? this.bold,
      color: color ?? this.color,
      fontSize: fontSize ?? this.fontSize,
      itemType: itemType ?? this.itemType,
      light: light ?? this.light,
      regular: regular ?? this.regular,
      semiBold: semiBold ?? this.semiBold,
      textStyle: textStyle ?? this.textStyle,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  FontWeight getWeight({
    bool isBold = false,
    bool isSemiBold = false,
    bool isLight = false,
  }) {
    var weight = regular;
    if (isBold) {
      weight = bold;
    } else if (isSemiBold) {
      weight = semiBold;
    } else if (isLight) {
      weight = light;
    }
    return weight;
  }
}
