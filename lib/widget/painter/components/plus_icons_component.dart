import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rose_chart_widget_demo/models/chart_sector.dart';
import 'package:rose_chart_widget_demo/transitions/rotate_transition.dart';
import 'package:rose_chart_widget_demo/widget/painter/extended_custom_painter.dart';

class PlusIconsComponent extends ExtendedCustomPainter {
  final double adjustedAngleToTop;
  final List<ChartSectorModel> sectorsData;
  final bool isShowCenterPlus;
  final int axesCount;
  final Color plusIconColor;
  final Color plusIconBackgroundColor;
  final double offsetForLabels;
  final RotateTransition rotateTransition;
  final double chartYOffset;
  final double centralCircleRadiusMod;

  PlusIconsComponent({
    required this.adjustedAngleToTop,
    required this.sectorsData,
    required this.isShowCenterPlus,
    required this.axesCount,
    required this.plusIconBackgroundColor,
    required this.plusIconColor,
    required this.offsetForLabels,
    required this.rotateTransition,
    required this.chartYOffset,
    required this.centralCircleRadiusMod,
  });

  @override
  void extendedPaint(
    Canvas canvas,
    Size originalSize,
    Size scaledSize,
    Offset translation,
  ) {
    final double radius = scaledSize.width / 2 - offsetForLabels;
    final double angle = 2 * pi / axesCount;

    for (int index = 0; index < axesCount; index++) {
      final startAngle =
          angle * index + rotateTransition.calcAngleOffset + pi / 6 + adjustedAngleToTop;
      final centralCircleRadius = scaledSize.width * centralCircleRadiusMod / 2;

      if (sectorsData[index].strength == 0) {
        _drawPlusIcon(
          canvas: canvas,
          angle: startAngle,
          chartCenter: Offset(originalSize.width / 2, scaledSize.height / 2 + chartYOffset),
          radiusFromCenter: radius / 2.4 + centralCircleRadius,
          plusIconColor: plusIconColor,
          plusIconBackgroundColor: plusIconBackgroundColor,
        );
      }

      if (isShowCenterPlus) {
        _drawPlusIcon(
          canvas: canvas,
          angle: -pi / 2,
          chartCenter: Offset(originalSize.width / 2, scaledSize.height / 2 + chartYOffset),
          radiusFromCenter: centralCircleRadius * 0.8,
          plusIconColor: plusIconColor,
          plusIconBackgroundColor: plusIconBackgroundColor,
        );
      }
    }
  }

  static void _drawPlusIcon({
    required Canvas canvas,
    required double angle,
    required Offset chartCenter,
    required double radiusFromCenter,
    required Color plusIconColor,
    required Color plusIconBackgroundColor,
  }) {
    final paint = Paint()
      ..color = plusIconBackgroundColor
      ..strokeWidth = 2.0;

    final center = Offset(
      cos(angle) * radiusFromCenter + chartCenter.dx,
      sin(angle) * radiusFromCenter + chartCenter.dy,
    );

    const radius = 16.0;

    final circlePath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));

    canvas.drawShadow(circlePath, Colors.black38, 8, true);
    canvas.drawPath(circlePath, paint);

    final iconPaint = Paint()
      ..color = plusIconColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..blendMode = BlendMode.src;

    const iconRadius = 6.0;

    canvas.drawLine(center.translate(-iconRadius, 0), center.translate(iconRadius, 0), iconPaint);
    canvas.drawLine(center.translate(0, -iconRadius), center.translate(0, iconRadius), iconPaint);
  }
}
