import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rose_chart_widget_demo/models/chart_sector.dart';
import 'package:rose_chart_widget_demo/transitions/rotate_transition.dart';
import 'package:rose_chart_widget_demo/widget/painter/extended_custom_painter.dart';

class SectorsGroupComponent extends ExtendedCustomPainter {
  final List<ChartSectorModel> sectorsData;
  final int maxStrength;
  final double fillColorOpacity;
  final double centralCircleRadiusMod;
  final double offsetForLabels;

  final int centralSectorsMaxCount;
  final int centralSectorsActiveCount;
  final BuildContext context;

  final RotateTransition rotateTransition;
  final double chartXOffset;
  final double chartYOffset;
  final double adjustedAngleToTop;

  late Offset _center;
  late double _centralCircleRadius;
  late double _maxRadius;
  late double _radiusStep;
  late double _angle;
  late double _strokeWidth;

  SectorsGroupComponent({
    required this.sectorsData,
    required this.maxStrength,
    required this.fillColorOpacity,
    required this.centralCircleRadiusMod,
    required this.offsetForLabels,
    required this.centralSectorsMaxCount,
    required this.centralSectorsActiveCount,
    required this.context,
    required this.rotateTransition,
    required this.chartXOffset,
    required this.chartYOffset,
    required this.adjustedAngleToTop,
  })  : assert(centralSectorsMaxCount == sectorsData.length),
        assert(centralSectorsActiveCount <= centralSectorsMaxCount);

  @override
  void extendedPaint(
    Canvas canvas,
    Size originalSize,
    Size scaledSize,
    Offset translation,
  ) {
    _center = Offset(originalSize.width / 2, scaledSize.height / 2 + chartYOffset);
    _centralCircleRadius = scaledSize.width * centralCircleRadiusMod / 2;
    _maxRadius = scaledSize.width / 2 - _centralCircleRadius - offsetForLabels;
    _radiusStep = _maxRadius / maxStrength;
    _angle = 2 * pi / sectorsData.length;
    _strokeWidth = _radiusStep / 2;

    canvas.translate(chartXOffset, 0);

    for (int index = 0; index < sectorsData.length; index++) {
      final model = sectorsData[index];
      final startAngle = _angle * index + rotateTransition.calcAngleOffset + adjustedAngleToTop;
      final endAngle = startAngle + _angle;
      final sectorRadius = _radiusStep * model.strength + _strokeWidth / 2 + _centralCircleRadius;
      if (model.strength > 0) {
        _drawSector(canvas, model, startAngle, endAngle, sectorRadius);
        _drawBorder(canvas, model, startAngle, endAngle, sectorRadius);
      }
      _drawCentralSectors(
        canvas,
        model,
        startAngle - rotateTransition.calcAngleOffset,
        endAngle - rotateTransition.calcAngleOffset,
        index < centralSectorsActiveCount,
      );
    }

    canvas.translate(-chartXOffset, 0);
  }

  void _drawSector(
    Canvas canvas,
    ChartSectorModel model,
    double startAngle,
    double endAngle,
    double sectorRadius,
  ) {
    final path = Path();

    final paint = Paint()
      ..color = model.contextCategory.color.withOpacity(fillColorOpacity)
      ..style = PaintingStyle.fill;

    path.moveTo(
      cos(startAngle) * sectorRadius + _center.dx,
      sin(startAngle) * sectorRadius + _center.dy,
    );

    path.arcTo(
      Rect.fromCircle(
        center: _center,
        radius: sectorRadius,
      ),
      startAngle,
      endAngle - startAngle,
      false,
    );

    path.lineTo(
      cos(endAngle) * sectorRadius + _center.dx,
      sin(endAngle) * sectorRadius + _center.dy,
    );

    if (_centralCircleRadius > 0) {
      path.arcTo(
        Rect.fromCircle(
          center: _center,
          radius: _centralCircleRadius + _strokeWidth * 1.5,
        ),
        endAngle,
        -(endAngle - startAngle),
        false,
      );
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawBorder(
    Canvas canvas,
    ChartSectorModel model,
    double startAngle,
    double endAngle,
    double sectorRadius,
  ) {
    final path = Path();
    final paint = Paint()
      ..color = model.contextCategory.color
      ..style = PaintingStyle.fill;

    path.moveTo(
      cos(startAngle) * sectorRadius + _center.dx,
      sin(startAngle) * sectorRadius + _center.dy,
    );

    path.arcTo(
      Rect.fromCircle(
        center: _center,
        radius: sectorRadius,
      ),
      startAngle,
      endAngle - startAngle,
      false,
    );

    path.lineTo(
      cos(endAngle) * sectorRadius + _center.dx,
      sin(endAngle) * sectorRadius + _center.dy,
    );

    if (_centralCircleRadius > 0) {
      path.arcTo(
        Rect.fromCircle(
          center: _center,
          radius: sectorRadius - _strokeWidth,
        ),
        endAngle,
        -(endAngle - startAngle),
        false,
      );
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawCentralSectors(
    Canvas canvas,
    ChartSectorModel model,
    double startAngle,
    double endAngle,
    bool isActive,
  ) {
    final radius = _centralCircleRadius - _strokeWidth / 2;

    final gradient = isActive
        ? const RadialGradient(
            colors: [
              Color(0xFF35C7F0),
              Color(0x0035C7F0),
            ],
            stops: [
              0.7865,
              1.0,
            ],
          )
        : const RadialGradient(
            colors: [
              Color(0xFF636367),
              Color(0x00636367),
            ],
            stops: [
              0.7865,
              1.0,
            ],
          );

    final shader = gradient.createShader(
      Rect.fromCircle(
        center: _center,
        radius: _centralCircleRadius + _strokeWidth,
      ),
    );

    final paint = Paint()
      ..shader = shader
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(
      cos(startAngle) * _centralCircleRadius + _center.dx,
      sin(startAngle) * _centralCircleRadius + _center.dy,
    );

    path.arcTo(
      Rect.fromCircle(
        center: _center,
        radius: radius,
      ),
      startAngle,
      endAngle - startAngle,
      false,
    );

    path.lineTo(
      cos(endAngle) * _centralCircleRadius + _center.dx,
      sin(endAngle) * _centralCircleRadius + _center.dy,
    );

    if (_centralCircleRadius > 0) {
      path.arcTo(
        Rect.fromCircle(
          center: _center,
          radius: _centralCircleRadius + _strokeWidth / 2,
        ),
        endAngle,
        -(endAngle - startAngle),
        false,
      );
    }

    path.close();
    canvas.drawPath(path, paint);
  }
}
