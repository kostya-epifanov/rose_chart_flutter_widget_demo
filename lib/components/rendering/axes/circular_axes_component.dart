import 'package:flutter/material.dart';
import 'package:rose_chart_widget_demo/components/rendering/painter/extended_custom_painter.dart';

class CircularAxesComponent extends ExtendedCustomPainter {
  final BuildContext context;
  final int axesCount;
  final double centralCircleRadiusMod;
  final double offsetForLabels;
  final double chartXOffset;
  final double chartYOffset;

  CircularAxesComponent({
    required this.context,
    required this.axesCount,
    required this.centralCircleRadiusMod,
    required this.offsetForLabels,
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
    final centralCircleRadius = scaledSize.width * centralCircleRadiusMod / 2;
    final maxRadius = scaledSize.width / 2 - centralCircleRadius - offsetForLabels;
    final radiusStep = maxRadius / axesCount;
    final strokeWidth = radiusStep / 2;

    canvas.save();

    canvas.translate(originalSize.width / 2 + chartXOffset, scaledSize.width / 2 + chartYOffset);

    for (int index = 0; index < axesCount; index++) {
      final radius = centralCircleRadius + radiusStep * (index + 1);

      final shader = const RadialGradient(
        radius: 0.5002,
        colors: [
          Color.fromRGBO(255, 255, 255, 0.1),
          Color.fromRGBO(255, 255, 255, 0.4),
        ],
        stops: [
          0.915,
          1.0,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset.zero,
          radius: radius + strokeWidth / 2,
        ),
      );

      final paint = Paint()
        ..strokeWidth = strokeWidth
        ..shader = shader
        ..color = Colors.transparent.withOpacity(0.4)
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(
        const Offset(0, 0),
        radius,
        paint,
      );
    }

    canvas.restore();
  }
}
