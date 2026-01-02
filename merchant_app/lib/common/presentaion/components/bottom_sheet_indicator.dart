import 'package:flutter/material.dart';

class BottomSheetIndicator extends StatelessWidget {
  final double height, width;
  final Color colour;
  final EdgeInsetsGeometry margin;

  const BottomSheetIndicator({
    Key? key,
    this.height = 4,
    this.width = 78,
    this.colour = const Color(0xFFD7D7D7),
    this.margin = const EdgeInsets.symmetric(vertical: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: colour,
      margin: margin,
    );
  }
}
