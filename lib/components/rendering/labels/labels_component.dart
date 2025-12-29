import 'package:flutter/material.dart';
import 'package:rose_chart_widget_demo/components/rendering/labels/circular_labels_component.dart';
import 'package:rose_chart_widget_demo/components/rendering/labels/summary_labels_component.dart';
import 'package:rose_chart_widget_demo/models/chart_sector.dart';
import 'package:rose_chart_widget_demo/transitions/chart_state.dart';
import 'package:rose_chart_widget_demo/transitions/chart_transition.dart';
import 'package:rose_chart_widget_demo/transitions/rotate_transition.dart';
import 'package:rose_chart_widget_demo/components/rendering/painter/extended_custom_painter.dart';

class LabelsComponent extends ExtendedCustomPainter {
  final List<ChartSectorModel> data;
  final TextStyle textStyle;
  final double centralCircleRadiusMod;
  final double offsetForLabels;
  final String centralLabelText;
  final Color centralLabelMarkColor;
  final double markHeight;
  final double markWidth;
  final double markOffset;
  final double chartXOffset;
  final double chartYOffset;

  final RotateTransition rotateTransition;

  final ChartTransition transition;
  final double stateTransitionValue;

  final double adjustedAngleToTop;

  LabelsComponent({
    required this.data,
    required this.textStyle,
    required this.centralCircleRadiusMod,
    required this.offsetForLabels,
    required this.centralLabelText,
    required this.centralLabelMarkColor,
    required this.markHeight,
    required this.markWidth,
    required this.markOffset,
    required this.transition,
    required this.stateTransitionValue,
    required this.rotateTransition,
    required this.chartXOffset,
    required this.chartYOffset,
    required this.adjustedAngleToTop,
  });

  @override
  void extendedPaint(
    Canvas canvas,
    Size originalSize,
    Size scaledSize,
    Offset translation,
  ) {
    canvas.translate(chartXOffset, 0);

    CircularLabelsComponent(
      adjustedAngleToTop: adjustedAngleToTop,
      data: data,
      textStyle: textStyle,
      centralCircleRadiusMod: centralCircleRadiusMod,
      offsetForLabels: offsetForLabels,
      centralLabelText: centralLabelText,
      centralLabelMarkColor: centralLabelMarkColor,
      markHeight: markHeight,
      markWidth: markWidth,
      markOffset: markOffset,
      paintAlphaValue: transition.calcLabelAlpha(
        stateAttachedToLabel: const ChartState.base(),
        transitionValue: stateTransitionValue,
      ),
      rotateTransition: rotateTransition,
      chartYOffset: chartYOffset,
    ).extendedPaint(canvas, originalSize, scaledSize, translation);

    canvas.translate(-chartXOffset, 0);

    SummaryLabelsComponent(
      data: data,
      centralLabelText: centralLabelText,
      centralLabelMarkColor: centralLabelMarkColor,
      textStyle: textStyle,
      offsetForLabels: offsetForLabels,
      markHeight: markHeight,
      markWidth: markWidth,
      markOffset: markOffset,
      paintAlphaValue: transition.calcLabelAlpha(
        stateAttachedToLabel: const ChartState.summary(),
        transitionValue: stateTransitionValue,
      ),
    ).extendedPaint(canvas, originalSize, scaledSize, translation);
  }
}
