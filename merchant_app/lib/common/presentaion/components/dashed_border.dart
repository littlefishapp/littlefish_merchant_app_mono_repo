import 'dart:ui';
import 'package:flutter/material.dart';

class DashedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;
  final BorderRadius? borderRadius;

  const DashedBorder({
    Key? key,
    required this.child,
    this.color = const Color(0xFC8E8C8F),
    this.dashWidth = 6.0,
    this.dashSpace = 6.0,
    this.strokeWidth = 1.0,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      // creates a canvas to paint on
      painter: _DashedBorderPainter(
        color: color,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        strokeWidth: strokeWidth,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

// CustomPainter that paints onto the canvas, creating a dashed border
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;
  final BorderRadius? borderRadius;

  _DashedBorderPainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeWidth,
    this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    var path = Path()
      ..addRRect(
        borderRadius?.toRRect(rect) ??
            RRect.fromRectAndRadius(rect, Radius.zero),
      );

    final Path dashPath = Path();
    double dashLength = dashWidth;
    double distance = 0.0;

    // create dashed lines for all 4 sides
    for (PathMetric pathMetric in path.computeMetrics()) {
      // path.computeMetrics extracts 4 sides of rectangle
      while (distance < pathMetric.length) {
        // create dashed lines along the side
        final double end = distance + dashLength;
        dashPath.addPath(pathMetric.extractPath(distance, end), Offset.zero);
        distance += dashLength + dashSpace;
        dashLength = dashWidth;
      }
      distance = 0.0; // reset distance for the next side
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
