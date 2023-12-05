import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rose_chart_widget_demo/transitions/rotate_transition.dart';
import 'package:rose_chart_widget_demo/widget/painter/extended_custom_painter.dart';

class RadialAxesComponent extends ExtendedCustomPainter {
  final int axesCount;
  final int maxStrength;
  final Color axesColor;
  final double strokeWidth;
  final double offsetForLabels;
  final RotateTransition rotateTransition;
  final double chartXOffset;
  final double chartYOffset;

  late Offset _center;
  late double _radius;
  late double _radiusStep;
  late double _angle;
  late double _circleAxesStrokeWidth;

  RadialAxesComponent({
    required this.axesCount,
    required this.maxStrength,
    required this.axesColor,
    required this.strokeWidth,
    required this.offsetForLabels,
    required this.rotateTransition,
    required this.chartXOffset,
    required this.chartYOffset,
  });

  @override
  void extendedPaint(
    Canvas canvas,
    Size originalSize,
    Size scaledSize,
    Offset translation,
  ) {
    final paint = Paint()
      ..color = axesColor
      ..strokeWidth = strokeWidth;

    _center = Offset(originalSize.width / 2, scaledSize.height / 2 + chartYOffset);
    _radius = scaledSize.width / 2 - offsetForLabels;
    _radiusStep = _radius / maxStrength;
    _angle = 2 * pi / axesCount;
    _circleAxesStrokeWidth = _radiusStep / 2;

    canvas.translate(chartXOffset, 0);

    for (int index = 0; index < axesCount; index++) {
      final startAngle = _angle * index + rotateTransition.calcAngleOffset;

      canvas.drawLine(
        Offset(
          _center.dx,
          _center.dy,
        ),
        Offset(
          cos(startAngle) * (_radius + _circleAxesStrokeWidth) + _center.dx,
          sin(startAngle) * (_radius + _circleAxesStrokeWidth) + _center.dy,
        ),
        paint,
      );
    }

    canvas.translate(-chartXOffset, 0);
  }
}
