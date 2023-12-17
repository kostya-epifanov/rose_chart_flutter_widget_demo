import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:rose_chart_widget_demo/transitions/chart_state.dart';

class ChartTransition {
  final ChartState fromState;
  final ChartState toState;

  const ChartTransition({
    required this.fromState,
    required this.toState,
  });

  bool get havePluses => toState != const ChartState.detailed();

  double calcWidgetHeight({
    required double transitionValue,
  }) {
    final invertedAnimVal = 1 - transitionValue;
    final toHeight = toState.widgetHeight;
    final fromHeight = fromState.widgetHeight;
    return toHeight + (fromHeight - toHeight) * invertedAnimVal;
  }

  Size calcScaledSize({
    required Size originalSize,
    required double transitionValue,
  }) {
    return Size(
      _calcScaledSizeParam(
        param: originalSize.width,
        transitionValue: transitionValue,
      ),
      _calcScaledSizeParam(
        param: originalSize.height,
        transitionValue: transitionValue,
      ),
    );
  }

  Offset calcTranslationOffset({
    required Size originalSize,
    required Size scaledSize,
    required double transitionValue,
  }) {
    return Offset(
      _calcTranslatedPositionParam(
        originalSizeParam: originalSize.width,
        scaledSizeParam: scaledSize.width,
        fromPosMod: fromState.posXMod,
        toPosMod: toState.posXMod,
        transitionValue: transitionValue,
      ),
      _calcTranslatedPositionParam(
        originalSizeParam: originalSize.height,
        scaledSizeParam: scaledSize.height,
        fromPosMod: fromState.posYMod,
        toPosMod: toState.posYMod,
        transitionValue: transitionValue,
      ),
    );
  }

  double calcLabelAlpha({
    required ChartState stateAttachedToLabel,
    required double transitionValue,
  }) {
    if (fromState == stateAttachedToLabel) {
      return 1.0 - min(transitionValue * 2, 1);
    }
    if (toState == stateAttachedToLabel) {
      return max((transitionValue - 0.5) * 2, 0);
    }
    return 0;
  }

  double calcBottomFadeAlpha({
    required double transitionValue,
  }) {
    if (fromState.haveBottomFade) {
      return 1 - transitionValue;
    }
    if (toState.haveBottomFade) {
      return transitionValue;
    }
    return 0;
  }

  bool isGesturesEnabled({
    required double transitionValue,
  }) {
    return transitionValue == 0 && fromState.isGesturesEnabled ||
        transitionValue == 1 && toState.isGesturesEnabled;
  }

  double _calcScaledSizeParam({
    required double param,
    required double transitionValue,
  }) {
    final double from = fromState.scaleMod * param;
    final double to = toState.scaleMod * param;
    return to + (from - to) * (1 - transitionValue);
  }

  double _calcTranslatedPositionParam({
    required double originalSizeParam,
    required double scaledSizeParam,
    required double fromPosMod,
    required double toPosMod,
    required double transitionValue,
  }) {
    final double fromOffsetParam = scaledSizeParam * fromPosMod;
    final double toOffsetParam = scaledSizeParam * toPosMod;
    final double correction =
        scaledSizeParam > originalSizeParam ? -(scaledSizeParam - originalSizeParam) / 2 : 0;
    return toOffsetParam + (fromOffsetParam - toOffsetParam) * (1 - transitionValue) + correction;
  }

  double getChartXOffset({
    required double transitionValue,
  }) =>
      toState.chartXoffset * transitionValue;

  double calcChartYOffset({
    required double transitionValue,
  }) =>
      fromState.chartYoffset + transitionValue * (toState.chartYoffset - fromState.chartYoffset);
}
