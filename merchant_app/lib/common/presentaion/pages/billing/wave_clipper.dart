//Costom CLipper class with Path

// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(
      0,
      size.height,
    ); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, size.height);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, size.height - 20.0);
    //second point of quadratic bezier curve
    var secondStart = Offset(
      size.width - (size.width / 3.24),
      size.height - 44,
    );
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, size.height - 10);

    // var firstStart = Offset(size.width / 5, size.height);
    // //fist point of quadratic bezier curve
    // var firstEnd = Offset(size.width / 2.25, size.height - 20.0);
    // //second point of quadratic bezier curve
    // var secondStart =
    //     Offset(size.width - (size.width / 3.24), size.height - 44);
    // //third point of quadratic bezier curve
    // var secondEnd = Offset(size.width, size.height - 10);

    //second point of quadratic bezier curve
    // var thirdStart = Offset(size.width - (size.width / 3.24), size.height - 44);
    //third point of quadratic bezier curve
    // var thirdEnd = Offset(size.width, size.height - 10);

    path.quadraticBezierTo(
      firstStart.dx,
      firstStart.dy,
      firstEnd.dx,
      firstEnd.dy,
    );
    path.quadraticBezierTo(
      secondStart.dx,
      secondStart.dy,
      secondEnd.dx,
      secondEnd.dy,
    );

    //fourth point of quadratic bezier curve

    //fourth point of quadratic bezier curve
    // path.quadraticBezierTo(
    // thirdStart.dx, thirdStart.dy, thirdEnd.dx, thirdEnd.dy);

    path.lineTo(
      size.width,
      0,
    ); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //if new instance have different instance than old instance
    //then you must return true;
  }
}
