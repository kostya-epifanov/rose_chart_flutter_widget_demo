import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rose_chart_widget_demo/transitions/chart_transition.dart';
import 'package:rose_chart_widget_demo/components/rendering/painter/extended_custom_painter.dart';

class RoseChartPainter extends CustomPainter {
  final List<ExtendedCustomPainter> components;

  final ChartTransition transition;
  final double transitionValue;

  RoseChartPainter({
    required this.components,
    required this.transition,
    required this.transitionValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final minSize = min(size.height, size.width);
    final squareSize = Size(minSize, minSize);

    final Size scaledSize = transition.calcScaledSize(
      originalSize: squareSize,
      transitionValue: transitionValue,
    );

    final Offset translatedPosition = transition.calcTranslationOffset(
      originalSize: squareSize,
      scaledSize: scaledSize,
      transitionValue: transitionValue,
    );

    canvas.translate(translatedPosition.dx, translatedPosition.dy);

    for (final element in components) {
      element.extendedPaint(canvas, size, scaledSize, translatedPosition);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => this != oldDelegate;
}
