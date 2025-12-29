import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rose_chart_widget_demo/extensions/string_extension.dart';
import 'package:rose_chart_widget_demo/models/chart_sector.dart';
import 'package:rose_chart_widget_demo/components/rendering/painter/extended_custom_painter.dart';

class SummaryLabelsComponent extends ExtendedCustomPainter {
  final List<ChartSectorModel> data;
  final String centralLabelText;
  final Color centralLabelMarkColor;
  final TextStyle textStyle;
  final double offsetForLabels;
  final double markHeight;
  final double markWidth;
  final double markOffset;
  final double paintAlphaValue;

  final Paint _markPaint = Paint();
  final TextPainter _textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );

  SummaryLabelsComponent({
    required this.data,
    required this.centralLabelText,
    required this.centralLabelMarkColor,
    required this.textStyle,
    required this.markHeight,
    required this.offsetForLabels,
    required this.markWidth,
    required this.markOffset,
    required this.paintAlphaValue,
  });

  @override
  void extendedPaint(
    Canvas canvas,
    Size originalSize,
    Size scaledSize,
    Offset translation,
  ) {
    final offset = offsetForLabels * 1.33;

    _drawLabel(
      canvas,
      Offset(
        -translation.dx + offset,
        -translation.dy,
      ),
      centralLabelText,
      centralLabelMarkColor,
    );

    for (int index = 0; index < data.length; index++) {
      final ChartSectorModel model = data[index];
      _drawLabel(
        canvas,
        Offset(
          -translation.dx + offset,
          -translation.dy + (_textPainter.height + offsetForLabels / 2) * (index + 1),
        ),
        model.category.title,
        model.category.color,
      );
    }
  }

  void _drawLabel(
    Canvas canvas,
    Offset offset,
    String title,
    Color markColor,
  ) {
    _markPaint.color = markColor.withOpacity(paintAlphaValue);
    _textPainter.text = TextSpan(
      text: title.toLowerCase().capitalize(),
      style: textStyle.copyWith(
        color: textStyle.color?.withOpacity(paintAlphaValue.clamp(0, 0.7)),
      ),
    );
    _textPainter.layout(
      maxWidth: double.maxFinite,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(offset.dx - 8, offset.dy + _textPainter.height / 2),
          width: markWidth,
          height: markHeight,
        ),
        const Radius.circular(2.0),
      ),
      _markPaint,
    );
    _textPainter.paint(canvas, offset);
  }
}
