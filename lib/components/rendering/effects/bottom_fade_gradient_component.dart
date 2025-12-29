import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rose_chart_widget_demo/transitions/chart_transition.dart';
import 'package:rose_chart_widget_demo/components/rendering/painter/extended_custom_painter.dart';

class BottomFadeGradientComponent extends ExtendedCustomPainter {
  final Color color;
  final ChartTransition transition;
  final double transitionValue;
  final double chartXOffset;

  BottomFadeGradientComponent({
    required this.color,
    required this.transition,
    required this.transitionValue,
    required this.chartXOffset,
  });

  @override
  void extendedPaint(
    Canvas canvas,
    Size originalSize,
    Size scaledSize,
    Offset translation,
  ) {
    canvas.translate(chartXOffset, 0);

    final Color fadeColor = color.withOpacity(
      transition.calcBottomFadeAlpha(transitionValue: transitionValue),
    );

    final Offset shaderRectStartPoint = Offset(
      0, //  -translation.dx,
      originalSize.height * 0.66 + translation.dy,
    );
    final Offset shaderRectEndPoint = Offset(
      scaledSize.width,
      transition.calcWidgetHeight(transitionValue: transitionValue) - translation.dy,
    );

    final fadePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          fadeColor,
          fadeColor.withOpacity(fadeColor.opacity * 0.75),
          color.withOpacity(0),
        ],
      ).createShader(
        Rect.fromPoints(
          shaderRectStartPoint,
          shaderRectEndPoint,
        ),
      );

    canvas.drawRect(
      Rect.fromPoints(
        shaderRectStartPoint,
        shaderRectEndPoint,
      ),
      fadePaint,
    );
  }
}
