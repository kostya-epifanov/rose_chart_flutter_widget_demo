import 'package:flutter/cupertino.dart';

abstract class ExtendedCustomPainter extends CustomPainter {
  void extendedPaint(
    Canvas canvas,
    Size originalSize,
    Size scaledSize,
    Offset translation,
  );

  @override
  void paint(Canvas canvas, Size size) => extendedPaint(canvas, size, size, const Offset(0, 0));

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => this != oldDelegate;
}
