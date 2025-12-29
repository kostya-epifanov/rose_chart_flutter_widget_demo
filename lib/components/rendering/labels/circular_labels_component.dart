import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rose_chart_widget_demo/models/chart_sector.dart';
import 'package:rose_chart_widget_demo/transitions/rotate_transition.dart';
import 'package:rose_chart_widget_demo/components/rendering/painter/extended_custom_painter.dart';

class CircularLabelsComponent extends ExtendedCustomPainter {
  static const _labelOffset = 5.0;

  final List<ChartSectorModel> data;
  final TextStyle textStyle;
  final double centralCircleRadiusMod;
  final double offsetForLabels;
  final String centralLabelText;
  final Color centralLabelMarkColor;
  final double markHeight;
  final double markWidth;
  final double markOffset;
  final double paintAlphaValue;
  final RotateTransition rotateTransition;
  final double adjustedAngleToTop;
  final double chartYOffset;

  final Paint _markPaint = Paint();
  final TextPainter _textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );

  late Offset _center;
  late double _sectorAngle;
  late double _drawOffsetRadius;
  late double _sectorOuterSideWidth;

  CircularLabelsComponent({
    required this.data,
    required this.textStyle,
    required this.centralCircleRadiusMod,
    required this.offsetForLabels,
    required this.centralLabelText,
    required this.centralLabelMarkColor,
    required this.markHeight,
    required this.markWidth,
    required this.markOffset,
    required this.paintAlphaValue,
    required this.rotateTransition,
    required this.adjustedAngleToTop,
    required this.chartYOffset,
  });

  @override
  void extendedPaint(
    Canvas canvas,
    Size originalSize,
    Size scaledSize,
    Offset translation,
  ) {
    _center = Offset(originalSize.width / 2, scaledSize.height / 2 + chartYOffset);
    _sectorAngle = 2 * pi / data.length;
    _drawOffsetRadius = scaledSize.width / 2 - offsetForLabels;
    _sectorOuterSideWidth = 2 * _drawOffsetRadius * sin(_sectorAngle / 2);

    _drawCentralLabel(canvas, centralLabelText, centralLabelMarkColor);

    final angleOffset = rotateTransition.calcAngleOffset + adjustedAngleToTop;

    for (int index = 0; index < data.length; index++) {
      final model = data[index];
      final startAngle = (_sectorAngle * index + angleOffset) % (2 * pi);
      final middleAngle = startAngle + _sectorAngle / 2;
      final textDrawAngle = middleAngle - (_sectorAngle * _getTitleWidth(model) / 2);
      final double rotateAngle = textDrawAngle + pi / data.length + (pi - _sectorAngle) / 2;
      final Offset textPos = Offset(
        cos(textDrawAngle) * _drawOffsetRadius + _center.dx,
        sin(textDrawAngle) * _drawOffsetRadius + _center.dy,
      );

      canvas.save();
      canvas.translate(textPos.dx, textPos.dy);
      canvas.rotate(rotateAngle);

      final nAngle = startAngle < 0 ? 2 * pi + startAngle : startAngle;

      _drawLabel(
        canvas: canvas,
        model: model,
        isReversedSector: nAngle < pi * 0.9,
      );

      canvas.restore();
    }
  }

  double _getTitleWidth(ChartSectorModel model) {
    _textPainter.text = TextSpan(text: model.category.title, style: textStyle);
    _textPainter.layout();
    return _textPainter.width / _sectorOuterSideWidth;
  }

  void _drawLabel({
    required Canvas canvas,
    required ChartSectorModel model,
    required bool isReversedSector,
  }) {
    double nextAngle = 0;

    if (!isReversedSector) {
      nextAngle = _drawMarkAtAngle(
        canvas: canvas,
        angle: nextAngle,
        color: model.category.color,
      );
    }

    final characters = model.category.title.runes.map((e) => String.fromCharCode(e)).toList();

    for (int index = 0; index < characters.length; index++) {
      nextAngle = _drawLetterAtAngle(
        canvas: canvas,
        letter: characters[isReversedSector ? characters.length - 1 - index : index],
        angle: nextAngle,
        isReversedSector: isReversedSector,
      );
    }

    if (isReversedSector) {
      canvas.translate(7, 1);
      nextAngle = _drawMarkAtAngle(
        canvas: canvas,
        angle: nextAngle,
        color: model.category.color,
      );
    }
  }

  double _drawLetterAtAngle({
    required Canvas canvas,
    required String letter,
    required double angle,
    required bool isReversedSector,
  }) {
    _textPainter.text = TextSpan(
      text: letter,
      style: textStyle.copyWith(
        color: textStyle.color?.withOpacity(paintAlphaValue.clamp(0, 1.0)),
      ),
    );
    _textPainter.layout(
      maxWidth: double.maxFinite,
    );

    final double d = _textPainter.width;
    final double alpha = 2 * asin(d / (2 * _drawOffsetRadius));

    final newAngle = (alpha + angle) / 2;

    canvas.rotate(newAngle);

    if (isReversedSector) {
      canvas.save();
      canvas.rotate(pi);
    }

    final dx = isReversedSector ? -d : 0.0;
    final dy = isReversedSector ? _labelOffset : -_textPainter.height - _labelOffset;

    _textPainter.paint(canvas, Offset(dx, dy));

    if (isReversedSector) {
      canvas.restore();
    }

    canvas.translate(d, 0);

    return alpha;
  }

  double _drawMarkAtAngle({
    required Canvas canvas,
    required double angle,
    required Color color,
  }) {
    _markPaint.color = color.withOpacity(paintAlphaValue);
    final double alpha = 2 * asin(markWidth / (2 * _drawOffsetRadius));
    final double newAngle = (alpha + angle) / 2;
    canvas.rotate(newAngle);
    _drawMarkAtOffset(
      canvas,
      Offset(
        markOffset - 2.0,
        -markHeight - _labelOffset,
      ),
    );
    canvas.translate(markWidth, 0);
    return alpha;
  }

  void _drawMarkAtOffset(Canvas canvas, Offset offset) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: offset,
          width: markWidth,
          height: markHeight,
        ),
        const Radius.circular(2.0),
      ),
      _markPaint,
    );
  }

  void _drawCentralLabel(Canvas canvas, String title, Color markColor) {
    _markPaint.color = centralLabelMarkColor.withOpacity(paintAlphaValue);
    _drawMarkAtOffset(canvas, Offset(_center.dx, _center.dy - 7));
    _textPainter.text = TextSpan(
      text: centralLabelText,
      style: textStyle.copyWith(
        fontWeight: FontWeight.w600,
        color: textStyle.color?.withOpacity(paintAlphaValue),
      ),
    );
    _textPainter.layout(
      maxWidth: double.maxFinite,
    );
    _textPainter.paint(
      canvas,
      Offset(_center.dx - _textPainter.width / 2, _center.dy + 3),
    );
  }
}
